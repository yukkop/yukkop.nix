{ ... }: {
  /* this module may include in home-manager module */

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      decoration = {
        shadow_offset = "0 5";
      };

      "$mod" = "SUPER";
      "$terminal" = "kitty";

      monitor = ",preferred,auto,auto";

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
        gaps_in = 5;
	gaps_out = 20;

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
        "$terminal"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow" 
      ];

      bind = [
	"$mod, T, exec, $terminal"
	"$mod, X, exit"
	"$mod, SPACE, togglefloating"

	#move focus
	"$mod, H, movefocus, l"
	"$mod, J, movefocus, d"
	"$mod, K, movefocus, u"
	"$mod, L, movefocus, r"
      ];
    };
  };
}
