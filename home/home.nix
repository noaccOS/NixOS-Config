{ pkgs, lib, user ? { name = "noaccos"; fullName = "Francesco Noacco"; }, ... }:

{
  home.username = user.name;
  home.homeDirectory = lib.mkForce "/home/${user.name}";
  xdg.configHome = "/home/${user.name}/.config/";

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/theming.nix
    ./modules/cli.nix
    ./modules/gui.nix
    ./modules/gui.nix
    ./modules/nixgl.nix
    ./modules/programs/emacs.nix
    ./modules/programs/foot.nix
    ./modules/programs/mpv.nix
    ./modules/programs/vscode.nix
    ./modules/programs/wezterm.nix
    ./modules/programs/wezterm/module.nix
  ];

  home.stateVersion = "23.11";
}
