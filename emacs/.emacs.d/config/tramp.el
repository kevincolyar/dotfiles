(use-package tramp
  :after org
  :defer t
  :config
  ;; Disable version control on tramp buffers to avoid freezes.
  (setq vc-ignore-dir-regexp
        (format "\\(%s\\)\\|\\(%s\\)"
                vc-ignore-dir-regexp
                tramp-file-name-regexp))
  (setq tramp-default-method "ssh")
  (setq tramp-auto-save-directory
        (expand-file-name "tramp-auto-save" user-emacs-directory))
  (setq tramp-persistency-file-name
        (expand-file-name "tramp-connection-history" user-emacs-directory))
  (setq password-cache-expiry nil)
  (setq tramp-use-ssh-controlmaster-options nil)
  (setq remote-file-name-inhibit-cache nil)

  ;; (customize-set-variable 'tramp-ssh-controlmaster-options
  ;;                         (concat
  ;;                          "-o ControlPath=/tmp/ssh-tramp-%%r@%%h:%%p "
  ;;                          "-o ControlMaster=auto -o ControlPersist=yes"))
  )
