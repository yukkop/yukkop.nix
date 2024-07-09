 userName: { pkgs, ... }: {
  /*  */

  home-manager.users."${userName}" = {
    home.packages = with pkgs; [
      mpv
    ];

    home.persistence."/persist/home/${userName}" = {
      directories = [
        ".config/mpv"
      ];
      allowOther = true;
    };
  };
}
