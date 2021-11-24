{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.terminal.xst;
in {
  options.modules.terminal.xst = {
    enable = mkEnableOption "Suckless Terminal";
    makeDefault = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        xst
        (makeDesktopItem {
          name = "xst";
          desktopName = "Suckless Terminal";
          icon = "utilities-terminal";
          exec = "${xst}/bin/xst";
          categories = "Development;System;Utility";
        })
      ];

      modules.shell.zsh.rcInit = ''
        [ "$TERM" = xst-x256color ] && export TERM=xterm-256color
      '';
    }

    (mkIf cfg.makeDefault { env.TERMINAL = "xst"; })
  ]);
}
