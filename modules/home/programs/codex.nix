{ ... }:

{
  programs.codex = {
    enable = true;

    settings = {
      # Model configuration (GPT-5 Codex series)
      model = "gpt-5.5";

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
