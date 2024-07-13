{ lib, config, ... }: {
  options = {
    module.program.docker.enable = lib.mkEnableOption "enable docker";
  };

  config = lib.mkIf config.module.program.docker.enable {
    virtualisation.docker.enable = true;
  };
}

