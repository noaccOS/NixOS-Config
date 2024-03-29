{ pkgs, lib, user ? { name = "noaccos"; fullName = "Francesco Noacco"; }, ... }:

{
  home.username = user.name;
  home.homeDirectory = lib.mkForce "/home/${user.name}";
  xdg.configHome = "/home/${user.name}/.config/";
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/cli.nix
    ./modules/gui.nix
    ./modules/development.nix
    ./modules/nixgl.nix
    ./modules/theming.nix
    ./modules/programs/browsers/firefox.nix
    ./modules/programs/editors/helix.nix
    ./modules/programs/editors/vscode.nix
    ./modules/programs/terminals/alacritty.nix
    ./modules/programs/terminals/foot.nix
    ./modules/programs/terminals/rio.nix
    ./modules/programs/video/mpv.nix
  ];

  homeModules.theming.enable = lib.mkDefault true;

  home.stateVersion = "23.11";
}
