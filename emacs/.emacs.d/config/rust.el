(use-package rust-mode)
(add-hook 'rust-mode-hook #'lsp)
(use-package rustic)

(general-define-key
 :states 'normal
 :keymaps 'rust-mode-map
 :prefix ","
 "tt" '(rustic-cargo-current-test :which-key "Test Current")
 "ta" '(rustic-cargo-test :which-key "Test All")
 "K"  '(lsp-ui-doc-glance)
 )
