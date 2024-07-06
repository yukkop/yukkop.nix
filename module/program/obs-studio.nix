userName: { pkgs, ... }: {
  /*  */

  home-manager.users."${userName}" = {
    home.packages = with pkgs; [
      obs-studio
    ];

    home.persistence."/persist/home/yukkop" = {
      directories = [
        ".config/obs-studio"
      ];
      allowOther = true;
    };
  };
}
