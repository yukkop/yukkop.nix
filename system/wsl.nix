{ config, lib, pkgs, outputs, ... }:
{
  imports = with outputs.nixosModules;
  [ 
    environment.preset.default
  ];

  wsl.defaultUser = "yukkop";

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
  } ];

  preset.impermanence = false;
  preset.user.yukkop.enable = true;

  preset.program.ncdu.enable = lib.mkForce true;
  preset.program.ripgrep.enable = lib.mkForce true;

  preset.shellAliases = {
    nrs = "sudo nixos-rebuild switch /persist/nixos#home";
    nrb = "sudo nixos-rebuild build /persist/nixos#home";
    nrB = "nixos-rebuild boot /persist/nixos#home";
  };

  users.defaultUserShell = pkgs.zsh;

  users.groups.owner = {};

  /* ssh */
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      #AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  programs.bash.shellAliases = config.preset.shellAliases;

  # TODO: x server
  #services.xserver.xkb = {
  #  layout = "us,ru";
  #  #variant = "workman,";
  #  options = "grp:alt_shift_toggle";
  #};
  # TODO: terminal
  console.keyMap = "us";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    blender
    man-pages
    man-pages-posix
    man-db
    ffmpeg
  ];

  documentation.dev.enable = true;
  documentation.man = {
    # In order to enable to mandoc man-db has to be disabled.
    man-db.enable = false;
    mandoc.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .

  system.stateVersion = "24.05"; # Did you read the comment?
}
