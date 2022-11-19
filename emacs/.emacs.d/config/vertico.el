;; Vertico provides a performant and minimalistic vertical completion UI based on the default completion system. The main focus of Vertico is to provide a UI which behaves correctly under all circumstances.
;; https://github.com/minad/vertico
;; https://kristofferbalintona.me/posts/202202211546/
(use-package vertico
  :ensure t
  :diminish
  :general
  (:keymaps 'vertico-map
            "<tab>" #'vertico-insert  ; Insert selected candidate into text area
            "<escape>" #'minibuffer-keyboard-quit ; Close minibuffer
            ;; NOTE 2022-02-05: Cycle through candidate groups
            "C-j" #'vertico-next
            "C-k" #'vertico-previous)
  (nmap
    :prefix "SPC"
    "sl"  'vertico-repeat ;; TODO: Not working
    )
  :config
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t)
  (vertico-mode))

(add-hook 'minibuffer-setup-hook #'vertico-repeat-save)

(use-package compat)
(use-package wgrep)
(use-package vertico-posframe)

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
    "pf" 'consult-projectile-find-file

    "bb"  'consult-buffer

    "tt"  '(consult-load-theme :which-key "choose theme")

    "ff" 'find-file
    "fd" 'delete-file
    "fr" 'consult-recent-file))

(use-package consult-dir :defer t)
(use-package consult-projectile :defer t)
(use-package consult-flycheck :defer t)
(use-package consult-lsp :defer t)
(use-package consult-yasnippet :defer t)

;; ;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


