;;; -*- lexical-binding: t; -*-
;; Eglot
;; ------------------------------------------------------------------------------
;; https://joaotavora.github.io/eglot/#Using-Eglot

(setq read-process-output-max (* 4 1024 1024)) ; 4MB

(use-package eglot
  :straight nil
  :ensure nil
  :defer t
  ;; Emacs 31: `treesit-enabled-modes' (config/tree-sitter.el) puts every
  ;; enabled pair from `treesit-major-mode-remap-alist' into
  ;; `major-mode-remap-alist', so python-mode/ruby-mode/js-mode/css-mode/
  ;; c-mode/c++-mode/csharp-mode/go-mode are never the selected major mode
  ;; and their hooks never run -- only the -ts-mode hook does. The fake
  ;; parents from `derived-mode-add-parents' make `provided-mode-derived-p'
  ;; report t (so `eglot-server-programs' keys still match), but
  ;; `run-mode-hooks' skips them. Non-ts entries below are the languages
  ;; with no enabled ts mode: rustic owns .rs, nix-mode has no ts variant.
  ;; mhtml-ts-mode also runs html-ts-mode-hook and html-mode-hook, so one
  ;; entry covers .html.
  :hook ((
         python-ts-mode
         rust-mode
         rustic-mode
         ruby-ts-mode
         js-ts-mode
         mhtml-ts-mode
         css-ts-mode
         typescript-ts-mode
         tsx-ts-mode
         json-ts-mode
         go-ts-mode
         yaml-ts-mode
         nix-mode
         c-ts-mode
         c++-ts-mode
         csharp-ts-mode
         ) . eglot-ensure)

  ;; `eglot-code-action-indications' defaults to `(eldoc-hint left-fringe
  ;; margin)' (eglot.el:612). The `eldoc-hint' member makes
  ;; `eglot--update-hints'-style suggestions arrive through
  ;; `eldoc-documentation-functions', and with
  ;; `eldoc-box-hover-at-point-mode' (config/eldoc.el) any eldoc output pops
  ;; the childframe -- so merely sitting on a line with an available action
  ;; opened a box saying so. Keep only the passive indicators; SPC c a
  ;; (`eglot-code-actions', config/key-mapping.el) is the entry point.
  :custom
  (eglot-code-action-indications '(left-fringe margin))

  :config
  (defun my/eglot-set-server (modes command)
    "Set eglot server COMMAND for MODES, replacing any existing entry."
    (setf (alist-get modes eglot-server-programs nil nil #'equal)
          command))
  
  (defun my/eglot-configure-servers (config-list)
    "Configure multiple eglot servers from CONFIG-LIST. Each entry should be (MODES . COMMAND)."
    (dolist (config config-list)
      (my/eglot-set-server (car config) (cdr config))))
  
  ;; Configure all servers at once
  (my/eglot-configure-servers
   '(((ruby-mode ruby-ts-mode) . ("ruby-lsp"))
     ((python-mode python-ts-mode) . ("ty" "server"))
     ;; SQL is linted by sqruff through flycheck (config/flycheck.el), not by
     ;; an LSP server: every SQL server packaged in nixpkgs is PostgreSQL-only
     ;; (squawk) or ships no diagnostics (sqls), and `sqruff lsp' publishes
     ;; layout rules only -- it never reports parse errors.
     ;; ((python-mode python-ts-mode) . ("pyrefly" "lsp"))
     ;; ((python-mode python-ts-mode) . ("ruff"))
     ;; ((html-mode html-ts-mode mhtml-mode) . ("vscode-html-language-server" "--stdio"))
     ;; ((css-mode css-ts-mode) . ("vscode-css-language-server" "--stdio"))
     ;; ((markdown-mode) . ("vscode-markdown-language-server" "--stdio"))
     ))

  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'eglot-completion-at-point
                       #'tempel-expand
                       #'cape-file))))

  (add-hook 'eglot-managed-mode-hook #'my/eglot-capf)

  )

  ;; (with-eval-after-load 'eglot
  ;;   (add-to-list 'eglot-server-programs
  ;;                '((ruby-mode ruby-ts-mode) . "ruby-lsp")
  ;;                '((python-mode python-ts-mode) . ("pyrefly" "lsp"))
  ;;                '((html-mode html-ts-mode) . ("vscode-html-language-server" "--stdio"))
  ;;                ;; '((css-mode css-ts-mode) . ("vscode-css-language-server" "--stdio"))
  ;;                ;; '(markdown-mode . ("vscode-markdown-language-server" "--stdio"))
  ;;                )))

;; Install Instructions:
;; https://github.com/jdtsmith/eglot-booster
;; M-x package-vc-install https://github.com/jdtsmith/eglot-booster
;; (use-package eglot-booster
;; 	:after eglot
;; 	:config	(eglot-booster-mode))
