;; https://github.com/minad/corfu

(use-package corfu
  :custom
  (corfu-auto t)
  :hook ((prog-mode . corfu-mode)
         (org-mode . corfu-mode))
  :bind
  (:map corfu-map
        ("C-j" . corfu-next)
        ("C-k" . corfu-previous))
  :general
  (evil-insert-state-map "C-k" nil)
  :init
:init
  (setq corfu-auto nil)                 ;; Enable auto completion
  (setq corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (setq corfu-min-width 80)
  (setq corfu-max-width corfu-min-width)       ; Always have the same width
   (setq corfu-preselect-first t)   
   (corfu-mode 1))
