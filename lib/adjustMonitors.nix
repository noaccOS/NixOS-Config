lib: monitors:
let
  inherit (lib)
    mapAttrs
    recursiveUpdate
    ;
in
mapAttrs (
  _name: value:
  recursiveUpdate {
    frameRate = null;
    position = {
      x = 0;
      y = 0;
    };
    scale = 1;
    rotation = value.rotation or "normal";
  } value
) monitors
