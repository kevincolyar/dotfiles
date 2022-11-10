;; Dumb Jump is an Emacs "jump to definition" package with support for 50+ programming languages that favors "just working". 
;; https://github.com/jacktasia/dumb-jump
;; Usage: SPC c d - Jump to code definition

;; (use-package dumb-jump
;;   :config
;;   (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
;;   :init
;;   (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(use-package dumb-jump
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  :commands dumb-jump-result-follow
  :config
  (setq
   dumb-jump-prefer-searcher 'rg
   dumb-jump-aggressive nil
   dumb-jump-selector 'vertico)
  (add-hook 'dumb-jump-after-jump-hook #'better-jumper-set-jump))
