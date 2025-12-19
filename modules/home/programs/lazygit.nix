{ ... }:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };

      # Tokyo Night theme
      gui.theme = {
        activeBorderColor = [
          "#7aa2f7"
          "bold"
        ];
        inactiveBorderColor = [ "#565f89" ];
        searchingActiveBorderColor = [
          "#7aa2f7"
          "bold"
        ];
        optionsTextColor = [ "#7aa2f7" ];
        selectedLineBgColor = [ "#292e42" ];
        selectedRangeBgColor = [ "#292e42" ];
        cherryPickedCommitBgColor = [ "#2ac3de" ];
        cherryPickedCommitFgColor = [ "#1a1b26" ];
        unstagedChangesColor = [ "#f7768e" ];
        defaultFgColor = [ "#c0caf5" ];
      };
    };
  };
}
