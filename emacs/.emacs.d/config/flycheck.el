(use-package flycheck
  :init (global-flycheck-mode))

(use-package flycheck-inline
  :after flycheck
  :init (global-flycheck-inline-mode))
