;;; termius --- Termius (iOS/iPadOS SSH client) tweaks  -*- lexical-binding: t; -*-
;;; Commentary:
;; Termius reaches these machines over SSH into a dedicated tmux session; see
;; the zshrc block that execs `tmux new-session -A -s termius'.
;;; Code:

(defun my/termius-terminal-p ()
  "Non-nil when this Emacs was started from Termius.
Matches zshrc: LC_TERMINAL=Termius, or tmux session name `termius'."
  (or (string-prefix-p "termius" (downcase (or (getenv "LC_TERMINAL") "")))
      (and (getenv "TMUX")
           (equal "termius"
                  (string-trim
                   (shell-command-to-string
                    "tmux display-message -p '#S' 2>/dev/null"))))))

(defun my/tty-termius-mouse ()
  "Enable xterm mouse tracking on Termius TTY frames.
tmux then sees mouse_any_flag and passes wheel/taps through to Emacs."
  (when (and (not (display-graphic-p))
             (my/termius-terminal-p))
    (xterm-mouse-mode 1)))

(add-hook 'tty-setup-hook #'my/tty-termius-mouse)
(add-hook 'emacs-startup-hook #'my/tty-termius-mouse)

;;; termius.el ends here
