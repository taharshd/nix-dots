{
  description = "My Home Manager config (inspired by Th0rgal)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # Change if you use aarch64, etc.
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      homeConfigurations = {
        # Replace "harth" with your actual username
        harth = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            # Optionally, you can add ./config.nix or others if needed
          ];
          # Optionally, pass extraSpecialArgs if you want to use them in your configs
          # extraSpecialArgs = { ... };
        };
      };
    };
}
