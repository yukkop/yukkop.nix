{ streamHost, letsEncryptEmail, ... }: { pkgs, config, lib, ... }:
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
in
{
  options = {
    module.server.nginx-rtmp.enable = lib.mkEnableOption "enable nxginx rtmp server";
  };
  
  config = lib.mkIf config.module.server.nginx-rtmp.enable {
    # Create necessary directories and files
    environment.etc."nginx/html/stream.html".text = streamHtml;
    environment.etc."nginx/xsl/stat.xsl".text = statXsl;

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
    security.acme.certs = {
      "${streamHost}".email = "${letsEncryptEmail}";
    };

    security.acme.acceptTerms = true;
    services.nginx = {
      enable = true;
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
      ackage = nginxWithRtmp;
      recommendedGzipSettings = true;
      virtualHosts = {
        "${streamHost}" = {
          enableACME = true;
          forceSSL = true;
          listen = [ { addr = "0.0.0.0"; port = 443; } ];
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
  };
}
