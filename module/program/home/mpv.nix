 userName: { pkgs, lib, config, ... }: {
  options = {
    module.program.mpv = {
      enable =
        lib.mkEnableOption "enable mpv";
      persistence =
        lib.mkEnableOption "enable persistence for mpv config";
    };
  };

  config = lib.mkIf config.module.program.mpv.enable {
    module.program.shellAliases = {
      mpvf = "mpv --osd-msg1='\${estimated-frame-number} / \${estimated-frame-count}'";
    };

    home-manager.users."${userName}" = {
      home.packages = with pkgs; [
        mpv
      ];
  
      home.persistence."/persist/home/${userName}" = 
        lib.mkIf config.module.program.mpv.persistence 
      {

        directories = [
          ".config/mpv"
        ];
        allowOther = true;
      };
    };
  };
}
