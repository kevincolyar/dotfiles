;;; -*- lexical-binding: t; -*-
;; Built-in `typescript-ts-mode' / `tsx-ts-mode' (Emacs 29+). The previous
;; `typescript-mode' + `tree-sitter-major-mode-language-alist' path never
;; ran: config/tree-sitter.el no longer loads the elisp `tree-sitter' package,
;; so `:after tree-sitter' never fired.
;;
;; File associations and remaps come from `treesit-enabled-modes'
;; (config/tree-sitter.el). Eglot hooks are in config/eglot.el.
