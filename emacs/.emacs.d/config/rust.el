
;; (use-package rust-mode :defer t)

(use-package rustic
  :defer t
  :config
  (setq rustic-lsp-client 'eglot)
  :general
  (nmap
   :prefix ","
   "t"  '(:ignore t :which-key "Tests")
   "tt" '(rustic-cargo-current-test :which-key "Test Current")
   "ta" '(rustic-cargo-test :which-key "Test All")
   "tl" '(rustic-cargo-test-rerun :which-key "Test Last")))

; (add-hook 'rust-mode-hook #'lsp)

;; Turn off flymake.
(add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
