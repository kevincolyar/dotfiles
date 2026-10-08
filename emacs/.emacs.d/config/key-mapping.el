;;; -*- lexical-binding: t; -*-
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
  (interactive)
  (let ((search-text (if (use-region-p)
                         (buffer-substring-no-properties (region-beginning) (region-end))
                       (read-string "Search text: "))))
    (when (and search-text (not (string= search-text "")))
      (let ((url (concat "https://search.brave.com/search?q=" 
                         (url-hexify-string search-text))))
        (browse-url url)))))




;; Transient (magit, gptel, etc) menus
  (with-eval-after-load 'transient
    (keymap-set transient-map "<escape>" #'transient-quit-one))

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
  "cf"  'format-all-region-or-buffer
  ;; "ce"  'consult-flycheck
  ;; "ce"  'flycheck-list-errors
  ;; "ce"  'flymake-show-buffer-diagnostics
  "cd"  'xref-find-definitions

  ;; "cD"  'lsp-describe-thing-at-point
  "cr"  'xref-find-references
  "cR"  'eglot-rename

  ;; Debugging (dape, config/dape.el). Mirrors `dape-global-map' (C-x C-a)
  ;; rather than inventing a second set of mnemonics.
  "d"   '(:ignore t :which-key "debug")
  ;; `my/dape' picks the configuration with `completing-read' (vertico);
  ;; `dape' itself keeps its own prompt, which completes config keys and
  ;; file names. `C-u SPC d d' goes from the first to the second.
  "dd"  '(my/dape :which-key "start")
  "dD"  '(dape :which-key "start (dape prompt)")
  "dr"  'dape-restart
  "dk"  'dape-kill
  "dq"  'dape-quit

  "db"  'dape-breakpoint-toggle
  "dB"  'dape-breakpoint-remove-all
  "dl"  'dape-breakpoint-log
  "de"  'dape-breakpoint-expression
  "dh"  'dape-breakpoint-hits

  "dc"  'dape-continue
  "dn"  'dape-next
  "di"  'dape-step-in
  "do"  'dape-step-out
  "du"  'dape-until
  "dp"  'dape-pause

  "dw"  'dape-watch-dwim
  "dx"  'dape-evaluate-expression
  "dI"  'dape-info
  "dR"  'dape-repl
  "dt"  'dape-select-thread
  "ds"  'dape-select-stack

  "xe"  'eval-last-sexp

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
  "ff" 'consult-find-file
  "fc" 'copy-file
  "fR" 'rename-file-and-buffer

  "g"  '(:ignore t :which-key "git")
  "gg" 'magit-status
  "gb" 'magit-blame-addition
  "gf" 'magit-file-dispatch
  "gl" 'magit-log-current

  "o"  '(:ignore t :which-key "org")
  "oc" 'org-capture
  "ot" '((lambda () (interactive) (org-capture nil "t")) :which-key "capture TODO")

  "R" 'reload-init-file

  "s"  '(:ignore t :which-key "search")
  ;; "ss"  'swiper-thing-at-point

  "ti"  'tempel-insert

  "w"   '(:ignore t :which-key "web")
  "ws"  'search-web

  )

(use-package which-key
  :straight nil
  :ensure nil
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.1))
