(use-package org
  :defer t
  :hook
  (org-mode . org-indent-mode)
  :config
  (setq
   org-refile-targets '((org-agenda-files :maxlevel . 3))
   org-refile-use-outline-path 'file
   org-outline-path-complete-in-steps nil
   org-refile-allow-creating-parent-nodes 'confirm
   org-log-done 'time
   org-html-checkbox-type 'html
   org-todo-keyword-faces
   '(
     ("HOLD" . "orange")
     ("WAIT" . "red")
     ("STRT" . "red")
     ;; ("CANCELED" . (:foreground "blue" :weight bold))
     ))
  :general
  (:keymaps 'org-mode-map
            :states 'normal
            "RET" 'org-open-at-point-global
            "TAB" 'org-cycle)
  (:keymaps 'org-mode-map
             ;; NOTE: keymaps specified with :keymaps must be quoted
             :states 'normal
             :keymaps 'org-mode-map
             :prefix ","
             "a"  'org-agenda
             "s"  '(:ignore t :which-key "Subtree")
             "sa" 'org-archive-subtree
             "si" 'org-insert-todo-heading-respect-content
             "sl" 'org-demote-subtree
             "sh" 'org-promote-subtree
             "sn" 'org-toggle-narrow-to-subtree
             "ss" 'org-sparse-tree
             "sj" 'org-move-subtree-down
             "sk" 'org-move-subtree-up
             "ds" 'org-schedule
             "e"  'org-export-dispatch
             "t"  'org-todo
             "r"  'org-refile
             "#"  'org-update-statistics-cookies
             "ds" 'org-schedule
             "e"  'org-export-dispatch
             "t"  'org-todo
             "r"  'org-refile
             "#"  'org-update-statistics-cookies
             "c"  'org-toggle-checkbox
             )
  )

(use-package org-bullets
  :defer t
  :hook (org-mode . org-bullets-mode))

;; https://blog.aaronbieber.com/2017/03/19/organizing-notes-with-refile.html

;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (load-theme 'kaolin-dark t)
;;             (set-face-background 'default "unspecified-bg")))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
