{ pkgs, lib, inputs, ... }:

{
  imports = [
    # ./example.nix - add your modules here
  ];
  # home-manager options go here
  home.packages = [
    # pkgs.vscode-fhs
  ];
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
  
  home.file = {
  # Path is relative to this hm/default.nix filez
  # Adjust if you placed your source file elsewhere
    ".config/electron-flags.conf" = {
      source = lib.mkForce ../config/electron-flags.conf;
    };
    ".config/hypr/monitors.conf" = {
      source = lib.mkForce ../config/hypr/monitors.conf;
    };
    ".config/hypr/hyde.conf" = {
      source = lib.mkForce ../config/hypr/hyde.conf;
    };
    ".config/kitty/hyde.conf" = {
      source = lib.mkForce ../config/kitty/hyde.conf;
    };
    ".zshrc" = {
      source = lib.mkForce ../config/.zshrc;
    };
    ".config/hypr/windowrules.conf" = {
      source = lib.mkForce ../config/hypr/windowrules.conf;
    };
    ".config/hypr/keybindings.conf" = {
      source = lib.mkForce ../config/hypr/keybindings.conf;
    };
    ".config/hypr/userprefs.conf" = {
      source = lib.mkForce ../config/hypr/userprefs.conf;
    };
    # ".config/waybar/modules/style.css" = {
    #   source = lib.mkForce ../config/waybar/modules/style.css;
    # };
    #".config/waybar/style.css" = {
    #  source = lib.mkForce ../config/waybar/style.css;
    #};
  };


  # hydenix home-manager options go here
  hydenix.hm = {
    #! Important options
    enable = true;

    
     # ! Below are defaults

      comma.enable = true; # useful nix tool to run software without installing it first
      dolphin.enable = true; # file manager
      editors = {
        enable = true; # enable editors module
        neovim = true; # enable neovim module
        vscode.enable = false;
        vim = true; # enable vim module
        default = "vim"; # default text editor
      };
      fastfetch.enable = true; # fastfetch configuration
      git = {
        enable = true; # enable git module
        name = "taharshd"; # git user name eg "John Doe"
        email = "trdev4@gmail.com"; # git user email eg "john.doe@example.com"
      };
      hyde.enable = true; # enable hyde module
      hyprland.enable = true; # enable hyprland module
      lockscreen = {
        enable = true; # enable lockscreen module
        hyprlock = true; # enable hyprlock lockscreen
        swaylock = false; # enable swaylock lockscreen
      };
      notifications.enable = true; # enable notifications module
      qt.enable = true; # enable qt module
      rofi.enable = true; # enable rofi module
      screenshots = {
        enable = true; # enable screenshots module
        grim.enable = true; # enable grim screenshot tool
        slurp.enable = true; # enable slurp region selection tool
        satty.enable = true; # enable satty screenshot annotation tool
        swappy.enable = false; # enable swappy screenshot editor
      };
      shell = {
        enable = true; # enable shell module
        zsh.enable = true; # enable zsh shell
        zsh.configText = ""; # zsh config text
        bash.enable = false; # enable bash shell
        fish.enable = false; # enable fish shell
        pokego.enable = false; # enable Pokemon ASCII art scripts
      };
      social = {
        enable = true; # enable social module
        discord.enable = true; # enable discord module
        webcord.enable = true; # enable webcord module
        vesktop.enable = true; # enable vesktop module
      };
      spotify.enable = false; # enable spotify module
      swww.enable = true; # enable swww wallpaper daemon
      terminals = {
        enable = true; # enable terminals module
        kitty = {
          enable = true; # enable kitty terminal
          configText = ""; # kitty config text
        };
      };
      
      theme = {
        enable = true; # enable theme module
        active = "Pixel Dream"; # active theme name
        themes = [
          "AbyssGreen"
          "Abyssal-Wave"
          "Another World"
          "Bad Blood"
          "BlueSky"
          "Cat Latte"
          "Cosmic Blue"
          "Crimson Blade"
          "Decay Green"
          "DoomBringers"
          "Dracula"
          "Edge Runner"
          "Eternal Arctic"
          "Ever Blushing"
          "Frosted Glass"
          "Graphite Mono"
          "Green Lush"
          "Greenify"
          "Gruvbox Retro"
          "Ice Age"
          "Mac OS"
          "Material Sakura"
          "Monokai"
          "Monterey Frost"
          "Moonlight"
          "Nordic Blue"
          "One Dark"
          "Oxo Carbon"
          "Paranoid Sweet"
          "Pixel Dream"
          "Rain Dark"
          "Red Stone"
          "Rosé Pine"
          "Solarized Dark"
          "Synth Wave"
          "Tokyo Night"
          "Vanta Black"
          "Windows 11"
          "Scarlet Night"
          "Sci-fi"
          "Catppuccin Mocha"
          "Catppuccin Latte"
        ]; # default enabled themes, full list in https://github.com/richen604/hydenix/tree/main/hydenix/sources/themes
      };
      waybar.enable = true; # enable waybar module
      wlogout.enable = true; # enable wlogout module
      xdg.enable = true; # enable xdg module
  };
}
