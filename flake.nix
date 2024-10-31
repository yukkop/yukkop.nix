{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-24-05.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
      inputs.home-manager.follows = "home-manager";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
    };

    nixos-hardware.url = "github:yukkop/nixos-hardware/b4497d9a077c777d9a7941517b7ef5045c3e873b";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24-05";
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

    # privat repo
    # FIXME starter system in neverlate repo
    neverlate.url = "git+ssh://github/yukkop/neverlate.git?shallow=1";
  };

  outputs = {self, nixos-wsl, nix-on-droid, nixpkgs-24-05, nixpkgs-unstable, deploy-rs, ...}@inputs: 
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

      nixosModules = ./module/nix-os/default.nix;
      sharedModules = ./module/shared/default.nix;
      homeManagerModules = ./module/home-manager/default.nix; 
      nixOnDroidModules = ./module/nix-on-droid/default.nix; 

      nixOnDroidConfigurations.tablet = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs-24-05 {
	  allowUnfree = true;
	};
        modules = [
	  ./system/tablet.nix
	  self.nixOnDroidModules
	  self.homeManagerModules
	];
        extraSpecialArgs = {
          inherit inputs flakeRootPath;
          outputs = self;
	  configType = "nix-on-droid";
        };
      };

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
            outputs = self;
            nixosModules = self.nixosModules;
	    configType = "nixos";
          };
        })
        (let
	  system = "x86_64-linux";
	in
	mkNixosConfiguration nixpkgs-24-05 "neverlate" {
	  inherit system;
          config = { 
	    allowUnfree = true;
	  };
          modules = [
	    inputs.neverlate.nixosModules.${system}.default
	  ];
          specialArgs = {
            inherit inputs flakeRootPath;
            outputs = self;
            nixosModules = self.nixosModules;
	    configType = "nixos";
          };
        })
        (mkNixosConfiguration nixpkgs-24-05 "wsl" {
          config = { 
	    allowUnfree = true;
	  };
          system = "x86_64-linux";
	  modules = [
	    nixos-wsl.nixosModules.default {
              system.stateVersion = "24.05";
	      wsl.enable = true;
	    }
	  ];
          specialArgs = {
            inherit inputs flakeRootPath;
            outputs = self;
            nixosModules = self.nixosModules;
	    configType = "nixos-wsl";
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

      deploy.nodes.neverlate = let
        inherit (self.nixosConfigurations.neverlate.config.nixpkgs) system;
      in {
        hostname = "neverlate";
        fastConnection = true;
        profilesOrder = [ "system" ];
        #sshOpts = [ ];
        profiles."system" = {
          sshUser = "root";
          path = deploy-rs.lib.${system}.activate.nixos
            self.nixosConfigurations.neverlate;
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
