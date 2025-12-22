# Persistence options for NixOS impermanence
{ lib, config, ... }:

let
  inherit (lib) mkOption mkEnableOption types;
in
{
  options.nesco.persistence = {
    enable = mkEnableOption "impermanence (ephemeral root filesystem)";

    dataPrefix = mkOption {
      type = types.str;
      default = "/persist";
      description = "Path prefix for persistent data";
    };

    cachePrefix = mkOption {
      type = types.str;
      default = "/cache";
      description = "Path prefix for persistent cache";
    };

    # Directories to persist (used by NixOS impermanence module)
    directories = mkOption {
      type = types.listOf types.str;
      default = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd"
      ];
      description = "System directories to persist";
    };

    # Files to persist
    files = mkOption {
      type = types.listOf types.str;
      default = [
        "/etc/machine-id"
      ];
      description = "System files to persist";
    };

    # User directories to persist
    userDirectories = mkOption {
      type = types.listOf types.str;
      default = [
        ".config"
        ".local"
        ".ssh"
        "Documents"
        "Projects"
      ];
      description = "User directories to persist";
    };
  };
}
