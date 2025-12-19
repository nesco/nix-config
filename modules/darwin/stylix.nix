{ pkgs, ... }:

{
  stylix = {
    enable = true;

    # Disable auto-enabling targets (some are incompatible)
    autoEnable = false;

    # Theme selection - uncomment one:
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/one-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";

    # Required: a wallpaper image (Stylix uses it for color extraction fallback)
    # Using a simple generated image since we're setting colors explicitly
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/enkia/tokyo-night-wallpapers/main/1920x1080/traditional_tokyo_night_wallpaper.png";
      sha256 = "sha256-7WpDdlgUXCZ9xLIyQNMT2a4WkINxNQWjMUqFOqokwdw=";
    };

    # Font configuration
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        terminal = 14;
        applications = 13;
      };
    };

  };
}
