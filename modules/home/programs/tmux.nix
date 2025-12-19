{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Better terminal support
    terminal = "tmux-256color";

    # VI mode
    keyMode = "vi";
    customPaneNavigationAndResize = true;

    # Start windows/panes at 1, not 0
    baseIndex = 1;

    # Mouse support
    mouse = true;

    # Reduce escape delay (important for vim/neovim)
    escapeTime = 0;

    # More history
    historyLimit = 50000;

    # Focus events for vim/neovim
    focusEvents = true;

    # Start sensible defaults first
    sensibleOnTop = true;

    # No confirmation when killing panes/windows
    disableConfirmationPrompt = true;

    # Prefix: Ctrl-a (more ergonomic than Ctrl-b)
    prefix = "C-a";

    # Split with v and s (vim-like)
    reverseSplit = true;

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      # Session management
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }

      # Better copy mode
      yank

      # Fuzzy finding
      tmux-fzf

      # Tokyo Night theme
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_window_id_style digital
          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_show_path 1
          set -g @tokyo-night-tmux_path_format relative
        '';
      }
    ];

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Faster command sequences
      set -s escape-time 0

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity off

      # Better split bindings (in addition to v/s)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # New window in current path
      bind c new-window -c "#{pane_current_path}"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Quick pane cycling
      bind -r Tab select-pane -t :.+

      # Vim-like copy mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-selection-and-cancel

      # Clear scrollback
      bind C-l send-keys 'C-l' \; clear-history
    '';
  };
}
