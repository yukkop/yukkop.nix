# TODO userNameS
{ userName, pkgs, ... }: {
  /* module for home-manager */

  home-manager.users."${userName}" = {
    home.packages = with pkgs; [
      qutebrowser
    ];
  };
}
