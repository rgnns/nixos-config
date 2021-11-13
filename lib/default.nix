{ inputs, pkgs, lib, ... }:

let
  inherit (modules) mapModules;

  modules = import ./modules.nix {
    inherit lib;
    self.attrs = import ./attrs.nix { inherit lib; self = {}; };
  };

  mylib = lib.makeExtensible (self:
    with self; mapModules ./.
      (file: import file { inherit self lib pkgs inputs; }));

in mylib.extend (self: super: lib.foldr (a: b: a // b) {} (lib.attrValues super))
