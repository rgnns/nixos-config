{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.tools.gpg;
in {
  options.modules.tools.gpg = {
    enable = mkEnableOption "GnuPG";
  };

  config = mkIf cfg.enable {
    environment.variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";

    programs.gnupg.agent.enable = true;

    home.configFile."gnupg/gpg-agent.conf".text = ''
      allow-loopback-pinentry
      enable-ssh-support
      default-cache-ttl 86400
      max-cache-ttl 86400
      pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
    '';
  };
}
