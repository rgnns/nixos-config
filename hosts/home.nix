{ config, lib, ... }:

with lib;
{
  networking.hosts =
    let
      hostConfig = {
        "192.168.86.14" = [ "krueger" ];
      };
      hosts = flatten (attrValues hostConfig);
      hostName = config.networking.hostName;
    in mkIf (builtins.elem hostName hosts) hostConfig;

  time.timeZone = mkDefault "America/Los_Angeles";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  location = {
    latitude = 42.6579;
    longitude = -83.1132;
  };
}
