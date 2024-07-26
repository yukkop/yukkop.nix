user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.user."${user}".program.vscode;
in
{
  options = {
    preset.user."${user}".program.vscode = {
      enable =
        lib.mkEnableOption "enable vscode";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      programs.vscode = {
        enable = true;
	extensions = with pkgs.vscode-extensions; [ 
	  ms-vsliveshare.vsliveshare
	  alefragnani.project-manager
	  asvetliakov.vscode-neovim
	];
      };

      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        # TODO:
        directories = [];
        allowOther = true; 
      };
    };
  };
}
