user: { pkgs, lib, config,  ... }: 
let
  cfg = config.preset.user."${user}".program.discord;
in
{
  options = {
    preset.user."${user}".program.discord = {
      enable =
        lib.mkEnableOption "enable discord";
    };
  };
 
  config = 
    lib.mkIf cfg.enable
  {
    home-manager.users."${user}" = 
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
 
      home.persistence."/persist/home/${user}" =
        lib.mkIf config.preset.impermanence
      {
        directories = [
          ".config/discord"
        ];
        allowOther = true;
      };
    };
  };
}

