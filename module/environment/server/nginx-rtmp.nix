{ pkgs, config, lib, ... }:
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
in
{
  options = {
    module.server.nginx-rtmp = {
      enable = lib.mkEnableOption "enable nxginx rtmp server";
      streamHost = lib.mkOption {
        type = lib.types.str;
        description = ''
	  host
        '';
      };
      letsEncryptEmail = lib.mkOption {
        type = lib.types.str;
        #apply = x: assert (builtins.stringLength x < 32 || abort "'${x}' is not looks like email"); x;
        description = ''
	  email
        '';
      };
    }; 
  };
  
  config = 
  let
    streamHost = config.module.server.nginx-rtmp.streamHost;
    letsEncryptEmail = config.module.server.nginx-rtmp.letsEncryptEmail;
  in
  lib.mkIf config.module.server.nginx-rtmp.enable
  {
    # Create necessary directories and files
    environment.etc."nginx/html/stream.html".text = streamHtml;
    environment.etc."nginx/xsl/stat.xsl".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/arut/nginx-rtmp-module/master/stat.xsl"; 
      sha256 = "sha256-lBJrKrjbhj4RB1m7XkRDGiFI+1L/+eIsO0tYtMb9q7I=";
    };

    fileSystems."/tmp/hls" = {
      device = "tmpfs";
      fsType = "tmpfs";
    };

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];  # Use Google DNS servers as an example
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # email address used with Let's Encrypt
    #security.acme.certs = {
    #  "${streamHost}".email = "${letsEncryptEmail}";
    #};

    #security.acme.acceptTerms = true;
    services.nginx = {
      enable = true;
      appendConfig = ''
        #rtmp {
        #  server {
        #    listen 1935; # Standard RTMP port
        #    chunk_size 4096;
        #    application drawing {
        #      live on;
        #      hls on;
        #      hls_path /tmp/hls;
        #      hls_nested on;
        #      hls_fragment 1;
        #      hls_playlist_length 5;
        #    }
        #  }
        #};
      '';
      #commonHttpConfig = '' '';
      package = nginxWithRtmp;
      recommendedGzipSettings = true;
      virtualHosts = {
        "${streamHost}" = {
          listen = [ { addr = "0.0.0.0"; port = 80; } ];
          locations."/watch" = {
            root = "/etc/nginx/html";
            index = "stream.html";
          };
	  # This URL provides RTMP statistics in XML
          locations."/stat" = {
            extraConfig = ''
              rtmp_stat all;
              rtmp_stat_stylesheet stat.xsl;
            '';
          };
          locations."=/stat.xsl" = {
	    # XML stylesheet to view RTMP stats.
            # Copy stat.xsl wherever you want
            # and put the full directory path here
            alias = "/etc/nginx/xsl/stat.xsl";
          };
          locations."/hls" = {
            root = "/tmp";
            extraConfig = ''
              types {
                application/vnd.apple.mpegurl m3u8;
                video/mp2t ts;
              }
              add_header Cache-Control no-cache;
              add_header Access-Control-Allow-Origin *;
            '';
          };
        };
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
  };
}
