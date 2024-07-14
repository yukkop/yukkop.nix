userName: { lib, config, inputs, flakeRoot, ...}:
{
  options = {
    module.home.user."${userName}".program.nixvim = {
      enable =
        lib.mkEnableOption "enable nixvim";
      persistence =
        lib.mkEnableOption "enable persistence for nixvim config";
    };
  };

  # TODO: take out this to funktion and use for both homeManagerModules.nixvim and modules.nixvim
  config = lib.mkIf config.module.home.user."${userName}".program.nixvim.enable {
    home-manager.users."${userName}" = {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim 
        flakeRoot.nixosModules.program.common.nixvim
      ];

      module.program.nixvim.enable = true;

      # impermamence
      home.persistence."/persist/home/${userName}" = 
       lib.mkIf config.module.home.user."${userName}".program.nixvim.persistence
      {
        directories = [
          "$XDG_DATA_HOME/nvim/treesitter"
        ];
        allowOther = true;
      };
    };
  };
}
