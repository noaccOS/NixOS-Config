{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.editors.vscode;

  customPackages = import ./customPackages.nix {
    buildVscodeMarketplaceExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension;
    licenses = lib.licenses;
  };

  userSettings = lib.pipe ./settings.json [
    builtins.readFile
    builtins.fromJSON
  ];
  keybindings = lib.pipe ./keybindings.json [
    builtins.readFile
    builtins.fromJSON
  ];
in
{
  options.homeModules.programs.editors.vscode = {
    enable = lib.mkEnableOption "VSCode";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vscodium;
      description = "VSCode package to install";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${cfg.package.executableName} --wait";
      description = ''
        The string to use when setting vscode as the default editor.
      '';
    };
    visual = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      default = "${cfg.package.executableName} --wait";
      description = ''
        The string to use when setting vscode as the default visual.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
      # inherit userSettings keybindings;

      # enableUpdateCheck = false;
      # enableExtensionUpdateCheck = true;

      extensions =
        with pkgs.vscode-extensions;
        [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          kahole.magit
          mkhl.direnv
          elixir-lsp.vscode-elixir-ls
          mhutchie.git-graph
          donjayamanne.githistory
          github.vscode-github-actions
          github.vscode-pull-request-github
          eamodio.gitlens
          golang.go
          jnoortheen.nix-ide
          ibm.output-colorizer
          humao.rest-client
          streetsidesoftware.code-spell-checker
          tamasfe.even-better-toml
        ]
        ++ customPackages;
    };
  };
}
