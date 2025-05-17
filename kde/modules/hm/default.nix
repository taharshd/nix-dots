{ config, pkgs, lib, inputs, system, ... }:

{
  imports = [
    # ./example.nix - add your modules here
  ];

  # Your existing gh configuration
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # Your existing home.file configurations
  # Consider reviewing these, especially Hyprland/Wayland specific ones,
  # if you are no longer using those environments.
  home.file = {
    # Example: ".config/Code/User/settings.json" = { source = lib.mkForce ../config/Code/User/settings.json; };
    # Example: ".config/waybar/modules/style.css" = { source = lib.mkForce ../config/waybar/modules/style.css; };
    # Example: ".config/waybar/style.css" = { source = lib.mkForce ../config/waybar/style.css; };

    # These were in your original config, review if still needed for KDE:
    # ".config/electron-flags.conf" = { source = lib.mkForce ../config/electron-flags.conf; };
    # ".config/hypr/monitors.conf" = { source = lib.mkForce ../config/hypr/monitors.conf; }; # Hyprland specific
    # ".config/hypr/hyde.conf" = { source = lib.mkForce ../config/hypr/hyde.conf; }; # Hyprland specific
    # ".config/kitty/hyde.conf" = { source = lib.mkForce ../config/kitty/hyde.conf; }; # Hydenix specific for Kitty, manage via programs.kitty.extraConfig instead
    # ".zshrc" = { source = lib.mkForce ../config/.zshrc; }; # Keep if you use Zsh
    # ".config/hypr/windowrules.conf" = { source = lib.mkForce ../config/hypr/windowrules.conf; }; # Hyprland specific
    # ".config/hypr/keybindings.conf" = { source = lib.mkForce ../config/hypr/keybindings.conf; }; # Hyprland specific
    # ".config/hypr/userprefs.conf" = { source = lib.mkForce ../config/hypr/userprefs.conf; }; # Hyprland specific
  };

  # --- Converted Hydenix Options ---


  home.packages = with pkgs; [ 
      comma
      discord
    ];

  # Dolphin File Manager (KDE's default, enabling here allows for HM configuration if needed)
  programs.dolphin.enable = true;
  # You can add specific Dolphin settings here, e.g.:
  # programs.dolphin.settings = {
  #   General.ConfirmExit = false;
  # };

  # Editors
  programs.neovim.enable = true;
  # programs.neovim.extraConfig = ''
  #   set nu
  # '';
  programs.vim.enable = true;
  # programs.vim.extraConfig = ''
  #   set nu
  # '';
  home.sessionVariables.EDITOR = "neovim"; # Sets the default editor

  # Fastfetch
  programs.fastfetch.enable = true;
  # programs.fastfetch.settings = {
  #   logo.source = "nixos_small";
  # };

  # Git
  programs.git = {
    enable = true;
    userName = "taharshd";
    userEmail = "trdev4@gmail.com";
    # extraConfig = {
    #   core.editor = "nvim";
    # };
  };

  # Notifications
  # KDE Plasma has its own notification system.
  # If you want a standalone daemon like Dunst, you can enable it:
  # services.dunst = {
  #   enable = true;
  #   settings = {
  #     global = {
  #       format = "<b>%s</b>\\n%b";
  #     };
  #   };
  # };

  # Qt Platform Theme and Styling
  # This helps ensure Qt applications integrate well with your Plasma theme.
  qt = {
    enable = true;
    platformTheme = "kde"; # Or "qtct" if you use qt5ct/qt6ct
    style = "breeze"; # Or your preferred Qt style
  };

  programs.rofi = {
      enable = true;
      theme = "solarized";
      extraConfig = {
      modi = "drun,run,window";
    };
  };

  # Shell (Zsh)
  programs.zsh = {
    enable = true; 
    ohMyZsh.enable = true; # Example: if you use Oh My Zsh
  };


  # Terminals (Kitty)
  programs.kitty = {
    enable = true;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
    };
    # mimeApps.enable = true; # Enable if you want to manage default applications
    # mimeApps.defaultApplications = {
    #   "text/html" = "firefox.desktop";
    #   "image/jpeg" = "krita.desktop";
    # };
  };
}
