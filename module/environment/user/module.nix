{ lib, pkgs, ... }@args:
let 
  readUsers = path: 
    with lib; 
    with builtins; let
      paths = pipe (readDir path) [
        (filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name && name != "module.nix"))
	attrNames
        (map (name: { 
	  name = builtins.replaceStrings [".nix"] [""] name;
	  value = import "${path}/${name}" args;
	}))
	listToAttrs
      ];
    in
      paths;
in
{
  options = {
    preset.user = readUsers ./user;

  };

  config = {
  };
}
