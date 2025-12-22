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
      # SOPS age key location
      export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"
      # Load secrets (API keys, etc.)
      # Each user maintains their own ~/.secrets.env
      [[ -f ~/.secrets.env ]] && { set -a; source ~/.secrets.env; set +a; }
      # Load sops-managed secrets
      [[ -r /run/secrets/context7_api_key ]] && export CONTEXT7_API_KEY="$(cat /run/secrets/context7_api_key)"
    '';
  };
}
