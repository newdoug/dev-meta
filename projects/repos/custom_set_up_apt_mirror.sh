#!/usr/bin/env bash

# Tired of how buggy debmirror tends to be, so just going to GET stuff myself.

[ "$DEBUG" = "1" ] && set -x

if ! command -v curl >/dev/null; then
  printf "Please install curl first: apt install curl\n" >&2
  exit 1
fi

DEFAULT_COMPS="main,contrib,non-free,non-free-firmware,main/debian-installer,restricted,universe,multiverse"
DEFAULT_HOST="archive.ubuntu.com"
DEFAULT_ROOT="ubuntu"

BASE_URL="archive.ubuntu.com"

list_root() {
}
