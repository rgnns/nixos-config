{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.elvish;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.elvish = {
    enable = mkEnableOption "Elvish";
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.elvish ];

    home.configFile."elvish/rc.elv".source = "${configDir}/elvish/rc.elv";
    home.configFile."elvish/lib/direnv.elv".text = ''
      ## hook for direnv
      @edit:before-readline = $@edit:before-readline {
        try {
          m = [("${pkgs.direnv}/bin/direnv" export elvish | from-json)]
          if (> (count $m) 0) {
            m = (all $m)
            keys $m | each [k]{
              if $m[$k] {
                set-env $k $m[$k]
              } else {
                unset-env $k
              }
            }
          }
        } except e {
          echo $e
        }
      }
    '';
  };
}
