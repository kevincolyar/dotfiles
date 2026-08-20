;;; early-init.el --- Pre-init setup -*- lexical-binding: t; -*-
;;; Commentary:
;; Runs before package.el would initialise and before the first frame exists,
;; so this is the only place that can cover the straight.el bootstrap in init.el.
;;; Code:

;; straight.el owns every package here. Leaving package.el enabled only buys a
;; scan of `package-user-dir' and its archive cache.
(setq package-enable-at-startup nil)

;; Startup allocates heavily -- the straight bootstrap alone is the single
;; biggest item in init -- and it runs before anything in config/. Raise the
;; threshold for the whole of startup, then drop back to a value that keeps
;; interactive GC pauses short rather than leaving it permanently huge.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024)
                  gc-cons-percentage 0.1)))

;; Suppress "For information about GNU Emacs and the GNU system, type C-h C-a."
;;
;; `inhibit-startup-echo-area-message' deliberately resists being set from a
;; shared config: `display-startup-echo-area-message' (startup.el) only honours
;; it when the value equals this machine's `init-file-user' *and* the literal
;; text (setq inhibit-startup-echo-area-message "NAME") appears in
;; `user-init-file' itself -- it re-reads and greps the file. That rules out
;; setting it from here, and a single hardcoded name would only ever match one
;; of `kevin.colyar' / `kevincolyar'. Overriding the function is
;; username-independent and does the same job.
(advice-add 'display-startup-echo-area-message :override #'ignore)

;; The startup pause: `tty-run-terminal-initialization' -> `terminal-init-xterm'
;; -> `xterm--init' probes the terminal for capabilities by sending OSC/DA
;; escape sequences and blocking on the reply for `xterm-query-timeout'
;; (2 seconds) each. Measured here: two unanswered queries = 4.23s spent inside
;; terminal init, every bit of it after `after-init-time', which is why
;; `emacs-init-time' reported ~1.9s while startup visibly took ~6.3s.
;;
;; `term/tmux.el' and `term/screen.el' already avoid this by declaring
;; capabilities instead of checking (their own comment: "don't use
;; xterm-extra-capabilities's `check' setting since that doesn't seem" to
;; work), but that only applies when TERM says tmux/screen -- set TERM to
;; xterm-256color inside tmux, as is common for truecolor, and the `check'
;; path comes back. Declare the same capability set unconditionally.
(setq xterm-extra-capabilities '(modifyOtherKeys))

;;; early-init.el ends here
