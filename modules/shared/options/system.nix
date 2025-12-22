# System configuration options
# NOTE: These options are for future NixOS use. Currently, the nesco config
# is defined as a simple attrset in flake.nix for Darwin.
{ lib, pkgs, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.nesco = {
    # Platform detection (read-only)
    isLinux = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isLinux;
      readOnly = true;
      description = "Whether the current system is Linux";
    };

    isDarwin = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isDarwin;
      readOnly = true;
      description = "Whether the current system is Darwin (macOS)";
    };

    # System settings
    hostname = mkOption {
      type = types.str;
      description = "System hostname";
    };

    timeZone = mkOption {
      type = types.str;
      default = "Europe/Paris";
      description = "System timezone";
    };

    stateVersion = mkOption {
      type = types.oneOf [ types.str types.int ];
      description = "NixOS/nix-darwin state version";
    };

    # Theming
    theme = mkOption {
      type = types.enum [ "catppuccin" "tokyonight" ];
      default = "catppuccin";
      description = "Color theme to use";
    };

    catppuccin = {
      flavor = mkOption {
        type = types.enum [ "latte" "frappe" "macchiato" "mocha" ];
        default = "macchiato";
        description = "Catppuccin flavor";
      };

      accent = mkOption {
        type = types.enum [
          "blue" "flamingo" "green" "lavender" "maroon"
          "mauve" "peach" "pink" "red" "rosewater"
          "sapphire" "sky" "teal" "yellow"
        ];
        default = "peach";
        description = "Catppuccin accent color";
      };
    };

    tokyonight = {
      style = mkOption {
        type = types.enum [ "storm" "night" "moon" "day" ];
        default = "storm";
        description = "Tokyo Night style variant";
      };
    };
  };
}
