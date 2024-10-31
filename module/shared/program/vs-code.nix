{ pkgs, lib, config, nixosModules, outputs, ... }@args: 
let
  cfg = config.preset.program.vs-code;
in
{
  options = with lib; {
    preset.program.vs-code = {
      enable =
        mkEnableOption "enable vs-code";
      config = mkOption {
        type = types.anything;
        description = ''
          vs-code config attributes or fuction that return its
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
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
