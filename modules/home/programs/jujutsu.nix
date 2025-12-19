{ config, ... }:

{
  programs.jujutsu = {
    enable = true;

    settings = {
      # User info - inherit from git config
      user = {
        name = config.programs.git.userName;
        email = config.programs.git.userEmail;
      };

      # UI settings
      ui = {
        # Use delta for diffs (same as git)
        pager = "delta";
        diff.format = "git";

        # Editor
        editor = "nvim";

        # Default command when running `jj`
        default-command = "log";
      };

      # Git settings
      git = {
        # Push bookmarks automatically
        auto-local-bookmark = true;
      };

      # Signing (same key as git)
      signing = {
        sign-all = true;
        backend = "ssh";
        key = "~/.ssh/id_ed25519.pub";
      };

      # Aliases
      aliases = {
        l = [
          "log"
          "-r"
          "(trunk()..@):: | (trunk()..@)-"
        ];
        d = [ "diff" ];
        s = [ "status" ];
        c = [ "commit" ];
        n = [ "new" ];
        e = [ "edit" ];
        a = [ "abandon" ];
        sq = [ "squash" ];
        sp = [ "split" ];
        desc = [ "describe" ];
      };

      # Revset aliases
      revset-aliases = {
        "trunk()" =
          "latest(remote_bookmarks(exact:main, exact:origin) | remote_bookmarks(exact:master, exact:origin))";
        "mine()" = "author(exact:\"${config.programs.git.userEmail}\")";
      };

      # Colors
      colors = {
        "diff removed" = {
          fg = "red";
        };
        "diff added" = {
          fg = "green";
        };
      };
    };
  };
}
