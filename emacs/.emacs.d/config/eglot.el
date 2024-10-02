;; Eglot
;; ------------------------------------------------------------------------------
;; https://joaotavora.github.io/eglot/#Using-Eglot


(use-package eglot
  :defer t
  :hook (
         (python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (rustic-mode . eglot-ensure)
         (ruby-mode . eglot-ensure)
         (ruby-ts-mode . eglot-ensure)
         (js-ts-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         )
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '((ruby-mode ruby-ts-mode) "ruby-lsp"))))

;; Install Instructions:
;; https://github.com/jdtsmith/eglot-booster
;; M-x package-vc-install https://github.com/jdtsmith/eglot-booster
;; (use-package eglot-booster
;; 	:after eglot
;; 	:config	(eglot-booster-mode))
