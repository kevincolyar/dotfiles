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
  (defun my/clipetty-emit (string)
    "Emit STRING, optionally wrapped in a DCS, to the current terminal.
Replaces `clipetty--emit', which `write-region's to SSH_TTY and so breaks
when tmux has kept a stale SSH_TTY across attaches."
    (if (<= (length string) clipetty--max-cut)
        (let ((tmux    (getenv "TMUX" (selected-frame)))
              (term    (getenv "TERM" (selected-frame)))
              (ssh-tty (getenv "SSH_TTY" (selected-frame))))
          (condition-case nil
              (send-string-to-terminal
               (clipetty--dcs-wrap string tmux term ssh-tty))
            (error nil)))
      (message "Selection too long to send to terminal %d" (length string))
      (sit-for 1)))

  ;; Advice rather than a `defun' over the package's private function: it
  ;; shows up in `describe-function' and survives the package being reloaded,
  ;; which would otherwise silently restore the upstream body.
  (advice-add 'clipetty--emit :override #'my/clipetty-emit))
