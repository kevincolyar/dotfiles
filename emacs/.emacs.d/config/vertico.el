;; Vertico provides a performant and minimalistic vertical completion UI based on the default completion system. The main focus of Vertico is to provide a UI which behaves correctly under all circumstances.
;; https://github.com/minad/vertico
(use-package vertico
  :ensure t
  :diminish
  ;; NOT WORKING
  :bind (:map vertico-map
         ("C-k" . next-line-or-history-element)
         ("C-j" . previous-line-or-history-element))
  :config
  (vertico-mode))

;; Completion Style
(use-package orderless)

(use-package consult)
(use-package compat)
(use-package consult-dir)
(use-package consult-flycheck)

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package wgrep)
(use-package all-the-icons-completion)
(use-package vertico-posframe)
