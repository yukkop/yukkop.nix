{ persist ? false, pkgs, inputs, flakeRoot ? null, flakeRootPath, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  users.users."yukkop" = {
   isNormalUser = true;
   initialPassword = "kk";
   extraGroups = [ "wheel" "docker" "owner" ];
  };

  systemd.tmpfiles.rules = [
    "d /persist/home/yukkop 1777 yukkop users - -"
  ];

  home-manager = {
    users = {
      "yukkop" = {
        imports = let 
          #screenshoter = flakeRoot.nixosModules.program.screenshot.wayland-way;
	  screenshoter = import ../program/screenshot/wayland-way.nix;
	in [
          inputs.impermanence.nixosModules.home-manager.impermanence
          (flakeRoot.nixosModules.program.nixvim { homeManager = true; nixvim = inputs.nixvim; })
          (flakeRoot.nixosModules.program.hyprland.home-manager { screenshotCommand = ""; })
	  #screenshoter.module pkgs
        ];

        home.stateVersion = "24.05";

        home.persistence."/persist/home/yukkop" = {
          directories = [
            "Downloads"
            "pj"
            "ms"
            "pc"
            "dc"
            "vd"
            ".ssh"
	    ".config/qutebrowser" # TODO: in qutebrowser module
	    ".local/share/qutebrowser"
	    ".local/share/Steam" # TODO: in steam module
          ];
          files = [
            "dw" # link to Downloads
          ];
          allowOther = true; # allows other users, such as root, to access files
        };

	home.packages = with pkgs; [
	  telegram-desktop
	  discord
	];

        programs.git = {
          enable = true;
          lfs.enable = true;
          userName = "yukkop";
          userEmail = "hectic.yukkop@gmail.com";
          extraConfig = {
            push = { autoSetupRemote = true; };
            safe = { directory = "/persist/nixos"; };
            init = { defaultBranch = "master"; };
          };
        };
      };
    };
  };
}
