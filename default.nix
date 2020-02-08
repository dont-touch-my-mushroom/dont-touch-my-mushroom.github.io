{
  siteUrl? "http://www.dont-tou.ch",
  pkgs? import ./nix/pkgs.nix,
  stdenv? pkgs.stdenv,
  lib? pkgs.lib,
  bundlerEnv? pkgs.bundlerEnv,
  ruby? pkgs.ruby_2_4,
  callPackage? pkgs.callPackage
}:

let
  # gemset.nix was generated with
  # $(nix-build '<nixpkgs>' -A bundix)/bin/bundix
  # See https://stesie.github.io/2016/08/nixos-github-pages-env
  jekyllEnv = bundlerEnv {
    name = "jekyllEnv";
    ruby = ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
  sourceFilter = (import ./nix/source-filter.nix) { inherit lib; };
  configSite = pkgs.writeTextFile {
    name = "_config.yml";
    text = builtins.toJSON { url = siteUrl; };
  };
in stdenv.mkDerivation {
  name = "dont-touch-jekyll";
  src = builtins.filterSource sourceFilter ./.;
  phases = [ "unpackPhase" "installPhase" ];
  buildInputs = [
    jekyllEnv
  ];
  installPhase = ''
    jekyll build --config _config.yml,${configSite} --destination $out
  '';
}
