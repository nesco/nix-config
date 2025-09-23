{
  description = "The config of Emmanuel Federbusch's macOS computers (nix-darwin + home-manager)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url  = "github:LnL7/nix-darwin";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }:
  let 
    username = "emmanuel";
    hostname = "emmanuel-mbp";
    system = "aarch64-darwin"; # M-Series
  in {
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
            git gh lazygit ripgrep fd jq eza bat fzf tree tmux watchman glow jujutsu docker

            # languages / runtimes
            nodejs_22 bun deno go gopls python313 rustup uv ocaml opam php

            # formatters / linters / TS
            ruff nodePackages.prettier nodePackages.typescript

            # editors & build
            neovim vscode zed-editor cmake pkg-config gnumake vim

            # media & misc
            ffmpeg yt-dlp ast-grep

            # db & cloud CLIs
            sqlite postgresql supabase-cli
          ];

          programs.zsh = { 
            enable = true;
            initExtra = ''
              # Ensure Nix-managed programs take priority
              export PATH=/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:$PATH
              export EDITOR=nvim
            '';
          };
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
          home-manager.users.${username} = { pkgs, ... }: {
            home.stateVersion = "25.05";
            programs.starship.enable = true;
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

            home.file.".gitignore_global".text = ''
              .DS_Store
              node_modules/
            '';
          };
        }

        # Optional nix-homebrew (disabled by default)
        # nix-homebrew.darwinModules.nix-homebrew {
        # nix-homebrew = {
        #   enable = false; # still off for now
        #   user = username;
        #   taps = [ "homebrew/homebrew-core" "homebrew/homebrew-cask" ];
        #   packages = {
        #     brews = [ ];
        #     casks = [ ];
        #   };
        # };
        # }
      ];
    };
  };
}
