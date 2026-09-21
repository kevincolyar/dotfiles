;;; -*- lexical-binding: t; -*-
;; Built-in `typescript-ts-mode' / `tsx-ts-mode' (Emacs 29+). The previous
;; `typescript-mode' + `tree-sitter-major-mode-language-alist' path never
;; ran: config/tree-sitter.el no longer loads the elisp `tree-sitter' package,
;; so `:after tree-sitter' never fired.
;;
;; File associations and remaps come from `treesit-enabled-modes'
;; (config/tree-sitter.el). Eglot hooks are in config/eglot.el.

;; Emacs 31's stock `auto-mode-alist' (files.el) only maps "\\.js[mx]?\\'"
;; to `javascript-mode' -- .mjs (ESM) and .cjs (CommonJS) match nothing and
;; open in `fundamental-mode', so neither tree-sitter fontification nor the
;; `js-ts-mode' eglot hook (config/eglot.el) ever runs. Map them to
;; `javascript-mode' (the `js-mode' alias files.el uses for .js) rather than
;; to `js-ts-mode' directly: `treesit-enabled-modes' then supplies the
;; (javascript-mode . js-ts-mode) remap, and the same entry degrades to
;; `js-mode' if the javascript grammar is unavailable.
(add-to-list 'auto-mode-alist '("\\.[cm]js\\'" . javascript-mode))
