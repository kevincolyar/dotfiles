
;; (use-package rust-mode :defer t)

(use-package rustic
  :defer t
  :config
  (setq rustic-lsp-client 'eglot)
  :general
  (nmap
   :prefix ","
   "cb" '(rustic-cargo-build :which-key "Cargo Build")
   "t"  '(:ignore t :which-key "Tests")
   "tt" '(rustic-cargo-current-test :which-key "Test Current")
   "ta" '(rustic-cargo-test :which-key "Test All")
   "tl" '(rustic-cargo-test-rerun :which-key "Test Last")))

;; TODO - Waiting for treesitter mode (rust-ts-mode) to be parent mode to rustic-mode
;; https://github.com/brotzeit/rustic/issues/475

; (add-hook 'rust-mode-hook #'lsp)

;; Turn off flymake.
;; (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
