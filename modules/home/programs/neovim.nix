{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false; # keep vim as vim

    # Packages available to neovim (LSPs, formatters, linters, tools)
    extraPackages = with pkgs; [
      # === LSP Servers ===
      # Lua
      lua-language-server

      # Nix
      nil
      nixd

      # JavaScript/TypeScript
      bun # Fast JS/TS runtime & package manager
      nodePackages.typescript-language-server
      vscode-langservers-extracted # HTML, CSS, JSON, ESLint
      nodePackages.svelte-language-server
      tailwindcss-language-server
      emmet-language-server

      # Go
      gopls
      golangci-lint-langserver

      # Python (Astral tools)
      uv # Fast package manager
      ruff # Linter/formatter with LSP (ruff server)
      ty # Type checker
      pyright

      # Rust
      rust-analyzer

      # C/C++
      clang-tools # clangd
      cmake-language-server

      # Java
      jdt-language-server

      # PHP
      phpactor
      # nodePackages.intelephense  # alternative

      # OCaml
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat

      # Haskell
      haskell-language-server

      # Elixir
      elixir-ls

      # Markdown
      marksman

      # YAML/TOML
      yaml-language-server
      taplo # TOML

      # Docker
      dockerfile-language-server
      docker-compose-language-service

      # Bash/Shell
      nodePackages.bash-language-server
      shellcheck

      # SQL
      sqls

      # === Formatters ===
      # Lua
      stylua

      # Nix
      nixfmt-rfc-style
      # alejandra  # alternative

      # JavaScript/TypeScript/Web
      prettierd
      nodePackages.prettier

      # Go
      gofumpt
      goimports-reviser
      golines

      # Python - ruff handles formatting (black/isort compatible)

      # C/C++
      # clang-tools provides clang-format

      # Shell
      shfmt

      # SQL
      sqlfluff

      # === Linters ===
      # Go
      golangci-lint

      # Python
      # ruff handles linting too

      # Shell
      # shellcheck listed above

      # Markdown
      markdownlint-cli2

      # === Tools ===
      # Required by various plugins
      ripgrep
      fd
      tree-sitter

      # Git (for fugitive, gitsigns, etc.)
      git

      # Node (for various tools)
      nodejs

      # Make (for building)
      gnumake
    ];

    # Python provider packages (for plugins needing Python)
    withPython3 = true;
    extraPython3Packages =
      ps: with ps; [
        pynvim
      ];

    # Node provider (for coc.nvim, copilot, etc.)
    withNodeJs = true;
  };
}
