;;; -*- lexical-binding: t; -*-
;; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
;; I don’t use rsync though because it breaks remote shells. Edit: This is going to be fixed in Emacs 30.2.

;; No `:after org': that wraps the whole form in `with-eval-after-load 'org', so
;; touching a remote path before org has loaded -- `consult-recent-file' in a
;; fresh session, for instance -- loaded tramp with none of the settings below.
;; `:defer t' alone already keeps it lazy.
(use-package tramp
  :straight nil
  :ensure nil
  :defer t
  :config
  ;; Prevent extra files
  (setq remote-file-name-inhibit-locks t
        tramp-use-scp-direct-remote-copying t
        remote-file-name-inhibit-auto-save-visited t)
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
  ;; Default is 60s. An unreachable or unresolvable host (kubi.lan currently
  ;; NXDOMAINs) otherwise blocks Emacs for a full minute on first touch.
  (setq tramp-connection-timeout 5)

  ;; Default `tramp-remote-path' is a fixed list of system directories, so
  ;; anything installed under the login shell's PATH (~/.nix-profile/bin,
  ;; ~/.local/bin) is invisible to `executable-find'/`process-file' -- which
  ;; is how `consult-find-file' locates `fd' on a remote host. The
  ;; `tramp-own-remote-path' placeholder splices in the remote user's own
  ;; PATH; appended, so system directories still win on ambiguity.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path t)

  ;; (customize-set-variable 'tramp-ssh-controlmaster-options
  ;;                         (concat
  ;;                          "-o ControlPath=/tmp/ssh-tramp-%%r@%%h:%%p "
  ;;                          "-o ControlMaster=auto -o ControlPersist=yes"))
  )
