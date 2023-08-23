{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.nixgl;
in
{
  options.homeModules.nixgl = {
    enable = lib.mkEnableOption "nixgl integration";
    driver = lib.mkOption {
      type = lib.types.enum [ "nvidia" "mesa" ];
      default = "intel";
      description = "gpu drivers to use";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = let
      packages = {
        mesa = {
          gl = pkgs.nixgl.nixGLIntel;
          vk = pkgs.nixgl.nixVulkanIntel;
        };
        nvidia = {
          gl = pkgs.nixgl.nixGLNvidia;
          vk = pkgs.nixgl.nixVulkanNvidia;
        };
      }.${cfg.driver};
      in
      [ packages.gl packages.vk ];
  };
}
