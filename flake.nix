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
      # System configuration
      hostname = "mbp";
      system = "aarch64-darwin"; # Apple Silicon (M-series)
      primaryUser = "emmanuel";

      # User definitions with their git identities
      users = {
        emmanuel = {
          name = "Emmanuel Federbusch";
          email = "emmanuel@federbusch.fr";
          home = "/Users/emmanuel";
        };
        emmanuelf = {
          name = "Emmanuel Federbusch";
          email = "emmanuel.federbusch@pearltrees.net";
          home = "/Users/pearltrees";
        };
      };

      # Helper function to create Home Manager user config
      mkUserConfig = username: userInfo: { pkgs, ... }: {
        imports = [
          ./modules/home/shared.nix
        ];

        # User-specific git configuration
        programs.git = {
          userName = userInfo.name;
          userEmail = userInfo.email;
        };
      };
    in
    {
      # Main system configuration
      # Build with: darwin-rebuild switch --flake ~/.config/nix#mbp
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit primaryUser; };
        modules = [
          # Determinate Nix compatibility
          ({ ... }: {
            nix.enable = false; # Required for Determinate Nix
          })

          # Core nix-darwin settings
          ({ pkgs, ... }: {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            # Define all users
            users.users.emmanuel = {
              home = users.emmanuel.home;
              shell = pkgs.zsh;
            };
            users.users.pearltrees = {
              home = users.emmanuelf.home;
              shell = pkgs.zsh;
            };

            nixpkgs.config.allowUnfree = true;

            system.stateVersion = 6;
            system.primaryUser = primaryUser;

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

            # Configure all users with shared config + user-specific overrides
            home-manager.users.emmanuel = mkUserConfig "emmanuel" users.emmanuel;
            home-manager.users.pearltrees = mkUserConfig "pearltrees" users.emmanuelf;
          }

          # Optional nix-homebrew (disabled by default)
          # nix-homebrew.darwinModules.nix-homebrew {
          # nix-homebrew = {
          #   enable = false;
          #   user = primaryUser;
          #   autoMigrate = true;
          # };
          # }
        ];
      };
    };
}
