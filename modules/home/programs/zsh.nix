{ lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkBefore ''
      ZSH_DISABLE_COMPFIX=true
      # Ensure Nix-managed programs take priority
      export PATH=/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:/opt/homebrew/bin:$PATH
    '';
  };
}
