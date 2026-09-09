{ config, lib, pkgs, ... }:

let
  configDir =
    if config.home.preferXdgDirectories then
      "${config.xdg.configHome}/codex"
    else
      "${config.home.homeDirectory}/.codex";
  python = pkgs.python3.withPackages (packages: [ packages.tomlkit ]);
  defaults = pkgs.writeText "codex-defaults.json" (builtins.toJSON config.programs.codex.settings);
  updateConfig = pkgs.writeText "update-codex-config.py" ''
    import json
    import os
    from pathlib import Path
    import sys
    import tempfile

    import tomlkit

    target = Path(sys.argv[1])
    defaults = json.loads(Path(sys.argv[2]).read_text())
    document = tomlkit.parse(target.read_text()) if target.exists() else tomlkit.document()

    def merge_settings(current, updates):
        for key, value in updates.items():
            if isinstance(value, dict):
                if key not in current or not hasattr(current[key], "items"):
                    current[key] = tomlkit.table()
                merge_settings(current[key], value)
            else:
                current[key] = value

    merge_settings(document, defaults)
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", dir=target.parent, delete=False) as temporary:
        temporary_path = Path(temporary.name)
        try:
            temporary.write(tomlkit.dumps(document))
            temporary.close()
            os.replace(temporary_path, target)
        finally:
            temporary_path.unlink(missing_ok=True)
  '';
in

{
  programs.codex = {
    enable = true;

    settings = {
      model = "gpt-6-astra";
      projects."/Users/emmanuel/.config/nix".trust_level = "trusted";

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

  home.file."${lib.removePrefix config.home.homeDirectory config.xdg.configHome}/codex/config.toml" =
    lib.mkIf config.home.preferXdgDirectories { enable = false; };
  home.file.".codex/config.toml" =
    lib.mkIf (!config.home.preferXdgDirectories) { enable = false; };

  home.activation.updateCodexConfig = lib.hm.dag.entryBetween
    [ "linkGeneration" ]
    [ "writeBoundary" ]
    ''
      run ${python}/bin/python ${updateConfig} ${lib.escapeShellArg "${configDir}/config.toml"} ${defaults}
    '';
}
