{ ... }:

{
  programs.git = {
    enable = true;

    # Global gitignore
    ignores = [
      ".DS_Store"
      "node_modules/"
      ".direnv/"
      "*.swp"
      "*~"
    ];

    # Git settings (replaces extraConfig)
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      rerere.enabled = true;
      column.ui = "auto";
      branch.sort = "-committerdate";

      # SSH commit signing
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };

    # Uncomment to enable Git LFS
    # lfs.enable = true;
  };

  # Delta pager (moved from programs.git.delta)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = false;
    };
  };
}
