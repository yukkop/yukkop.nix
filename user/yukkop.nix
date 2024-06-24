{ pkgs, inputs, ... }:

{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.stateVersion = "24.05";

  home.persistence."/persist/home/yukkop" = {
    directories = [
      "Downloads"
      "pj"
      "ms"
      "pc"
      "dc"
      "vd"
      ".ssh"
    ];
    files = [
      "dw" # link to Downloads
    ];
    allowOther = true; # allows other users, such as root, to access files
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "yukkop";
    userEmail = "hectic.yukkop@gmail.com";
    extraConfig = {
      push = { autoSetupRemote = true; };
      safe = { directory = "/persist/nixos"; };
      init = { defaultBranch = "master"; };
    };
  };
}
