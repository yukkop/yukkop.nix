{ self, inputs, flake, lib, ... }: rec {

  /* For knowing if the repo is locked */
  isLocked = !(builtins.readFile ../locked == "0");
  ifUnlocked = lib.optional (!isLocked);


  defaultConfig = nixpkgs: {
    allowUnfreePredicate = nixpkgs: [
    ];
  };

  /* Utility for NisOS configuration creation with sane defaults.

     Example:
     ```nix
     mkNixosConfiguration ./module inputs.nixpkgs-unstable "my-system" { system = "x86_64-linux"; }
     ```
        => an `x86_64-linux` system with configuration at
        `module/system/my-system.nix`, pkgs from `inputs.nixpkgs-unstable` with
        default overlay of this flake, hostname 'my-system', and this flake,
        this flake's inputs and this flake's root path passed as special args to
        modules.

     ```nix
     mkNixosConfiguration ./module inputs.nixpkgs-23-05 "my-system-custom" {
       system = "aarch64-linux"; 
       pkgs = mypkgs;
         ({ networking.hostName = "my-system-hostname" })
       ];
       specialArgs = { inherit foo bar baz; }
     }
     ```
       => an `aarch64-linux` system with configuration called
       "my-system-custom" at `module/system/my-system-custom.nix`, with pkgs
       `mypkgs`, lib `mypkgs.lib`, hostname 'my-system-hostname', and foo, bar
       and baz passed as special args to modules.
       Any omitted args will be substituted with defaults. This function is
       less usable if you don't want the defaults of this flake.

     ```nix
     mkNixosConfiguration ./module inputs.nixpkgs-23-05 "my-system-custom" {
       system = "x86_64-linux"; 
       overlays = [ foo bar baz ];
       config = { allowUnfree = true; };
       specialArgs = { inherit a b c; }
     }
     ```
       => an `aarch64-linux` system with configuration called
       "my-system-custom" at `module/system/my-system-custom.nix`, with pkgs
       from `inputs.nixpkgs-23-05`, lib from `inputs.nixpkgs-23-05`, hostname
       'my-system-hostname', overlays foo, bar and baz, nixpkgs config with
       unfree software enabled and a, b and c passed as special args to
       modules.
       NOTE: if you pass pkgs or lib directly it will not use overlays and
       config provided.

     Type:
       Options :: {
         system :: String;        # system architecture
         config :: AttrSet;       # see docs on `nixpkgs.config`
         overlays :: [OverlayFn]; # see the docs on nixpkgs overlays
         pkgs :: AttrSet;         # package set
         lib :: AttrSet;          # nixpkgs library attrset
         modules :: [Module];     # NixOS modules
         specialArgs :: AttrSet;  # custom arguments to pass to modules
       }
       mkNixosConfiguration ::
         Path          # dir with your modules with `system/name.nix` in it
         -> Nixpkgs    # nixpkgs from your flake inputs
         -> String     # configuration name (used for flake attribute and
                       hostname)
         -> Options    # options above
         -> { name :: String; value :: NixosSystem; };
                               
  */
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
        "Module '${toString systemModulePath}' does not exist and you haven't provided your own modules. Default NixOS system will be built."
        systemModule;
      specialArgs = args.specialArgs or { inherit self inputs flake; }; # Pass flake inputs to our config
    });
  };

  readModulesRecursive = path:
    lib.mapAttrs' (
      name: value: let
        name' = builtins.replaceStrings [".nix"] [""] name;
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

    readSubModulesAsListWithArgs = path: args: 
      with lib; 
      with builtins; let
        paths = pipe (readDir path) [
	  (mapAttrs (name: value:
            if value == "regular" && hasSuffix ".nix" name && name != "module.nix" then
              { pass = true; path =  "${path}/${name}"; }
            else if value == "directory" then
	      let
                path' = "${path}/${name}/module.nix";
	      in
	      if pathExists "${path'}" then
                { pass = true; path = "${path'}"; }
	      else 
	        { pass = false; }
	    else
	      { pass = false; }
          ))
	  ( filterAttrs (_: value: value.pass == true))
	  (mapAttrsToList (_: value: (import value.path args)))
        ];
      in
        paths;

    readSubModulesAsList = path: 
      with lib; 
      with builtins; let
        paths = pipe (readDir path) [
	  (mapAttrs (name: value:
            if value == "regular" && hasSuffix ".nix" name && name != "module.nix" then
              { pass = true; path =  "${path}/${name}"; }
            else if value == "directory" then
	      let
                path' = "${path}/${name}/module.nix";
	      in
	      if pathExists "${path'}" then
                { pass = true; path = "${path'}"; }
	      else 
	        { pass = false; }
	    else
	      { pass = false; }
          ))
	  ( filterAttrs (_: value: value.pass == true))
	  (mapAttrsToList (_: value: value.path))
        ];
      in
        paths;

    /* */
    readSubModules = path: 
      with lib; 
      with builtins; let
        paths = pipe (readDir path) [
	  (mapAttrs (name: value:
            if value == "regular" && hasSuffix ".nix" name && name != "module.nix" then
              { pass = true; path =  "${path}/${name}"; }
            else if value == "directory" then
	      let
                path' = "${path}/${name}/module.nix";
	      in
	      if pathExists "${path'}" then
                { pass = true; path = "${path'}"; }
	      else 
	        { pass = false; }
	    else
	      { pass = false; }
          ))
	  ( filterAttrs (_: value: value.pass == true))
	  (mapAttrsToList (_: value: value.path))
        ];
        pathToName = flip pipe [
          (removePrefix "${path}/")
          (replaceStrings ["/module.nix" ".nix"] ["" ""])
        ];
        attrList =
          map (path': {
            name = pathToName (unsafeDiscardStringContext path');
            value = import path';
          })
          paths;
      in
        listToAttrs attrList;

    readModulesRecursive' = path:
        with lib;
        with builtins; let
          paths = pipe "${path}" [
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
              name = pathToName (unsafeDiscardStringContext path');
              value = import path';
            })
            paths;
        in
          listToAttrs attrList;

      evaluateAttrOrFunction = value: args: 
       (if lib.isFunction value  then
         value args
       else
         value) 
       // { enable = true; };
}
