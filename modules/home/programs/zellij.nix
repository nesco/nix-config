{ ... }:

{
  programs.zellij = {
    enable = true;

    # KDL settings
    settings = {
      # Theme
      theme = "tokyo-night";

      # Mouse support
      mouse_mode = true;

      # Copy to system clipboard
      copy_on_select = true;

      # Scrollback
      scroll_buffer_size = 50000;

      # Session serialization (for resurrect)
      session_serialization = true;
      serialize_pane_viewport = true;

      # Default layout
      default_layout = "compact";

      # On force close (detach or quit)
      on_force_close = "detach";
    };

    # Tokyo Night theme definition
    themes = {
      tokyo-night = ''
        themes {
          tokyo-night {
            fg "#c0caf5"
            bg "#1a1b26"
            black "#15161e"
            red "#f7768e"
            green "#9ece6a"
            yellow "#e0af68"
            blue "#7aa2f7"
            magenta "#bb9af7"
            cyan "#7dcfff"
            white "#a9b1d6"
            orange "#ff9e64"
          }
        }
      '';
    };

    # Custom layouts
    layouts = {
      # Development layout with editor, git, files, and shell
      dev = ''
        layout {
          default_tab_template {
            pane size=1 borderless=true {
              plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
              plugin location="zellij:status-bar"
            }
          }

          tab name="Editor" focus=true {
            pane command="nvim"
          }

          tab name="Git" {
            pane command="lazygit"
          }

          tab name="Files" {
            pane command="yazi"
          }

          tab name="Shell" {
            pane
          }
        }
      '';
    };
  };
}
