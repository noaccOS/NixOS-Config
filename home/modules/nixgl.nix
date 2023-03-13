{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixgl.nixGLDefault
  ];
}
