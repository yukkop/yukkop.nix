{ persist ? false, pkgs, inputs, flakeRoot ? null, flakeRootPath, ... }:
let 
  user = "yukkop";
in
{
  imports = [
    inputs.home-manager.nixosModules.default
    (flakeRoot.nixosModules.program.qutebrowser user)
    (flakeRoot.nixosModules.program.steam user)
    (flakeRoot.nixosModules.program.obs-studio user)
    (flakeRoot.nixosModules.program.minecraft user)
    (flakeRoot.nixosModules.program.youtube.youtube-dl user)
    (flakeRoot.nixosModules.program.discord user)
  ];

  programs.qutebrowser.enable = true;
  programs.qutebrowser.persistence = true;

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
	  screenshoter = import ../program/screenshot/wayland-way.nix;
	in [
          inputs.impermanence.nixosModules.home-manager.impermanence
          (flakeRoot.nixosModules.program.nixvim { homeManager = true; nixvim = inputs.nixvim; })
          (flakeRoot.nixosModules.program.hyprland.home-manager { screenshotCommand = "grim -g \"''$(slurp)\" - | swappy -f"; })
	  screenshoter
        ];

        home.stateVersion = "24.05";

        home.persistence."/persist/home/yukkop" = {
          directories = [
            "Downloads"
            "pj"
            "ms"
            "pc"
            "dc"
	    "mn"
            "vd"
            ".ssh"
	    ".local/share/TelegramDesktop" # TODO: in telegram module
	    ".config/tmux" # TODO: in tmux module
	    ".tmux" # TODO: in tmux module
          ];
          files = [
	    # FIXME simlynks issue
            "dw" # link to Downloads
          ];
          allowOther = true; # allows other users, such as root, to access files
        };

	home.packages = with pkgs; [
	  telegram-desktop
	  htop
	  mpv
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
