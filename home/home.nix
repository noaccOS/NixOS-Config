{
  pkgs,
  lib,
  user ? "noaccos",
  ...
}:

{
  home.username = user;
  home.homeDirectory = lib.mkForce "/home/${user}";
  xdg.configHome = "/home/${user}/.config/";
  xdg.enable = true;
  nixpkgs.config.allowUnfree = true;

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };

  imports = [
    ./modules/cli.nix
    ./modules/gui.nix
    ./modules/development.nix
    ./modules/nixgl.nix
    ./modules/programs/browsers/firefox.nix
    ./modules/programs/cli/zellij/program.nix
    ./modules/programs/editors/helix.nix
    ./modules/programs/editors/vscode.nix
    ./modules/programs/terminals/alacritty.nix
    ./modules/programs/terminals/foot.nix
    ./modules/programs/terminals/rio.nix
    ./modules/programs/video/mpv.nix
  ];

  home.stateVersion = "23.11";
}
