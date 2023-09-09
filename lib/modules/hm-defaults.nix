system:
inputs:
{ config, ... }:
{
  homeModules = {
    cli.enable = true;
    gui.enable = true;
    theming.enable = true;
    theming.theme = "catppuccin";
    programs.editors.vscode.defaultEditor = true;
    programs.editors.emacs.package = inputs.emacs-overlay.packages.${system}.emacs-pgtk;
  };
}
