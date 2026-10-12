;;; -*- lexical-binding: t; -*-
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
  :config
  (global-git-gutter-mode +1)
  :custom
  (git-gutter:linum-setup)
  (git-gutter:update-all-windows)
  (git-gutter:update-interval 2))

;; xclip shells out to pbcopy/xclip on the host Emacs runs on. Over SSH that
;; is the remote machine's clipboard, not the client's: kills land somewhere
;; invisible and `p' pastes stale remote text. clipetty (config/clipetty.el)
;; already carries kills to the client terminal via OSC 52, so only use xclip
;; locally. `my/ssh-session-p' comes from config/theme.el, loaded earlier.
(use-package xclip
  :if (not (my/ssh-session-p))
  :init
  (xclip-mode 1))

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

(use-package editorconfig
  :straight nil
  :ensure nil
  :config
  (editorconfig-mode 1))

;; Manage garbage collection
;; (use-package gcmh
;;   :config
;;   (gcmh-mode 1))


;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun reload-init-file ()
  (interactive)
  (load-file user-init-file))
