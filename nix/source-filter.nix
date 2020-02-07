{ lib }:

name: type:
    let baseName = builtins.baseNameOf (builtins.toString name); 
    in ! (
      # Filter out git
      baseName == ".gitignore" ||
      (type == "directory" && baseName == ".git" ) ||

      # Filter out build results
      (type == "directory" && (
        baseName == "target" ||
        baseName == "dev" ||
        baseName == "_site" ||
        baseName == ".sass-cache" ||
        baseName == ".jekyll-metadata" ||
        baseName == "build-artifacts"
        )) ||

      # Filter out nix-build result symlinks
      (type == "symlink" && lib.hasPrefix "result" baseName) ||

      # Filter out IDE config
      (type == "directory" && (
        baseName == ".idea" ||
        baseName == ".vscode"
        )) ||
      lib.hasSuffix ".iml" baseName ||

      # Filter out nix build files
      lib.hasSuffix ".nix" baseName ||
      
      # Filter out nix helper scripts
      baseName == "install_fmt_clippy.sh" ||
      baseName == "prepare_commit.sh" ||
      baseName == "run-carnix.sh" ||
      baseName == "update-deps.sh" ||
      baseName == "node2nix.sh" ||

      # Filter out editor backup / swap files.
      lib.hasSuffix "~" baseName ||
      builtins.match "^\\.sw[a-z]$" baseName != null ||
      builtins.match "^\\..*\\.sw[a-z]$" baseName != null ||
      lib.hasSuffix ".tmp" baseName ||
      lib.hasSuffix ".bak" baseName ||

      # Temp files during development
      baseName == "Procfile" ||
      baseName == "perf.data" ||
      lib.hasSuffix ".o" baseName ||
      lib.hasSuffix ".so" baseName
    )