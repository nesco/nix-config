{ ... }:

{
  programs.opencode = {
    enable = true;

    settings = {
      # Model - uses Anthropic by default
      model = "anthropic/claude-opus-4-5";

      # Disable telemetry/sharing
      autoshare = false;
      autoupdate = false;
    };
  };
}
