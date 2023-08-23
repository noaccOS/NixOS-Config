{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.vscode;
  customPackages = import vscode/customPackages.nix {
    buildVscodeMarketplaceExtension = pkgs.vscode-utils.buildVscodeMarketplaceExtension;
    licenses = lib.licenses;
  };
  userSettings = lib.pipe vscode/settings.json [ builtins.readFile builtins.fromJSON ];
  keybindings = lib.pipe vscode/keybindings.json [ builtins.readFile builtins.fromJSON ];
in
{
  options.homeModules.vscode.enable = lib.mkEnableOption "custom vscode";
  config.programs.vscode = {
    enable = cfg.enable;
    package = pkgs.vscodium;
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
}
