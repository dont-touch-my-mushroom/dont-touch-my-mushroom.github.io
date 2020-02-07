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
GITREV=$($GIT show-ref -s HEAD)

if test -n "$(git status --porcelain)"; then
    echo "!!! repository has uncomitted changes" >&2
    exit 1
fi

if test -n "$(cd publish; git status --porcelain)"; then
    echo "!!! publish sub repository has uncomitted changes" >&2
    exit 2
fi

echo "=== Updating publish submodule"
$GIT submodule update --remote

echo "=== Copy homepage files to master in publish directory"
nix run "(import ./nix/pkgs.nix).rsync" -c \
    rsync -rvLk --exclude='.git' --delete "$HOMEPAGE/" "$PROJECT_DIR/publish"

echo "=== Committing generated homepage files"
cd "$PROJECT_DIR/publish"
echo "www.dont-tou.ch" >CNAME
$GIT add .
$GIT commit -m "Generated files from ${GITREV}"

cd "$PROJECT_DIR"
$GIT push --recurse-submodules=on-demand
$GIT commit -m "Published ${GITREV}" -- publish

echo "========= Pushing ============================="
cd "$PROJECT_DIR"
$GIT push --recurse-submodules=on-demand