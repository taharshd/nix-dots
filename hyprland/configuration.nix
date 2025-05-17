{
  inputs,
  # --- Add system argument ---
  system,
  config,
  spicetify,
  ##pkgs,
  ...
}:
let
  # Package declaration
  # ---------------------
  # Ensure the 'system' argument received by this module is used
  currentSystem = system;
  pkgs = import inputs.hydenix.inputs.hydenix-nixpkgs {
    # --- Explicitly assign system = currentSystem ---
    system = currentSystem;
    config.allowUnfree = true;
    overlays = [
      inputs.hydenix.lib.overlays
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      (import ./overlays/customPkgs.nix)

      (final: prev: {
        userPkgs = import inputs.nixpkgs {
          # --- Explicitly assign system = currentSystem here too ---
          system = currentSystem;
          config.allowUnfree = true;
        };
      })
    ];
  };
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{

  fonts.packages = with pkgs; [
    helvetica-neue-lt-std
  ];

  programs.spicetify = {
     enable = true;
     enabledExtensions = with spicePkgs.extensions; [
       adblockify
       hidePodcasts
       shuffle # shuffle+ (special characters are sanitized out of extension names)
     ];
    theme = spicePkgs.themes.text;
    colorScheme = "CatppuccinMacchiato";
   };

  services.postgresql.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
 # hardware.nvidia.modesetting.enable = true;
	
  hardware.graphics.enable = true;

  hardware.nvidia.prime = {
    offload.enable = false; # Disable PRIME offload
    sync.enable = false;    # Disable PRIME sync (if applicable/enabled by default)
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };


  # Set pkgs for hydenix globally, any file that imports pkgs will use this
  nixpkgs.pkgs = pkgs;

  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    inputs.hydenix.lib.nixOsModules
    ./modules/system

    # === GPU-specific configurations ===

    /*
      For drivers, we are leveraging nixos-hardware
      Most common drivers are below, but you can see more options here: https://github.com/NixOS/nixos-hardware
    */

    #! EDIT THIS SECTION
    # For NVIDIA setups
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia

    # For AMD setups
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU-specific configurations ===
    # For AMD CPUs
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd

    # For Intel CPUs
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-intel

    # === Other common modules ===
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      pkgs = pkgs;
      # --- Explicitly pass system = currentSystem ---
      system = currentSystem;
    };

    backupFileExtension = "backup";

    #! EDIT THIS USER (must match users defined below)
    users."harth" =
      { ... }:
      {
        imports = [
          inputs.hydenix.lib.homeModules
          # Nix-index-database - for comma and command-not-found
          inputs.nix-index-database.hmModules.nix-index

          inputs.textfox.homeManagerModules.textfox

          inputs.nur.modules.homeManager.default

          ./modules/hm
          ./modules/hm/gui
        ];
      };
  };

  # IMPORTANT: Customize the following values to match your preferences
  hydenix = {
    enable = true; # Enable the Hydenix module

    #! EDIT THESE VALUES
    hostname = "harth"; # Change to your preferred hostname
    timezone = "Asia/Karachi"; # Change to your timezone
    locale = "en_US.UTF-8"; # Change to your preferred locale

    /*
      Optionally edit the below values, or leave to use hydenix defaults
      visit ./modules/hm/default.nix for more options
    */
      audio.enable = true; # enable audio module
      boot = {
        enable = true; # enable boot module
        useSystemdBoot = false; # disable for GRUB
        grubTheme = pkgs.hydenix.grub-retroboot; # or pkgs.hydenix.grub-pochita
        grubExtraConfig = ""; # additional GRUB configuration
        kernelPackages = pkgs.linuxPackages_zen; # default zen kernel
      };
      gaming.enable = true; # enable gaming module
      hardware.enable = true; # enable hardware module
      network.enable = true; # enable network module
      nix.enable = true; # enable nix module
      sddm = {
        enable = true; # enable sddm module
        theme = pkgs.hydenix.sddm-candy; # or pkgs.hydenix.sddm-corners
      };
      system.enable = true; # enable system module
    /*
    */
  };

  #! EDIT THESE VALUES (must match users defined above)
  users.users.harth = {
    isNormalUser = true; # Regular user account
    initialPassword = "harth"; # Default password (CHANGE THIS after first login with passwd)
    extraGroups = [
      "wheel" # For sudo access
      "networkmanager" # For network management
      "video" # For display/graphics access
      # Add other groups as needed
    ];
    shell = pkgs.zsh; # Change if you prefer a different shell
  };

  system.stateVersion = "25.05";
}
