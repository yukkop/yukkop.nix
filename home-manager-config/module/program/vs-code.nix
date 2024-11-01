{ pkgs, lib, config,  ... }: 
let
  cfg = config.preset.program.vs-code;
in
{
  options = {
    preset.program.vs-code = {
      enable =
        lib.mkEnableOption "enable vs-code";
    };
  };
 
  config = 
    lib.mkIf cfg.enable
  {
      home.packages = with pkgs; [
	 (vscode-with-extensions.override {
           vscodeExtensions = with vscode-extensions; [
             bbenoist.nix
	     vim
           ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
             {
               name = "remote-ssh-edit";
               publisher = "ms-vscode-remote";
               version = "0.47.2";
               sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
             }
           ];
         })
      ];
  };
}

