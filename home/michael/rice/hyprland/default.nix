{ pkgs
, inputs
, ...
}:
let
  fontsize = "12";
  cursor = "macos-BigSur";
in
{
  home.packages = with pkgs; [
    (writeShellScriptBin "autostart" ''
      # Variables
      config=$HOME/.config/hypr
      scripts=$config/scripts

      # Waybar
      pkill waybar
      $scripts/launch_waybar &
      $scripts/tools/dynamic &

      # Wallpaper
      # swww kill
      # swww init

      # Dunst (Notifications)
      pkill dunst
      dunst &

      # Cursor
      hyprctl setcursor "macOS-BigSur" 32 # "Catppuccin-Mocha-Mauve-Cursors"

      # Others
      /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
    '')
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland = {
      enable = true;
    };

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$run" = "wofi";

      exec-once = [
        "autostart"
      ];

      env = [
        "LIBVA_DRIVER_NAME, nvidia"
        "XDG_SESSION_TYPE, wayland"
        "GBM_BACKEND, nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME, nvidia"
        "WLR_NO_HARDWARE_CURSORS, 1"
      ];

      bind = [
        "$mainMod, Q, killactive"
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, M, fullscreen, 1"
        "$mainMod, B, exec, $browser"
        "$mainMod, SPACE, exec, $run"
        "$mainMod, R, exec, $run"
      ];

      bindm = [
        # Mouse binds
        "$mainMod,mouse:272,movewindow"
        "$mainMod,mouse:273,resizewindow"
      ];
    };
  };

  xdg.configFile = {
    # "hypr/store/dynamic_out.txt".source = ./store/dynamic_out.txt;
    # "hypr/store/prev.txt".source = ./store/prev.txt;
    # "hypr/store/latest_notif".source = ./store/latest_notif;
    # "hypr/scripts/wall".source = ./scripts/wall;
    "hypr/scripts/launch_waybar".source = ./scripts/launch_waybar;
    # "hypr/scripts/tools/dynamic".source = ./scripts/tools/dynamic;
    # "hypr/scripts/tools/expand".source = ./scripts/tools/expand;
    # "hypr/scripts/tools/notif".source = ./scripts/tools/notif;
    # "hypr/scripts/tools/start_dyn".source = ./scripts/tools/start_dyn;
  };

}
