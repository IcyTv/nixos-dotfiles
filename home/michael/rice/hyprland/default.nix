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
      "$fileManager" = "thunar";
      "$menu" = "wofi";

      monitor = [
        "HDMI-0,preferred,4480x348,1"
        "DP-2,2560x1440@144,1920x108,1"
        "DP-3,preferred,0x0,1"
      ];

      exec-once = [
        "autostart"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        # TODO use nix-colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_is_master = "yes";
      };

      windowrulev2 = [
        "nomaximizerequest, class:.*"
        # TODO use nix-colors
        "bordercolor rgb(FF0000) rgb(880808),fullscreen:1"
      ];

      env = [
        "LIBVA_DRIVER_NAME, nvidia"
        "XDG_SESSION_TYPE, wayland"
        "GBM_BACKEND, nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME, nvidia"
        "WLR_NO_HARDWARE_CURSORS, 1"
        "XCURSOR_SIZE,24"
      ];

      bind = [
        "$mainMod, Q, killactive"
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, B, exec, $browser"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, R, exec, $menu"
        "$mainMod, E, exec, $fileManager"

        "$mainMod, M, fullscreen, 1"
        
        "$mainMod, V, togglefloating"
        "$mainMod, X, togglesplit"
        "$mainMod, P, pseudo"
        "$mainMod, T, togglegroup"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 12;
            in
              builtins.toString (x + 1 - (c * 12));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        12)
      );

      bindm = [
        # Mouse binds
        "$mainMod,mouse:272,movewindow"
        "$mainMod,mouse:273,resizewindow"
      ];

      workspace = [
        "1, monitor:HDMI-A-1"
        "2, monitor:DP-2"
        "3, monitor:DP-3"
        "4, monitor:HDMI-A-1"
        "5, monitor:DP-2"
        "6, monitor:DP-3"
        "7, monitor:HDMI-A-1"
        "8, monitor:DP-2"
        "9, monitor:DP-3"
        "10, monitor:HDMI-A-1"
        "11, monitor:DP-2"
        "12, monitor:DP-3"
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
