;; Tree-sitter
;; ------------------------------------------------------------------------------
(use-package tree-sitter-langs
  :after tree-sitter)

(use-package tree-sitter
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))
;;:init (global-tree-sitter-mode))

(use-package evil-commentary
  :init (evil-commentary-mode))

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
  ;; :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom (lsp-ui-doc-position 'bottom))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

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

 lsp-headerline-breadcrumb-enable nil

 lsp-rust-analyzer-server-display-inlay-hints t
 )

(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-inline
  :after flycheck
  :init (global-flycheck-inline-mode))

;; Company / Completion
;; (use-package company
;;   :config
;;   (setq company-minimum-prefix-length 1
;;       company-idle-delay 0.0) ;; default is 0.2
;;   :init (global-company-mode))

(use-package company
  :custom
  (company-idle-delay 0.1) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
	      ("C-j". company-select-next)
	      ("C-k". company-select-previous)
	      ("C-h". company-select-first)
	      ("C-l". company-select-last)))

;; Use TAB to expand snippet
(use-package yasnippet
  ;; :config
  ;; (yas-global-mode 1)
  ;; :commands yas-minor-mode
  :hook (
	 (rust-mode . yas-minor-mode)
	 (python-mode . yas-minor-mode)
	 (javascript-mode . yas-minor-mode)
	 (ruby-mode . yas-minor-mode)
         (lsp-mode . yas-minor-mode)
         ))

(use-package yasnippet-snippets
  :after yasnippet)

;; Code folding
(use-package origami
  :init (global-origami-mode))
