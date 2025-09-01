#!/usr/bin/env bash

[ "$DEBUG" = "1" ] && set -x

if ! command -v debmirror >/dev/null; then
  printf "Please install debmirror first: apt install debmirror\n" >&2
  exit 1
fi

DEFAULT_COMPS="main,contrib,non-free,non-free-firmware,main/debian-installer,restricted,universe,multiverse"
DEFAULT_HOST="archive.ubuntu.com"
DEFAULT_ROOT="ubuntu"

if [ -z "$HOST" ]; then
  printf "Default host '%s' being used (Ubuntu)\n" "${DEFAULT_HOST}"
  HOST="${DEFAULT_HOST}"
fi
if [ -z "$ROOT" ]; then
  printf "Default root '%s' being used (Ubuntu)\n" "${DEFAULT_ROOT}"
  ROOT="${DEFAULT_ROOT}"
fi

full_distros() {
  echo "$1,$1-security,$1-updates,$1-proposed,$1-backports"
  #echo "$1,$1-security,$1-updates,$1-backports"
}

usage() {
  printf "Usage: %s DST DISTROS [COMPS]\n" "$0" >&2
  printf "\tDST: destination download directory for apt repo contents\n" >&2
  printf "\tDISTROS: distribution to download\n" >&2
  printf "\t\te.g., \"xenial\"" >&2
  printf "\t\tThis will turn into \"%s\"\n" "$(full_distros xenial)" >&2
  printf "\tCOMPS: components/sections to download\n" >&2
  printf "\t\tDefault: \"%s\"\n" "${DEFAULT_COMPS}" >&2
}

DST="$1"
DISTROS="$(full_distros "$2")"
COMPS="$3"
if [ -z "$COMPS" ]; then
  COMPS="${DEFAULT_COMPS}"
fi
if [ -z "$DST" ] || ! mkdir -p "$DST" >/dev/null; then
  printf "DST '%s' must be an existing or writable directory\n" "$DST" >&2
  usage
  exit 1
fi
if [ -z "$DISTROS" ] || [ -z "$COMPS" ]; then
  usage
  exit 1
fi

SPACEAVAILK="$(df --output=avail "$DST" | tail -n1)"
if [ "$SPACEAVAILK" -lt "$((250*1024*1024))" ]; then
  printf "Warning: target directory to write mirror to ('%s') only has %d bytes available.\n" "$DST" "$SPACEAVAILK" >&2
  if [ -z "$FORCE" ]; then
    printf "Define the FORCE environment variable or choose a different directory to continue.\n" >&2
    exit 1
  fi
fi

echo debmirror --progress -v -h "$HOST" -r "$ROOT" --timeout=$((45*60)) --passive --source --i18n --diff=mirror -d "$DISTROS" -s "$COMPS" -a i386,amd64 --ignore-release-gpg --no-check-gpg "$DST"
if [ -z "$DRY" ]; then
  debmirror --progress -v -h "$HOST" -r "$ROOT" --timeout=$((45*60)) --passive --source --i18n --diff=mirror -d "$DISTROS" -s "$COMPS" -a i386,amd64 --ignore-release-gpg --no-check-gpg "$DST"
fi
# Original command I saw
#debmirror -p -v -h ftp.belnet.be -r mirror/ubuntu.com --method ftp --passive -d xenial,xenial-security,xenial-updates -a i386,amd64 --ignore-release-gpg  /path/to/usb-disk/ubuntu-xenial/
