{
  description = "The config of Emmanuel Federbusch's macOS computers (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
      username = "emmanuel";
      hostname = "mbp";
      system = "aarch64-darwin"; # M-Series
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username hostname; };
        modules = [
          ({ ... }: { nix.enable = false; })
         # Core nix-darwin settings
          ({ pkgs, ... }: {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            users.users.${username} = {
              home = "/Users/${username}";
              # shell = pkgs.fish;
              shell = pkgs.zsh;
            };
            nixpkgs.config.allowUnfree = true;


            system.stateVersion = 6;
            system.primaryUser = username;

            environment.systemPackages = with pkgs; [
              # shell & workflow
              # fish
              git
              gh
              lazygit
              ripgrep
              fd
              jq
              eza
              bat
              fzf
              tree
              tmux
              watchman
              glow
              jujutsu
              docker

              # Unsupported on mac for now + move to ghostty to compile it through nix: ghostty-bin

              # languages / runtimes
              nodejs_24
              bun
              pnpm
              deno
              go
              gopls
              python313
              rustup
              uv
              ocaml
              opam
              php

              # formatters / linters / TS
              ruff
              uv
              nodePackages.prettier
              nodePackages.typescript

              # editors & build
              neovim
              vscode
              cmake
              pkg-config
              gnumake
              vim

              # media & misc
              ffmpeg
              yt-dlp
              ast-grep
              tldr

              # db & cloud CLIs
              sqlite
              postgresql
              supabase-cli
            ];

            ## Use fish
            programs.zsh.enable = true;
            # programs.fish.enable = true;
            # environment.shells = [ pkgs.fish ];
            environment.shells = [ pkgs.zsh ];


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
            home-manager.users.${username} = { pkgs, lib, ... }: {
              home.stateVersion = "25.05";
              targets.darwin.linkApps.enable = true;
              programs.starship = {
                enable = true;
                enableZshIntegration = true;
                enableFishIntegration = true;
              };
              programs.zoxide.enable = true;
              programs.direnv.enable = true;
              programs.direnv.nix-direnv.enable = true;
              programs.fish = {
                enable = true;

                # Equivalent of your old zsh initContent, but in fish syntax
                interactiveShellInit = ''
                  # Ensure Nix-managed programs take priority
                  set -gx PATH /run/current-system/sw/bin /etc/profiles/per-user/$USER/bin /opt/homebrew/bin $PATH
                  set -gx EDITOR nvim
                  set -gx DIR_NIX ~/.config/nix
                '';

                shellAliases = {
                  ls = "eza --icons";
                  ll = "eza -lh --group-directories-first --icons";
                  la = "eza -lha --group-directories-first --icons";
                  lt = "eza -lh --tree --level=2 --group-directories-first --icons";
                };
              };
              programs.fzf = {
                enable = true;
                enableFishIntegration = true;
              };
              programs.zsh = {
                enable = true;
                initContent = ''
                  # Ensure Nix-managed programs take priority
                  export PATH=/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:/opt/homebrew/bin:$PATH
                  export EDITOR=nvim
                  export DIR_NIX=/Users/$USER/.config/nix
                '';
                shellAliases = {
                  ls = "eza --icons";
                  ll = "eza -lh --group-directories-first --icons";
                  la = "eza -lha --group-directories-first --icons";
                  lt = "eza -lh --tree --level=2 --group-directories-first --icons";
                };
              };
              programs.git = {
                enable = true;
                userName = "Emmanuel Federbusch";
                userEmail = "emmanuel@federbusch.fr";
                extraConfig = {
                  init.defaultBranch = "main";
                  pull.rebase = true;
                };
              };
              programs.neovim.enable = true;
              # programs.ghostty = {
              #   enable = true;
              #   settings = {
              #     theme = "TokyoNight Moon";
              #   };
              # };

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
