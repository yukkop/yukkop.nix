{ pkgs, flakeRoot, lib, ... }:
{
  imports =
  [ 
    flakeRoot.nixosModules.user.yukkop
    (flakeRoot.nixosModules.server.nginx-rtmp { streamHost = "stream.bfs.band"; letsEncryptEmail = "hectic.yukkop@gmail.com"; })
    flakeRoot.nixosModules.platform.hetzner-amd2
    flakeRoot.nixosModules.program.default
    flakeRoot.nixosModules.preset.default
  ];

  module.user.yukkop.enable = true;
  module.user.yukkop.graphics = false;
  module.user.yukkop.persistence = false;

  module.server.nginx-rtmp.enable = true;

  module.program = {
    docker = {
      enable = true;
    };
    nixvim = {
      enable = true;
      persistence = false;
    };
    zsh = {
      enable = true;
      persistence = false;
    };
  };

  users.defaultUserShell = pkgs.zsh;

  # Use the systemd-boot EFI boot loader.
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "";
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAK+DoSzaE5ic5ccTppjJjsVrMQj7oLyW+4S8fB2dUgG yukkop@home''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCudwg8NGJElcgwsiQcnxWkLpN8VvsEZo7Wf9e7MJNeDL1dMU5kLM/KdIa9FLW6ljzgw/uaah7ZpidYn0t0zUqiZSlytB/thAlke/IyWr3EbvOWUN8MtcAYnqRWDMMxNR5VzYgKDdxJmvEOuEDjTAtpSWRGJ87tPwZezORNrILYJLR6/pLmqL6NMfPcRPBM3DIUNXJS03Wx1b94NoMYh/QK8NUIW8H1fCRdiQBWTkgCbl5urnktPlFS4BPDl7IuNUbILy49IAS7OquCRIK2EyccXFEs6xk/IP+YvdTiZubi6B6zkj02bABAaWHMQdtKm4+9bAOWX2Pc80wI8ZcxL1XQoVVMUdDL2qg6JETqL0jPU1wKXNmjBl+Xc2WjfO6V9s0/H23QR8dtskON6JwZ41x6QaOxfRm/NNc3gqz+nWvyE2uEDLhzd6Y9OCu4d4F+9vzFIYiVfc2irfkA0a/l+86U/IBdD4GGmAvVwZmRNHbDmzhsmIkgZfHCVzT6Nvwf71c= snuff@jorge-desktop''
  ];

  /* ssh */
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      #AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "without-password";
    };
  };

  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [ 
    curl
  ];

  documentation.dev.enable = true;
  documentation.man = {
    # In order to enable to mandoc man-db has to be disabled.
    man-db.enable = false;
    mandoc.enable = true;
  };

  system.stateVersion = "24.05";
}
