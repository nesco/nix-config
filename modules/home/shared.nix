# Shared Home Manager configuration for all macOS users
# This module contains shell configurations, development tools, and environment settings
{ pkgs, ... }:

{
  home.stateVersion = "25.05";
  targets.darwin.linkApps.enable = true;

  # Common environment variables for all shells
  home.sessionVariables = {
    EDITOR = "nvim";
    DIR_NIX = "$HOME/.config/nix";
  };

  # Common aliases for all shells
  home.shellAliases = {
    ls = "eza --icons";
    ll = "eza -lh --group-directories-first --icons";
    la = "eza -lha --group-directories-first --icons";
    lt = "eza -lh --tree --level=2 --group-directories-first --icons";
  };

  # Prompt - integrated with all shells
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # Directory jumping - integrated with all shells
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # Direnv - auto-integrates with enabled shells
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Fuzzy finder - integrated with all shells
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  # Better shell history - synced, searchable
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      style = "compact";
    };
  };

  # Modern file manager
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # Multi-shell completions (essential for Nushell!)
  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  # Terminal multiplexer alternative
  programs.zellij = {
    enable = true;
  };

  # === Shell Configurations ===

  # Zsh - Default shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      # Ensure Nix-managed programs take priority
      export PATH=/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:/opt/homebrew/bin:$PATH
    '';
  };

  # Fish - Alternative shell
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Ensure Nix-managed programs take priority
      set -gx PATH /run/current-system/sw/bin /etc/profiles/per-user/$USER/bin /opt/homebrew/bin $PATH
    '';
  };

  # Nushell - Alternative shell (structured data shell)
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
        edit_mode: vi
      }
    '';
    extraEnv = ''
      # Ensure Nix-managed programs take priority
      $env.PATH = ($env.PATH | split row (char esep) | prepend "/run/current-system/sw/bin" | prepend $"/etc/profiles/per-user/($env.USER)/bin" | prepend "/opt/homebrew/bin")
    '';
  };

  # Git configuration with delta for better diffs
  # Note: userName and userEmail should be set per-user
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = false;
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.neovim.enable = true;

  home.file.".gitignore_global".text = ''
    .DS_Store
    node_modules/
  '';
}
