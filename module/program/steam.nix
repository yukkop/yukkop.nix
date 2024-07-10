 userName: { pkgs, config, ... }: {
  /*  */
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      package = (pkgs.steam.override {
      # Workaround for embedded browser not working.
      #
      # https://github.com/NixOS/nixpkgs/issues/137279
      extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];

      # Workaround for an issue with VK_ICD_FILENAMES on nvidia hardware:
      #
      # - https://github.com/NixOS/nixpkgs/issues/126428 (bug)
      # - https://github.com/NixOS/nixpkgs/issues/108598#issuecomment-858095726 (workaround)
      extraProfile = ''
        export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd32.json:$VK_ICD_FILENAMES
      '';
    });
  };

  # impruve game expireance
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud # program for simple hardware status monitor
  ];

  home-manager.users."${userName}" = {

    home.persistence."/persist/home/${userName}" = {
      directories = [
        ".local/share/Steam"
        ".steam"
      ];
      allowOther = true;
    };
  };
}
