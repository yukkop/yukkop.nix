{ self, inputs, flake, lib, ... }: rec {
  defaultConfig = nixpkgs: {
    allowUnfreePredicate = nixpkgs: [
    ];
  };

  mkNixosConfiguration = 
  with builtins;
  modulesPath:
  nixpkgs:
  name:
  options@{
    config ? defaultConfig nixpkgs,
    overlays ? [ self.overlays.default ],
    ...
  }: {
    inherit name;
    value = let
      args = removeAttrs options [ "config" "overlays" ];
      pkgs = import nixpkgs {
        inherit (args) system;
	inherit overlays config;
      };
      lib = pkgs.lib;
      systemModulePath = /${modulesPath}/system/${name}.nix;
      systemModule = filter pathExists [ systemModulePath ];
    in nixpkgs.lib.nixosSystem (args // {
      pkgs = args.pkgs or pkgs;
      lib = args.lib or lib;
      modules = args.modules or [
        ({ networking.hostName = name; })
      ]
      ++ lib.warnIf (systemModule == [] && !(args ? modules))
        "Module '${toString systemModulePath}' does not exist and you haven't provided your own modules. Default NixOS system will be build."
	systemModule;
      specialArgs = args.specialArgs or { inherit self inputs flake; }; # Pass flake inputs to our config
    });
  };

  readModulesRecursive = path:
    lib.mapAttrs' (
      name: value: let
        name' = builtins.replaceStrungs [".nix"] [""] name;
      in
        if value == "regular"
	then {
	  name = name';
	  value = import "${path}/${name}";
	}
	else {
	  inherit name;
	  value = readModulesRecursive "${path}/${name}";
	}
    ) (builtins.readDir path);

    readModulesRecursive' = path:
      with lib;
      with builtins; let
        path = pipe "${path}" [
	  (filesystem.listFilesRecursive)
	  (filter (hasSuffix ".nix"))
	];
	pathToName = flip pipe [
	  (removePrefix "${path}/")
	  (replaceStrings ["/" ".nix"] ["." ""])
	  (removeSuffix ".nix")
	];
	
	attrList = 
	  map (path': {
	    name = pathRoName (unsafeDiscordStringContext path');
	    value = import path';
	  })
	  paths;
       in
         listToAttrs attrList;
}
