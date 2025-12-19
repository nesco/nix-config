{ pkgs, ... }:

{
  programs.bat = {
    enable = true;

    config = {
      # Pager
      pager = "less -FR";

      # Style (what to show)
      style = "numbers,changes,header";

      # Line wrapping
      wrap = "auto";

      # Tab width
      tabs = "2";

      # Map syntaxes for specific files
      map-syntax = [
        "*.conf:INI"
        "*.envrc:Bash"
        ".gitignore:Git Ignore"
        "*.nix:Nix"
      ];

      # Theme
      theme = "tokyonight_night";
    };

    # Extra bat utilities
    extraPackages = with pkgs.bat-extras; [
      batdiff # diff with bat
      batman # man pages with bat
      batgrep # grep with bat
      batwatch # watch files with bat
    ];
  };
}
