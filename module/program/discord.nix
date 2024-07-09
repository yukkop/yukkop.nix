 userName: { pkgs, ... }: {
  /*  */

  home-manager.users."${userName}" = {
    home.packages = with pkgs; [
      discord
    ];

    home.persistence."/persist/home/${userName}" = {
      directories = [
        ".config/discord"
      ];
      allowOther = true;
    };
  };
}
