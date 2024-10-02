;; Key Mapping
;; --------------------------------------------------------------------------------

;; general.el provides a more convenient method for binding keys in emacs (for both evil and non-evil users).
;; https://github.com/noctuid/general.el#about
(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer kevincolyar/leader-keys
    ;; :keymaps '(normal insert visual emacs)
    :keymaps 'override
    :states '(normal motion)
    :prefix "SPC"
    :global-prefix "C-SPC")
  )

(defun search-web ()
  "Promt for search query and open it in the web browser."
  (interactive)
  (let ((query (read-string "Query: ")))
    (browse-url (concat "https://search.brave.com/search?q=" query))))

(kevincolyar/leader-keys
  ":"   'execute-extended-command
  "TAB" 'evil-switch-to-windows-last-buffer
  "?"   'beacon-blink

  "a"   '(:ignore t :which-key "ai")
  "t"   '(:ignore t :which-key "toggles")

  ;; "p" '(:keymap projectile-command-map :package projectile :which-key "Project")
  ;; "l" '(:keymap lsp-command-map :package lsp :which-key "LSP")

  "b"   '(:ignore t :which-key "buffers")
  "be"  'eval-buffer
  "re"  'eval-region

  "c"   '(:ignore t :which-key "code")
  ;; "ca"  'lsp-execute-code-action
  "ca"  'eglot-code-actions
  ;; "ce"  'flycheck-list-errors
  ;; "ce"  'flymake-show-buffer-diagnostics
  "cd"  'xref-find-definitions

  ;; "cD"  'lsp-describe-thing-at-point
  "cr"  'xref-find-references
  "cR"  'eglot-rename

  "h"  '(:ignore t :which-key "help")
  "hb" 'describe-bindings
  "hc" 'describe-command
  "hf" 'describe-function
  "hk" 'describe-key
  "hv" 'describe-variable
  "hs" 'describe-symbol
  "hm" 'describe-mode

  
  "f"  '(:ignore t :which-key "files")
  "fs" 'save-buffer
  "fd" 'delete-file
  "ff" 'find-file
  "fc" 'copy-file
  "fR" 'rename-file-and-buffer

  "g"  '(:ignore t :which-key "git")
  "gg" 'magit-status
  "gb" 'magit-blame-addition
  "gf" 'magit-log-current

  "R" 'reload-init-file

  "s"  '(:ignore t :which-key "search")
  ;; "ss"  'swiper-thing-at-point

  "w"   '(:ignore t :which-key "web")
  "ws"  'search-web

  "z="  'flyspell-correct-word-before-point)

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.1))
