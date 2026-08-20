;;; -*- lexical-binding: t; -*-
;; `:init (global-flycheck-mode)' loaded flycheck during startup, and
;; flycheck.el requires `url-util' at its top level, which drags in `url-parse'
;; and `auth-source' -- 0.22s of url machinery on top of flycheck itself.
;;
;; Hooking `prog-mode'/`text-mode' is not enough: *scratch* is created at
;; startup in `lisp-interaction-mode', which derives from `prog-mode', so the
;; hook fires and flycheck loads anyway. `find-file-hook' only fires for real
;; file buffers, which is also the only place a checker has anything to check.
(use-package flycheck
  :hook (find-file . flycheck-mode)
  :config
  (setq flycheck-ruby-rubocop-executable "bundle exec rubocop")
  )

(use-package flycheck-inline
  :after flycheck
  :init (global-flycheck-inline-mode))

;; Out of the box flycheck-inline is point-scoped: flycheck calls
;; `flycheck-display-errors-function' with only the errors at point, and
;; `flycheck-inline-display-errors' clears every phantom before drawing them
;; (flycheck-inline.el:230-234), while `flycheck-inline-clear-phantoms' drops
;; any phantom whose region does not contain point (:186-189). So exactly one
;; message is ever on screen. Drive it from the end of each syntax check
;; instead, over the whole error list.
(defun my-flycheck-inline-show-all (&rest _)
  "Draw an inline phantom for every error in the buffer."
  (when (bound-and-true-p flycheck-inline-mode)
    (mapc #'delete-overlay flycheck-inline--phantoms)
    (setq flycheck-inline--phantoms nil)
    (mapc #'flycheck-inline-display-error flycheck-current-errors)))

(defun my-flycheck-inline-all-setup ()
  "Make flycheck-inline show every error, not just the one at point."
  (if (bound-and-true-p flycheck-inline-mode)
      (progn
        ;; Neutralise both point-scoped entry points; `my-flycheck-inline-show-all'
        ;; owns drawing and clearing from here on.
        (setq-local flycheck-display-errors-function #'ignore
                    flycheck-clear-displayed-errors-function #'ignore)
        (add-hook 'flycheck-after-syntax-check-hook
                  #'my-flycheck-inline-show-all nil t)
        (my-flycheck-inline-show-all))
    (remove-hook 'flycheck-after-syntax-check-hook
                 #'my-flycheck-inline-show-all t)))

(add-hook 'flycheck-inline-mode-hook #'my-flycheck-inline-all-setup)

(use-package flycheck-eglot
  :after (flycheck eglot)
  :custom (flycheck-eglot-exclusive nil)
  :config
  (global-flycheck-eglot-mode 1))
