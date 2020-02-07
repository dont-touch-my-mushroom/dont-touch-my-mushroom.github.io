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
        baseName == "publish" ||
        baseName == "scripts" ||
        baseName == "nix" ||
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
      
      # Filter out editor backup / swap files.
      lib.hasSuffix "~" baseName ||
      builtins.match "^\\.sw[a-z]$" baseName != null ||
      builtins.match "^\\..*\\.sw[a-z]$" baseName != null ||
      lib.hasSuffix ".tmp" baseName ||
      lib.hasSuffix ".bak" baseName ||

      # Temp files during development
      lib.hasSuffix ".log" baseName ||
      lib.hasSuffix ".o" baseName ||
      lib.hasSuffix ".so" baseName
    )