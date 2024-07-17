{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";

    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:yukkop/nixos-hardware/b4497d9a077c777d9a7941517b7ef5045c3e873b";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
      #url = "github:nix-community/nixvim";
      #inputs.nixpkgs.follows = "nixpkgs-unstable";
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

  outputs = {self, nixpkgs-24-05, nixpkgs-unstable, deploy-rs, ...} @ inputs: 
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

      nixosModules = {
        infrastructure = self.lib.readModulesRecursive ./module/infrastructure;
	environment = {
	  module = import ./module/environment/module.nix;
	  common = self.lib.readModulesRecursive ./module/environment/common;
	  preset = self.lib.readModulesRecursive ./module/environment/preset;
	};
      };

      #nixosConfigurations.home = nixpkgs-24-05.lib.nixosSystem {
      #  system = "x86_64-linux";
      #  specialArgs = {inherit inputs flakeRootPath; flakeRoot = self;};
      #  modules = [
      #    #self.nixosModules.system.home
      #    ./module/system/home.nix
      #  ];
      #};

      # CRITICAL: if you try install unfree package wthout
      # config = { allowUnfree = true; };
      # this string, it will return strange unreadble error
      # allowing unfree in any another place does not fix it
      nixosConfigurations = let 
        mkNixosConfiguration = self.lib.mkNixosConfiguration ./.;
      in builtins.listToAttrs [
        (mkNixosConfiguration nixpkgs-24-05 "home" {
          config = { 
	    allowUnfree = true;
	    nvidia.acceptLicense = true;
	  };
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs flakeRootPath;
            flakeRoot = self;
          };
        })
        (mkNixosConfiguration nixpkgs-24-05 "tenix" {
          config = { };
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            outputs = self;
            nixosModules = self.nixosModules;
          };
        })
        (mkNixosConfiguration nixpkgs-24-05 "ariadne" {
          config = { };
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs flakeRootPath;
            flakeRoot = self;
          };
        })
        (mkNixosConfiguration nixpkgs-24-05 "neverlate" {
          config = { };
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs flakeRootPath;
            outputs = self;
          };
        })
      ];

      # --- Deployments
      # nix run nixpkgs#deploy-rs -- -s --remote-build .#tenix.system -- --verbose
      deploy.nodes.tenix = let
        inherit (self.nixosConfigurations.tenix.config.nixpkgs) system;
      in {
        hostname = "tenix";
        fastConnection = true;
        profilesOrder = [ "system" ];
        #sshOpts = [ ];
        profiles."system" = {
          sshUser = "root";
          path = deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.tenix;
          user = "root";
        };
      };

      deploy.nodes.ariadne = let
        inherit (self.nixosConfigurations.ariadne.config.nixpkgs) system;
      in {
        hostname = "ariadne";
        fastConnection = true;
        profilesOrder = [ "ariadne" ];
        #sshOpts = [ ];
        profiles."system" = {
          sshUser = "root";
          path = deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.ariadne;
          user = "root";
        };
      };
    };
}
