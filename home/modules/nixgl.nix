{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixgl.nixGLIntel
  ];
}
