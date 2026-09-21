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

  ;; Flycheck's only built-in SQL checker is `sql-sqlint', a Ruby gem last
  ;; released in 2019 that parses PostgreSQL exclusively. sqruff is a Rust
  ;; sqlfluff port covering 22 dialects (ansi, postgres, tsql, mysql,
  ;; sqlite, bigquery, snowflake, ...).
  ;;
  ;; Parse failures are reported with the literal rule code `????' and the
  ;; message "Unparsable section"; they only appear with `--parsing-errors'.
  ;; Diagnostics go to stderr, which flycheck reads because
  ;; `flycheck-start-command-checker' spawns via `start-file-process' with no
  ;; separate stderr pipe. Long messages wrap onto continuation lines that
  ;; carry the rule group, e.g. "| [layout.spacing]".
  (flycheck-def-option-var flycheck-sqruff-dialect nil sql-sqruff
    "Dialect passed to sqruff as `--dialect', overriding every other source.

When nil the dialect comes from a `.sqruff' file if one exists,
otherwise from `sql-product' via `my/sqruff-dialect-alist'."
    :type '(choice (const :tag "Infer from .sqruff or `sql-product'" nil)
                   (string :tag "Dialect name"))
    :safe #'stringp)

  ;; `sql-product' (sql-mode's own dialect setting, usually from
  ;; `.dir-locals.el') is the dialect the buffer already declares, so reuse
  ;; it. Only products sqruff implements are listed; `sqruff dialects' prints
  ;; the full set. `ansi' is absent on purpose: it is sqruff's own default,
  ;; and `sql-product' defaults to `ansi', so mapping it would silently
  ;; override a `.sqruff' dialect in every unconfigured buffer.
  (defvar my/sqruff-dialect-alist
    '((postgres . "postgres")
      (ms . "tsql")
      (mysql . "mysql")
      (sqlite . "sqlite")
      (oracle . "oracle")
      (db2 . "db2"))
    "Map `sql-product' symbols onto sqruff `--dialect' names.")

  (defun my/sqruff-dialect-args ()
    "Return the sqruff `--dialect' argument list for the current buffer.

Precedence: `flycheck-sqruff-dialect', then a `.sqruff' file (whose
own dialect must win, so nothing is passed), then `sql-product'."
    (when-let* ((dialect
                 (or flycheck-sqruff-dialect
                     (unless (locate-dominating-file default-directory ".sqruff")
                       (alist-get (bound-and-true-p sql-product)
                                  my/sqruff-dialect-alist)))))
      (list "--dialect" dialect)))

  (flycheck-define-checker sql-sqruff
    "A multi-dialect SQL linter using sqruff.

See URL `https://github.com/quarylabs/sqruff'."
    :command ("sqruff" "lint" "--parsing-errors"
              (eval (my/sqruff-dialect-args))
              "-")
    :standard-input t
    :error-patterns
    ((error line-start "L:" (zero-or-more " ") line
            " | P:" (zero-or-more " ") column
            " | ???? | " (message (one-or-more not-newline)
                                  (zero-or-more "\n" (one-or-more " ")
                                                "| " (one-or-more not-newline)))
            line-end)
     (warning line-start "L:" (zero-or-more " ") line
              " | P:" (zero-or-more " ") column
              " | " (id (one-or-more (not (any " "))))
              " | " (message (one-or-more not-newline)
                             (zero-or-more "\n" (one-or-more " ")
                                           "| " (one-or-more not-newline)))
              line-end))
    ;; sqruff reads `.sqruff' from the working directory only -- neither from
    ;; the linted file's directory nor from any parent -- so run it where the
    ;; config lives.
    :working-directory
    (lambda (_checker)
      (let ((start (or (and buffer-file-name
                            (file-name-directory buffer-file-name))
                       default-directory)))
        (or (locate-dominating-file start ".sqruff") start)))
    :modes (sql-mode))

  (add-to-list 'flycheck-checkers 'sql-sqruff)
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
