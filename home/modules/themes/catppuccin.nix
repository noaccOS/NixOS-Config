{ variant, inputs, lib, ... }:
let
  capitalize = s:
    let
      match = builtins.split "^(.)" s;
      head = lib.trivial.pipe match [
        (lib.trivial.flip builtins.elemAt 1)
        (lib.trivial.flip builtins.elemAt 0)
        lib.strings.toUpper
      ];
      rest = lib.trivial.pipe match [
        (lib.trivial.flip builtins.elemAt 2)
        lib.strings.toLower
      ];
    in
    head + rest;
in
{
  alacritty = inputs.catppuccin-alacritty + /catppuccin-${variant}.toml;

  bat = {
    withSource = true;
    name = "Catppuccin-${variant}";
    src = inputs.catppuccin-bat;
    file = "Catppuccin-${variant}.tmTheme";
  };

  fish = {
    # TODO: only downloads mocha for some reason?
    plugin = { name = "catppuccin"; src = inputs.catppuccin-fish; };
    name = "Catppuccin ${capitalize variant}";
  };

  helix = {
    name = "catppuccin_${variant}";
  };

  rio = {
    src = inputs.catppuccin-rio + /catppuccin-${variant}.toml;
    name = "catppuccin-${variant}";
  };

  starship =
    lib.trivial.pipe inputs.catppuccin-starship [
      (l: l + "/palettes/${variant}.toml")
      builtins.readFile
      builtins.fromTOML
    ] // { palette = "catppuccin_${variant}"; };
}
