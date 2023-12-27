system:
inputs:
{ config, ... }:
{
  homeModules = {
    cli.enable = true;
    gui.enable = true;
    theming.enable = true;
    programs.editors.vscode.defaultEditor = true;
  };
}
