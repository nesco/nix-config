# Python environment - minimal setup
# Project dependencies should be managed with uv (per-project .venv)
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python interpreter only - uv manages packages per-project
    python314

    # Note: ruff, uv, pyright are installed system-wide in flake.nix
  ];

  home.sessionVariables = {
    # Disable pip's version warning (use uv instead)
    PIP_DISABLE_PIP_VERSION_CHECK = "1";
    # Use uv for pip operations
    PIP_REQUIRE_VIRTUALENV = "1";
  };

  # uv config
  home.file.".config/uv/uv.toml".text = ''
    # Default to using system Python from Nix
    python-preference = "system"

    # Create .venv in project directory
    # Run: uv venv && uv pip install -r requirements.txt
  '';
}
