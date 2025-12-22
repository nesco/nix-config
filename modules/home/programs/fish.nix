{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    # Abbreviations (expand on space, better than aliases)
    shellAbbrs = {
      # Git
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gp = "git push";
      gl = "git pull";
      gs = "git status";
      gst = "git stash";
      gsp = "git stash pop";
      glg = "git log --oneline --graph";

      # Nix
      nr = "darwin-rebuild switch --flake ~/.config/nix";
      nfu = "nix flake update";
      ns = "nix search nixpkgs";
      nsh = "nix-shell";
      nd = "nix develop";

      # Common
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      md = "mkdir -p";
    };

    # Custom functions
    functions = {
      # Quick directory creation and cd
      mkcd = {
        description = "Create directory and cd into it";
        body = "mkdir -p $argv[1] && cd $argv[1]";
      };

      # Git commit with message
      gcm = {
        description = "Git commit with message";
        argumentNames = [ "message" ];
        body = "git commit -m $message";
      };

      # Find in files
      rga = {
        description = "Ripgrep with file preview";
        body = ''
          set result (rg --color=always --line-number --no-heading --smart-case $argv | \
            fzf --ansi --preview 'bat --color=always (echo {} | cut -d: -f1) --highlight-line (echo {} | cut -d: -f2)')
          if test -n "$result"
            set file (echo $result | cut -d: -f1)
            set line (echo $result | cut -d: -f2)
            $EDITOR +$line $file
          end
        '';
      };

      # Last command status in prompt (if needed)
      fish_prompt_status = {
        description = "Show exit status if non-zero";
        body = ''
          set -l last_status $status
          if test $last_status -ne 0
            set_color red
            echo -n "[$last_status] "
            set_color normal
          end
        '';
      };
    };

    interactiveShellInit = ''
      # Ensure Nix-managed programs take priority
      fish_add_path --prepend /run/current-system/sw/bin
      fish_add_path --prepend /etc/profiles/per-user/$USER/bin

      # Homebrew (lower priority than Nix)
      fish_add_path --append /opt/homebrew/bin

      # SOPS age key location
      set -gx SOPS_AGE_KEY_FILE "$HOME/.config/sops/age/keys.txt"

      # Load secrets (API keys, etc.)
      # Each user maintains their own ~/.secrets.env
      if test -f ~/.secrets.env
        for line in (cat ~/.secrets.env | grep -v '^#' | grep -v '^$')
          set -l key (echo $line | cut -d= -f1)
          set -l val (echo $line | cut -d= -f2-)
          set -gx $key $val
        end
      end
      # Load sops-managed secrets
      if test -r /run/secrets/context7_api_key
        set -gx CONTEXT7_API_KEY (cat /run/secrets/context7_api_key)
      end

      # Suppress greeting
      set -g fish_greeting

      # Vi mode
      fish_vi_key_bindings

      # Better vi mode cursor
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
    '';

    # Plugins
    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
    ];
  };
}
