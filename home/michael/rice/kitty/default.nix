{pkgs, ...}: {
  # home.packages = with pkgs; [kitty];
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
      mode = "no-cursor";
    };
    theme = "Catppuccin-Macchiato";
    font = {
      name = "SourceCodePro Nerd Font";
      size = 10;
    };

    settings = {
      text_composition_strategy = "platform";
      sync_to_monitor = "yes";

      # Don't ask for confirmation when closing a tab.
      confirm_os_window_close = 0;
      disable_ligatures = "never";

      copy_on_select = "clipboard";
      clear_all_shortcuts = true;
      draw_minimal_borders = "yes";
      input_delay = 0;
      kitty_mod = "ctrl+shift";

      # Mouse
      mouse_hide_wait = 10;
      url_style = "double";

      # Shhhhh
      enable_audio_bell = false;
      visual_bell_duration = 0;
      window_alert_on_bell = false;
      bell_on_tab = false;
      command_on_bell = "none";

      term = "xterm-256color";

      # Padding
      window_padding_width = 10;

      # Tab Bar
      tab_bar_edge = "top";
      tab_bar_margin_width = 5;
      tab_bar_margin_height = "5 0";
      tab_bar_style = "separator";
      tab_bar_min_tabs = 2;
      # tab_separator = "";
      tab_title_template = "{fmt.fg._5c6370}{fmt.bg.default}{fmt.fg._abb2bf}{fmt.bg._5c6370} {tab.active_oldest_wd} {fmt.fg._5c6370}{fmt.bg.default} ";
      active_tab_title_template = "{fmt.fg._BAA0E8}{fmt.bg.default}{fmt.fg.default}{fmt.bg._BAA0E8} {tab.active_oldest_wd} {fmt.fg._BAA0E8}{fmt.bg.default} ";
      # tab_bar_edge = "bottom";
      # tab_bar_style = "powerline";
      # tab_powerline_style = "slanted";
      # active_tab_title_template = "{index}: {title}";
      # active_tab_font_style = "bold-italic";
      # inactive_tab_font_style = "normal";

    };
  };
}