let
  sources = import ./nix/sources.nix;
  _pkgs = import ./nix/pkgs.nix;

in {
  pkgs? _pkgs,
  stdenv? pkgs.stdenv,
  lib? pkgs.lib,
  bundlerEnv? pkgs.bundlerEnv,
  ruby? pkgs.ruby,
  callPackage? pkgs.callPackage
}:

let default = callPackage ./. {};

in stdenv.mkDerivation {
  name = "env";
  buildInputs = [
    ruby.devEnv
    pkgs.git
    pkgs.bundix
    pkgs.rsync
  ] ++ default.buildInputs;

  shellHook = ''
    echo "# Rendering locally"
    echo "  1. Run 'jekyll serve'"
    echo "  2. Open http://localhost:4000/"
    echo "# Update dependencies"
    echo "  1. Run 'bundle update'"
    echo "  2. Run 'bundix'"
    echo "  3. Try if 'nix-build' still works"
    echo "# Build the website"
    echo "  (does not deploy it)
    echo "  1. Run 'nix-build'"
    echo "  2. Result is in ./result"
  '';
}