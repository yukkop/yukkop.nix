userName: { pkgs, lib, config, ... }: {
  options = {
    module.program.obs-studio = {
      enable =
        lib.mkEnableOption "enable obs-studio";
      persistence =
        lib.mkEnableOption "enable persistence for obs-studio data";
    };
  };

  config = lib.mkIf config.module.program.obs-studio.enable {
    home-manager.users."${userName}" = {
      home.packages = with pkgs; [
        obs-studio
      ];
  
      home.persistence."/persist/home/${userName}" = 
        lib.mkIf config.module.program.obs-studio.persistence 
      {
        directories = [
          ".config/obs-studio"
        ];
        allowOther = true;
      };
    };
  };
}
