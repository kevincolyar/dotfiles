;; https://github.com/jacktasia/dumb-jump

(use-package dumb-jump
  :config
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))
