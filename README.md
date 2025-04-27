## My dots for NixOS

To replicate this system on any NixOS boot, install NixOS from a minimal ISO, and run the following commands:

1. `git clone https://github.com/taharshd/nix-dots`
2. `cd nix-dots/`
3. `sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix`
4. `git init && git add .` (flakes must be managed by git)
5. `sudo nixos-rebuild switch --flake .`
6. If no password has been set previously, run `passwd` to change  initialPassword set in `configuration.nix`

### Upgrading

```bash
nix flake update hydenix
```
or define a specific version in your `flake.nix` template

```nix
inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hydenix = {
      # Available inputs:
      # Main: github:richen604/hydenix
      # Dev: github:richen604/hydenix/dev 
      # Commit: github:richen604/hydenix/<commit-hash>
      # Version: github:richen604/hydenix/v1.0.0
      url = "github:richen604/hydenix";
    };
  };
```

run `nix flake update hydenix` again to load the update, then rebuild your system to apply the changes
  