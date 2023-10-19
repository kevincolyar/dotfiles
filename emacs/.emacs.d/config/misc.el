(use-package undo-fu)

(use-package undo-fu-session
  :init (undo-fu-session-global-mode)
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

(use-package chatgpt-shell
  :ensure t
  :config
  ;; file ~/.authinfo has this line:
  ;;  machine api.openai.com password OPENAI_KEY
  (setq chatgpt-shell-openai-key
        (auth-source-pick-first-password :host "api.openai.com")))

(use-package helpful
  :after evil
  :init
  (setq evil-lookup-func #'helpful-at-point)
  ;; :custom
  ;; (counsel-describe-function-function #'helpful-callable)
  ;; (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap desribe-variable] . helpful-variable)
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
