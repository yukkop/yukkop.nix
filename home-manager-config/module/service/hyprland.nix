{ lib, config, ... }:
let
  cfg = config.preset.windowManager.hyprland;
in
{
  /* this module may include in home-manager module */
  options = {
    preset.windowManager.hyprland = {
      enable =
        lib.mkEnableOption "enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
      #programs.eww = {
      #  enable = true;
      #  configDir = "/home/${userName}/.config/eww/";
      #};

      wayland.windowManager.hyprland = {
        enable = true;
  
        settings = {
          decoration = {
            shadow_offset = "0 5";
          };
  
          "$mod" = "SUPER_R";
          "$mod2" = "SUPER_L CONTROL_R";
          "$terminal" = "kitty";
          "$browser" = "qutebrowser";
          "$obs" = "obs";
          "$messenger" = "telegram-desktop";
          "$calling-app" = "discord";
          "$screenshot" = "";
          "$menu" = "rofi -show drun -show-icons";
  
          "$monitor1" = "eDP-1";
          "$monitor2" = "HDMI-A-1";
  
          monitor = [ 
            "$monitor1, 1920x1080@120, 0x0, 1"
            "$monitor2, 1920x1080, -1920x0, 1"
          ];
  
          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
          ];
  
          misc = {

          };
  
          input = {
            kb_layout = "us,ru";
            kb_options = "grp:alt_shift_toggle,compose:ralt";
            follow_mouse = 1;
          };
  
          general = {
            gaps_in = 0;
            gaps_out = 0;
  
            border_size = 0;
  
            allow_tearing = false;
  
            layout = "dwindle";
          };
  
          decoration = {
  
          };
  
          animation = [
            "fade,0"
            "workspaces,0"
            "windows,0"
          ];
  
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };
  
          exec-once = [
            "[workspace name:term silent] $terminal"
            "[workspace name:web silent] $browser"
            #"waybar"
          ];
  
          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
            "$mod ALT, mouse:272, resizewindow" 
          ];
  
          "$ws1" = "term";
          "$ws2" = "web";
          "$ws3" = "mess";
          "$ws4" = "tool";
          "$ws5" = "call";
          "$ws6" = "misc";
          "$ws7" = "game";
          "$ws8" = "record";
          "$ws9" = "lauch";
          "$ws10" = "rare";
          # mirrored workspaces in case if i need more
          "$ws1m" = "m-term";
          "$ws2m" = "m-web";
          "$ws3m" = "m-mess";
          "$ws4m" = "m-tool";
          "$ws5m" = "m-call";
          "$ws6m" = "m-misc";
          "$ws7m" = "m-game";
          "$ws8m" = "m-record";
          "$ws9m" = "m-lauch";
          "$ws10m" = "m-rare";
  
          workspace = [
            "name:$ws1, on-create-empty:$terminal, monitor:$monitor1, default:true"
            "name:$ws2, on-create-empty:$browser, monitor:$monitor2, default:true"
            "name:$ws3, on-create-empty:$messenger, monitor:$monitor1"
            #"name:$ws4, "
            "name:$ws5, on-create-empty:$calling-app, monitor:$monitor2"
            #"name:$ws6, "
            "name:$ws7, monitor:$monitor1"
            "name:$ws8, on-create-empty:$obs, monitor:$monitor2"
            "name:$ws9, monitor:$monitor1"
          ];
  
  
          bind = [
            "$mod, RETURN, exec, $terminal"
            "$mod, X, exit"
            "$mod, C, killactive"
            "$mod, SPACE, togglefloating"
            "$mod CONTROL_L, B, exec, $menu"
            "$mod, F, fullscreen"
            "$mod SHIFT, R, exec, hyprctl reload"
            ", code:107, exec, $screenshot"
  
            # move focus
            "$mod, H, movefocus, l"
            "$mod, J, movefocus, d"
            "$mod, K, movefocus, u"
            "$mod, L, movefocus, r"
  
            # Switch workspaces 
            "$mod, 1, workspace, name:$ws1"
            "$mod, 2, workspace, name:$ws2"
            "$mod, 3, workspace, name:$ws3"
            "$mod, 4, workspace, name:$ws4"
            "$mod, 5, workspace, name:$ws5"
            "$mod, 6, workspace, name:$ws6"
            "$mod, 7, workspace, name:$ws7"
            "$mod, 8, workspace, name:$ws8"
            "$mod, 9, workspace, name:$ws9"
            "$mod2, 1, workspace, name:$ws1m"
            "$mod2, 2, workspace, name:$ws2m"
            "$mod2, 3, workspace, name:$ws3m"
            "$mod2, 4, workspace, name:$ws4m"
            "$mod2, 5, workspace, name:$ws5m"
            "$mod2, 6, workspace, name:$ws6m"
            "$mod2, 7, workspace, name:$ws7m"
            "$mod2, 8, workspace, name:$ws8m"
            "$mod2, 9, workspace, name:$ws9m"
  
            # Move active window to a workspace
            "$mod SHIFT, 1, movetoworkspace, name:$ws1"
            "$mod SHIFT, 2, movetoworkspace, name:$ws2"
            "$mod SHIFT, 3, movetoworkspace, name:$ws3"
            "$mod SHIFT, 4, movetoworkspace, name:$ws4"
            "$mod SHIFT, 5, movetoworkspace, name:$ws5"
            "$mod SHIFT, 6, movetoworkspace, name:$ws6"
            "$mod SHIFT, 7, movetoworkspace, name:$ws7"
            "$mod SHIFT, 8, movetoworkspace, name:$ws8"
            "$mod SHIFT, 9, movetoworkspace, name:$ws9"
            "$mod2 SHIFT, 1, movetoworkspace, name:$ws1m"
            "$mod2 SHIFT, 2, movetoworkspace, name:$ws2m"
            "$mod2 SHIFT, 3, movetoworkspace, name:$ws3m"
            "$mod2 SHIFT, 4, movetoworkspace, name:$ws4m"
            "$mod2 SHIFT, 5, movetoworkspace, name:$ws5m"
            "$mod2 SHIFT, 6, movetoworkspace, name:$ws6m"
            "$mod2 SHIFT, 7, movetoworkspace, name:$ws7m"
            "$mod2 SHIFT, 8, movetoworkspace, name:$ws8m"
            "$mod2 SHIFT, 9, movetoworkspace, name:$ws9m"
          ];
        };
      };
  };
}
