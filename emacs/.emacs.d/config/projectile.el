(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode 1)
  (setq counsel-projectile-rg-initial-input '(ivy-thing-at-point)))
