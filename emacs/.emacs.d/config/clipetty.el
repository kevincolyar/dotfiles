;;; -*- lexical-binding: t; -*-
(use-package clipetty
  :ensure t
  :hook (after-init . global-clipetty-mode)
  :config
  ;; clipetty--emit write-regions OSC 52 to $SSH_TTY. tmux keeps a stale
  ;; SSH_TTY across attach (Termius left /dev/ttys003 in the global env),
  ;; so evil `dd` dies with "Opening output file: Operation not permitted".
  ;; This session already has allow-passthrough + set-clipboard, so send
  ;; to the current terminal fd instead of opening a (possibly foreign) pty.
  ;; Never let a clipboard failure abort the kill.
  (defun clipetty--emit (string)
    "Emit STRING, optionally wrapped in a DCS, to the current terminal."
    (if (<= (length string) clipetty--max-cut)
        (let ((tmux    (getenv "TMUX" (selected-frame)))
              (term    (getenv "TERM" (selected-frame)))
              (ssh-tty (getenv "SSH_TTY" (selected-frame))))
          (condition-case nil
              (send-string-to-terminal
               (clipetty--dcs-wrap string tmux term ssh-tty))
            (error nil)))
      (message "Selection too long to send to terminal %d" (length string))
      (sit-for 1))))
