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
  :ensure t
  :init
  (setq global-linum-mode nil)
  (global-git-gutter-mode +1))

(use-package xclip
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
