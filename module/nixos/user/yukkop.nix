module: { inputs, lib, config,  ... }@args:
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
    ((import module) user)
  ];
  
  options = {
      preset.user."${user}" = {
        enable =
          lib.mkEnableOption "enable ${user}";
        graphics = lib.mkOption {
          type = lib.types.bool;
	  default = false;
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

    users.users."${user}" = {
     isNormalUser = true;
     initialPassword = "kk";
     extraGroups = [ "wheel" "docker" "owner" ];
    };
  
    systemd.tmpfiles.rules = [
      "d /persist/home/${user} 1777 ${user} users - -"
    ];
  
    home-manager.users."${user}" = 
  };
}
