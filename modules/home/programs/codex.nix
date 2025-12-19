{ ... }:

{
  programs.codex = {
    enable = true;

    settings = {
      # Model configuration (GPT-5 Codex series)
      model = "gpt-5.2-codex";
      # model = "gpt-5.1-codex-max";   # long-horizon agentic tasks
      # model = "gpt-5.1-codex-mini";  # faster, cheaper

      # Uncomment for local Ollama
      # model_provider = "ollama";
      # model = "codellama:latest";
      # model_providers = {
      #   ollama = {
      #     name = "Ollama";
      #     baseURL = "http://localhost:11434/v1";
      #     envKey = "OLLAMA_API_KEY";
      #   };
      # };
    };

    # Custom instructions for the agent
    # custom-instructions = ''
    #   - Follow existing code patterns
    #   - Write tests for new functionality
    # '';
  };
}
