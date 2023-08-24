{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.programs.vscode;

  customPackages = import vscode/customPackages.nix {
    buildVscodeMarketplaceExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension;
    licenses = lib.licenses;
  };

  userSettings = lib.pipe vscode/settings.json [ builtins.readFile builtins.fromJSON ];
  keybindings = lib.pipe vscode/keybindings.json [ builtins.readFile builtins.fromJSON ];
in
{
  options.homeModules.programs.vscode = {
    enable = lib.mkEnableOption "VSCode";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vscodium;
      description = "VSCode package to install";
    };
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to configure VSCode as the default
        editor using the {env}`EDITOR` environment variable.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = cfg.package;
      inherit userSettings keybindings;

      enableUpdateCheck = false;
      enableExtensionUpdateCheck = true;

      extensions = with pkgs.vscode-extensions; [
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
      ] ++ customPackages;
    };

    home.sessionVariables = lib.mkIf cfg.defaultEditor {
      EDITOR = "${cfg.package.executableName} -n --wait";
      VISUAL = "${cfg.package.executableName} -n --wait";
    };
  };
}
