{ outputs, lib, ... }@args:
let
  userOpts = path:
    with lib; 
    with builtins; let
      functions = pipe (readDir path) [
        (filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name && name != "module.nix"))
	attrNames
        (map (with types; name: attrsOf (submodule (import "${path}/${name}"))))
      ];
    in
      functions;
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
  #userOpts = { name, config, ... }: {
  #  imports = (outputs.lib.readSubModulesAsList ./.);
  #
  #  options = {};
  #
  #  config = with lib; mkMerge
  #    [{ name = mkDefault name; }];
  #};
in
{
  #imports = (outputs.lib.readSubModulesAsList ./user);

  options = with lib; {
    preset.user = mkOption {
      default = {};
      type = with types; oneOf (userOpts ./user);
      example = {
        yukkop.enable = true;
      };
      description = ''
        precreated user modules
      '';
    };
  };

  config = {
    preset.user = readUsers ./user;
  };
}
