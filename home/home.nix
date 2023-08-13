{ config, pkgs, lib, user ? {name = "noaccos"; fullName = "Francesco Noacco";}, ... }:

let
  myPythonPackages = python-packages: with python-packages; [
    pypresence
    # pandas
    # requests
    # seaborn
    # ipykernel
    # scikit-learn
    # nltk
    # tensorflow
    # Keras
  ];
  myPython = pkgs.python3.withPackages myPythonPackages;

  # themes = pkgs.callPackage ./helpers/local-theming.nix { };
  # themes = {bat = "Dracula";};
in
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

  imports = [ ./modules/local-theming.nix ./modules/cli.nix ./modules/wezterm.nix ./modules/gui.nix ./modules/emacs.nix ];

  home.packages = with pkgs; [
    libsForQt5.breeze-qt5
    # lightcord

    # wine-ge
    # xmonad-git
    # xmonad-contrib-git

    myPython
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
