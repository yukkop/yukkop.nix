{ persist ? false, pkgs, inputs, flakeRoot ? null, flakeRootPath, lib, config, ... }:
let 
  user = "yukkop";
  shellAliases = {
    dev = "nix develop -c zsh";
    hlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 2 | tail -n 1)/hyprland.log";
    ttyhlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log";
    mpvf = "mpv --osd-msg1='\${estimated-frame-number} / \${estimated-frame-count}'";
  };
in
{
  #options = {
  #  user.yukkop = {
  #    enable =
  #      lib.mkEnableOption "enable yukkop";
  #    graphics =
  #      lib.mkEnableOption "enable graphics for user";
  #  };
  #};

  #config = lib.mkIf config.user.yukkop.enable {
    imports = [
      inputs.home-manager.nixosModules.default
      (flakeRoot.nixosModules.program.youtube.youtube-dl user)
      (flakeRoot.nixosModules.program.discord user)
      (flakeRoot.nixosModules.program.mpv user)
      (flakeRoot.nixosModules.program.obs-studio user)
      (flakeRoot.nixosModules.program.minecraft user)
      (flakeRoot.nixosModules.program.qutebrowser user)
      (flakeRoot.nixosModules.program.steam user)
    ];

    module.program = {
      steam.enable = true;
      steam.persistence = true;
  
      qutebrowser.enable = true;
      qutebrowser.persistence = true;

      mpv.enable = true;
      mpv.persistence = true;

      discord.enable = true;
      discord.persistence = true;

      minecraft.enable = true;
      minecraft.persistence = true;

      obs-studio.enable = true;
      obs-studio.persistence = true;
    };
  
    users.users."${user}" = {
     isNormalUser = true;
     initialPassword = "kk";
     extraGroups = [ "wheel" "docker" "owner" ];
    };
  
    systemd.tmpfiles.rules = [
      "d /persist/home/yukkop 1777 yukkop users - -"
    ];
  
    home-manager = {
      users = {
        "${user}" = {
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
  	    "zsh/history"
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
  	];
  
  	programs = {
  	  bash = {
  	    shellAliases = shellAliases;
  	  };
  	  zsh = {
              enable = true;
              enableCompletion = true;
              autosuggestion.enable = true;
              syntaxHighlighting.enable = true;
            
  	    shellAliases = shellAliases;
              history = {
                size = 10000;
                path = "$HOME/zsh/history";
              };
              oh-my-zsh = {
                enable = true;
                #plugins = [ "git" "thefuck" ];
                #theme = "fox";
  	      #theme = "imajes";
  	      theme = "terminalparty";
  	      #theme = "itchy"
  	      #theme = "kardan"
  	      #theme = "nicoulaj"
              };
            };
  	};
  
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
  #};
}
