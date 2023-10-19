;; https://github.com/minad/consult

(defun get-project-root ()
  (when (fboundp 'projectile-project-root)
    (projectile-project-root)))

;; https://github.com/minad/consult/issues/399
(defun consult-ripgrep-symbol-at-point ()
  (interactive)
  (consult-ripgrep (get-project-root) (thing-at-point 'symbol)))

;; https://www.youtube.com/watch?v=UtqE-lR2HCA&t=1246s
;; https://youtu.be/5ffb2at2d7w?t=412
;; https://github.com/minad/consult#use-package-example
;; https://github.com/minad/consult/issues/247
(use-package consult
  :ensure t

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode) 

   ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.05
        register-preview-function #'consult-register-format
        )

;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.1 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.1 any)
  )

  :general
  (nmap
    :keymaps 'override
    :prefix "SPC"

    ;; ":"   'consult-M-x
    "/"   'consult-ripgrep ;; TODO: not working
    "*"   'consult-ripgrep-symbol-at-point
    ;; "/"   'consult-grep
    ;; "pf" 'consult-projectile-find-file
    "pf" 'consult-projectile

    "bb"  'consult-buffer

    "tt"  '(consult-theme :which-key "choose theme")

    "ff" 'find-file
    "fd" 'delete-file
    "fr" 'consult-recent-file))

(use-package consult-dir :ensure t :defer t)
(use-package consult-projectile :ensure t :defer t)
(use-package consult-flycheck :ensure t :defer t)
(use-package consult-lsp :ensure t :defer t)
(use-package consult-yasnippet :ensure t :defer t)

;; ;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
