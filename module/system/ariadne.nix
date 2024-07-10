# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, flakeRoot, lib, ... }:
let
  # Define a custom Nginx with RTMP module
  nginxWithRtmp = pkgs.nginxStable.override {
    openssl = pkgs.libressl;
    modules = [ pkgs.nginxModules.rtmp ];
  };

  # HTML content for the HLS player
  streamHtml = ''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Live Stream</title>
        <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
    </head>
    <body>
        <video id="video" width="720" controls></video>
        <script>
            if(Hls.isSupported()) {
                var video = document.getElementById("video");
                var hls = new Hls();
                hls.loadSource("http://78.46.234.141:8080/hls/index.m3u8");
                hls.attachMedia(video);
                hls.on(Hls.Events.MANIFEST_PARSED,function() {
                    video.play();
                });
            }
        </script>
    </body>
    </html>
  '';

  # Sample stylesheet for RTMP stats (stat.xsl)
  statXsl = ''
    <?xml version="1.0"?>
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <html>
        <head>
            <title>RTMP Streams</title>
        </head>
        <body>
            <h1>RTMP Streams</h1>
            <table border="1">
                <tr>
                    <th>Name</th>
                    <th>Address</th>
                </tr>
                <xsl:for-each select="rtmp/server/application">
                    <tr>
                        <td><xsl:value-of select="name"/></td>
                        <td><xsl:value-of select="live/streams/stream/name"/></td>
                    </tr>
                </xsl:for-each>
            </table>
        </body>
        </html>
    </xsl:template>
    </xsl:stylesheet>
  '';
  shellAliases = { };
in
{
  imports =
  [ 
    flakeRoot.nixosModules.platform.hetzner-amd2
    flakeRoot.nixosModules.program.tmux
  ];

  # Create necessary directories and files
  environment.etc."nginx/html/stream.html".text = streamHtml;
  environment.etc."nginx/xsl/stat.xsl".text = statXsl;

  fileSystems."/tmp/hls" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  users.defaultUserShell = pkgs.zsh;

  nix.settings.experimental-features = ["nix-command" "flakes"];

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

  programs.bash.shellAliases = shellAliases;
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # email address used with Let's Encrypt
  security.acme.certs = {
    "stream.bfs.band".email = "hectic.yukkop.it@gmail.com";
  };

  security.acme.acceptTerms = true;
  services.nginx = {
    enable = true;
    package = nginxWithRtmp;
    recommendedGzipSettings = true;
    virtualHosts = {
      "stream.bfs.band" = {
	enableACME = true;
	forceSSL = true;
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
	basicAuth = { yukkop = "я свой, пути"; snuff = "какой ещё пароль, блять"; };
        locations."/" = {
          index = "stream.html";
          root = "/var/www/html";
        };
      };
      #"stream.bfs.band" = {
      #  listen = [ { addr = "0.0.0.0"; port = 80; } ];
      #  locations."/" = {
      #    root = "/var/www/html";
      #    index = "stream.html";
      #  };
      #};
      #"watch.stream.bfs.band" = {
      #  listen = [ { addr = "0.0.0.0"; port = 8080; } ];
      #  locations."/stat" = {
      #    extraConfig = ''
      #      rtmp_stat all;
      #      rtmp_stat_stylesheet stat.xsl;
      #    '';
      #  };
      #  locations."=/stat.xsl" = {
      #    alias = "/var/www/xsl/stat.xsl";
      #  };
      #  locations."/hls" = {
      #    root = "/tmp";
      #    extraConfig = ''
      #      types {
      #        application/vnd.apple.mpegurl m3u8;
      #        video/mp2t ts;
      #      }
      #      add_header Cache-Control no-cache;
      #      add_header Access-Control-Allow-Origin *;
      #    '';
      #  };
      #};
    };
  };

  users.groups = {
    nginx = {};
  };

  users.users.nginx = {
    isSystemUser = true;
    group = "nginx";
    description = "Nginx web server user";
  };

  system.stateVersion = "24.05";
}
