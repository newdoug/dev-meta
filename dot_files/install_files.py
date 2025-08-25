#!/usr/bin/env python3

import argparse
import os
import shutil
import sys


SCRIPT_DIR = os.path.dirname(os.path.expanduser(os.path.realpath(__file__)))
DEFAULT_DOT_FILES_DIR = SCRIPT_DIR

DEFAULT_DOT_FILES = {
    ".valgrindrc",
    ".nanorc",
    ".vimrc",
    ".bashrc",
    ".gitignore",
    ".gitconfig",
}

BACKUP_FILE_EXT = "bak"


def get_home_dir():
    return os.getenv("HOME") or "/home/user"


def backup_file(basedir: str, orig_abs_filename: str):
    base_filename = os.path.basename(orig_abs_filename)
    orig_filename = os.path.join(basedir, base_filename)
    if not os.path.exists(orig_filename):
        # nothing to back up
        return
    new_filename = f"{orig_filename}.{BACKUP_FILE_EXT}"
    idx = 0
    while os.path.exists(new_filename):
        new_filename = f"{orig_filename}.{idx}.{BACKUP_FILE_EXT}"
        idx += 1
    print(f"Backing up file '{orig_filename}' to '{new_filename}'")
    shutil.copy(orig_filename, new_filename)


def install_dot_file(dest: str, filename: str, bkp: bool = True):
    home_dir = dest
    base_filename = os.path.basename(filename)
    filename = os.path.join(home_dir, base_filename)
    if bkp:
        backup_file(home_dir, filename)
    repo_dot_file = os.path.join(DEFAULT_DOT_FILES_DIR, base_filename)
    # install dot file to home dir
    print(f"Copying file '{repo_dot_file}' to '{home_dir}'")
    shutil.copy(repo_dot_file, home_dir)


def install_dot_files(dest: str, bkp: bool = True):
    for dot_file in DEFAULT_DOT_FILES:
        install_dot_file(dest, dot_file, bkp=bkp)


def main() -> int:
    parser = argparse.ArgumentParser(description="install current dot files into home directory")
    parser.add_argument("--no-bkp", help="Don't backup currently installed dot files if they exist", action="store_true")
    parser.add_argument("--dest", help="Destination directory to install to. By "
    "default, this is the home directory of the executing user, determined by "
    "HOME environment variable")

    parsed_args = parser.parse_args(sys.argv[1:])

    bkp = not parsed_args.no_bkp
    dest = parsed_args.dest
    if not dest:
        dest = get_home_dir()

    install_dot_files(dest, bkp)
    return 0


if __name__ == '__main__':
    sys.exit(main())
