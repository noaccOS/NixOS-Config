{ pkgs, lib, config, ... }:
let cfg = config.homeModules.programs.editors.helix;
in {
  options.homeModules.programs.editors.helix = {
    enable = lib.mkEnableOption "helix";
  };

  config.programs.helix = {
    enable = cfg.enable;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
      };
    };
  };
}
