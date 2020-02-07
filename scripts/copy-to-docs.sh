#!/usr/bin/env bash

cd $(dirname "$0")/..
nix-build || {
    echo "Building page failed." >&2
    exit 1
}

mkdir -p docs
nix run "(import ./nix/pkgs.nix).rsync" \ 
    rsync -avz --delete result/* docs/