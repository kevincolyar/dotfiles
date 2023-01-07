;; LSP
;; ------------------------------------------------------------------------------
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 (rust-mode . lsp)
	 (python-mode . lsp)
	 (typescript-mode . lsp)
	 ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deffered))


(add-hook 'lsp-mode-hook '(lsp-describe-thing-at-point))

;; optionally
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :general
  (nmap
    :keymaps 'lsp-ui-mode-map
    "" #'lsp-describe-thing-at-point)
  :custom (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(setq
 lsp-ui-doc-enable t
 lsp-ui-doc-position 'bottom
 lsp-ui-doc-show-with-cursor nil
 lsp-ui-doc-show-with-mouse nil

 lsp-eldoc-render-all t ;; Show inline type hints

 lsp-ui-peek-enable nil
 lsp-ui-sideline-enable t
 lsp-ui-imenu-enable t
 lsp-ui-sideline-show-code-actions t
 lsp-ui-sideline-show-diagnostics nil ;; Don't show errors, let flycheck-inline display them

 lsp-headerline-breadcrumb-enable nil

 lsp-rust-analyzer-server-display-inlay-hints t

 )
