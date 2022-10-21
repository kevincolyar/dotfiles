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

(kevincolyar/leader-keys
  ":"   'counsel-M-x
  "TAB" 'evil-switch-to-windows-last-buffer
  ;; "/"   'counsel-projectile-rg
  "/"   'counsel-rg
  "*"   'counsel-projectile-rg
  "?"   'beacon-blink

  "t"   '(:ignore t :which-key "Toggles")
  "tt"  '(counsel-load-theme :which-key "choose theme")

  ;; "p" '(:keymap projectile-command-map :package projectile :which-key "Project")
  "pf" 'counsel-projectile-find-file
  "l" '(:keymap lsp-command-map :package lsp :which-key "LSP")

  "b"   '(:ignore t :which-key "Buffers")
  "bb"  'counsel-switch-buffer
  "be"  'eval-buffer

  "c"   '(:ignore t :which-key "Code")
  "ca"  'lsp-execute-code-action
  "ce"  'flycheck-list-errors

  "ea" 'embark-act

  "h"   '(:ignore t :which-key "Help")
  "hd"  '(:ignore t :which-key "Describe")
  "hdb" 'describe-bindings
  "hdf" 'describe-function
  "hdk" 'describe-key
  "hdv" 'describe-variable
  "hds" 'describe-symbol

  "f"  '(:ignore t :which-key "Files")
  "fs" 'save-buffer
  "ff" 'counsel-find-file
  "fr" 'counsel-recentf

  "g"  '(:ignore t :which-key "git")
  "gg" 'magit-status
  "gb" 'magit-blame-addition

  "s"  '(:ignore t :which-key "Search")
  "sl"  'ivy-resume
  "ss"  'swiper-thing-at-point

  "z="  'flyspell-correct-at-point)

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.1))
