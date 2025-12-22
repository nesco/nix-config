# Shared Home Manager configuration for all macOS users
# This module contains shell configurations, development tools, and environment settings
{ lib, ... }:

{
  imports = [
    ./programs/atuin.nix
    ./programs/bat.nix
    ./programs/claude-code.nix
    ./programs/codex.nix
    ./programs/direnv.nix
    # ./programs/emacs.nix  # TODO: org package has download issues in nixpkgs
    ./programs/eza.nix
    ./programs/fish.nix
    ./programs/fzf.nix
    ./programs/gemini-cli.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/jujutsu.nix
    ./programs/lazygit.nix
    ./programs/neovim.nix
    ./programs/nushell.nix
    ./programs/opencode.nix
    ./programs/python.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/vim.nix
    ./programs/zellij.nix
    ./programs/zsh.nix
  ];

  home.stateVersion = "25.05";
  targets.darwin.linkApps.enable = true;

  # Shell integrations - set once, applies to all programs
  home.shell.enableZshIntegration = true;
  home.shell.enableFishIntegration = true;
  home.shell.enableNushellIntegration = true;

  # Common environment variables for all shells
  home.sessionVariables = {
    DIR_NIX = "$HOME/.config/nix";
  };

  # Shell aliases - eza aliases handled by programs.eza
  # Add other aliases here if needed
  # home.shellAliases = { };

  # Directory jumping
  programs.zoxide.enable = true;

  # Modern file manager
  programs.yazi.enable = true;

  # Multi-shell completions (essential for Nushell!)
  programs.carapace.enable = true;
}
