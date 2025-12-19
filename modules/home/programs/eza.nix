{ ... }:

{
  programs.eza = {
    enable = true;

    # Icons
    icons = "auto";

    # Colors
    colors = "auto";

    # Git integration (show git status)
    git = true;

    # Extra options applied to all eza calls
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];

    # Nushell has native structured ls/ps/etc - keep those
    enableNushellIntegration = false;

    # Theme customization (optional - Stylix handles colors)
    # theme = { };
  };
}
