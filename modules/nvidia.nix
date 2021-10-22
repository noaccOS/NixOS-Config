{pkgs, lib, ...}:
{
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers      = [ "nvidia" ];

  # options.nvidia.removeXTearing = lib.mkOption{
  #   description = "Remove tearing for X sessions";
  #   default = true;
  #   type = pkgs.types.bool;
  # };
  
  services.xserver.screenSection = # lib.mkIf nvidia.removeXTearing
    ''
        Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
        Option         "AllowIndirectGLXProtocol" "off"
        Option         "TripleBuffer" "on"
      '';
}
