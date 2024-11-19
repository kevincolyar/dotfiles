(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-inline
  :after flycheck
  :init (global-flycheck-inline-mode))

(use-package flycheck-popup-tip)

(use-package flycheck-eglot
  :after (flycheck eglot)
  :custom (flycheck-eglot-exclusive nil)
  :config
  (global-flycheck-eglot-mode 1))
