{ lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    # Silence deprecation warning - we handle defaults in matchBlocks."*"
    enableDefaultConfig = false;

    # Include personal hosts and OrbStack
    includes = [
      "~/.orbstack/ssh/config"
      "~/.ssh/config.local"
    ];

    # Default settings for all hosts
    matchBlocks = {
      "*" = {
        # Use ssh-agent
        addKeysToAgent = "yes";
        # UseKeychain is an Apple-specific OpenSSH option (macOS Keychain integration)
        extraOptions = lib.optionalAttrs pkgs.stdenv.isDarwin {
          UseKeychain = "yes";
        };

        # Multiplexing (reuse connections)
        controlMaster = "auto";
        controlPath = "~/.ssh/sockets/%r@%h-%p";
        controlPersist = "10m";

        # Keep connections alive
        serverAliveInterval = 60;
        serverAliveCountMax = 3;

        # Security
        hashKnownHosts = true;
        identitiesOnly = true;
      };

      # GitHub
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/id_ed25519" ];
      };

      # GitLab
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = [ "~/.ssh/id_ed25519" ];
      };
    };
  };
}
