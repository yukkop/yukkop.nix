{ pkgs, ... }: {
  /*
    command to make a screenshot
    provide it to display manager module
  */
  callCommand = "grim -g \"''$(slurp)\" - | swappy -f";

  module = a: {
    home.packages = with pkgs; [
      grim
      slurp
      swappy
    ];
  };
}
