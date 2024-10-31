{ pkgs, lib, config, ... }: 
let
   cfg = config.preset.windowManager.hyprland;
in
{
  options = {
    preset.windowManager.hyprland = {
      enable =
        lib.mkEnableOption "enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      #package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    };

    environment = { 
      sessionVariables = {
        # Id cursor bevomes invisible
        WLR_NORHARDWARE_CURSORS = "1";

        # Hint electron apps to use wayland
        NIXOS_OZONE_WL = "1";
      };
      systemPackages = with pkgs; [
        /* Bar sulution */
        eww
        (waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          })
        )

        /* starter */
        #wofi
        rofi-wayland

        /* Notification deamon */
        dunst
        libnotify # dependensy

        kitty # TODO temp
      ];
    };

    hardware = {

      opengl.enable = true;

      # Most wayland compositors need this
      nvidia.modesetting.enable = true;
    };

    security.rtkit.enable = true;
    # nessesary for obs?
    services.pipewire = { 
      enable = true;
    };
  };
}
