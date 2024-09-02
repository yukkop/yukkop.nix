{ pkgs, outputs, lib, inputs, system, config, ... }:
let 
  dbName = "neverlate";
  dbPort = 49889;
  dbPassword = "sfiej58dlkjmidf54116kssmdfijwak47u";
  dbUser = "neverlate";
  # postgresql does not look in internet!
  databaseUrl = "postgresql://${dbUser}:${dbPassword}@localhost:${toString dbPort}/${dbName}?host=/var/run/postgresql";
in
{
  imports =
  [ 
    outputs.nixosModules.infrastructure.platform.hetzner-amd2
    outputs.nixosModules.environment.preset.default
  ];

  services.neverlate-backend = {
    enable = true;
    databaseUrl = databaseUrl;
    logFilter = "debug";
  };

  services.neverlate-frontend = {
    enable = true;
    ssl = true;
    email = "hectic.yukkop@gmail.com";
    apiUrl = "http://localhost:8000";
    host = "neverlate-english.com";
  };

  services.neverlate-database = {
    enable = true;
    dbname = dbName;
    port = dbPort;
    password = dbPassword;
    user = dbUser;
  };

  preset.impermanence = false;
  preset.user.yukkop.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "";
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUqLmQXXcgpdv89UkDmctj5XmCBKMByQsFrEqBCfB1O yukkop@nixos''
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  documentation.dev.enable = true;
  documentation.man = {
    # In order to enable to mandoc man-db has to be disabled.
    man-db.enable = false;
    mandoc.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  system.stateVersion = "24.05";
}
