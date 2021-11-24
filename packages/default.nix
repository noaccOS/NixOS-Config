self: super: rec {
  comma           = super.callPackage ./comma           {};
  # emacsIDE           = super.callPackage ./emacsIDE           {};
  # wine-ge            = super.callPackage ./wine-ge            {};
  xcursor-breeze  = super.callPackage ./xcursor-breeze  {};
  spotify-adblock = super.callPackage ./spotify-adblock {};
}
