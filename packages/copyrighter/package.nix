{
  stdenvNoCC,
  coreutils,
  git,
  ripgrep,
  sd,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "copyrighter";
  version = "0.1.0";
  src = ./.;

  buildInputs = [
    coreutils
    git
    ripgrep
    sd
  ];

  dontBuild = true;

  installPhase = ''
    install -Dm755 copyrighter.sh $out/bin/copyrighter
  '';
}
