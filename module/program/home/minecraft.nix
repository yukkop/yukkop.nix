userName: { pkgs, lib, config, ... }: {
  options = {
    module.program.minecraft = {
      enable =
        lib.mkEnableOption "enable minecraft";
      persistence =
        lib.mkEnableOption "enable persistence for minecraft config";
    };
  };

  config = lib.mkIf config.module.program.minecraft.enable {
    home-manager.users."${userName}" = {
      home.packages = with pkgs;
      [
        # TODO: some overlay with config
        prismlauncher
        openjdk
        (lowPrio openjdk8) # `lowPrio` prevent simlink colision with `openjdk` 
        (lowPrio openjdk17)
      ];

      home.persistence."/persist/home/${userName}" = 
        lib.mkIf config.module.program.minecraft.persistence 
      {
        directories = [
          ".local/share/PrismLauncher/"
        ];
        allowOther = true;
      };
    };
  };
}
