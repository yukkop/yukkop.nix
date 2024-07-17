{ lib, ... }:
let 
  readUsers = path: 
    with lib; 
    with builtins; let
      paths = pipe (readDir path) [
        (filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name && name != "module.nix"))
	attrNames
        (map (name: { 
	  name = builtins.replaceStrings [".nix"] [""] name;
	  value = { enable = mkEnableOption ""; };
	}))
	listToAttrs
      ];
    in
      paths;
in
{
  user = readUsers ./user;

  options = {
  };

  config = {
  };
}
