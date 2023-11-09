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
  ))
