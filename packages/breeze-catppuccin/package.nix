{
  ast-grep,
  fd,
  inkscape,
  kdePackages,
  nushell,
  python3,
  stdenv,
  xorg,
  ...
}:
stdenv.mkDerivation {
  pname = "breeze-cursor-catppuccin";
  version = "0.1.0";
  src = kdePackages.breeze.src;

  buildInputs =
    let
      pythonWithPackages = python3.withPackages (py: with py; [ pyside6 ]);
    in
    [
      ast-grep
      fd
      inkscape
      nushell
      pythonWithPackages
      xorg.xcursorgen
    ];

  buildPhase = ''
    cp -R cursors/Breeze cursors/Breeze_Catppuccin
    cd cursors/Breeze_Catppuccin
    cp -v ${./fix_colors.nu} fix_colors.nu
    cp -v ${./build.sh} build.sh
    cp -v ${./render.json} render.json
    cp -v ${./index.theme} src/index.theme
    cp -v ../src/generate_cursors generate_cursors
    ls -l
    bash build.sh
  '';

  installPhase = ''
     mkdir -p $out/share/icons
     mv Breeze_Catppuccin $out/share/icons/ 
  '';
}
