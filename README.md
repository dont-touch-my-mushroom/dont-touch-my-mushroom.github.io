## Install nix

The only dependency you need to install
for the scripts in this repo is 
[nix](https://nixos.org/nix/).

For Windows, some Windows Subsystem For Linux (WSL) is required.

## Rendering locally

In a `nix-shell` in the repository:

1. Run `jekyll serve`
2. Open http://localhost:4000/

## Publish web page

1. Run `./scripts/publish.sh`
2. Check webpage

## Update dependencies

In a `nix-shell` in the repository:

1. Run `bundle update`
2. Run `bundix`
3. Try if `nix-build` still works
4. Commit and push
