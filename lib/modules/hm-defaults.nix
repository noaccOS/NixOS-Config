system:
inputs:
{
  homeModules = {
    cli.enable = true;
    gui.enable = true;
    theming.enable = true;
    theming.theme = "catppuccin";
    programs.vscode.defaultEditor = true;
    programs.emacs.package = inputs.emacs-overlay.packages.${system}.emacs-pgtk;
  };
}
