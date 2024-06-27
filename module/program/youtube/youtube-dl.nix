 userName: { pkgs, ... }: {
  /* utility for download content from youtube */

  home-manager.users."${userName}" = {
    home.packages = with pkgs; [
      youtube-dl
    ];
  };
}
