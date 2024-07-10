{ config, pkgs, ... }:

let
  # Define a custom Nginx with RTMP module
  nginxWithRtmp = pkgs.nginxStable.override {
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
  # Other configurations...

  services.nginx = {
    enable = true;
    package = nginxWithRtmp;
    recommendedGzipSettings = true;
    virtualHosts = {
      "meet.bfs.band" = {
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        locations."/" = {
          root = "/var/www/html";
          index = "stream.html";
        };
      };
      "hls.meet.bfs.band" = {
        listen = [ { addr = "0.0.0.0"; port = 8080; } ];
        locations."/stat" = {
          extraConfig = ''
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
          '';
	};
        locations."=/stat.xsl" = {
          alias = "/var/www/xsl/stat.xsl";
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

  #systemd.services.nginx = {
  #  after = [ "network.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    ExecStartPre = "${nginxWithRtmp}/bin/nginx -t";
  #    ExecStart = "${nginxWithRtmp}/bin/nginx";
  #    ExecReload = "${nginxWithRtmp}/bin/nginx -s reload";
  #    ExecStop = "${nginxWithRtmp}/bin/nginx -s quit";
  #    Restart = "on-failure";
  #    RestartSec = "5s";
  #    Type = "forking";
  #  };
  #};

  # Create necessary directories and files
  environment.etc."nginx/html/stream.html".text = streamHtml;
  environment.etc."nginx/xsl/stat.xsl".text = statXsl;

  fileSystems."/tmp/hls" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };
}
