{ pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  spotify ? pkgs.spotify
}:
let custom-spotify = spotify.overrideAttrs ( old: {
      postInstall = "sed -i '$iexport LD_PRELOAD=$out/lib/libspotifyadblock.so' $out/share/spotify/spotify";
    });
in
pkgs.rustPlatform.buildRustPackage {
    name = "spotify-adblock";
    src = fetchTarball "https://github.com/noaccOS/spotify-adblock/archive/refs/heads/main.tar.gz";
    #cargoSha256 = "1pbvw9hdzn3i97mahdy9y6jnjsmwmjs3lxfz7q6r9r10i8swbkak";
    cargoLock.lockFile = ./Cargo.lock;

    postPatch = ''
      substituteInPlace Makefile \
        --replace "PREFIX = /usr/local" "PREFIX = $out"
    '';

    # desktopItems = [ desktopItem ];
    buildInputs = [ custom-spotify ];

    skipCheck = true;
    installPhase = ''
  mkdir -p $out/share/applications
  mkdir -p $out/lib

  cp target/x86_64-unknown-linux-gnu/release/libspotifyadblock.{so,d} $out/lib/

      echo "[Desktop Entry]
Type=Application
Name=Spotify (adblock)
GenericName=Music Player
Icon=spotify-client
TryExec=spotify
Exec=env LD_PRELOAD=$out/lib/libspotifyadblock.so ${custom-spotify}/bin/spotify %U
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
StartupWMClass=spotify
      " > $out/share/applications/spotify-adblock.desktop
    '';
 
  meta = with lib; {
    description = "Spotify adblocker for linux";
    license = licenses.gpl3;
    homepage = "https://github.com/noaccOS/spotify-adblock";
    platforms = platforms.linux;
  };
}

  
  # desktopItem = makeDesktopItem {
  #   name = "spotify-adblock";
  #   exec = "${spotify-adblock}/lib/spotify-adblock.so ${spotify}/bin/spotify %U";
  #   desktopName = "Spotify (adblock)";
  #   genericName = "Music player without adverts";
  #   categories = "Audio;Music;Player;AudioVideo;";
  # };

