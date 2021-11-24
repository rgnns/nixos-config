{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.tools.ssh;
in {
  options.modules.tools.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable {
    home-manager.users.gl.programs.ssh = {
      enable = true;

      controlMaster = "auto";
      controlPath = "/tmp/ssh-%u-%r@%h:%p";
      controlPersist = "1800";

      forwardAgent = true;

      hashKnownHosts = true;
      userKnownHostsFile = "~/.config/ssh/known_hosts";

      matchBlocks = {
        id_local = {
          host = lib.concatStringsSep " " [
            "myrkheim" "vanaheim"
          ];
          identityFile = "~/.config/ssh/id_local";
          identitiesOnly = true;
        };

        id_github = {
          host = "github.com";
          identityFile = "~/.config/ssh/id_github";
        };

        id_gitlab = {
          host = "gitlab.com";
          identityFile = "~/.config/ssh/id_gitlab";
        };

        keychain = {
          host = "*";
          extraOptions = {
            UseKeychain = "yes";
            AddKeysToAgent = "yes";
            IgnoreUnknown = "UseKeychain";
          };
        };
      };
    };
  };
}
