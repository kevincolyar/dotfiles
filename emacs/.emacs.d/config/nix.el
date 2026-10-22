;;; -*- lexical-binding: t; -*-
;; The server entry lives with the others in config/eglot.el. No `:after
;; eglot': that deferred `:mode' until eglot happened to load.
(use-package nix-mode
  :mode "\\.nix\\'")

(use-package direnv
  :config (direnv-mode))
