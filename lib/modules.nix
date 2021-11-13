{ self, lib, ... }:

with builtins;
with lib;
let inherit (self.attrs) mapFilterAttrs;
in rec {
  mapModules = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n))
                   (n: v:
                     let path = "${toString dir}/${n}"; in
                     if v == "directory" && pathExists "${path}/default.nix"
                     then nameValuePair n (fn path)
                     else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
                     then nameValuePair (removeSuffix ".nix" n) (fn path)
                     else nameValuePair "" null)
                   (readDir dir);

  mapModulesRec = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n))
                   (n: v:
                     let path = "${toString dir}/${n}"; in
                     if v == "directory"
                     then nameValuePair n (importModules path)
                     else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
                     then nameValuePair (removeSuffix ".nix" n) (import path)
                     else nameValuePair "" null)
                   (readDir dir);

  mapModulesRec' = dir: fn:
    let
      dirs = mapAttrsToList (k: _: "${dir}/${k}")
                            (filterAttrs
                              (n: v: v == "directory" && !(hasPrefix "_" n))
                              (readDir dir));
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
    in map fn paths;
}