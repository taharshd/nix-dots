{ pkgs, lib,  ... }:
let
  textfoxTabOverride = ''
    /* shift the little “tabs” label down a bit */
    #TabsToolbar::before {
      margin: 0 !important;
      top: 0.15rem !important;
      left: 1.25rem !important;
      padding: 0 4px !important;
    }
  '';
  in
{
  programs.firefox = {
    enable = true;

    profiles = {
      harth = {
        userChrome = lib.mkAfter textfoxTabOverride;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          vimium
          bitwarden
          startpage-private-search
          firefox-color
          darkreader
          react-devtools
        ];
      };
    };
  };

  textfox = {
    enable = true;
    profile = "harth";

    # https://github.com/adriankarlen/textfox/pull/131
    useLegacyExtensions = false;
    config = {
      border = {
        transition = "0.2s ease";
          width = "2px";
          radius = "0px";
      };
      tabs.horizontal.enable = true;

      tabs.vertical.margin="0.8rem";

      displayWindowControls = true;
      displayNavButtons = false;
      displayUrlbarIcons = true;
      displaySidebarTools = true;
      displayTitles = true;
      font = {
        family = "SF Mono";
        size = "16px";
      };
    };

  };
}