{ config, lib, ... }:

with lib.hm.gvariant;
{
  config.dconf.settings = lib.mkIf (config.homeModules.windowManagers.gnome-shell.enable) {
    "org/gnome/desktop/input-sources" = {
      mru-sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "ibus"
          "mozc-on"
        ])
      ];
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "ibus"
          "mozc-on"
        ])
      ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      minimize = [ ];
      move-to-workspace-1 = [ "<Shift><Super>apostrophe" ];
      move-to-workspace-2 = [ "<Shift><Super>comma" ];
      move-to-workspace-3 = [ "<Shift><Super>period" ];
      move-to-workspace-4 = [ "<Shift><Super>p" ];
      move-to-workspace-left = [ "<Shift><Super>h" ];
      move-to-workspace-right = [ "<Shift><Super>s" ];
      switch-input-source = [ ];
      switch-input-source-backward = [ ];
      switch-to-workspace-1 = [ "<Super>n" ];
      switch-to-workspace-2 = [ "<Super>comma" ];
      switch-to-workspace-3 = [ "<Super>period" ];
      switch-to-workspace-4 = [ "<Super>p" ];
      switch-to-workspace-last = [ "<Super>t" ];
      switch-to-workspace-left = [ "<Super>h" ];
      switch-to-workspace-right = [ "<Super>s" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      auto-raise = false;
      resize-with-right-button = true;
      titlebar-font = "Inter Nerd Font 11";
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "<Super>c" ];
      show-screenshot-ui = [ "<Super>o" ];
      toggle-quick-settings = [ "<Super>r" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      cursor-theme = "Breeze_Catppuccin";
      document-font-name = "Atkinson Hyperlegible Next 11";
      enable-hot-corners = false;
      font-name = "Inter Nerd Font 11";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Adwaita";
      monospace-font-name = "Iosevka-NoaccOS 11";
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [ ];
      enabled-extensions = [ ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-alignment = "CENTRE";
      dock-position = "BOTTOM";
      intellihide-mode = "ALL_WINDOWS";
      isolate-monitors = true;
      isolate-workspaces = true;
      multi-monitor = true;
      show-mounts-only-mounted = true;
      show-mounts = true;
      show-trash = false;
    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      datemenu-fix-weather-widget = false;
      datemenu-remove-notifications = false;
      disable-adjust-content-border-radius = false;
      disable-remove-shadow = false;
      list-buttons = "[{\"name\":\"SystemItem\",\"title\":null,\"visible\":true},{\"name\":\"OutputStreamSlider\",\"title\":null,\"visible\":true},{\"name\":\"InputStreamSlider\",\"title\":null,\"visible\":false},{\"name\":\"St_BoxLayout\",\"title\":null,\"visible\":true},{\"name\":\"BrightnessItem\",\"title\":null,\"visible\":true},{\"name\":\"NMWiredToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMWirelessToggle\",\"title\":\"Wi-Fi\",\"visible\":true},{\"name\":\"NMModemToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMBluetoothToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMVpnToggle\",\"title\":null,\"visible\":false},{\"name\":\"BluetoothToggle\",\"title\":\"Bluetooth\",\"visible\":true},{\"name\":\"PowerProfilesToggle\",\"title\":\"Power Mode\",\"visible\":true},{\"name\":\"NightLightToggle\",\"title\":\"Night Light\",\"visible\":true},{\"name\":\"DarkModeToggle\",\"title\":\"Dark Style\",\"visible\":true},{\"name\":\"KeyboardBrightnessToggle\",\"title\":\"Keyboard\",\"visible\":false},{\"name\":\"RfkillToggle\",\"title\":\"Airplane Mode\",\"visible\":true},{\"name\":\"RotationToggle\",\"title\":\"Auto Rotate\",\"visible\":false},{\"name\":\"ServiceToggle\",\"title\":\"GSConnect\",\"visible\":true},{\"name\":\"DndQuickToggle\",\"title\":\"Do Not Disturb\",\"visible\":true},{\"name\":\"BackgroundAppsToggle\",\"title\":\"No Background Apps\",\"visible\":false},{\"name\":\"MediaSection\",\"title\":null,\"visible\":false}]";
      notifications-enabled = false;
      notifications-use-native-controls = true;
      volume-mixer-position = "top";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };
  };
}
