"""
- https://archive.ubuntu.com/ubuntu/
    - dists/
        - bionic/
            - Contents-{arch1}.gz
            - Contents-{arch2}.gz
            ...
            - InRelease
            - Release
            - Release.gpg
            - by-hash/
                - SHA256/ (possibly other hash types too??)
                    - <SHA256_1>: is a plaintext message that is PGP-signed and lists hashes (MD5, SHA1, and SHA256
                      apparently) of meta-files in main/, multiverse/, restricted/, and universe/. This includes
                      Sources, Release, Sources.xz, Sources.gz, Packages, Packages.gz, Packages.xz, Translation*,
                      Index, Contents-{arch}*, Components*, icons*, etc.
                      - Or is a similar message but no PGP signature
                      - Or is just a PGP signature.
                      - Some other file that maps files/dirs in one directory to files/dirs in another?
                      - Or is a similar file, but gzipped
            - main/
                - binary-{arch}/
                    - Packages.gz
                    - Packages.xz
                    - Release
                    - by-hash/
                        - <SHA256_1>: Some hash as a filename, contents is zipped list of all packages, their filename
                          in pool/ directory, dependencies, recommends, maintainer, version, and other metadata
                          (including MD5, SHA1, and SHA256 hashes). It's pretty much just one entry per line with field
                          name: field value syntax and one extra newline separating entries. Last line of file probably
                          empty. Some fields (mainly "Description") may be multi-lined. Each extra "line" is just a new
                          line that begins with a space character.
                - debian-installer/
                    - binary-{arch} - similar stuff?
                - dep11/
                    - Components*
                    - icons*
                    - by-hash/SHA256/ - similar, but different (and differently formatted_ metadata?
                - dist-upgrader-all/
                    - 18.04.<minor_vers>/
                        - *Announcement* files
                        - <rel_name>.tar.gz
                        - <rel_name>.tar.gpg
                    ...
                    - current/
                - i18n/
                    - Translation* files
                    - Index
                    - by-hash/SHA256/ - probably similar type of stuff
                - installer-{arch}/
                    - dirs, some with dates, some just 'current'/
                        - Looks like various installer/boot/kernel type of files. Not actual installer ISOs though.
                - signed/
                    - idk, just grab, not much
                - source/
                    - Release
                    - Source.gz
                    - Source.xz
                    - by-hash/SHA256/
                - uefi/
                    - Looks like firmware, grub stuff
            - multiverse/
            - restricted/
            - universe/
        - bionic-backports/
        - bionic-proposed/
        - bionic-security/
        - bionic-updates/
        ...
        # Not ALL are in here - older ones may need a different base URL
        
    - pool/
        - main/
            - actual packages eventually
        - multiverse/
        - restricted/
        - universe/
    - ubuntu/ seems like a softlink or something to same directory, so should ignore or infinite loop
"""
import sys

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin


def fetch_metadata(url, method="HEAD"):
    """
    Fetch metadata for a URL using HEAD (or GET fallback).
    
    Returns a dict with status, headers, redirects, etc.
    """
    metadata = {
        "url": url,
        "final_url": None,
        "status_code": None,
        "is_redirect": False,
        "redirect_chain": [],
        "headers": {},
        "content_type": None,
        "content_length": None,
        "last_modified": None,
    }

    try:
        resp = requests.request(method, url, allow_redirects=True, timeout=10)
    except Exception as e:
        metadata["error"] = str(e)
        return metadata

    metadata["final_url"] = resp.url
    metadata["status_code"] = resp.status_code
    metadata["is_redirect"] = len(resp.history) > 0
    metadata["redirect_chain"] = [r.url for r in resp.history]

    metadata["headers"] = dict(resp.headers)
    metadata["content_type"] = resp.headers.get("Content-Type")
    metadata["content_length"] = (
        int(resp.headers["Content-Length"]) if "Content-Length" in resp.headers else None
    )
    metadata["last_modified"] = resp.headers.get("Last-Modified")

    return metadata


def crawl_directory(base_url, visited=None, collect_files=True):
    """
    Recursively crawls directory-style websites with detailed metadata collection.
    
    Returns dict with 'directories' and 'files', each holding metadata dicts.
    Each directory also records cumulative file size and counts.
    """
    if visited is None:
        visited = set()

    results = {"directories": [], "files": []}

    if base_url in visited:
        return results
    visited.add(base_url)

    # Fetch metadata for directory page
    dir_meta = fetch_metadata(base_url, method="GET")
    if dir_meta.get("error"):
        print(f"Got error trying to query base URL '{base_url}'", file=sys.stderr)
        return results
    dir_meta["type"] = "directory"
    dir_meta["directory_size"] = 0
    dir_meta["file_count"] = 0
    dir_meta["subdirectory_count"] = 0
    results["directories"].append(dir_meta)

    # If it doesn't look like HTML, don't parse further
    if not dir_meta.get("content_type", "").lower().startswith("text/html"):
        return results

    # Parse links
    try:
        response = requests.get(base_url, timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, "html.parser")
    except Exception as e:
        dir_meta["error"] = f"Failed to fetch directory listing: {e}"
        return results

    for tag in soup.find_all("a", href=True):
        href = tag["href"]

        # Skip anchors and parent dir links
        if href.startswith("#") or href.startswith("?") or href in ("../", "./"):
            continue

        url = urljoin(base_url, href)

        if url in visited:
            continue

        if href.endswith("/"):  # directory
            print(f"Crawling dir at URL '{url}'")
            sub = crawl_directory(url, visited, collect_files)
            # Merge sub-results
            results["directories"].extend(sub["directories"])
            results["files"].extend(sub["files"])

            # Update directory stats
            dir_meta["subdirectory_count"] += 1
            dir_meta["directory_size"] += sum(
                f.get("content_length", 0) or 0 for f in sub["files"]
            )
            dir_meta["file_count"] += len(sub["files"])

        else:  # file candidate
            print(f"Querying URL '{url}'")
            file_meta = fetch_metadata(url, method="HEAD")
            if error := file_meta.get("error"):
                # TODO: this is just a failure on HEAD request - could continue with GET
                print(f"Got error trying to query URL '{url}'", file=sys.stderr)
                return results
            print(f"Got metadata for url '{url}': {file_meta}")
            content_type = file_meta.get("content_type", "")
            if content_type and content_type.lower().startswith("text/html"):
                # It's actually a directory without trailing slash
                print(f"Crawling dir at URL '{url}'")
                sub = crawl_directory(url, visited, collect_files)
                results["directories"].extend(sub["directories"])
                results["files"].extend(sub["files"])

                dir_meta["subdirectory_count"] += 1
                dir_meta["directory_size"] += sum(
                    f.get("content_length", 0) or 0 for f in sub["files"]
                )
                dir_meta["file_count"] += len(sub["files"])
            else:
                if collect_files:
                    file_meta["type"] = "file"
                    results["files"].append(file_meta)
                    # Update directory stats
                    dir_meta["file_count"] += 1
                    dir_meta["directory_size"] += file_meta.get("content_length", 0) or 0

    return results


if __name__ == "__main__":
    import argparse

    def main(args: list[str]) -> int:
        parser = argparse.ArgumentParser(description="Crawl a directory-style website")
        parser.add_argument("base_url", help="URL to start at")
        # TODO: implement
        parser.add_argument("-d", "--download-files", help="Actually download found files", action="store_true")
        parsed_args = parser.parse_args(args)
        start_url = parsed_args.base_url
        site_map = crawl_directory(start_url)

        print("\n=== Directories ===")
        for d in site_map["directories"]:
            print(d)

        print("\n=== Files ===")
        for f in site_map["files"]:
            print(f)

        return 0
    
    sys.exit(main(sys.argv[1:]))
