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

(defvar consult-find-file--dir nil
  "Search root of the running `consult-find-file'.
Bound during the `consult--read' call so `consult-find-file-up' knows which
directory to ascend from.")

(defun consult-find-file-up ()
  "Move the `consult-find-file' search root up one directory.
Only acts on an empty prompt; otherwise deletes backward as usual, so
backspace still narrows normally. The listing is rebuilt from the parent by
re-invoking `consult-find-file' on a timer, since the candidates are gathered
up front rather than completed path-by-path."
  (interactive)
  (if (or (not consult-find-file--dir)
          (/= (minibuffer-prompt-end) (point-max)))
      (call-interactively #'delete-backward-char)
    (let* ((dir consult-find-file--dir)
           (parent (file-name-directory (directory-file-name dir))))
      (if (or (null parent) (equal parent dir))
          (minibuffer-message "Already at the filesystem root")
        ;; Re-invoke after this minibuffer unwinds, so `:state' tears down its
        ;; preview buffers before the next listing opens.
        (run-at-time 0 nil #'consult-find-file parent)
        (abort-recursive-edit)))))

(defvar-keymap consult-find-file-map
  :doc "Keymap active during `consult-find-file'."
  "<remap> <delete-backward-char>" #'consult-find-file-up
  "DEL" #'consult-find-file-up
  "<backspace>" #'consult-find-file-up)

;; Functional core: decide what the selection means, without touching the
;; filesystem or any buffer, so the choice is inspectable on its own.
(defun consult-find-file--plan (selection dir known)
  "Return a plan for visiting SELECTION under DIR, given KNOWN candidates.
The plan is a plist of :path (absolute) and :typed, the latter non-nil when
SELECTION is not one of KNOWN — i.e. it was typed rather than picked. Note
that :typed says nothing about existence on disk, only that the listing did
not offer it. Pure: derives names, reads no files."
  (list :path (expand-file-name selection dir)
        :typed (not (member selection known))))

;; Imperative shell: the only part that reads the filesystem or opens a buffer.
(defun consult-find-file--visit (plan)
  "Visit the file described by PLAN, from `consult-find-file--plan'.
Offers to create a missing parent directory first; declining still visits,
since `save-buffer' asks again. Typed input naming a file that does not exist
is reported, so creating one is never silent."
  (let* ((path (plist-get plan :path))
         (parent (file-name-directory path)))
    (when (and parent
               (not (file-directory-p parent))
               (yes-or-no-p (format "Create directory %s? "
                                    (abbreviate-file-name parent))))
      (make-directory parent t))
    (when (and (plist-get plan :typed) (not (file-exists-p path)))
      (message "New file: %s" (abbreviate-file-name path)))
    (find-file path)))

;; `consult-fd'/`consult-find' stream candidates from an async process that
;; only starts once you type, so there's no initial listing and (since they
;; never pass `:state' to `consult--read') no preview either. This instead
;; gathers the full file list up front, like `consult-recent-file' does with
;; `recentf-list', so it behaves like `consult-buffer': everything shown
;; immediately, narrow as you type, live preview via `consult--file-preview'.
(defun consult-find-file (&optional dir)
  "Find a file under DIR (default `default-directory') with an immediate
listing and live preview, like `consult-buffer' but for files.

Backspace on an empty prompt moves the search root up one directory.
RET on input matching no candidate creates that file instead; `M-RET'
(`vertico-exit-input') forces the typed text even when a candidate is
selected."
  (interactive)
  (require 'consult)
  ;; Normalized so `consult-find-file-up' can walk to the parent reliably.
  (let* ((dir (file-name-as-directory (expand-file-name (or dir default-directory))))
         (default-directory dir)
         (consult-find-file--dir dir)
         (fd (if (executable-find "fd") "fd" "fdfind"))
         (files (process-lines fd "--type" "f" "--color=never")))
    (consult-find-file--visit
     (consult-find-file--plan
      (consult--read
       files
       :prompt (format "Find file (%s): " (abbreviate-file-name dir))
       :sort nil
       ;; nil so unmatched input is returned verbatim and becomes a new file.
       :require-match nil
       :category 'file
       :keymap consult-find-file-map
       :state (consult--file-preview)
       :history 'file-name-history)
      dir files))))

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
