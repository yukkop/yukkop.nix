user: { pkgs, config, lib, ... }: 
let
  cfg = config.preset.program.steam;
in
{
  options = {
    preset.program.steam = {
      enable =
        lib.mkEnableOption "enable steam";
      persistence =
        lib.mkEnableOption "enable persistence for steam data";
    };
  };

  /*  */
  config = lib.mkIf cfg.enable {
    # FIXME: in some home manager related module in nixos modules
    # programs.steam = {
    #     enable = true;
    #     gamescopeSession.enable = true;
    #     remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #     dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    #     localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    #     package = (pkgs.steam.override {
    #     # Workaround for embedded browser not working.
    #     #
    #     # https://github.com/NixOS/nixpkgs/issues/137279
    #     extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];

    #     ## Workaround for an issue with VK_ICD_FILENAMES on nvidia hardware:
    #     ##
    #     ## - https://github.com/NixOS/nixpkgs/issues/126428 (bug)
    #     ## - https://github.com/NixOS/nixpkgs/issues/108598#issuecomment-858095726 (workaround)
    #     #extraProfile = ''
    #     #  export VK_ICD_FILENAMES=${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json:$VK_ICD_FILENAMES
    #     #'';
    #   });
    # };

    # # impruve game expireance
    # programs.gamemode.enable = true;

    # FIXME: env packages in home manager? if i use nix on droid? a?
    #environment.systemPackages = with pkgs; [
    #  mangohud # program for simple hardware status monitor
    #];

      home.persistence."/persist/home/${user}" = 
        lib.mkIf config.preset.impermanence 
      {
        directories = [
          ".local/share/Steam"
          #".steam"
	  # Rimworld saves
	  ".config/unity3d/Ludeon Studios/RimWorld by Ludeon Studios/"
	  # FTL saves
	  ".local/share/FasterThanLight"
        ];
        allowOther = true;
      };
  };
}
