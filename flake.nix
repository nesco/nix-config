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

    # Theming
    catppuccin.url = "github:catppuccin/nix";
    tokyonight.url = "github:mrjones2014/tokyonight.nix";

    # Stylix (disabled - kept for future use)
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence (for future NixOS servers)
    impermanence.url = "github:nix-community/impermanence";

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

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      catppuccin,
      tokyonight,
      stylix,
      sops-nix,
      impermanence,
      nix-homebrew,
      ...
    }:
    let
      # ============================================
      # Centralized configuration (nesco namespace)
      # ============================================
      nesco = {
        # System
        hostname = "mbp";
        system = "aarch64-darwin";
        stateVersion = 6;
        timeZone = "Europe/Paris";

        # Primary user
        primaryUser = "emmanuel";

        # Theming - switch between "catppuccin" or "tokyonight"
        theme = "catppuccin";

        # Catppuccin options (when theme = "catppuccin")
        catppuccin = {
          flavor = "macchiato";  # latte, frappe, macchiato, mocha
          accent = "peach";      # blue, flamingo, green, lavender, maroon, mauve, peach, pink, red, rosewater, sapphire, sky, teal, yellow
        };

        # Tokyo Night options (when theme = "tokyonight")
        tokyonight = {
          style = "storm";  # storm, night, moon, day
        };

        # User definitions
        users = {
          emmanuel = {
            name = "Emmanuel Federbusch";
            email = "emmanuel@federbusch.fr";
            home = "/Users/emmanuel";
          };
          pearltrees = {
            name = "Emmanuel Federbusch";
            email = "emmanuel.federbusch@pearltrees.net";
            home = "/Users/pearltrees";
          };
        };
      };

      # Helper function to create Home Manager user config
      mkUserConfig =
        username: userInfo:
        { pkgs, lib, ... }:
        {
          imports = [
            catppuccin.homeModules.catppuccin
            tokyonight.homeManagerModules.default
            ./modules/home/shared.nix
          ];

          # User-specific git configuration
          programs.git.settings.user = {
            name = userInfo.name;
            email = userInfo.email;
          };

          # Theming - conditional based on nesco.theme
          catppuccin = lib.mkIf (nesco.theme == "catppuccin") {
            enable = true;
            flavor = nesco.catppuccin.flavor;
            accent = nesco.catppuccin.accent;
          };

          tokyonight = lib.mkIf (nesco.theme == "tokyonight") {
            enable = true;
            style = nesco.tokyonight.style;
          };
        };
    in
    {
      # Main system configuration
      # Build with: darwin-rebuild switch --flake ~/.config/nix#mbp
      darwinConfigurations.${nesco.hostname} = nix-darwin.lib.darwinSystem {
        system = nesco.system;
        specialArgs = {
          inherit nesco;
          primaryUser = nesco.primaryUser;
        };
        modules = [
          # Determinate Nix compatibility
          (
            { ... }:
            {
              nix.enable = false; # Required for Determinate Nix
            }
          )

          # Core nix-darwin settings
          (
            { pkgs, ... }:
            {
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];

              # Define all users
              users.users.emmanuel = {
                home = nesco.users.emmanuel.home;
                shell = pkgs.zsh;
              };
              users.users.pearltrees = {
                home = nesco.users.pearltrees.home;
                shell = pkgs.zsh;
              };

              nixpkgs.config.allowUnfree = true;

              system.stateVersion = nesco.stateVersion;
              system.primaryUser = nesco.primaryUser;

              environment.systemPackages = with pkgs; [
                # === Shells ===
                fish
                nushell

                # === Version Control ===
                git
                gh
                glab # GitLab CLI
                lazygit
                tig # Git TUI
                jujutsu
                delta # Better git diff viewer

                # === CLI Tools & Utilities ===
                # Modern replacements for Unix tools
                ripgrep # Better grep (rg)
                fd # Better find
                eza # Better ls
                bat # Better cat
                dust # Better du
                duf # Better df
                procs # Better ps
                bottom # Better top/htop (btm)

                # Fuzzy finding & navigation
                fzf # Fuzzy finder
                zoxide # Smarter cd (installed, configured in HM)

                # File management
                yazi # Modern file manager TUI
                tree # Directory tree viewer

                # Text processing & viewing
                jq # JSON processor
                yq-go # YAML/JSON/XML processor
                fx # Interactive JSON viewer
                dasel # Universal data selector
                miller # CSV/JSON/etc swiss army knife
                qsv # Fast CSV toolkit (xsv fork)
                sd # Better sed
                choose # Better cut/awk
                glow # Markdown renderer

                # Shell enhancements
                atuin # Better shell history
                carapace # Multi-shell completions
                navi # Interactive cheatsheet
                tldr # Simplified man pages
                tealdeer # Alternative tldr client (Rust)

                # HTTP & networking
                xh # Better curl (httpie in Rust)
                grpcurl # gRPC CLI

                # Disk usage
                ncdu # NCurses disk usage

                # Development tools
                watchman # File watching service
                watchexec # Execute on file changes
                entr # Run commands when files change
                ast-grep # AST-based code search
                semgrep # Semantic code analysis
                tokei # Code statistics
                scc # Sloc, cloc alternative
                hyperfine # Command benchmarking
                difftastic # Structural diff tool (difft)

                # === Development Tools ===
                tmux # Terminal multiplexer
                zellij # Modern tmux alternative
                neovim
                vim
                vscode

                docker
                lazydocker # TUI for Docker

                # Kubernetes
                kubectl
                k9s # K8s TUI
                kubernetes-helm # Helm package manager

                # === Build Tools ===
                cmake
                pkg-config
                gnumake
                just # Modern make alternative
                ninja # Fast build system
                meson # Build system

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
                golangci-lint

                # Python (env managed in modules/home/programs/python.nix)
                ruff # Linter/formatter
                uv # Fast pip/venv
                pyright # Type checker

                # Rust
                rustup

                # Haskell
                ghc
                cabal-install
                stack
                haskell-language-server

                # Elixir/Erlang
                elixir
                erlang

                # Ruby
                ruby
                bundler

                # JVM
                jdk
                gradle
                maven

                # Zig
                zig
                zls # Zig language server

                # Gleam
                gleam

                # OCaml
                ocaml
                opam
                dune_3

                # PHP
                php

                # Version managers
                mise

                # === Local LLM Inference ===
                ollama # LLM runner with Metal support
                llama-cpp # llama.cpp with Metal support

                # === Media Tools ===
                ffmpeg
                yt-dlp

                # === Databases & Cloud ===
                sqlite
                postgresql
                supabase-cli

                # === Secrets management ===
                sops
                age
                ssh-to-age
                git-crypt
                gnupg
                pinentry_mac
              ];

              # Enable shells - zsh is default, fish and nushell are alternatives
              programs.zsh.enable = true;
              programs.fish.enable = true;
              environment.shells = [
                pkgs.zsh
                pkgs.fish
                pkgs.nushell
              ];

              security.pam.services.sudo_local.touchIdAuth = true;

              # macOS defaults
              system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
              system.defaults.dock.autohide = true;
              system.defaults.finder.FXPreferredViewStyle = "Nlsv"; # list view
            }
          )

          # Stylix theming (temporarily disabled - opencode compatibility issue)
          # stylix.darwinModules.stylix
          # ./modules/darwin/stylix.nix

          # Secrets management with sops-nix
          sops-nix.darwinModules.sops
          ./modules/darwin/sops.nix

          # Home Manager as a nix-darwin module
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit nesco; };

            # Configure all users with shared config + user-specific overrides
            home-manager.users.emmanuel = mkUserConfig "emmanuel" nesco.users.emmanuel;
            home-manager.users.pearltrees = mkUserConfig "pearltrees" nesco.users.pearltrees;
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
