{ pkgs, lib, config, nixosModules, outputs, ... }@args: 
let
  optionName = "zoxide";
  cfg = config.preset.program.${optionName};
in
{
  options = with lib; {
    preset.program.${optionName} = {
      enable =
        mkEnableOption "enable ${optionName}";
    };
  };

  config = lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        zoxide
      ];
  };
}
