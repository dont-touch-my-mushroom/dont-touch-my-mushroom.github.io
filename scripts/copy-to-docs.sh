#!/usr/bin/env bash

set -ex

cd $(dirname "$0")/..
HOMEPAGE=$(nix-build)

GIT=$(nix-build ./nix/pkgs.nix -A git)/bin/git
GITREV=$(git rev-parse HEAD)
$GIT checkout master

nix run "(import ./nix/pkgs.nix).rsync" -c \
    rsync -avLk --delete "$BUILD" .

$GIT add .
$GIT commit -m "Generated files from ${GITREV}"
$GIT push origin master