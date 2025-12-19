{ ... }:

{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      search_mode = "fuzzy";
      style = "compact";

      # Tokyo Night colors
      colors = {
        title = {
          fg = "#7aa2f7";
        };
        prompt = {
          fg = "#7dcfff";
        };
        selected_line_bg = "#292e42";
        filter_hint = {
          fg = "#565f89";
        };
        default = {
          fg = "#c0caf5";
        };
      };
    };
  };
}
