;; https://github.com/minad/consult
;; Consult provides search and navigation commands based on the Emacs completion function completing-read.
;; Completion allows you to quickly select an item from a list of candidates.

(defun get-project-root ()
  (when (fboundp 'projectile-project-root)
    (projectile-project-root)))

;; https://github.com/minad/consult/issues/399
(defun consult-ripgrep-symbol-at-point ()
  (interactive)
  (consult-ripgrep (get-project-root) (thing-at-point 'symbol)))

;; `consult-fd'/`consult-find' stream candidates from an async process that
;; only starts once you type, so there's no initial listing and (since they
;; never pass `:state' to `consult--read') no preview either. This instead
;; gathers the full file list up front, like `consult-recent-file' does with
;; `recentf-list', so it behaves like `consult-buffer': everything shown
;; immediately, narrow as you type, live preview via `consult--file-preview'.
(defun consult-find-file (&optional dir)
  "Find a file under DIR (default `default-directory') with an immediate
listing and live preview, like `consult-buffer' but for files."
  (interactive)
  (require 'consult)
  (let* ((dir (or dir default-directory))
         (fd (if (executable-find "fd") "fd" "fdfind"))
         (files (let ((default-directory dir))
                  (mapcar (lambda (f) (consult--fast-abbreviate-file-name (expand-file-name f dir)))
                          (process-lines fd "--type" "f" "--color=never")))))
    (find-file
     (consult--read
      files
      :prompt (format "Find file (%s): " (abbreviate-file-name dir))
      :sort nil
      :require-match t
      :category 'file
      :state (consult--file-preview)
      :history 'file-name-history))))

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

  ;; Custom ripgrep command, use .ignore file to ignore hidden dirs like .git or node_modules
  (setq consult-ripgrep-args "rg --follow --hidden --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip")

  :config
  (consult-customize
   '(consult-theme :preview-key '(:debounce 0.1 any))
   consult-buffer
   '(consult-ripgrep :preview-key '(:debounce 0.1 any)) 
   consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-recent-file
   '(consult--source-project-recent-file :preview-key '(:debounce 0.1 any))
  )

  :general
  (:states '(normal visual)
    :keymaps 'override
    :prefix "SPC"

    "/"   'consult-ripgrep
    "*"   'consult-ripgrep-symbol-at-point
    ;; "pf" 'consult-projectile
    "pf" 'project-find-file
    "pp" 'consult-projectile-switch-project

    "bb" 'consult-buffer
    "ce" 'consult-flycheck

    "fr" 'consult-recent-file

    "tt"  '(consult-theme :which-key "choose theme")
    ))

(use-package consult-dir :defer t)
(use-package consult-projectile :defer t)
(use-package consult-flycheck :defer t)
(use-package consult-eglot :defer t)
;; (use-package consult-yasnippet :defer t)

;; ;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
