{ pkgs, ... }: {
  /* module for home-manager */

  home.packages = with pkgs; [
    qutebrowser
  ];
}
