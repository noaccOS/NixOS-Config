self: super: rec {
  comma           = super.callPackage ./comma           {};
  # emacsIDE           = super.callPackage ./emacsIDE           {};
  # wine-ge            = super.callPackage ./wine-ge            {};
  wezterm-nightly = super.callPackage ./wezterm-nightly {};
  xcursor-breeze  = super.callPackage ./xcursor-breeze  {};
  spotify-adblock = super.callPackage ./spotify-adblock {};
  emacs-ng        = super.callPackage ./emacs-ng        {};
}
