#!/usr/bin/env bash

[ "$DEBUG" = "1" ] && set -x

set -e

SCRIPTDIR="$(readlink -f "$(dirname "$0")")"
cd "$SCRIPTDIR"

zip -9 -e projects_priv.zip projects_priv.adoc
