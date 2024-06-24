{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
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
        overlays = [ self.overlays.default ];
        config = self.lib.defaultConfig nixpkgs-unstable;
      });

      nixosModlules = self.lib.readModulesRecursive' ./module;

      #nixosConfigurations.home = nixpkgs-unstable.lib.nixosSystem {
      #  system = "x86_64-linux";
      #  specialArgs = {inherit inputs;};
      #  modules = [
      #    inputs.disko.nixosModules.default
      #    (import ./disko.nix { device = "/dev/nvme0n1"; })

      #    ./host/home/configuration.nix
      #          
      #    inputs.impermanence.nixosModules.impermanence
      #    inputs.home-manager.nixosModules.default
      #  ];
      #};

      nixosConfigurations = let 
        mkNixosConfiguration = self.lib.mkNixosConfiguration ./module;
      in builtins.listToAttrs [
        (mkNixosConfiguration nixpkgs-unstable "home" {
	  system = "x86_64-linux";
	  specialArgs = {
            inherit inputs flakeRootPath;
	    flakeRoot = self;
	  };
	})
      ];
    };
}
