{ userName, pkgs, ... }: {
  /*  */

  home-manager.users."${userName}" = {
    home.packages = with pkgs;
    [
      # TODO: some overlay with config
      prismlauncher
      openjdk
      (lowPrio openjdk8) # `lowPrio` prevent simlink colision with `openjdk` 
      (lowPrio openjdk17)
    ];
  };
}
