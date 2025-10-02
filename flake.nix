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
      hostname = "emmanuel-mbp";
      system = "aarch64-darwin"; # M-Series
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username hostname; };
        modules = [
          # Core nix-darwin settings
          ({ pkgs, ... }: {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            users.users.${username}.home = "/Users/${username}";

            nixpkgs.config.allowUnfree = true;


            system.stateVersion = 6;
            system.primaryUser = username;

            environment.systemPackages = with pkgs; [
              # shell & workflow
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

            programs.zsh.enable = true;
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

              # Install GNU Man tools
              home.packages = with pkgs; [
                man-db
              ];

              # Prefer the Nix man-db over macOS ones
              home.sessionPath = [
                "${pkgs.man-db}/bin"
                "${pkgs.man-db}/libexec/bin"
              ];

              # Point man/apropos to your per-user whatis DB
              home.sessionVariables = {
                MANOPT = "-M ''${"\${XDG_CACHE_HOME:-$HOME/.cache}"}/man";
              };

              # Rebuild the DB on every HM switch
              home.activation.updateWhatis = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                set -e
                cache="''${XDG_CACHE_HOME:-$HOME/.cache}/man"
                mkdir -p "$cache"

                MANPATHS="
                  $HOME/.nix-profile/share/man
                  /etc/profiles/per-user/$USER/share/man
                  /run/current-system/sw/share/man
                  /opt/homebrew/share/man
                  /usr/local/share/man
                  /usr/share/man
                "

                /usr/libexec/makewhatis -o "$cache/whatis" $MANPATHS || true
              '';

              targets.darwin.linkApps.enable = true;
              programs.starship.enable = true;
              programs.zoxide.enable = true;
              programs.fzf.enable = true;
              programs.direnv.enable = true;
              programs.direnv.nix-direnv.enable = true;
              programs.zsh = {
                enable = true;
                initContent = ''
                  # Ensure Nix-managed programs take priority
                  export PATH=/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:$PATH
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
