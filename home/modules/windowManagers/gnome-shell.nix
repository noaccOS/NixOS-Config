{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeModules.windowManagers.gnome-shell;

  inherit (lib)
    forEach
    mkDefault
    mkEnableOption
    mkIf
    optionals
    ;
in
{
  options.homeModules.windowManagers.gnome-shell = {
    enable = mkEnableOption "gnome programs and looks";
  };
  config = mkIf cfg.enable {
    homeModules.programs.browsers.firefox.gnomeIntegration = mkDefault true;

    home.packages = with pkgs; [
      adw-gtk3
      evolution-data-server-gtk4
      file-roller
      fragments
      gnome-calculator
      gnome-calendar
      gnome-disk-utility
      gnome-font-viewer
      gnome-maps
      gnome-online-accounts
      gnome-online-accounts-gtk
      gnome-software
      loupe
      nautilus
      nautilus-python
      papers
      qadwaitadecorations
      qadwaitadecorations-qt6
      seahorse
      yelp
    ];

    home.sessionVariables = {
      QT_WAYLAND_DECORATION = "adwaita";
    };

    gtk.enable = true;
    gtk.gtk3.bookmarks =
      let
        xdg-bookmarks = with config.xdg.userDirs; [
          documents
          download
          music
          pictures
          videos
        ];
        xdg-bookmark-entries = forEach xdg-bookmarks (bookmark: "file://${bookmark}");
      in
      [ "file://${config.home.homeDirectory}/src" ]
      ++ optionals config.xdg.userDirs.enable xdg-bookmark-entries;

    xdg.mimeApps.defaultApplications = {
      # Applications
      "application/bzip2" = "org.gnome.FileRoller.desktop";
      "application/fits" = "org.gnome.Maps.desktop";
      "application/gpx+xml" = "org.gnome.Maps.desktop";
      "application/gzip" = "org.gnome.FileRoller.desktop";
      "application/illustrator" = "org.gnome.Papers.desktop";
      "application/mxf" = "mpv.desktop";
      "application/ogg" = "mpv.desktop";
      "application/oxps" = "org.gnome.Papers.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/pgp-keys" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs7-mime" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs7-mime+pem" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs8" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs8+pem" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs10" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs10+pem" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs12" = "org.gnome.seahorse.Application.desktop";
      "application/pkcs12+pem" = "org.gnome.seahorse.Application.desktop";
      "application/pkix-cert" = "org.gnome.seahorse.Application.desktop";
      "application/pkix-cert+pem" = "org.gnome.seahorse.Application.desktop";
      "application/pkix-crl" = "org.gnome.seahorse.Application.desktop";
      "application/pkix-crl+pem" = "org.gnome.seahorse.Application.desktop";
      "application/postscript" = "org.gnome.Papers.desktop";
      "application/ram" = "mpv.desktop";
      "application/sdp" = "mpv.desktop";
      "application/smil" = "mpv.desktop";
      "application/smil+xml" = "mpv.desktop";
      "application/streamingmedia" = "mpv.desktop";
      "application/vnd.android.package-archive" = "org.gnome.FileRoller.desktop";
      "application/vnd.apple.mpegurl" = "mpv.desktop";
      "application/vnd.comicbook+zip" = "org.gnome.Papers.desktop";
      "application/vnd.comicbook-rar" = "org.gnome.Papers.desktop";
      "application/vnd.debian.binary-package" = "org.gnome.FileRoller.desktop";
      "application/vnd.flatpak" = "gnome-software-local-file-flatpak.desktop";
      "application/vnd.flatpak.ref" = "gnome-software-local-file-flatpak.desktop";
      "application/vnd.flatpak.repo" = "gnome-software-local-file-flatpak.desktop";
      "application/vnd.geo+json" = "org.gnome.Maps.desktop";
      "application/vnd.google-earth.kml+xml" = "org.gnome.Maps.desktop";
      "application/vnd.iccprofile" = "gcm-import.desktop";
      "application/vnd.ms-asf" = "mpv.desktop";
      "application/vnd.ms-cab-compressed" = "org.gnome.FileRoller.desktop";
      "application/vnd.ms-wpl" = "mpv.desktop";
      "application/vnd.ms-xpsdocument" = "org.gnome.Papers.desktop";
      "application/vnd.rar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/vnd.rn-realmedia" = "mpv.desktop";
      "application/vnd.rn-realmedia-vbr" = "mpv.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-7z-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-ace" = "org.gnome.FileRoller.desktop";
      "application/x-alz" = "org.gnome.FileRoller.desktop";
      "application/x-apple-diskimage" = "org.gnome.FileRoller.desktop";
      "application/x-app-package" = "gnome-software-local-file-packagekit.desktop";
      "application/x-ar" = "org.gnome.FileRoller.desktop";
      "application/x-archive" = "org.gnome.FileRoller.desktop";
      "application/x-arj" = "org.gnome.FileRoller.desktop";
      "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
      "application/x-brotli" = "org.gnome.FileRoller.desktop";
      "application/x-bzdvi" = "org.gnome.Papers.desktop";
      "application/x-bzip" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-bzip1" = "org.gnome.FileRoller.desktop";
      "application/x-bzip1-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-bzip-brotli-tar" = "org.gnome.FileRoller.desktop";
      "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-bzpdf" = "org.gnome.Papers.desktop";
      "application/x-bzpostscript" = "org.gnome.Papers.desktop";
      "application/x-cabinet" = "org.gnome.FileRoller.desktop";
      "application/x-cb7" = "org.gnome.Papers.desktop";
      "application/x-cbr" = "org.gnome.Papers.desktop";
      "application/x-cbt" = "org.gnome.Papers.desktop";
      "application/x-cbz" = "org.gnome.Papers.desktop";
      "application/x-cd-image" =
        "gnome-disk-image-mounter.desktop;gnome-disk-image-writer.desktop;org.gnome.FileRoller.desktop";
      "application/x-chrome-extension" = "org.gnome.FileRoller.desktop";
      "application/x-compress" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-cpio" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-cue" = "mpv.desktop";
      "application/x-deb" = "org.gnome.FileRoller.desktop";
      "application/x-dvi" = "org.gnome.Papers.desktop";
      "application/x-ear" = "org.gnome.FileRoller.desktop";
      "application/x-extension-m4a" = "mpv.desktop";
      "application/x-extension-mp4" = "mpv.desktop";
      "application/x-ext-cb7" = "org.gnome.Papers.desktop";
      "application/x-ext-cbr" = "org.gnome.Papers.desktop";
      "application/x-ext-cbt" = "org.gnome.Papers.desktop";
      "application/x-ext-cbz" = "org.gnome.Papers.desktop";
      "application/x-ext-djv" = "org.gnome.Papers.desktop";
      "application/x-ext-djvu" = "org.gnome.Papers.desktop";
      "application/x-ext-dvi" = "org.gnome.Papers.desktop";
      "application/x-ext-eps" = "org.gnome.Papers.desktop";
      "application/x-ext-pdf" = "org.gnome.Papers.desktop";
      "application/x-ext-ps" = "org.gnome.Papers.desktop";
      "application/x-flash-video" = "mpv.desktop";
      "application/x-font-otf" = "org.gnome.font-viewer.desktop";
      "application/x-font-pcf" = "org.gnome.font-viewer.desktop";
      "application/x-font-ttf" = "org.gnome.font-viewer.desktop";
      "application/x-font-type1" = "org.gnome.font-viewer.desktop";
      "application/x-gtar" = "org.gnome.FileRoller.desktop";
      "application/x-gzdvi" = "org.gnome.Papers.desktop";
      "application/x-gzip" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-gzpdf" = "org.gnome.Papers.desktop";
      "application/x-gzpostscript" = "org.gnome.Papers.desktop;org.gnome.FileRoller.desktop";
      "application/x-java-archive" = "org.gnome.FileRoller.desktop";
      "application/x-lha" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-lhz" = "org.gnome.FileRoller.desktop";
      "application/x-lrzip" = "org.gnome.FileRoller.desktop";
      "application/x-lrzip-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-lz4" = "org.gnome.FileRoller.desktop";
      "application/x-lz4-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-lzip" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-lzip-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-lzma" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-lzma-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-lzop" = "org.gnome.FileRoller.desktop";
      "application/x-matroska" = "mpv.desktop";
      "application/x-mpegurl" = "mpv.desktop";
      "application/x-ms-wim" = "org.gnome.FileRoller.desktop";
      "application/x-netshow-channel" = "mpv.desktop";
      "application/x-ogg" = "mpv.desktop";
      "application/x-ogm" = "mpv.desktop";
      "application/x-ogm-audio" = "mpv.desktop";
      "application/x-ogm-video" = "mpv.desktop";
      "application/x-pem-file" = "org.gnome.seahorse.Application.desktop";
      "application/x-pem-key" = "org.gnome.seahorse.Application.desktop";
      "application/x-pkcs7-certificates" = "org.gnome.seahorse.Application.desktop";
      "application/x-pkcs12" = "org.gnome.seahorse.Application.desktop";
      "application/x-quicktimeplayer" = "mpv.desktop";
      "application/x-quicktime-media-link" = "mpv.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-raw-disk-image" = "gnome-disk-image-mounter.desktop;gnome-disk-image-writer.desktop";
      "application/x-raw-disk-image-xz-compressed" = "gnome-disk-image-writer.desktop";
      "application/x-redhat-package-manager" = "gnome-software-local-file-packagekit.desktop";
      "application/x-rpm" = "org.gnome.FileRoller.desktop";
      "application/x-rzip" = "org.gnome.FileRoller.desktop";
      "application/x-rzip-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-shorten" = "mpv.desktop";
      "application/x-smil" = "mpv.desktop";
      "application/x-source-rpm" = "org.gnome.FileRoller.desktop";
      "application/x-spkac" = "org.gnome.seahorse.Application.desktop";
      "application/x-spkac+base64" = "org.gnome.seahorse.Application.desktop";
      "application/x-ssh-key" = "org.gnome.seahorse.Application.desktop";
      "application/x-streamingmedia" = "mpv.desktop";
      "application/x-stuffit" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-tarz" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-tzo" = "org.gnome.FileRoller.desktop";
      "application/x-vnc" = "org.gnome.Connections.desktop";
      "application/x-war" = "org.gnome.FileRoller.desktop";
      "application/x-x509-ca-cert" = "org.gnome.seahorse.Application.desktop";
      "application/x-x509-user-cert" = "org.gnome.seahorse.Application.desktop";
      "application/x-xar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-xz" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-xzpdf" = "org.gnome.Papers.desktop";
      "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/x-zerosize" = "org.gnome.TextEditor.desktop";
      "application/x-zip" = "org.gnome.FileRoller.desktop";
      "application/x-zip-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-zoo" = "org.gnome.FileRoller.desktop";
      "application/x-zstd-compressed-tar" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";
      "application/zstd" = "org.gnome.FileRoller.desktop;org.gnome.Nautilus.desktop";

      # Audio
      "audio/3gpp" = "mpv.desktop";
      "audio/3gpp2" = "mpv.desktop";
      "audio/aac" = "mpv.desktop";
      "audio/ac3" = "mpv.desktop";
      "audio/aiff" = "mpv.desktop";
      "audio/AMR" = "mpv.desktop";
      "audio/amr-wb" = "mpv.desktop";
      "audio/dv" = "mpv.desktop";
      "audio/eac3" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/m3u" = "mpv.desktop";
      "audio/m4a" = "mpv.desktop";
      "audio/mp1" = "mpv.desktop";
      "audio/mp2" = "mpv.desktop";
      "audio/mp3" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/mpeg2" = "mpv.desktop";
      "audio/mpeg3" = "mpv.desktop";
      "audio/mpegurl" = "mpv.desktop";
      "audio/mpg" = "mpv.desktop";
      "audio/musepack" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/opus" = "mpv.desktop";
      "audio/rn-mpeg" = "mpv.desktop";
      "audio/scpls" = "mpv.desktop";
      "audio/vnd.dolby.heaac.1" = "mpv.desktop";
      "audio/vnd.dolby.heaac.2" = "mpv.desktop";
      "audio/vnd.dts" = "mpv.desktop";
      "audio/vnd.dts.hd" = "mpv.desktop";
      "audio/vnd.rn-realaudio" = "mpv.desktop";
      "audio/vnd.wave" = "mpv.desktop";
      "audio/vorbis" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/webm" = "mpv.desktop";
      "audio/x-aac" = "mpv.desktop";
      "audio/x-adpcm" = "mpv.desktop";
      "audio/x-aiff" = "mpv.desktop";
      "audio/x-ape" = "mpv.desktop";
      "audio/x-m4a" = "mpv.desktop";
      "audio/x-matroska" = "mpv.desktop";
      "audio/x-mp1" = "mpv.desktop";
      "audio/x-mp2" = "mpv.desktop";
      "audio/x-mp3" = "mpv.desktop";
      "audio/x-mpegurl" = "mpv.desktop";
      "audio/x-mpg" = "mpv.desktop";
      "audio/x-ms-asf" = "mpv.desktop";
      "audio/x-ms-wma" = "mpv.desktop";
      "audio/x-musepack" = "mpv.desktop";
      "audio/x-pls" = "mpv.desktop";
      "audio/x-pn-au" = "mpv.desktop";
      "audio/x-pn-realaudio" = "mpv.desktop";
      "audio/x-pn-wav" = "mpv.desktop";
      "audio/x-pn-windows-pcm" = "mpv.desktop";
      "audio/x-realaudio" = "mpv.desktop";
      "audio/x-scpls" = "mpv.desktop";
      "audio/x-shorten" = "mpv.desktop";
      "audio/x-tta" = "mpv.desktop";
      "audio/x-vorbis" = "mpv.desktop";
      "audio/x-vorbis+ogg" = "mpv.desktop";
      "audio/x-wav" = "mpv.desktop";
      "audio/x-wavpack" = "mpv.desktop";

      # Images
      "image/*" = "org.gnome.Loupe.desktop";
      "image/avif" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop;";
      "image/gif" = "org.gnome.Loupe.desktop;";
      "image/heic" = "org.gnome.Loupe.desktop;";
      "image/jpeg" = "org.gnome.Loupe.desktop;";
      "image/jxl" = "org.gnome.Loupe.desktop;";
      "image/png" = "org.gnome.Loupe.desktop;";
      "image/svg+xml" = "org.gnome.Loupe.desktop;";
      "image/svg+xml-compressed" = "org.gnome.Loupe.desktop;";
      "image/tiff" = "org.gnome.Loupe.desktop;";
      "image/vnd.djvu" = "org.gnome.Evince.desktop;";
      "image/vnd.microsoft.icon" = "org.gnome.Loupe.desktop;";
      "image/vnd.radiance" = "org.gnome.Loupe.desktop;";
      "image/vnd.rn-realpix" = "org.gnome.Loupe.desktop;";
      "image/vnd-ms.dds" = "org.gnome.Loupe.desktop;";
      "image/webp" = "org.gnome.Loupe.desktop;";
      "image/x-bzeps" = "org.gnome.Evince.desktop;";
      "image/x-dds" = "org.gnome.Loupe.desktop;";
      "image/x-eps" = "org.gnome.Evince.desktop;";
      "image/x-exr" = "org.gnome.Loupe.desktop;";
      "image/x-gzeps" = "org.gnome.Evince.desktop;";
      "image/x-pict" = "org.gnome.Loupe.desktop;";
      "image/x-portable-anymap" = "org.gnome.Loupe.desktop;";
      "image/x-portable-bitmap" = "org.gnome.Loupe.desktop;";
      "image/x-portable-graymap" = "org.gnome.Loupe.desktop;";
      "image/x-portable-pixmap" = "org.gnome.Loupe.desktop;";
      "image/x-qoi" = "org.gnome.Loupe.desktop;";
      "image/x-tga" = "org.gnome.Loupe.desktop;";

      # File manager
      "inode/directory" = "org.gnome.Nautilus.desktop";

      # Font
      "font/ttf" = "org.gnome.font-viewer.desktop";
      "font/otf" = "org.gnome.font-viewer.desktop";
      "font/woff" = "org.gnome.font-viewer.desktop";

      #Text
      "text/calendar" = "org.gnome.Calendar.desktop";
      "text/google-video-pointer" = "mpv.desktop";
      "text/x-google-video-pointer" = "mpv.desktop";

      # Video
      "video/3gp" = "mpv.desktop";
      "video/3gpp" = "mpv.desktop";
      "video/3gpp2" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/divx" = "mpv.desktop";
      "video/dv" = "mpv.desktop";
      "video/fli" = "mpv.desktop";
      "video/flv" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/mp2t" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/mp4v-es" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
      "video/mpeg-system" = "mpv.desktop";
      "video/msvideo" = "mpv.desktop";
      "video/ogg" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/vivo" = "mpv.desktop";
      "video/vnd.avi" = "mpv.desktop";
      "video/vnd.divx" = "mpv.desktop";
      "video/vnd.mpegurl" = "mpv.desktop";
      "video/vnd.rn-realvideo" = "mpv.desktop";
      "video/vnd.vivo" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-anim" = "mpv.desktop";
      "video/x-avi" = "mpv.desktop";
      "video/x-flc" = "mpv.desktop";
      "video/x-fli" = "mpv.desktop";
      "video/x-flic" = "mpv.desktop";
      "video/x-flv" = "mpv.desktop";
      "video/x-m4v" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/x-mjpeg" = "mpv.desktop";
      "video/x-mpeg" = "mpv.desktop";
      "video/x-mpeg2" = "mpv.desktop";
      "video/x-mpeg3" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";
      "video/x-ms-afs" = "mpv.desktop";
      "video/x-ms-asf" = "mpv.desktop";
      "video/x-ms-asf-plugin" = "mpv.desktop";
      "video/x-ms-asx" = "mpv.desktop";
      "video/x-ms-wm" = "mpv.desktop";
      "video/x-ms-wmv" = "mpv.desktop";
      "video/x-ms-wmx" = "mpv.desktop";
      "video/x-ms-wvx" = "mpv.desktop";
      "video/x-ms-wvxvideo" = "mpv.desktop";
      "video/x-nsv" = "mpv.desktop";
      "video/x-ogm" = "mpv.desktop";
      "video/x-ogm+ogg" = "mpv.desktop";
      "video/x-theora" = "mpv.desktop";
      "video/x-theora+ogg" = "mpv.desktop";
      "video/x-totem-stream" = "mpv.desktop";

      # x-content
      "x-content/unix-software" = "nautilus-autorun-software.desktop";
      "x-content/video-dvd" = "mpv.desktop";
      "x-scheme-handler/appstream" = "org.gnome.Software.desktop";
      "x-scheme-handler/eds-oauth2" = "org.gnome.evolution-data-server.OAuth2-handler.desktop";
      "x-scheme-handler/geo" = "org.gnome.Maps.desktop";
      "x-scheme-handler/ghelp" = "yelp.desktop";
      "x-scheme-handler/gnome-extensions" = "org.gnome.BrowserConnector.desktop";
      "x-scheme-handler/goa-oauth2" = "org.gnome.OnlineAccounts.OAuth2.desktop";
      "x-scheme-handler/help" = "yelp.desktop";
      "x-scheme-handler/icy" = "mpv.desktop";
      "x-scheme-handler/icyx" = "mpv.desktop";
      "x-scheme-handler/info" = "yelp.desktop";
      "x-scheme-handler/magnet" = "de.haeckerfelix.Fragments.desktop";
      "x-scheme-handler/mailto" = "org.gnome.Geary.desktop";
      "x-scheme-handler/man" = "yelp.desktop";
      "x-scheme-handler/maps" = "org.gnome.Maps.desktop";
      "x-scheme-handler/mms" = "mpv.desktop";
      "x-scheme-handler/mmsh" = "mpv.desktop";
      "x-scheme-handler/net" = "mpv.desktop";
      "x-scheme-handler/pnm" = "mpv.desktop";
      "x-scheme-handler/rtmp" = "mpv.desktop";
      "x-scheme-handler/rtp" = "mpv.desktop";
      "x-scheme-handler/rtsp" = "mpv.desktop";
      "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
      "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
      "x-scheme-handler/uvox" = "mpv.desktop";
    };
  };
}
