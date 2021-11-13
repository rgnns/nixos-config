{ inputs, pkgs, lib, ... }:

with lib;
with lib.my;
let sys = "x86_64-linux";
in {
  mkHost = path: attrs @ { system ? sys, ... }:
    let name = (removeSuffix ".nix" (baseNameOf path));
    in lib.nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault name;
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../.
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { system ? sys, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
