{ pkgs, ... }:

{
  programs.vim = {
    enable = true;

    # Sensible defaults
    settings = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Tabs/spaces
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;

      # Search
      ignorecase = true;
      smartcase = true;

      # History
      history = 1000;

      # Undo persistence
      undofile = true;
      undodir = [ "~/.vim/undo" ];

      # Backup/swap directories
      backupdir = [ "~/.vim/backup" ];
      directory = [ "~/.vim/swap" ];

      # Mouse
      mouse = "a";

      # Theme
      background = "dark";

      # Hidden buffers
      hidden = true;
    };

    extraConfig = ''
      " No compatible mode
      set nocompatible

      " Syntax and filetype
      syntax on
      filetype plugin indent on

      " Better splitting
      set splitbelow splitright

      " Show matching brackets
      set showmatch

      " Scrolloff
      set scrolloff=8

      " No error bells
      set noerrorbells visualbell t_vb=

      " Faster updates
      set updatetime=300

      " Leader key
      let mapleader = " "

      " Quick save/quit
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>

      " Clear search highlight
      nnoremap <leader>/ :nohlsearch<CR>

      " Better window navigation
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
    '';

    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-surround
      vim-commentary
      vim-repeat
    ];
  };
}
