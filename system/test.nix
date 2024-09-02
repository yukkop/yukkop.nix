{ pkgs, lib, config, modulesPath, ... }: {
  imports = [
    ../module/infrastructure/platform/hetzner-amd2.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  environment.systemPackages = [ pkgs.curl ];

  # Autologin nrv in the VM
  services.getty.autologinUser = "root";

  # Backdoor for when ssh host keys are wrong
  users.users.root.password = lib.mkForce "zalupa";
  users.users.root.hashedPassword = lib.mkForce null;
  users.users.root.hashedPasswordFile = lib.mkForce null;
  users.users.root.initialPassword = lib.mkForce null;
  users.users.root.passwordFile = lib.mkForce null;

  virtualisation.vmVariant = {
    virtualisation.forwardPorts = [
      { from = "host"; host.port = 40500; guest.port = 22; }
      { from = "host"; host.port = 8000; guest.port = 8000; }
      { from = "host"; host.port = 8888; guest.port = 80; }
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMezFt0OjCXCEjuOch03oTGXxgON+O9YShrU0hC0dJfb''
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;

    };
  };
}
