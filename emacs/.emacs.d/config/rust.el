(use-package rust-mode
  :defer t)
(use-package rustic
  :defer t)

(general-define-key
 :states 'normal
 :keymaps 'rust-mode-map
 :prefix ","
 "tt" '(rustic-cargo-current-test :which-key "Test Current")
 "ta" '(rustic-cargo-test :which-key "Test All")
 )

(add-hook 'rust-mode-hook #'lsp)
