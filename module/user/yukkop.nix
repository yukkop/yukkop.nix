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
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          (flakeRoot.nixosModules.program.nixvim { homeManager = true; nixvim = inputs.nixvim; })
          flakeRoot.nixosModules.program.hyprland.home-manager
          flakeRoot.nixosModules.program.flameshot
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
          ];
          files = [
            "dw" # link to Downloads
          ];
          allowOther = true; # allows other users, such as root, to access files
        };

	home.packages = with pkgs; [
	  telegram-desktop
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
