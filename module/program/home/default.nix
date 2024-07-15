user: shellAliases: { lib, options, inputs, flakeRoot, ... }: 
let 
  userOpts = { name, ... }: {
    imports = [
      flakeRoot.nixosModules.program.home.discord
    ];
   
    options = {
      name = lib.mkOption {
        type = lib.types.passwdEntry lib.types.str;
        apply = x: assert (builtins.stringLength x < 32 || abort "Username '${x}' is longer than 31 characters which is not allowed!"); x;
        description = ''
          The name of the user account. If undefined, the name of the
          attribute set will be used.
        '';
      };
    };
    config =  lib.mkMerge [
      { name = lib.mkDefault name; }
    ];
  };
in {
  imports = [
    inputs.home-manager.nixosModules.default
    (flakeRoot.nixosModules.program.home.youtube.youtube-dl user)
    (flakeRoot.nixosModules.program.home.mpv user)
    (flakeRoot.nixosModules.program.home.obs-studio user)
    (flakeRoot.nixosModules.program.home.minecraft user)
    (flakeRoot.nixosModules.program.home.qutebrowser user)
    (flakeRoot.nixosModules.program.home.steam user)
    (flakeRoot.nixosModules.program.home.telegram user)
    (flakeRoot.nixosModules.program.home.nixvim user)
    (flakeRoot.nixosModules.program.home.zsh user { shellAliases = shellAliases; })
    (flakeRoot.nixosModules.program.home.hyprland user "grim -g \"''$(slurp)\" - | swappy -f")
  ];

  options = {
    flakeModule.home.user = lib.mkOption {
      default = {};
      type = with lib.types; attrsOf (submodule userOpts);
      example = {
        alice = {
	  program.discord.ebable = true;
	  program.zsh.ebable = false;
        };
      };
      description = ''
      '';
    };
  };

  config = {
    flakeModule.home.user.yukkop.program.discord.enable = true;
  };
}
