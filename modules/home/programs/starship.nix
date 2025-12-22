# Starship prompt configuration
#
# Theming: Palette is automatically set by catppuccin/tokyonight nix modules
# based on nesco.theme in flake.nix. Do NOT set palette here.
#
# This file configures behavior and symbols only - colors come from the theme.
#
# Presets reference (for manual use outside nix):
#   starship preset nerd-font-symbols  - Nerd Font icons
#   starship preset tokyo-night        - Tokyo Night theme
#   starship preset catppuccin-powerline - Catppuccin theme
{ ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # === General ===
      add_newline = true;
      scan_timeout = 10;

      # === Prompt symbols ===
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold blue)";
      };

      # === Directory ===
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
      };

      # === Git ===
      git_branch = {
        symbol = " ";
        truncation_length = 20;
      };

      git_status = {
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

      # === Nerd Font symbols for languages ===
      # (matches starship nerd-font-symbols preset)
      c.symbol = " ";
      golang.symbol = " ";
      haskell.symbol = " ";
      java.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      nodejs.symbol = " ";
      python.symbol = " ";
      rust.symbol = "󱘗 ";
      zig.symbol = " ";

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
      };

      # === Language detection ===
      nodejs.detect_files = [ "package.json" ".node-version" ".nvmrc" ];
      python.detect_extensions = [ "py" ];
      rust.detect_files = [ "Cargo.toml" ];
      golang.detect_files = [ "go.mod" ];

      # === Command duration (show if > 2s) ===
      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
      };

      # === Disabled modules ===
      aws.disabled = true;
      gcloud.disabled = true;
      azure.disabled = true;
    };
  };
}
