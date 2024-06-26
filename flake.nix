{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixvim = {
      #url = "github:nix-community/nixvim/nixos-24.05";
      #inputs.nixpkgs.follows = "nixpkgs-24-05";
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };
  };

  outputs = {self, nixpkgs-24-05, nixpkgs-unstable, ...} @ inputs: 
  let
    flakeRootPath = ./.;
  
    # Generates outputs for all systems below
    forAllSystems = nixpkgs-unstable.lib.genAttrs systems;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in {
      lib = import ./lib {
        inherit self inputs;
        flake = flakeRootPath;
        lib = nixpkgs-unstable.lib;
      };

      overlays = import ./overlay { lib = nixpkgs-unstable.lib; };
      
      legacyPackages = forAllSystems (system: import nixpkgs-unstable {
        inherit system;
        overlays = [ /* self.overlays.default */ ];
        config = self.lib.defaultConfig nixpkgs-unstable;
      });

      nixosModules = self.lib.readModulesRecursive ./module;

      nixpkgs-unstable.config.allowUnfree = true;

      nixosConfigurations = let 
        mkNixosConfiguration = self.lib.mkNixosConfiguration ./module;
      in builtins.listToAttrs [
        (mkNixosConfiguration nixpkgs-24-05 "home" {
	  system = "x86_64-linux";
	  specialArgs = {
            inherit inputs flakeRootPath;
	    flakeRoot = self;
	  };
	})
      ];
    };
}
