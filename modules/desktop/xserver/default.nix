{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xserver;
    configDir = config.dotfiles.configDir;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environments enabled at a time";
      }
      {
        assertion =
          let srv = config.services;
          in srv.xserver.enable ||
             srv.sway.enable ||
             !(anyAttrs
               (n: v: isAttrs v &&
                      anyAttrs (n: v: isAttrs v && v.enable))
               cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      paper-icon-theme
    ];

    fonts = {
      enableDefaultFonts = true;
      enableGhostscriptFonts = true;
      fontDir.enable = true;
      fonts = with pkgs; [
        corefonts
        fira-code
        fira-code-symbols
        font-awesome
        font-awesome-ttf
        (iosevka.override {
          set = "term";
          privateBuildPlan = {
            family = "Iosevka Custom";
            spacing = "term";
            serifs = "sans";
            no-cv-ss = true;
            variants = {
              inherits = "ss15";
            };
          };
        })
        jetbrains-mono
        material-design-icons
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
        roboto-mono
        roboto
        siji
      ];
    };
  };
}
