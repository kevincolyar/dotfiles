;;; -*- lexical-binding: t; -*-
;; Emacs 31 remaps visiting a language to its *-ts-mode. Must be `setopt':
;; `treesit-enabled-modes' has a :set that writes `major-mode-remap-alist'.
;; `setq` would leave remaps unset.
;;
;; rust-ts-mode is omitted: rustic owns .rs via `rust-mode-treesitter-derive'
;; (config/rust.el). php-ts-mode omitted: langs.el maps .php to web-mode.
;; markdown-ts-mode is not in the custom type; langs.el maps .md/.mdx/.markdown.
;; Emacs 31's type uses `mhtml-ts-mode', not `html-ts-mode'.
(setopt treesit-auto-install-grammar 'always)
(setopt treesit-enabled-modes
        '(python-ts-mode
          ruby-ts-mode
          js-ts-mode
          typescript-ts-mode
          tsx-ts-mode
          mhtml-ts-mode
          css-ts-mode
          json-ts-mode
          yaml-ts-mode
          toml-ts-mode
          dockerfile-ts-mode
          go-ts-mode
          bash-ts-mode
          lua-ts-mode
          c-ts-mode
          c++-ts-mode))
