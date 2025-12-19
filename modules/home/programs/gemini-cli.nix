{ ... }:

{
  programs.gemini-cli = {
    enable = true;

    # Default model (Gemini 3 series)
    defaultModel = "gemini-3-pro";
    # defaultModel = "gemini-3-flash";  # faster, cheaper

    settings = {
      vimMode = true;
      preferredEditor = "nvim";
      # autoAccept = true;
    };

    # Global context/instructions
    # context = {
    #   GEMINI = ''
    #     # Global Context
    #
    #     - Follow existing code patterns
    #     - Write clean, maintainable code
    #   '';
    # };

    # Custom commands
    # commands = {
    #   review = {
    #     prompt = "Review the current code changes and provide feedback.";
    #     description = "Review code changes";
    #   };
    # };
  };
}
