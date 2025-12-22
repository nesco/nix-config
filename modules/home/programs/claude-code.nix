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
          # === File operations ===
          "Read"
          "Edit"
          "Write"
          "Glob"
          "Grep"

          # === Git (non-mutating) ===
          "Bash(git diff:*)"
          "Bash(git status:*)"
          "Bash(git log:*)"
          "Bash(git show:*)"
          "Bash(git branch:*)"
          "Bash(git remote:*)"
          "Bash(git stash list:*)"
          "Bash(git tag:*)"
          "Bash(git rev-parse:*)"
          "Bash(git ls-files:*)"
          "Bash(git blame:*)"
          "Bash(git shortlog:*)"
          "Bash(git describe:*)"
          "Bash(git config --get:*)"
          "Bash(git config --list:*)"

          # === Git power tools ===
          "Bash(gh:*)"
          "Bash(glab:*)"
          "Bash(tig:*)"
          "Bash(delta:*)"
          "Bash(difft:*)"

          # === Nix ===
          "Bash(nix:*)"
          "Bash(nix-shell:*)"
          "Bash(nix-build:*)"
          "Bash(nix-env:*)"
          "Bash(nixfmt:*)"

          # === Python ===
          "Bash(uv:*)"
          "Bash(uvx:*)"
          "Bash(python:*)"
          "Bash(python3:*)"
          "Bash(pip:*)"
          "Bash(pytest:*)"
          "Bash(ruff:*)"
          "Bash(mypy:*)"
          "Bash(black:*)"
          "Bash(isort:*)"
          "Bash(pyright:*)"
          "Bash(poetry:*)"
          "Bash(pdm:*)"
          "Bash(hatch:*)"

          # === JavaScript/TypeScript ===
          "Bash(node:*)"
          "Bash(npm:*)"
          "Bash(npx:*)"
          "Bash(pnpm:*)"
          "Bash(bun:*)"
          "Bash(bunx:*)"
          "Bash(deno:*)"
          "Bash(yarn:*)"
          "Bash(tsc:*)"
          "Bash(eslint:*)"
          "Bash(prettier:*)"
          "Bash(vitest:*)"
          "Bash(jest:*)"
          "Bash(tsx:*)"
          "Bash(esbuild:*)"
          "Bash(vite:*)"
          "Bash(turbo:*)"
          "Bash(biome:*)"

          # === Rust ===
          "Bash(cargo:*)"
          "Bash(rustc:*)"
          "Bash(rustfmt:*)"
          "Bash(clippy:*)"
          "Bash(rustup:*)"

          # === Go ===
          "Bash(go:*)"
          "Bash(gopls:*)"
          "Bash(golangci-lint:*)"

          # === Haskell ===
          "Bash(ghc:*)"
          "Bash(ghci:*)"
          "Bash(cabal:*)"
          "Bash(stack:*)"
          "Bash(hls:*)"

          # === Elixir/Erlang ===
          "Bash(elixir:*)"
          "Bash(mix:*)"
          "Bash(iex:*)"
          "Bash(erl:*)"
          "Bash(rebar3:*)"

          # === Ruby ===
          "Bash(ruby:*)"
          "Bash(gem:*)"
          "Bash(bundle:*)"
          "Bash(bundler:*)"
          "Bash(rake:*)"
          "Bash(rails:*)"
          "Bash(irb:*)"

          # === JVM (Java/Kotlin/Scala) ===
          "Bash(java:*)"
          "Bash(javac:*)"
          "Bash(gradle:*)"
          "Bash(mvn:*)"
          "Bash(kotlin:*)"
          "Bash(kotlinc:*)"
          "Bash(scala:*)"
          "Bash(sbt:*)"

          # === .NET ===
          "Bash(dotnet:*)"

          # === Zig ===
          "Bash(zig:*)"

          # === OCaml ===
          "Bash(ocaml:*)"
          "Bash(opam:*)"
          "Bash(dune:*)"
          "Bash(ocamlfind:*)"

          # === Gleam ===
          "Bash(gleam:*)"

          # === Version managers ===
          "Bash(mise:*)"
          "Bash(asdf:*)"
          "Bash(fnm:*)"
          "Bash(rtx:*)"

          # === Containers (read-only) ===
          "Bash(docker ps:*)"
          "Bash(docker images:*)"
          "Bash(docker logs:*)"
          "Bash(docker inspect:*)"
          "Bash(docker stats:*)"
          "Bash(docker top:*)"
          "Bash(docker version:*)"
          "Bash(docker info:*)"
          "Bash(docker compose ps:*)"
          "Bash(docker compose logs:*)"
          "Bash(docker compose config:*)"
          "Bash(lazydocker:*)"
          "Bash(kubectl get:*)"
          "Bash(kubectl describe:*)"
          "Bash(kubectl logs:*)"
          "Bash(kubectl explain:*)"
          "Bash(kubectl api-resources:*)"
          "Bash(kubectl config view:*)"
          "Bash(kubectl config current-context:*)"
          "Bash(k9s:*)"
          "Bash(helm list:*)"
          "Bash(helm status:*)"
          "Bash(helm show:*)"
          "Bash(helm template:*)"

          # === Code analysis & AST ===
          "Bash(ast-grep:*)"
          "Bash(semgrep:*)"
          "Bash(tree-sitter:*)"
          "Bash(tokei:*)"
          "Bash(scc:*)"
          "Bash(cloc:*)"

          # === Data processing ===
          "Bash(jq:*)"
          "Bash(yq:*)"
          "Bash(fx:*)"
          "Bash(dasel:*)"
          "Bash(miller:*)"
          "Bash(mlr:*)"
          "Bash(xsv:*)"
          "Bash(csvkit:*)"
          "Bash(sqlite3:*)"
          "Bash(psql:*)"

          # === HTTP/API ===
          "Bash(curl:*)"
          "Bash(wget:*)"
          "Bash(xh:*)"
          "Bash(http:*)"
          "Bash(httpie:*)"
          "Bash(grpcurl:*)"

          # === Build & task runners ===
          "Bash(make:*)"
          "Bash(just:*)"
          "Bash(task:*)"
          "Bash(cmake:*)"
          "Bash(ninja:*)"
          "Bash(meson:*)"
          "Bash(bazel:*)"

          # === File watchers ===
          "Bash(watchexec:*)"
          "Bash(entr:*)"
          "Bash(watchman:*)"
          "Bash(fswatch:*)"

          # === System info & exploration ===
          "Bash(dust:*)"
          "Bash(duf:*)"
          "Bash(ncdu:*)"
          "Bash(procs:*)"
          "Bash(btm:*)"
          "Bash(htop:*)"
          "Bash(btop:*)"
          "Bash(hyperfine:*)"

          # === Documentation ===
          "Bash(tldr:*)"
          "Bash(man:*)"
          "Bash(cheat:*)"
          "Bash(navi:*)"

          # === Modern CLI tools ===
          "Bash(fd:*)"
          "Bash(rg:*)"
          "Bash(fzf:*)"
          "Bash(bat:*)"
          "Bash(eza:*)"
          "Bash(sd:*)"
          "Bash(choose:*)"
          "Bash(glow:*)"
          "Bash(zoxide:*)"

          # === Unix essentials ===
          "Bash(ls:*)"
          "Bash(cat:*)"
          "Bash(head:*)"
          "Bash(tail:*)"
          "Bash(wc:*)"
          "Bash(sort:*)"
          "Bash(uniq:*)"
          "Bash(grep:*)"
          "Bash(find:*)"
          "Bash(tree:*)"
          "Bash(which:*)"
          "Bash(whereis:*)"
          "Bash(type:*)"
          "Bash(env:*)"
          "Bash(echo:*)"
          "Bash(printf:*)"
          "Bash(pwd:*)"
          "Bash(realpath:*)"
          "Bash(dirname:*)"
          "Bash(basename:*)"
          "Bash(xargs:*)"
          "Bash(tee:*)"
          "Bash(tr:*)"
          "Bash(cut:*)"
          "Bash(awk:*)"
          "Bash(sed:*)"
          "Bash(diff:*)"
          "Bash(comm:*)"
          "Bash(paste:*)"
          "Bash(column:*)"
          "Bash(file:*)"
          "Bash(stat:*)"
          "Bash(md5:*)"
          "Bash(shasum:*)"
          "Bash(sha256sum:*)"
          "Bash(base64:*)"
          "Bash(date:*)"
          "Bash(cal:*)"
          "Bash(bc:*)"
          "Bash(expr:*)"
          "Bash(id:*)"
          "Bash(whoami:*)"
          "Bash(groups:*)"
          "Bash(chmod:*)"
          "Bash(chown:*)"
          "Bash(mkdir:*)"
          "Bash(rmdir:*)"
          "Bash(cp:*)"
          "Bash(mv:*)"
          "Bash(ln:*)"
          "Bash(touch:*)"
          "Bash(test:*)"
          "Bash([:*)"

          # === Compression ===
          "Bash(tar:*)"
          "Bash(zip:*)"
          "Bash(unzip:*)"
          "Bash(gzip:*)"
          "Bash(gunzip:*)"
          "Bash(zstd:*)"
          "Bash(xz:*)"
          "Bash(7z:*)"

          # === Network (read-only) ===
          "Bash(ping:*)"
          "Bash(dig:*)"
          "Bash(nslookup:*)"
          "Bash(host:*)"
          "Bash(whois:*)"
          "Bash(netstat:*)"
          "Bash(ss:*)"
          "Bash(lsof:*)"

          # === Context7 MCP tools ===
          "mcp__context7__resolve-library-id"
          "mcp__context7__get-library-docs"

          # === Secrets management ===
          "Bash(sops:*)"
          "Bash(git-crypt:*)"
          "Bash(gpg:*)"
          "Bash(gpg2:*)"
          "Bash(age:*)"
          "Bash(age-keygen:*)"
          "Bash(ssh-to-age:*)"

          # === Web fetching ===
          "WebFetch"
          "WebSearch"
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

    # MCP servers
    # Note: CONTEXT7_API_KEY must be set in ~/.secrets.env
    mcpServers = {
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp"
        ];
        # CONTEXT7_API_KEY set via shell sessionVariables from sops secret
      };
    };
  };
}
