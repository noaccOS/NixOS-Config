{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.torrent.transmission;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  jsonFormat = pkgs.formats.json { };
  settingsFile = jsonFormat.generate "transmission-settings.json" cfg.settings;
  settingsPath = "${config.xdg.configHome}/transmission/settings.json";

  # Keys that differ from the baseline, skipping the GTK window state
  diffFilter = pkgs.writeText "transmission-settings-diff.jq" ''
    .[0] as $baseline
    | .[1]
    | with_entries(
        select(
          $baseline[.key] != .value
          and (.key | test("^(main-window-|details-window-|sort-)|^(open-dialog-dir|statusbar-stats)$") | not)
        )
      )
  '';

  # Print the settings changed from the GUI as a Nix attrset, ready to be moved to `settings`
  settingsDiff = pkgs.writeShellApplication {
    name = "transmission-settings-diff";
    runtimeInputs = with pkgs; [
      coreutils
      nixfmt
      transmission_4
      xq
    ];
    text = ''
      settings="''${1:-${settingsPath}}"
      tmp=$(mktemp -d)
      trap 'rm -rf "$tmp"' EXIT

      # libtransmission defaults, overridden by the settings already managed by nix
      transmission-daemon --config-dir "$tmp" --dump-settings 2>/dev/null > "$tmp/defaults.json"
      cat "$tmp/defaults.json" ${settingsFile} | xq --slurp '.[0] * .[1]' > "$tmp/baseline.json"

      cat "$tmp/baseline.json" "$settings" \
        | xq --slurp --from-file ${diffFilter} \
        | nix eval --impure --expr 'builtins.fromJSON (builtins.readFile /dev/stdin)' \
        | nixfmt -
    '';
  };
in
{
  options.homeModules.programs.torrent.transmission = {
    enable = mkEnableOption "transmission";
    package = mkPackageOption pkgs "transmission_4-gtk" { };
    settings = mkOption {
      inherit (jsonFormat) type;
      default = { };
      description = ''
        Settings merged into transmission's settings.json on activation.
        The file stays writable, so settings changed from the GUI are kept:
        use `transmission-settings-diff` to print them as nix.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      settingsDiff
    ];

    homeModules.programs.torrent.transmission.settings = {
      # first and last pieces are still downloaded first
      sequential_download = true;
      download-dir = config.xdg.userDirs.download;
    };

    home.activation.transmissionSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings=${lib.escapeShellArg settingsPath}
      current=$(cat "$settings" 2>/dev/null || echo '{}')
      merged=$(printf '%s\n' "$current" | cat - ${settingsFile} | ${lib.getExe pkgs.xq} --slurp '.[0] * .[1]')
      run mkdir -p "$(dirname "$settings")"
      run --quiet sh -c 'printf "%s\n" "$1" > "$2.tmp" && mv "$2.tmp" "$2"' _ "$merged" "$settings"
    '';
  };
}
