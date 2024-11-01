user: { pkgs, lib, config, ... }: 
let
  cfg = config.preset.program.vscode;
in
{
  options = {
    preset.program.vscode = {
      enable =
        lib.mkEnableOption "enable vscode";
    };
  };

  config = lib.mkIf cfg.enable {
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
}
