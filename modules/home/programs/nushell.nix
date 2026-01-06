{ pkgs, ... }:

{
  programs.nushell = {
    enable = true;

    # Structured settings (preferred over extraConfig)
    settings = {
      show_banner = false;
      edit_mode = "vi";

      # Completions
      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "fuzzy";
        external = {
          enable = true;
          max_results = 100;
        };
      };

      # History
      history = {
        file_format = "sqlite";
        max_size = 100000;
        sync_on_enter = true;
        isolation = false;
      };

      # Table display
      table = {
        mode = "rounded";
        index_mode = "always";
        show_empty = true;
        padding = {
          left = 1;
          right = 1;
        };
        header_on_separator = false;
      };

      # Errors
      error_style = "fancy";

      # Hooks (optional)
      # hooks.pre_prompt = [];
    };

    # Environment variables
    extraEnv = ''
      # Ensure Nix-managed programs take priority
      $env.PATH = ($env.PATH | split row (char esep) | prepend "/run/current-system/sw/bin" | prepend $"/etc/profiles/per-user/($env.USER)/bin" | prepend "/opt/homebrew/bin")

      # SOPS age key location
      $env.SOPS_AGE_KEY_FILE = $"($env.HOME)/.config/sops/age/keys.txt"

      # Load secrets (API keys, etc.)
      # Each user maintains their own ~/.secrets.env
      let secrets_file = $"($env.HOME)/.secrets.env"
      if ($secrets_file | path exists) {
        open $secrets_file
        | lines
        | where { |line| not ($line | str starts-with '#') and ($line | str contains '=') }
        | each { |line|
          let idx = ($line | str index-of '=')
          let key = ($line | str substring 0..$idx)
          let value = ($line | str substring ($idx + 1)..)
          {$key: $value}
        }
        | reduce -f {} { |it, acc| $acc | merge $it }
        | load-env
      }

      # Load sops-managed secrets
      if ("/run/secrets/context7_api_key" | path exists) {
        $env.CONTEXT7_API_KEY = (open /run/secrets/context7_api_key | str trim)
      }
    '';

    # Plugins
    plugins = with pkgs.nushellPlugins; [
      formats # CSV, JSON, YAML, etc.
      query # query data structures (xpath, web scraping)
      gstat # git status info
      polars # dataframes (like pandas)
      # highlight # syntax highlighting
      # net      # network utilities
      # regex    # regex operations
      # units    # unit conversions
    ];
  };
}
