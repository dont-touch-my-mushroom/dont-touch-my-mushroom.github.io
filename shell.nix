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
    sources.niv
  ] ++ default.buildInputs;

  shellHook = ''
    echo "Check README.md for instruction on how to"
    grep -e '^##' README.md
  '';
}