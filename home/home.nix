{
  pkgs,
  lib,
  user ? "noaccos",
  ...
}:
let
  inherit (lib) mkForce;
in
{
  home.username = user;
  home.homeDirectory = mkForce "/home/${user}";
  xdg.configHome = "/home/${user}/.config/";
  xdg.enable = true;
  nix.settings = {
    commit-lockfile-summary = "chore(nix): update inputs";
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
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
    ./modules/gnome.nix
    ./modules/personal.nix
    ./modules/work.nix
    ./modules/programs/browsers/firefox.nix
    ./modules/programs/cli/zellij/program.nix
    ./modules/programs/cli/gitui.nix
    ./modules/programs/editors/helix/program.nix
    ./modules/programs/editors/vscode/program.nix
    ./modules/programs/launchers/anyrun.nix
    ./modules/programs/shells/nu/program.nix
    ./modules/programs/terminals/alacritty.nix
    ./modules/programs/terminals/foot.nix
    ./modules/programs/terminals/ghostty.nix
    ./modules/programs/terminals/kitty.nix
    ./modules/programs/terminals/rio.nix
    ./modules/programs/terminals/wezterm.nix
    ./modules/programs/video/mpv.nix
    ./modules/windowManagers/bars/waybar.nix
    ./modules/windowManagers/niri.nix
    ./modules/windowManagers/gnome-shell.nix
  ];

  home.stateVersion = "25.05";
}
