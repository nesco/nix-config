{
  description = "Emmanuel Federbusch's macOS system configuration";

  # Flake inputs - using unstable for latest packages
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew integration (currently disabled)
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }:
    let
      # User and system configuration
      username = "emmanuel";
      hostname = "mbp";
      system = "aarch64-darwin"; # Apple Silicon (M-series)
    in
    {
      # Main system configuration
      # Build with: darwin-rebuild switch --flake ~/.config/nix#mbp
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username hostname; };
        modules = [
          # Determinate Nix compatibility
          ({ ... }: {
            nix.enable = false; # Required for Determinate Nix
          })

          # Core nix-darwin settings
          ({ pkgs, ... }: {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            users.users.${username} = {
              home = "/Users/${username}";
              shell = pkgs.zsh;
            };
            nixpkgs.config.allowUnfree = true;


            system.stateVersion = 6;
            system.primaryUser = username;

            environment.systemPackages = with pkgs; [
              # === Shells ===
              fish
              nushell

              # === Version Control ===
              git
              gh
              lazygit
              jujutsu
              delta           # Better git diff viewer

              # === CLI Tools & Utilities ===
              # Modern replacements for Unix tools
              ripgrep         # Better grep (rg)
              fd              # Better find
              eza             # Better ls
              bat             # Better cat
              dust            # Better du
              duf             # Better df
              procs           # Better ps
              bottom          # Better top/htop (btm)

              # Fuzzy finding & navigation
              fzf             # Fuzzy finder
              zoxide          # Smarter cd (installed, configured in HM)

              # File management
              yazi            # Modern file manager TUI
              tree            # Directory tree viewer

              # Text processing & viewing
              jq              # JSON processor
              fx              # Interactive JSON viewer
              sd              # Better sed
              choose          # Better cut/awk
              glow            # Markdown renderer

              # Shell enhancements
              atuin           # Better shell history
              carapace        # Multi-shell completions
              navi            # Interactive cheatsheet
              tldr            # Simplified man pages
              tealdeer        # Alternative tldr client (Rust)

              # HTTP & networking
              xh              # Better curl (httpie in Rust)

              # Development tools
              watchman        # File watching service
              ast-grep        # AST-based code search
              tokei           # Code statistics
              hyperfine       # Command benchmarking

              # === Development Tools ===
              tmux            # Terminal multiplexer
              zellij          # Modern tmux alternative
              neovim
              vim
              vscode
              docker
              lazydocker      # TUI for Docker

              # === Build Tools ===
              cmake
              pkg-config
              gnumake

              # === Languages & Runtimes ===
              # JavaScript/TypeScript
              nodejs_24
              bun
              pnpm
              deno
              nodePackages.prettier
              nodePackages.typescript

              # Go
              go
              gopls

              # Python
              python313
              ruff
              uv

              # Rust
              rustup

              # OCaml
              ocaml
              opam

              # PHP
              php

              # === Media Tools ===
              ffmpeg
              yt-dlp

              # === Databases & Cloud ===
              sqlite
              postgresql
              supabase-cli
            ];

            # Enable shells - zsh is default, fish and nushell are alternatives
            programs.zsh.enable = true;
            programs.fish.enable = true;
            environment.shells = [ pkgs.zsh pkgs.fish pkgs.nushell ];


            security.pam.services.sudo_local.touchIdAuth = true;

            # macOS defaults
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
            system.defaults.dock.autohide = true;
            system.defaults.finder.FXPreferredViewStyle = "Nlsv"; # list view
          })

          # Home Manager as a nix-darwin module
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = { pkgs, ... }: {
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
              # Note: Aliases and common env vars are set via home.shellAliases and home.sessionVariables

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
                # Nushell config (config.nu)
                extraConfig = ''
                  $env.config = {
                    show_banner: false
                    edit_mode: vi
                  }
                '';
                # Nushell environment (env.nu)
                extraEnv = ''
                  # Ensure Nix-managed programs take priority
                  $env.PATH = ($env.PATH | split row (char esep) | prepend "/run/current-system/sw/bin" | prepend $"/etc/profiles/per-user/($env.USER)/bin" | prepend "/opt/homebrew/bin")
                '';
              };

              # Git configuration with delta for better diffs
              programs.git = {
                enable = true;
                userName = "Emmanuel Federbusch";
                userEmail = "emmanuel@federbusch.fr";
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
            };
          }

          # Optional nix-homebrew (disabled by default)
          # nix-homebrew.darwinModules.nix-homebrew {
          # nix-homebrew = {
          #   enable = false;
          #   user = username;
          #   autoMigrate = true;
          # };
          # }
        ];
      };
    };
}
