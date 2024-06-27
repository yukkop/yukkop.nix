 userName: { pkgs, ... }: {
  /*  */

  home-manager.users."${userName}" = {
    home.packages = with pkgs; [
      steam
    ];

    home.persistence."/persist/home/yukkop" = {
      directories = [
        ".local/share/Steam"
        ".steam"
      ];
      allowOther = true;
    };
  };
}
