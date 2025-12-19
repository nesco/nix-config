{ ... }:

{
  programs.claude-code = {
    enable = true;

    settings = {
      # Theme
      theme = "dark";

      # Default permissions
      permissions = {
        allow = [
          "Bash(git diff:*)"
          "Bash(git status:*)"
          "Bash(git log:*)"
          "Bash(nix flake check:*)"
          "Bash(nix fmt:*)"
          "Read"
          "Edit"
          "Write"
          "Glob"
          "Grep"
        ];
        deny = [
          "Read(./.env)"
          "Read(./secrets/**)"
          "Read(**/*.pem)"
          "Read(**/*.key)"
        ];
      };

      # Disable co-authored-by in commits (optional)
      # includeCoAuthoredBy = false;
    };

    # Custom commands (optional examples)
    # commands = {
    #   review = ''
    #     ---
    #     description: Review current changes
    #     allowed-tools: Bash(git diff:*), Read
    #     ---
    #     Review the current git diff and provide feedback.
    #   '';
    # };

    # MCP servers are configured via mcpServers if needed
    # mcpServers = {
    #   filesystem = {
    #     type = "stdio";
    #     command = "npx";
    #     args = [ "-y" "@modelcontextprotocol/server-filesystem" "/tmp" ];
    #   };
    # };
  };
}
