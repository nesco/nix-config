{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;

    # Use emacs-plus on macOS for better integration
    package = pkgs.emacs;

    # Essential packages
    extraPackages =
      epkgs: with epkgs; [
        # === Completion & Navigation ===
        vertico # vertical completion UI
        orderless # fuzzy matching
        consult # search/navigation commands
        marginalia # annotations in minibuffer
        embark # contextual actions
        corfu # in-buffer completion
        cape # completion extensions

        # === Editing ===
        evil # vim keybindings
        evil-collection # evil for more modes
        which-key # keybinding hints
        undo-tree # visual undo

        # === UI ===
        doom-themes # themes (Stylix may override)
        doom-modeline # modeline
        all-the-icons # icons
        rainbow-delimiters # colored parens

        # === Git ===
        magit # git interface
        diff-hl # git diff in gutter

        # === Project & Files ===
        projectile # project management
        treemacs # file tree

        # === Languages ===
        # LSP
        lsp-mode
        lsp-ui
        lsp-treemacs

        # Tree-sitter
        treesit-grammars.with-all-grammars

        # Nix
        nix-mode

        # Web
        web-mode
        typescript-mode
        json-mode
        yaml-mode

        # Lisp
        paredit
        rainbow-delimiters

        # Markdown
        markdown-mode

        # Org (use built-in org, add extras)
        # org  # Use built-in - ELPA version has download issues
        org-roam # zettelkasten/notes
        org-bullets # pretty bullets
        org-appear # show markup on cursor
        org-modern # modern styling
        toc-org # auto TOC

        # === Tools ===
        vterm # terminal
        direnv # direnv integration
        envrc # direnv integration for buffers
        editorconfig # .editorconfig support
      ];

    # Basic config (works alongside Doom/Spacemacs if you use those)
    extraConfig = ''
      ;; Performance
      (setq gc-cons-threshold 100000000)
      (setq read-process-output-max (* 1024 1024))

      ;; UI
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (setq ring-bell-function 'ignore)
      (setq use-short-answers t)

      ;; Line numbers
      (global-display-line-numbers-mode 1)
      (setq display-line-numbers-type 'relative)

      ;; Evil mode (vim bindings)
      (setq evil-want-integration t)
      (setq evil-want-keybinding nil)
      (require 'evil)
      (evil-mode 1)
      (evil-collection-init)

      ;; Which-key
      (require 'which-key)
      (which-key-mode)

      ;; Completion
      (require 'vertico)
      (vertico-mode)
      (require 'orderless)
      (setq completion-styles '(orderless basic))
      (require 'marginalia)
      (marginalia-mode)
      (require 'corfu)
      (global-corfu-mode)

      ;; Theme
      (require 'doom-themes)
      (load-theme 'doom-tokyo-night t)
      (require 'doom-modeline)
      (doom-modeline-mode 1)

      ;; Magit
      (require 'magit)

      ;; LSP
      (require 'lsp-mode)
      (setq lsp-keymap-prefix "C-c l")
      (add-hook 'prog-mode-hook #'lsp-deferred)

      ;; Direnv
      (require 'envrc)
      (envrc-global-mode)

      ;; Org-mode
      (require 'org)
      (setq org-directory "~/org")
      (setq org-agenda-files '("~/org"))
      (setq org-default-notes-file "~/org/inbox.org")
      (setq org-return-follows-link t)
      (setq org-hide-emphasis-markers t)
      (setq org-startup-indented t)
      (setq org-startup-folded 'content)
      (setq org-log-done 'time)
      (setq org-todo-keywords
            '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

      ;; Org modern (pretty UI)
      (require 'org-modern)
      (global-org-modern-mode)

      ;; Org-roam (zettelkasten)
      (require 'org-roam)
      (setq org-roam-directory "~/org/roam")
      (org-roam-db-autosync-mode)

      ;; Org keybindings
      (global-set-key (kbd "C-c a") 'org-agenda)
      (global-set-key (kbd "C-c c") 'org-capture)
      (global-set-key (kbd "C-c n f") 'org-roam-node-find)
      (global-set-key (kbd "C-c n i") 'org-roam-node-insert)

      ;; Backup files
      (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
      (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t)))
    '';
  };
}
