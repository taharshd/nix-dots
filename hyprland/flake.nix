{
  description = "template for hydenix";

  inputs = {
    # User's nixpkgs - for user packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hydenix and its nixpkgs - kept separate to avoid conflicts
    hydenix = {
      # Available inputs:
      # Main: github:richen604/hydenix
      # Dev: github:richen604/hydenix/dev
      # Commit: github:richen604/hydenix/<commit-hash>
      # Version: github:richen604/hydenix/v1.0.0
      url = "github:richen604/hydenix";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures consistency
    };

    # Nix-index-database - for comma and command-not-found
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sf-pro = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      flake = false;
    };
    sf-compact = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
      flake = false;
    };
    sf-mono = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
      flake = false;
    };
    sf-arabic = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Arabic.dmg";
      flake = false;
    };
    sf-armenian = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Armenian.dmg";
      flake = false;
    };
    sf-georgian = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Georgian.dmg";
      flake = false;
    };
    sf-hebrew = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Hebrew.dmg";
      flake = false;
    };
    ny = {
      url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
      flake = false;
    };

    textfox.url = "github:adriankarlen/textfox";
  };

  outputs =
    { ... }@inputs:
    let
      HOSTNAME = "harth";
      # --- Define system explicitly ---
      system = "x86_64-linux"; # Or "aarch64-linux", etc.


      hydenixConfig = inputs.hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem {
        # --- Pass explicit system ---
        inherit system;
        specialArgs = {
          inherit inputs system; # Pass system in specialArgs too
        };
        modules = [
          ./configuration.nix
          inputs.spicetify-nix.nixosModules.spicetify
        ];
      };

      pkgs = inputs.nixpkgs.legacyPackages.${system};

      unpackPhase = pkgName: ''
        runHook preUnpack
        undmg $src
        7z x '${pkgName}'
        7z x 'Payload~'
        runHook postUnpack
      '';

      commonInstall = ''
        mkdir -p "$out/share/fonts"
        mkdir -p "$out/share/fonts/opentype"
        mkdir -p "$out/share/fonts/truetype"
      '';

      commonBuildInputs = builtins.attrValues { inherit (pkgs) undmg p7zip; };

      makeAppleFont = (
        name: pkgName: src:
        pkgs.stdenvNoCC.mkDerivation {
          inherit name src;

          unpackPhase = unpackPhase pkgName;

          buildInputs = commonBuildInputs;
          setSourceRoot = "sourceRoot=`pwd`";

          installPhase =
            ''runHook preInstall''
            + commonInstall
            + ''
              find -name \*.otf -exec mv {} "$out/share/fonts/opentype/" \;
              find -name \*.ttf -exec mv {} "$out/share/fonts/truetype/" \;
            ''
            + ''runHook preInstall'';
        }
      );

      makeNerdAppleFont = (
        name: pkgName: src:
        pkgs.stdenvNoCC.mkDerivation {
          inherit name src;

          unpackPhase = unpackPhase pkgName;

          buildInputs =
            commonBuildInputs
            ++ builtins.attrValues { inherit (pkgs) parallel nerd-font-patcher; };

          setSourceRoot = "sourceRoot=`pwd`";

          buildPhase = ''
            runHook preBuild
            find -name \*.ttf -o -name \*.otf -print0 | parallel --will-cite -j $NIX_BUILD_CORES -0 nerd-font-patcher --no-progressbars -c {}
            runHook postBuild
          '';

          installPhase =
            ''runHook preInstall''
            + commonInstall
            + ''
              find -name \*.otf -maxdepth 1 -exec mv {} "$out/share/fonts/opentype/" \;
              find -name \*.ttf -maxdepth 1 -exec mv {} "$out/share/fonts/truetype/" \;
            ''
            + ''runHook preInstall'';
        }
      );
    in
    {
      
      nixosConfigurations.nixos = hydenixConfig;
      nixosConfigurations.${HOSTNAME} = hydenixConfig;

      sf-pro = makeAppleFont "sf-pro" "SF Pro Fonts.pkg" inputs.sf-pro;
      sf-pro-nerd = makeNerdAppleFont "sf-pro-nerd" "SF Pro Fonts.pkg" inputs.sf-pro;

      sf-compact = makeAppleFont "sf-compact" "SF Compact Fonts.pkg" inputs.sf-compact;
      sf-compact-nerd = makeNerdAppleFont "sf-compact-nerd" "SF Compact Fonts.pkg" inputs.sf-compact;

      sf-mono = makeAppleFont "sf-mono" "SF Mono Fonts.pkg" inputs.sf-mono;
      sf-mono-nerd = makeNerdAppleFont "sf-mono-nerd" "SF Mono Fonts.pkg" inputs.sf-mono;

      sf-arabic = makeAppleFont "sf-arabic" "SF Arabic Fonts.pkg" inputs.sf-arabic;
      sf-arabic-nerd = makeNerdAppleFont "sf-arabic-nerd" "SF Arabic Fonts.pkg" inputs.sf-arabic;

      sf-armenian = makeAppleFont "sf-armenian" "SF Armenian Fonts.pkg" inputs.sf-armenian;
      sf-armenian-nerd = makeNerdAppleFont "sf-armenian-nerd" "SF Armenian Fonts.pkg" inputs.sf-armenian;
      
      sf-georgian = makeAppleFont "sf-georgian" "SF Georgian Fonts.pkg" inputs.sf-georgian;
      sf-georgian-nerd = makeNerdAppleFont "sf-georgian-nerd" "SF Georgian Fonts.pkg" inputs.sf-georgian;
      
      sf-hebrew = makeAppleFont "sf-hebrew" "SF Hebrew Fonts.pkg" inputs.sf-hebrew;
      sf-hebrew-nerd = makeNerdAppleFont "sf-hebrew-nerd" "SF Hebrew Fonts.pkg" inputs.sf-hebrew;

      ny = makeAppleFont "ny" "NY Fonts.pkg" inputs.ny;
      ny-nerd = makeNerdAppleFont "ny-nerd" "NY Fonts.pkg" inputs.ny;

    };
}
