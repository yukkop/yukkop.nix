{ inputs, lib, config,  outputs, ... }:
let
  username = "yukkop";
  cfg = config.preset;
in
{
          imports = [
              inputs.impermanence.nixosModules.home-manager.impermanence
	      #./module
          ];

	  options = {
	    prese = {
              graphics = lib.mkEnableOption "enable graphics"; 
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

          config = {
            preset = {
              #graphics = lib.mkDefault (config.preset.graphics or false);
              graphics = false;
              shellAliases = {};
              #program = {
              #  nixvim.enable = true;

              #  zsh.enable = true;

              #  terminal.kitty.enable = true;

              #  # REFACTOR: if (true) {true} ?????
              #  steam.enable = lib.mkIf cfg.graphics true;
  
              #  qutebrowser.enable = lib.mkIf cfg.graphics true;

              #  mpv.enable = lib.mkIf cfg.graphics true;

              #  discord.enable = lib.mkIf cfg.graphics true;

              #  minecraft.enable = lib.mkIf cfg.graphics true;

              #  obs-studio.enable = lib.mkIf cfg.graphics true;

              #  telegram.enable = lib.mkIf cfg.graphics true;

              #  # deprecated
              #  youtube-dl.enable = false;

              #  yt-dlp.enable = true;
              #};
              #windowManager = lib.mkIf cfg.graphics {
              #  hyprland.enable = lib.mkIf cfg.graphics true;
              #};
            };

            home.stateVersion = "24.05";
  
            home.persistence."/persist/home/${username}" = lib.mkIf config.preset.impermanence {
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
  	        shellAliases = {};
  	      };
  	    };
  
            programs.git = {
              enable = true;
              lfs.enable = true;
              userName = username;
              userEmail = "hectic.yukkop@gmail.com";
              extraConfig = {
                push = { autoSetupRemote = true; };
                safe = { directory = "/persist/nixos"; };
                init = { defaultBranch = "master"; };
              };
            };
	  };
        }
