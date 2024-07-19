user: { lib, config, inputs, flakeRoot, ...}:
let
  cfg = config.preset.preset.user."${user}".program.nixvim;
in
{
  options = {
    preset.preset.user."${user}".program.nixvim = {
      enable =
        lib.mkEnableOption "enable nixvim";
      persistence =
        lib.mkEnableOption "enable persistence for nixvim config";
    };
  };

  # TODO: take out this to funktion and use for both homeManagerModules.nixvim and modules.nixvim
  config = lib.mkIf cfg.enable {
    home-manager.users."${user}" = {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim 
        flakeRoot.nixosModules.program.common.nixvim
      ];

      module.program.nixvim.enable = true;

      # impermamence
      home.persistence."/persist/home/${user}" = 
       lib.mkIf config.preset.impermamence
      {
        directories = [
          "$XDG_DATA_HOME/nvim/treesitter"
        ];
        allowOther = true;
      };
    };
  };
}
