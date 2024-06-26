{ screenshotCommand ? null, ... }: {
  /* this module may include in home-manager module */

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      decoration = {
        shadow_offset = "0 5";
      };

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "qutebrowser";
      "$screenshot" = "${screenshotCommand}";
      "$menu" = "rofi -show drun -show-icons";

      monitor = [ 
        #",preferred,auto,auto"
	"eDP-1, 1920x1080@120, 0x0, 1"
        "HDMI-A-1, 1920x1080, -1920x0, 1"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
      ];

      misc = {

      };

      input = {
        kb_layout = "us";
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

      animations = {

      };

      dwindle = {
        pseudotile = true;
	preserve_split = true;
      };

      exec-once = [
        "[workspace name:term] $terminal"
        "[workspace name:term] $terminal"
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

      workspace = [
        "name:$ws1, on-create-empty:[float] $terminal"
        "name:$ws2, on-create-empty:[float] $browser"
      ];


      bind = [
	"$mod, RETURN, exec, $terminal"
	"$mod, X, exit"
	"$mod, C, killactive"
	"$mod, SPACE, togglefloating"
	"$mod, D, exec, $menu"
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
	"$mod, 10, workspace, name:$ws10"

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
	"$mod SHIFT, 10, movetoworkspace, name:$ws10"
      ];
    };
  };
}
