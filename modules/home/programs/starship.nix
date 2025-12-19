{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # Tokyo Night color palette
      palette = "tokyo_night";
      palettes.tokyo_night = {
        foreground = "#c0caf5";
        background = "#1a1b26";
        black = "#15161e";
        red = "#f7768e";
        green = "#9ece6a";
        yellow = "#e0af68";
        blue = "#7aa2f7";
        magenta = "#bb9af7";
        cyan = "#7dcfff";
        white = "#a9b1d6";
      };

      # General
      add_newline = true;
      scan_timeout = 10;

      # Character (prompt symbol) - Tokyo Night colors
      character = {
        success_symbol = "[❯](bold cyan)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      # Directory - Tokyo Night blue
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold blue";
      };

      # Git - Tokyo Night magenta for branch
      git_branch = {
        symbol = " ";
        truncation_length = 20;
        style = "bold magenta";
      };
      git_status = {
        style = "bold yellow";
        conflicted = "=";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "+";
        renamed = "»";
        deleted = "✘";
      };

      # Languages - show version only when relevant
      nodejs.detect_files = [
        "package.json"
        ".node-version"
      ];
      python.detect_extensions = [ "py" ];
      rust.detect_files = [ "Cargo.toml" ];
      golang.detect_files = [ "go.mod" ];

      # Nix shell indicator
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      # Command duration (show if > 2s)
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
      };

      # Disabled modules (uncomment to disable)
      # package.disabled = true;
      # aws.disabled = true;
      # gcloud.disabled = true;
    };
  };
}
