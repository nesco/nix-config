{ ... }:

{
  programs.fzf = {
    enable = true;

    # Use fd instead of find (faster, respects .gitignore)
    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidget.command = "fd --type f --hidden --exclude .git";
    changeDirWidget.command = "fd --type d --hidden --exclude .git";
    historyWidget.command = "";

    # Default options
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
      # Tokyo Night colors
      "--color=fg:#c0caf5,bg:#1a1b26,hl:#ff9e64"
      "--color=fg+:#c0caf5,bg+:#292e42,hl+:#ff9e64"
      "--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7aa2f7"
      "--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
    ];

    # CTRL-T: file preview with bat
    fileWidget.options = [
      "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    ];

    # ALT-C: directory preview with eza
    changeDirWidget.options = [
      "--preview 'eza --tree --level=2 --icons --color=always {}'"
    ];

    # CTRL-R: history options
    historyWidget.options = [
      "--sort"
      "--exact"
    ];

    # tmux integration (optional)
    # tmux.enableShellIntegration = true;
  };
}
