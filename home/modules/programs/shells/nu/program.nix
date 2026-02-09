{
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.shells.nu;
  inherit (lib)
    mkEnableOption
    mkIf
    optionalString
    ;

  inherit (lib.hm.nushell) mkNushellInline;
in
{
  options.homeModules.programs.shells.nu = {
    enable = mkEnableOption "nushell";
  };
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      settings = {
        buffer_editor = mkNushellInline "$env.VISUAL | split row ' '";
        show_banner = false;
        rm.always_trash = true;
        completions.algorithm = "fuzzy";
        filesize.unit = "binary";
        cursor_shape = {
          vi_insert = "line";
          vi_normal = "block";
        };
        use_kitty_protocol = true;
        menus = [
          {
            name = "completion_menu";
            only_buffer_difference = false;
            # this whole config is needed just to change the marker here. why is this not a record?
            marker = "";
            type = {
              layout = "columnar";
              columns = 4;
              col_width = 20;
              col_padding = 2;
              tab_traversal = "horizontal";
            };
            style = {
              text = "green";
              selected_text = "green_reverse";
              description_text = "yellow";
            };
          }
        ];
      };
      configFile.source = ./config.nu;
      extraConfig = optionalString config.programs.starship.enable ''
        $env.TRANSIENT_PROMPT_COMMAND = ^starship module character
        $env.TRANSIENT_PROMPT_COMMAND_RIGHT = ^starship module time
      '';
    };
  };
}
