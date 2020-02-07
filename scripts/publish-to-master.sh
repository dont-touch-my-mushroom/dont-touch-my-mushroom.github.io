#!/usr/bin/env bash

set -ex

echo "========= Building home page =============================="

cd $(dirname "$0")/..
HOMEPAGE=$(nix-build)

echo "========= Checking out master ============================="

GIT=$(nix-build ./nix/pkgs.nix -A git)/bin/git
GITREV=$($GIT rev-parse HEAD)
BRANCH=$($GIT rev-parse --abbrev-ref HEAD)
$GIT checkout master
$GIT pull origin master

echo "========= Copy homepage files to master ==================="

nix run "(import ./nix/pkgs.nix).rsync" -c \
    rsync -avLk --delete "$BUILD" .

echo "========= Committing homepage files to master =============="

$GIT add .
$GIT commit -m "Generated files from ${GITREV}"

echo "========= Pushing homepage files to master ================="

$GIT push origin master

echo "========= Returning to $BRANCH============= ================="

$GIT checkout $BRANCH