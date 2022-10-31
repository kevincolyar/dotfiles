(use-package undo-fu)

(use-package undo-fu-session
  :init (global-undo-fu-session-mode)
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magic-display-buffer-function #'magic-display-buffer-same-window-except-diff-v1))

(use-package git-gutter
  :defer t
  :init
  (global-git-gutter-mode))

(use-package xclip
  :init
  (xclip-mode 1))

(use-package dumb-jump
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq xref-show-definitions-function #'xref-show-definitions-completing-read)
  :commands dumb-jump-result-follow
  :config
  (setq
   dumb-jump-prefer-searcher 'rg
   dumb-jump-aggressive nil
   dumb-jump-selector 'ivy)
  (add-hook 'dumb-jump-after-jump-hook #'better-jumper-set-jump))

(use-package helpful
  :after evil
  :init
  (setq evil-lookup-func #'helpful-at-point)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap desribe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
	   (format "%.2f seconds"
		   (float-time
		    (time-subtract after-init-time before-init-time)))
	   gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(use-package beacon
  :init (beacon-mode 1))

(use-package editorconfig)

;; Manage garbage collection
(use-package gcmh
  :demand
  :config
  (gcmh-mode 1))
