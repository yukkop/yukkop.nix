{ pkgs, ... }: {
  /*
    command to make a screenshot
    provide it to display manager module
  */
  #callCommand = "grim -g \"''$(slurp)\" - | swappy -f";

  home.packages = with pkgs; [
    grim
    slurp
    swappy
  ];
}
