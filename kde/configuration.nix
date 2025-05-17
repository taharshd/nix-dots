{ inputs, system, config, spicetify, ... }:
let
  currentSystem = system;
  pkgs = import inputs.pkgs {
    system = currentSystem;
    config.allowUnfree = true;
    overlays = [
      inputs.nur.overlays.default
      inputs.nix-vscode-extensions.overlays.default
      (import ./overlays/customPkgs.nix)
      (final: prev: {
        userPkgs = import inputs.nixpkgs {
          system = currentSystem;
          config.allowUnfree = true;
        };
      })
    ];
  };
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  # System settings
  networking.hostName = "harth";
  time.timeZone = "Asia/Karachi";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Bootloader (GRUB example)
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda"; # Change as needed!
    # theme = ... # Add a theme if you want
    # extraConfig = ""; # Add extra config if needed
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # NVIDIA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.graphics.enable = true;
  hardware.nvidia.prime = {
    offload.enable = false;
    sync.enable = false;
  };

  # Enable KDE Plasma
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  # SDDM theme (optional, use a standard one or your own)
  # services.xserver.displayManager.sddm.theme = "breeze"; # or your custom theme

  # Fonts
  fonts.packages = with pkgs; [
    helvetica-neue-lt-std
  ];

  # PostgreSQL
  services.postgresql.enable = true;

  # Spicetify
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      shuffle
    ];
    theme = spicePkgs.themes.text;
    colorScheme = "CatppuccinMacchiato";
  };

  # OBS Studio
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  # User
  users.users.harth = {
    isNormalUser = true;
    initialPassword = "harth"; # CHANGE after first login!
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.zsh;
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      pkgs = pkgs;
      system = currentSystem;
    };
    backupFileExtension = "backup";
    users."harth" = { ... }: {
      imports = [
        inputs.nix-index-database.hmModules.nix-index
        inputs.textfox.homeManagerModules.textfox
        inputs.nur.modules.homeManager.default
        ./modules/hm
        ./modules/hm/gui
      ];
    };
  };

  # Import hardware config and any other modules
  imports = [
    ./hardware-configuration.nix
    ./modules/system
  ];

  system.stateVersion = "25.05";
}