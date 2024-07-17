{ lib, config, inputs, nixosModules, outputs, ...}@args:
let 
  cfg = config.preset.program.nixvim;
in
{
  #  SAFETY: neccessary imports
  #  inputs.impermanence.nixosModules.impermanence
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  options = {
    preset.program.nixvim = {
      enable =
        lib.mkEnableOption "enable nixvim";
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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.nixvim = outputs.lib.evaluateAttrOrFunction cfg.config args;
    }
    (lib.mkIf config.preset.impermanence {
      environment.persistence."/persist/system" = 
      {
        hideMounts = true;
        directories = [
          "/root/nvim/treesitter"
        ];
      };
    })
  ]);
}
