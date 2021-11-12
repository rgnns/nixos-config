{ config, options, lib, home-manager, ... }:

with lib;
with lib.my;
{
  options = with types; {
    user = mkOpts attrs [];

    dotfiles = {
      dir = mkOption {
        type = path;
        default = (findFirst pathExists (toString ../.) [
          "${config.user.home}/.config/dotfiles"
          "/etc/dotfiles"
        ]);
      };
      binDir = mkOption {
        type = path;
        default = "${config.dotfiles.dir}/bin";
      };
      configDir = mkOption {
        type = path;
        default = "${config.dotfiles.dir}/config";
      };
      modulesDir = mkOption {
        type = path;
        default = "${config.dotfiles.dir}/modules";
      };
    };

    home = {
      file = mkOption {
        type = attrs;
        default = {};
      };
      configFile = mkOption {
        type = attrs;
        default = {};
      };
      dataFile = mkOption {
        type = attrs;
        default = {};
      };
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v: if isList v then concatMapStringsSep ":" (x: toString x) v
               else (toString v));
      default = {};
    };
  };

  config = {
    user =
      let name = "gl";
      in {
        inherit name;
        description = "The primary user account";
        extraGroups = [ "wheel" "networkmanager" ];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
        initialPassword = "";
      };

    home-manager = {
      useUserPackages = true;

      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix = let users = [ "root" config.user.name ]; in {
      trustedUsers = users;
      allowedUsers = users;
    };

    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit =
      concatStringsSep "\n"
        (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
