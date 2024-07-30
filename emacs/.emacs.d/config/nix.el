(use-package nix-mode
  :after eglot
  :init
  ;; Ensure `nil` is in your PATH.
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  :mode "\\.nix\\'")

(use-package direnv)
