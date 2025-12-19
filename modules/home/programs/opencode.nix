{ ... }:

{
  programs.opencode = {
    enable = true;

    settings = {
      # Model - uses Anthropic by default
      model = "anthropic/claude-sonnet-4-20250514";

      # Disable telemetry/sharing
      autoshare = false;
      autoupdate = false;
    };
  };
}
