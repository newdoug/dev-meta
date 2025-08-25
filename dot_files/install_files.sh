#!/usr/bin/env bash

# absolute directory this script is in
SCRIPTDIR="$(dirname "$(readlink -f "$0")")";


python3 "${SCRIPTDIR}/install_files.py" "$@";

