{ pkgs, inputs, flakeRoot ? null, lib, config, ... }:
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
  imports = [
    inputs.home-manager.nixosModules.default
    (flakeRoot.nixosModules.program.youtube.youtube-dl user)
    (flakeRoot.nixosModules.program.discord user)
    (flakeRoot.nixosModules.program.mpv user)
    (flakeRoot.nixosModules.program.obs-studio user)
    (flakeRoot.nixosModules.program.minecraft user)
    (flakeRoot.nixosModules.program.qutebrowser user)
    (flakeRoot.nixosModules.program.steam user)
    (flakeRoot.nixosModules.program.telegram user)
    (flakeRoot.nixosModules.program.nixvim.home-manager user)
    (flakeRoot.nixosModules.program.zsh user shellAliases)
    (flakeRoot.nixosModules.program.hyprland.home-manager user "grim -g \"''$(slurp)\" - | swappy -f")
  ];

  options = {
    module.user."${user}" = {
      enable =
        lib.mkEnableOption "enable ${user}";
      graphics =
        lib.mkEnableOption "enable graphics for ${user}";
      persistence =
        lib.mkEnableOption "enable persistence for ${user}";
    };
  };


  config = lib.mkIf config.module.user."${user}".enable {

    module.home.user."${user}".program = {
      nixvim.enable = true;
      nixvim.persistence = lib.mkIf config.module.user."${user}".persistence true;
    };
    module.program = {
      steam.enable = lib.mkIf config.module.user."${user}".graphics true;
      steam.persistence = lib.mkIf config.module.user."${user}".persistence true;
  
      qutebrowser.enable = lib.mkIf config.module.user."${user}".graphics true;
      qutebrowser.persistence = lib.mkIf config.module.user."${user}".persistence true;

      mpv.enable = lib.mkIf config.module.user."${user}".graphics true;
      mpv.persistence = lib.mkIf config.module.user."${user}".persistence true;

      discord.enable = lib.mkIf config.module.user."${user}".graphics true;
      discord.persistence = lib.mkIf config.module.user."${user}".persistence true;

      minecraft.enable = lib.mkIf config.module.user."${user}".graphics true;
      minecraft.persistence = lib.mkIf config.module.user."${user}".persistence true;

      obs-studio.enable = lib.mkIf config.module.user."${user}".graphics true;
      obs-studio.persistence = lib.mkIf config.module.user."${user}".persistence true;

      telegram.enable = lib.mkIf config.module.user."${user}".graphics true;
      telegram.persistence = lib.mkIf config.module.user."${user}".persistence true;

      zsh.enable = true;
      zsh.persistence = lib.mkIf config.module.user."${user}".persistence true;

      tmux.enable = true;
      youtube-dl.enable = true;
    };

    module.home.windowManager.hyprland.enable = lib.mkIf config.module.user."${user}".graphics true;
  
    users.users."${user}" = {
     isNormalUser = true;
     initialPassword = "kk";
     extraGroups = [ "wheel" "docker" "owner" ];
    };
  
    systemd.tmpfiles.rules = [
      "d /persist/home/${user} 1777 ${user} users - -"
    ];
  
    home-manager = {
      users = {
        "${user}" = {
          imports = let 
  	    screenshoter = import ../program/screenshot/wayland-way.nix;
  	  in [
              inputs.impermanence.nixosModules.home-manager.impermanence
  	      screenshoter
          ];

          home.stateVersion = "24.05";
  
          home.persistence."/persist/home/${user}" = lib.mkIf config.module.user."${user}".persistence {
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
  
  	  home.packages = with pkgs; [
  	    htop
  	  ];
  
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
    };
  };
}
