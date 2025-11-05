;; Eglot
;; ------------------------------------------------------------------------------
;; https://joaotavora.github.io/eglot/#Using-Eglot


(use-package eglot
  :defer t
  :hook ((
         python-mode
         python-ts-mode
         rust-mode
         rustic-mode
         ruby-mode
         ruby-ts-mode
         js-mode
         js-ts-mode
         html-mode
         html-ts-mode
         mhtml-mode
         css-mode
         css-ts-mode
         markdown-mode
         go-mode
         nix-mode
         c-mode
         c-ts-mode
         c++-mode
         c++-ts-mode
         ) . eglot-ensure)


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
     ((python-mode python-ts-mode) . ("pyrefly" "lsp"))
     ;; ((python-mode python-ts-mode) . ("ruff"))
     ((html-mode html-ts-mode mhtml-mode) . ("vscode-html-language-server" "--stdio"))
     ((css-mode css-ts-mode) . ("vscode-css-language-server" "--stdio"))
     ((markdown-mode) . ("vscode-markdown-language-server" "--stdio")))))

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
