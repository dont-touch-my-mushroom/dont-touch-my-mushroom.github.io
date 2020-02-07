#!/usr/bin/env bash

#
# This script will generate the static homepage files
# and push them to master.
#
# Github will automatically pick up the files from there.
#

set -e

cd $(dirname "$0")/..
PROJECT_DIR="$(pwd)"    

echo "=== Building home page / git"
HOMEPAGE=$(nix-build --no-out-link)
GIT=$(nix-build --no-out-link ./nix/pkgs.nix -A git)/bin/git

echo "=== Updating publish submodule"
$GIT submodule update --remote

echo "=== Copy homepage files to master in publish directory"
nix run "(import ./nix/pkgs.nix).rsync" -c \
    rsync -rvLk --exclude='.git/' --delete "$HOMEPAGE/" "$PROJECT_DIR/publish"

echo "=== Committing generated homepage files"
cd "$PROJECT_DIR/publish"
$GIT add .
$GIT commit -m "Generated files from ${GITREV}"

echo "========= Pushing ============================="
cd "$PROJECT_DIR"
$GIT push --recurse-submodules=on-demand