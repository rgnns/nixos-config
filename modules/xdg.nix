{ config, home-manager, ... }:

{
  home-manager.users.${config.user.name}.xdg.enable = true;

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
    variables = {
      ASPELL_CONF = "conf $XDG_CONFIG_HOME/aspell/config;";
      EDITOR = "vim";
      GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
      LESSHISTFILE = "$XDG_CACHE_HOME/less/history";
    };
    extraInit = ''
      export XAUTHORITY=/tmp/Xauthority
      [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
    '';
  };
}
