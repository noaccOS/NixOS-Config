{ config, pkgs, lib, user ? { name = "noaccos"; fullName = "Francesco Noacco"; }, ... }:

# let
#   # themes = pkgs.callPackage ./helpers/local-theming.nix { };
#   # themes = {bat = "Dracula";};
# in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user.name;
  home.homeDirectory = lib.mkForce "/home/${user.name}";
  xdg.configHome = "/home/${user.name}/.config/";

  nixpkgs.overlays = [
    (import ../packages)
  ];

  nixpkgs.config.allowUnfree = true;

  imports = [ ./modules/local-theming.nix ./modules/cli.nix ./modules/wezterm.nix ./modules/gui.nix ./modules/emacs.nix ./modules/vscode.nix
  ];

  home.packages = with pkgs; [
    libsForQt5.breeze-qt5
  ];

  home.stateVersion = "23.11";
}
