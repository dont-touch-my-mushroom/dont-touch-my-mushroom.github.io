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
date
HOMEPAGE=$(nix-build --no-out-link)
GIT=$(nix-build --no-out-link ./nix/pkgs.nix -A git)/bin/git
GITREV=$($GIT show-ref -s HEAD)

if test -n "$(git status --porcelain)"; then
    echo "!!! repository has uncomitted changes" >&2
    exit 1
fi

echo "=== Populating publish"
date
$GIT fetch
rm -rf publish
$GIT branch -f master origin/master
$GIT clone -l -b master . publish

echo "=== Copy homepage files to master in publish directory"
date
nix run "(import ./nix/pkgs.nix).rsync" -c \
    rsync -rvLk --exclude='.git' --delete "$HOMEPAGE/" "$PROJECT_DIR/publish"

echo "=== Committing generated homepage files"
date
cd "$PROJECT_DIR/publish"
echo "www.dont-tou.ch" >CNAME

if ! test -n "$(git status --porcelain)"; then
    echo "!!! No changes to commit in generated output" >&2
    exit 2
fi

$GIT add .
$GIT commit -m "Generated files from ${GITREV}"

echo "========= Pushing ============================="
date 
# this pushes to the main checkout
$GIT push
cd "$PROJECT_DIR"
# this pushes from main checkout to github
$GIT push origin master

echo "========= DONE! ============================="
date

echo "Check the result at https://www.dont-tou.ch"
echo "or http://www.dont-tou.ch if that's still broken."