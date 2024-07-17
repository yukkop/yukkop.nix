{ lib, config, ... }: {
  options = {
    preset.program.docker.enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf config.preset.program.docker.enable {
    virtualisation.docker.enable = true;
  };
}

