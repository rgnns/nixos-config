{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.services.dunst;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.services.dunst = {
    enable = mkEnableOption "Dunst";
    settings = mkOption {
      type = types.submodule {
        freeformType = with types; attrsOf (attrsOf eitherStrBoolIntList);
        options = {
          global.icon_path = mkOption {
            type = types.separatedString ":";
            description = "Paths where dunst will look for icons.";
          };
        };
      };
      default = {};
      description = "Configuration writteh ton <filename>$XDG_CONFIG_HOME/dunst/dunstrc</filename>.";
    };
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.dunst ];

    home.dataFile."dbus-1/services/org.knopwob.dunst.service".source =
      "${pkgs.dunst}/share/dbus-1/services.org.knopwob.dunst.service";

    modules.desktop.services.dunst.settings.global.icon_path = let
      basePaths = [
        "/run/current-system/sw"
        "~/.nix-profile"
        pkgs.hicolor-icon-theme
      ];
      themes = [ { package = pkgs.hicolor-icon-theme; name = "hicolor"; size = "32x32"; } ];
      categories = [
        "actions"
        "animations"
        "apps"
        "categories"
        "devices"
        "emblems"
        "emotes"
        "filesystem"
        "intl"
        "legacy"
        "mimetypes"
        "places"
        "status"
        "stock"
      ];
      mkPath = { basePath, theme, category }: "${basePath}/share/icons/${theme.name}/${theme.size}/${category}";
    in concatMapStringsSep ":" mkPath (cartesianProductOfSets {
      basePath = basePaths;
      theme = themes;
      category = categories;
    });

    home.configFile."dunst/dunstrc" = {
      source = "${configDir}/dunst/dunstrc";
      onChange = ''
        ${pkgs.procps}/bin/pkill -u "$USER" ''${VERBOSE+-e} dunst || true
      '';
    };

    systemd.user.services.dunst = {
      description = "Dunst notification daemon";
      after = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.dunst}/bin/dunst -config $XDG_CONFIG_HOME/dunst/dunstrc";
      };
    };
  };
}
