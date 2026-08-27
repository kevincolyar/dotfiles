;;; -*- lexical-binding: t; -*-
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

;; Imperative shell: `process-lines' calls `call-process', which ignores a
;; remote `default-directory' and runs the program locally, so a tramp DIR
;; listed the local tree. `process-file' dispatches through tramp's handler
;; instead, and `executable-find' needs its REMOTE argument to look for the
;; binary on the right host.
(defvar consult-find-file-eager-limit 20000
  "Largest file count `consult-find-file' will list eagerly.
Above this it streams through `fd' instead; see `consult-find-file'.")

(defun consult-find-file--files (dir &optional limit)
  "Return the file names under DIR, relative to DIR, as listed by `fd'.
With LIMIT, stop after that many files, which is what makes the size
check in `consult-find-file' cheap: `fd' exits as soon as the cap is hit
instead of walking the whole tree.  Runs on the remote host when DIR is
remote."
  (let* ((default-directory dir)
         (remote (file-remote-p dir))
         (fd (or (executable-find "fd" remote)
                 (executable-find "fdfind" remote)
                 (user-error "Neither fd nor fdfind found on %s"
                             (or remote "this host")))))
    (with-temp-buffer
      ;; `--hidden' because dotfiles are files too: without it `fd' skips every
      ;; dotted path, which in ~/.dotfiles meant 5 candidates instead of 117 --
      ;; everything real lives under `emacs/.emacs.d', `nix/.config' and
      ;; friends. `fd' still skips `.git' of its own accord, and its
      ;; `.gitignore' handling stays on, so the package trees ignored there
      ;; (`emacs/.emacs.d/straight', elpa, eln-cache) stay out of the listing.
      (let ((status (apply #'process-file fd nil t nil
                           "--type" "f" "--hidden" "--color=never"
                           (when limit
                             (list "--max-results" (number-to-string limit))))))
        ;; fd exits 1 on a genuine error; a partially readable tree still
        ;; exits 0, so only a hard failure aborts the listing.
        (unless (eq status 0)
          (user-error "%s exited with %s: %s" fd status
                      (string-trim (buffer-string))))
        (split-string (buffer-string) "\n" t)))))

;; Each preview opens the candidate, which over tramp is a round trip to the
;; host, so a remote listing debounces instead of reading a file per cursor
;; movement. Locally the default `consult-preview-key' (`any', i.e. immediate)
;; is already what is wanted.
(defun consult-find-file--preview-key (dir)
  "Return the preview key to use while listing DIR."
  (if (file-remote-p dir) '(:debounce 0.3 any) consult-preview-key))

;; The eager listing: everything on screen at once, narrowed client-side by the
;; completion style, with live preview.
(defun consult-find-file--select-eager (dir files)
  "Read one of FILES, all of them shown at once, under DIR."
  (consult--read
   files
   :prompt (format "Find file (%s): " (abbreviate-file-name dir))
   :sort nil
   ;; nil so unmatched input is returned verbatim and becomes a new file.
   :require-match nil
   :category 'file
   :keymap consult-find-file-map
   :state (consult--file-preview)
   :preview-key (consult-find-file--preview-key dir)
   :history 'file-name-history))

;; The streaming listing, for trees too large to hold in the minibuffer. `fd'
;; does the matching and only its output is consed up, so the cost follows what
;; was typed rather than the size of the tree. `consult--fd-make-builder' turns
;; the input into fd arguments (regexp by default, `-g' globs, `-F' literals,
;; `--' passes flags straight through) and returns the highlighter with it.
;;
;; Below `consult-async-min-input' characters that builder returns nil -- there
;; is no pattern to search for yet -- and consult's `:min-input' gate would not
;; have run it anyway, which left the prompt empty in $HOME with no hint that
;; anything was expected. Fill that state with a capped listing instead: the
;; same `--max-results' run that decided the tree was too big, which is 70ms
;; for 20000 files here. So there is always something to look at and preview,
;; and typing a real pattern hands over to an uncapped search.
(defun consult-find-file--stream-builder ()
  "Return the `fd' command-line builder used by the streaming listing."
  (let* ((consult-fd-args (append (consult--build-args consult-fd-args)
                                  '("--type" "f" "--hidden")))
         (base (consult--build-args consult-fd-args))
         (search (consult--fd-make-builder nil)))
    (lambda (input)
      (if (>= (length input) consult-async-min-input)
          (funcall search input)
        ;; `:highlight t' feeds the builder's own return value to
        ;; `consult--async-highlight', which wants a function or a pair whose
        ;; cdr is one (consult.el:2591). A bare list of arguments is read as
        ;; the latter and blows up in the process filter, so return the pair
        ;; with no highlighter -- there is no pattern to highlight anyway.
        (cons (append base (list "--max-results"
                                 (number-to-string
                                  consult-find-file-eager-limit)))
              nil)))))

(defun consult-find-file--select-stream (dir)
  "Read a file under DIR, streaming matches from `fd' as they are typed."
  (consult--read
   (consult--process-collection (consult-find-file--stream-builder)
     :highlight t
     ;; 0 so the empty prompt reaches the builder and gets the capped listing;
     ;; the builder itself keeps short input from starting a full-tree search.
     :min-input 0
     ;; Route the process through the file-name handlers, so a remote DIR
     ;; runs fd on the remote host, as the eager path does.
     :file-handler t)
   ;; The count is capped, so say so rather than implying a full listing.
   :prompt (format "Find file (%s, first %s; type to search): "
                   (abbreviate-file-name dir) consult-find-file-eager-limit)
   :sort nil
   :require-match nil
   :category 'file
   :keymap consult-find-file-map
   :state (consult--file-preview)
   :preview-key (consult-find-file--preview-key dir)
   ;; The input is a search pattern here, not a file name.
   :history '(:input consult--find-history)))

;; `consult-fd'/`consult-find' stream candidates from an async process that
;; only starts once you type, so there's no initial listing and (since they
;; never pass `:state' to `consult--read') no preview either. This gathers the
;; full file list up front instead, like `consult-recent-file' does with
;; `recentf-list', so it behaves like `consult-buffer': everything shown
;; immediately, narrow as you type, live preview via `consult--file-preview'.
;;
;; That trade only holds while the tree fits in the minibuffer. $HOME here is
;; 808131 files: `fd' needs 7.5s to walk it and emits 94MB, all of which would
;; be consed into candidates before the prompt even appeared. So the listing is
;; eager only up to `consult-find-file-eager-limit' -- decided by a capped `fd'
;; run, 70ms for a 20000 cap in $HOME against 7.5s uncapped -- and above it the
;; command streams, which is the one case where giving up the instant listing
;; buys something.
(defun consult-find-file (&optional dir)
  "Find a file under DIR (default `default-directory') with an immediate
listing and live preview, like `consult-buffer' but for files.

Trees larger than `consult-find-file-eager-limit' are searched through
`fd' as you type instead, since listing them whole is slower than any
search: the prompt says `fd search' when that happens.

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
         ;; One over the limit is enough to know the tree is too big.
         (files (consult-find-file--files dir (1+ consult-find-file-eager-limit)))
         (eager (<= (length files) consult-find-file-eager-limit)))
    (consult-find-file--visit
     (consult-find-file--plan
      (if eager
          (consult-find-file--select-eager dir files)
        (consult-find-file--select-stream dir))
      dir
      ;; No candidate list to compare against when streaming, so every
      ;; selection counts as typed; `consult-find-file--visit' only reports
      ;; the ones that do not exist, which is the behaviour that matters.
      (and eager files)))))

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
  ;; `consult-preview-excluded-files' ships as `("\\`/[^/|:]+:" "\\.gpg\\'")'
  ;; (consult.el:371-375) and the first regexp matches every tramp name, so
  ;; `consult--preview-file' skips remote candidates outright
  ;; (consult.el:1512-1513) -- which is why moving through a remote listing
  ;; previewed nothing at all. Drop that entry: a remote read is bounded the
  ;; same way a local one is (`consult-preview-partial-size' reads a
  ;; `consult-preview-partial-chunk' slice of anything over 1MB, and
  ;; `consult-preview-max-count' caps the live buffers), and the commands that
  ;; walk remote listings debounce their preview key. `.gpg' stays excluded:
  ;; previewing it would prompt for a passphrase per candidate.
  (setq consult-preview-excluded-files '("\\.gpg\\'"))

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
