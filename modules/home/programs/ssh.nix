{ lib, pkgs, ... }:

{
  programs.ssh = {
    enable = true;

    # Silence deprecation warning - we handle defaults in settings."*"
    enableDefaultConfig = false;

    # Include personal hosts and OrbStack
    includes = [
      "~/.orbstack/ssh/config"
      "~/.ssh/config.local"
    ];

    # New-style settings: attr keys are Host/Match patterns, values use
    # upstream OpenSSH directive names (CamelCase).
    settings = {
      # Defaults for all hosts
      "*" = {
        # Use ssh-agent
        AddKeysToAgent = "yes";

        # Multiplexing (reuse connections)
        ControlMaster = "auto";
        ControlPath = "~/.ssh/sockets/%r@%h-%p";
        ControlPersist = "10m";

        # Keep connections alive
        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;

        # Security
        HashKnownHosts = "yes";
        IdentitiesOnly = "yes";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # macOS Keychain integration (Apple-specific OpenSSH option)
        UseKeychain = "yes";
      };

      # GitHub
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };

      # GitLab
      "gitlab.com" = {
        HostName = "gitlab.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
