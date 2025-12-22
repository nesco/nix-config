# User configuration options
{ lib, config, ... }:

let
  inherit (lib) mkOption types;
in
{
  options.nesco.user = {
    name = mkOption {
      type = types.str;
      description = "Primary username";
    };

    fullName = mkOption {
      type = types.str;
      description = "User's full name";
    };

    email = mkOption {
      type = types.str;
      description = "User's email address";
    };

    home = mkOption {
      type = types.path;
      description = "User's home directory";
    };

    shell = mkOption {
      type = types.str;
      default = "zsh";
      description = "Default shell (zsh, fish, nushell)";
    };

    editor = mkOption {
      type = types.str;
      default = "nvim";
      description = "Default editor";
    };
  };
}
