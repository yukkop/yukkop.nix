{ inputs, lib, config, nixosModules,  ... }@args:
let 
  user = "yukkop";
  cfg = config.preset.user."${user}";
  shellAliases = {
    dev = "nix develop -c zsh";
    hlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 2 | tail -n 1)/hyprland.log";
    ttyhlog = "cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log";
  };
in
{
  imports = [
    (nixosModules.environment.preset.user.module user)
  ];
  
  options = {
      preset.user."${user}" = {
        enable =
          lib.mkEnableOption "enable ${user}";
        graphics = lib.mkOption {
          type = lib.types.bool;
	  default = config.preset.graphics;
          description = ''
            is enable graphics and program related to it in this yukkop
          '';
        };
        shellAliases = lib.mkOption {
          type = with lib.types; attrsOf (nullOr (either str path));
          default = {};
          description = "Shell alliases, would provide to all enable shell";
          example = {
            tmux = "tmux a";
            ll = "ls -la";
          };
        };
      };
  };


  config = 
    lib.mkIf cfg.enable 
  {
    preset.user."${user}" = {
      shellAliases = shellAliases;
      program = {
        nixvim.enable = true;

        zsh.enable = true;

        terminal.kitty.enable = true;

        steam.enable = lib.mkIf cfg.graphics true;
  
        qutebrowser.enable = lib.mkIf cfg.graphics true;

        mpv.enable = lib.mkIf cfg.graphics true;

        discord.enable = lib.mkIf cfg.graphics true;

        minecraft.enable = lib.mkIf cfg.graphics true;

        obs-studio.enable = lib.mkIf cfg.graphics true;

        telegram.enable = lib.mkIf cfg.graphics true;

        # deprecated
        youtube-dl.enable = false;

        yt-dlp.enable = true;
      };
      windowManager = lib.mkIf cfg.graphics {
        hyprland.enable = lib.mkIf cfg.graphics true;
      };
    };

    users.users."${user}" = {
     isNormalUser = true;
     initialPassword = "kk";
     extraGroups = [ "wheel" "docker" "owner" ];
    };
  
    systemd.tmpfiles.rules = [
      "d /persist/home/${user} 1777 ${user} users - -"
    ];
  
    home-manager.users."${user}" = {
          imports = [
              inputs.impermanence.nixosModules.home-manager.impermanence
          ];

          home.stateVersion = "24.05";
  
          home.persistence."/persist/home/${user}" = lib.mkIf config.preset.impermanence {
            directories = [
              "Downloads"
              "pj"
              "ms"
              "pc"
              "dc"
  	      "mc"
              "vd"
              ".ssh"
  	      ".config/tmux" # TODO: in tmux module
  	      ".tmux" # TODO: in tmux module
            ];
            files = [
  	      # FIXME simlynks issue
              "dw" # link to Downloads
            ];
            allowOther = true; # allows other users, such as root, to access files
          };
  
  	  programs = {
  	    bash = {
  	      shellAliases = shellAliases;
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
}
