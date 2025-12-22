# SOPS secrets configuration for Darwin
{ config, primaryUser, ... }:

{
  sops = {
    # Default encrypted secrets file
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Age key location
    age = {
      keyFile = "/Users/${primaryUser}/.config/sops/age/keys.txt";
      generateKey = false; # We manage the key manually
    };

    # Declare secrets here
    # Each secret will be decrypted to /run/secrets/<name> at activation
    secrets = {
      "context7_api_key" = {
        owner = primaryUser;
      };
      # SSH public keys for remote server access (one per machine)
      "authorized_keys/mbp_m1_max" = {
        owner = primaryUser;
      };
    };
  };
}
