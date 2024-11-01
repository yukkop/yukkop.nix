user: { 
  lib,
  config,
  inputs,
  nixosModules,
  outputs,
  pkgs,
  ...
}@args:

let
  cfg = config.preset.program.nixvim;
in
{
  options = {
    preset.program.nixvim = {
      enable =
        lib.mkEnableOption "enable nixvim";
      persistence =
        lib.mkEnableOption "enable persistence for nixvim config";
      config = lib.mkOption {
        type = lib.types.anything;
        default = nixosModules.environment.common.program.nixvim.default;
        apply = x: if lib.isFunction x then x else if lib.isAttrs x then x else throw "${cfg}.config must be a function or a attrs";
        description = ''
          nixvim config attributes or fuction that return its
        '';
      };
    };
  };

  # TODO: take out this to funktion and use for both homeManagerModules.nixvim and modules.nixvim
  config = lib.mkIf cfg.enable {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim 
      ];

      programs.nixvim = outputs.lib.evaluateAttrOrFunction cfg.config args;

      # impermanence
      home.persistence."/persist/home/${user}" = 
       lib.mkIf config.preset.impermanence
      {
        directories = [
          "$XDG_DATA_HOME/nvim/treesitter"
        ];
        allowOther = true;
      };
  };
}
