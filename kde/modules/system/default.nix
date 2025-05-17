{ pkgs, ... }:

{
  imports = [
    # ../hm/default.nix # Make sure this is NOT imported here
    # ... other system imports ...
  ];

  environment.systemPackages = with pkgs; [
    vscode
    wget
		kitty
		fastfetch
		gcc
		hyprlock
		pywal
		swaynotificationcenter
		ags
		pciutils
    libreoffice-qt6
    gh
    mpv
    wlogout
    nodejs
    tree
    btop
    direnv
    prisma
    openssl
    python3
    prisma-engines
    jupyter
    pywalfox
    pywal
    obsidian
    kdePackages.kcalc
  ];
  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
