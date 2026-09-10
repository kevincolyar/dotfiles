;;; ui --- Summary  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(setq window-combination-resize t)

(use-package doom-modeline
  :config
  (doom-modeline-mode 1))

;; (use-package smart-mode-line)

;; (use-package beacon
;;   :init (beacon-mode 1))

(use-package rainbow-delimiters
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package indent-bars
  :hook (prog-mode .indent-bars-mode))

(use-package doom-themes
  :config
  ;; (load-theme 'doom-sourcerer t)
  ;; (load-theme 'doom-Iosvkem t)
  ;; (load-theme 'doom-pine t)
  ;; (load-theme 'doom-dark+ t))
  ;; (load-theme 'doom-nord t)
;;   (load-theme 'doom-rouge t)
;;   ;; (load-theme 'doom-one t)
;;   ;; (doom-themes-visual-bell-config)
   (doom-themes-org-config)
  )

;; (use-package kaolin-themes
;;   :config
;;   ;; (load-theme 'kaolin-dark t)
;;   (load-theme 'kaolin-shiva t))

;;; ------------------------------------------------------------------
;;; Light/dark follows the client terminal, never the host OS
;;; ------------------------------------------------------------------
;; An appearance flip on the laptop reaches Emacs as a terminal report:
;;
;;   Ghostty --(CSI ? 997 ; 1|2 n)--> [tmux] --ssh--> [tmux] --> Emacs
;;
;; Emacs asks once with `CSI ? 996 n' and subscribes to later changes with
;; DECSET 2031, per TTY terminal.  tmux >= 3.5 answers 996 from the attached
;; client's theme and relays 2031 reports into panes that enabled the mode,
;; so a remote Emacs tracks the laptop with or without tmux at either end.
;; The host OS appearance is a local-GUI/last-resort fallback only:
;; mini.lan's Aqua setting is not the laptop that SSHed in.

(defun my/ssh-session-p ()
  "Non-nil when this Emacs is on the far side of SSH."
  (or (getenv "SSH_CONNECTION")
      (getenv "SSH_CLIENT")
      (getenv "SSH_TTY")))

(defun my/env-color-scheme ()
  "Return `dark', `light', or nil from COLORFGBG / LC_COLORFGBG.

Background index < 8 is dark, >= 8 is light.  `LC_COLORFGBG' is the
SSH-forwarded copy (sshd `AcceptEnv LC_*') that zshrc sets on the laptop.
A fallback only: it is fixed at login and cannot follow a later flip."
  (let* ((raw (or (getenv "COLORFGBG") (getenv "LC_COLORFGBG")))
         (parts (and raw (split-string raw ";" t)))
         (bg (car (last parts))))
    (when (and bg (string-match-p "\\`[0-9]+\\'" bg))
      (if (< (string-to-number bg) 8) 'dark 'light))))

(defun my/host-dark-mode-p ()
  "Return non-nil if this machine's OS appearance is dark.

`default-directory' is pinned local: in a TRAMP buffer
`shell-command-to-string' would run `defaults' on the remote host, which
is what made `auto-dark' unusable here.  Never consulted over SSH --
Linux hosts have no AppleInterfaceStyle, so it would always say dark."
  (pcase system-type
    ('darwin
     (let ((default-directory (expand-file-name "~/")))
       (string= "Dark"
                (string-trim
                 (shell-command-to-string
                  "defaults read -g AppleInterfaceStyle 2>/dev/null")))))
    (_ t)))

(defvar my/color-scheme nil
  "Client color scheme: `dark', `light', or nil when nothing reported yet.")

(defun my/dark-mode-p ()
  "Return non-nil when the dark theme variant should be active."
  (pcase (or my/color-scheme (my/env-color-scheme))
    ('dark t)
    ('light nil)
    (_ (and (not (my/ssh-session-p))
            (my/host-dark-mode-p)))))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(use-package autothemer :defer t)

;; One theme at a time.  The autothemer `rose-pine-*' themes do not define
;; `doom-modeline-*' faces, so loading them leaves the bar light regardless
;; of dark mode; `doom-rose-pine-*' colour the bar and the evil state tag.
(defconst my/dark-theme 'doom-rose-pine-moon)
(defconst my/light-theme 'doom-rose-pine-dawn)

(defun my/tty-unspecify-default-bg ()
  "Keep the TTY default face transparent so Ghostty's theme shows through."
  (unless (display-graphic-p)
    (set-face-background 'default "unspecified-bg")))

(defun my/apply-face-tweaks ()
  "Re-assert the hand-picked faces that a theme swap clobbers.
`load-theme' re-specs `isearch' and friends, so this runs after every
theme load instead of once at startup.  The colours are chosen to read
on both variants."
  (set-face-attribute 'completions-common-part nil
                      :foreground "#31748f" :weight 'bold)
  ;; Current search candidate.
  (set-face-attribute 'isearch nil
                      :background "#ff9900" :foreground "black"
                      :inverse-video nil)
  ;; Other search candidates.
  (set-face-attribute 'lazy-highlight nil
                      :background "#ffdd99" :foreground "black"
                      :inverse-video nil)
  ;; Transient menus (magit, gptel).
  (dolist (face '(transient-key-stay transient-key-return))
    (when (facep face)
      (set-face-attribute face nil :foreground "#99aa99")))
  ;; Markdown code blocks.
  (when (facep 'markdown-code-face)
    (set-face-attribute 'markdown-code-face nil :background 'unspecified)))

(defun my/refresh-modeline ()
  "Rebuild doom-modeline after a theme swap so the bar is not stale."
  (when (fboundp 'doom-modeline-refresh-bars)
    (doom-modeline-refresh-bars))
  (when (fboundp 'doom-modeline--reset-font-height-cache)
    (doom-modeline--reset-font-height-cache))
  (force-mode-line-update t))

(defun my/load-color-scheme-theme ()
  "Enable the theme that matches `my/dark-mode-p'.  Idempotent."
  (let ((theme (if (my/dark-mode-p) my/dark-theme my/light-theme)))
    (unless (eq (car custom-enabled-themes) theme)
      (mapc #'disable-theme (copy-sequence custom-enabled-themes))
      (load-theme theme t)
      (my/tty-unspecify-default-bg)
      (my/apply-face-tweaks)
      (my/refresh-modeline))))

(defun my/set-color-scheme (scheme)
  "Record client SCHEME (`dark' or `light') and reload the theme."
  (unless (eq my/color-scheme scheme)
    (setq my/color-scheme scheme)
    (my/load-color-scheme-theme)))

(defun my/queue-color-scheme (scheme)
  "Apply SCHEME from the command loop, not from inside key translation."
  (run-with-timer 0 nil #'my/set-color-scheme scheme))

;;; Terminal reports.
;;
;; Only a three-character "\e[?" entry in `input-decode-map' is ever
;; reached: Emacs ends the key sequence at the CSI private-parameter
;; introducer, so a nine-character `997;1n' binding never matches -- the
;; report tail self-inserts instead, which is why earlier revisions only
;; ever caught the startup reply.  xterm.el hangs its primary-DA handler
;; off the same three characters and reads the rest itself.

(defconst my/color-scheme-report-regexp "\\`997;\\([12]\\)n\\'"
  "Mode 2031 color-scheme report, without the leading `CSI ?'.")

(defun my/parse-color-scheme-report (body)
  "Return `dark', `light', or nil for the `CSI ?' report BODY."
  (when (string-match my/color-scheme-report-regexp body)
    (if (equal "1" (match-string 1 body)) 'dark 'light)))

(defun my/read-csi-body ()
  "Read the rest of a `CSI ?' sequence, final byte included.
Stops at the first final byte (`@' .. `~') or a 0.1s gap, so a truncated
report cannot wedge key translation.  Non-character events are pushed
back for the command loop."
  (let ((chars nil) (done nil))
    (while (not done)
      (let ((event (read-event nil nil 0.1)))
        (cond
         ((null event) (setq done t))
         ((characterp event)
          (push event chars)
          (when (<= ?@ event ?~) (setq done t)))
         (t (push event unread-command-events)
            (setq done t)))))
    (apply #'string (nreverse chars))))

(defun my/csi-private-dispatch (&optional _prompt)
  "Consume a `CSI ?' report: act on color-scheme ones, drop the rest.
The other private replies (primary DA, DECRQM) only arrive during
terminal setup, where `xterm--query' reads them with raw `read-event'
before this dispatcher is bound."
  (let ((scheme (my/parse-color-scheme-report (my/read-csi-body))))
    (when scheme
      (my/queue-color-scheme scheme)))
  [])

(defun my/tty-request-color-scheme ()
  "Ask the terminal for its color scheme; the reply is asynchronous."
  (unless (display-graphic-p)
    (send-string-to-terminal "\e[?996n")))

;; Declared in term/xterm, which is loaded on demand below; the declaration
;; keeps the `let' below a dynamic binding under byte compilation.
(defvar xterm-query-timeout)

(defun my/tty-query-color-scheme ()
  "Read the terminal's color scheme synchronously, before the first theme load.
`input-decode-map' is not consulted this early -- `sit-for' does not run
it -- so the startup value comes from `xterm--query', which reads raw
events.  NO-ASYNC is on: the async fallback would leave behind a
nine-character binding that can never match."
  (require 'term/xterm nil t)
  (when (fboundp 'xterm--query)
    (let ((xterm-query-timeout (if (my/ssh-session-p) 1.0 0.3)))
      (xterm--query
       "\e[?996n"
       `(("\e[?997;1n" . ,(lambda () (setq my/color-scheme 'dark)))
         ("\e[?997;2n" . ,(lambda () (setq my/color-scheme 'light))))
       t))))

(defun my/tty-on-focus-change ()
  "Re-ask on focus-in, for terminals that never send 2031 reports."
  (when (and (not (display-graphic-p))
             (frame-focus-state)
             (terminal-parameter nil 'my/color-scheme-tracking))
    (my/tty-request-color-scheme)))

(defvar my/focus-requery-installed nil
  "Non-nil once focus changes re-query the client color scheme.")

(defun my/tty-follow-client-color-scheme (&optional frame)
  "Track the client terminal's light/dark mode on FRAME's terminal."
  (with-selected-frame (or frame (selected-frame))
    (unless (or (display-graphic-p)
                (terminal-parameter nil 'my/color-scheme-tracking))
      (set-terminal-parameter nil 'my/color-scheme-tracking t)
      (define-key input-decode-map "\e[?" #'my/csi-private-dispatch)
      (send-string-to-terminal "\e[?2031h")
      (push "\e[?2031l" (terminal-parameter nil 'tty-mode-reset-strings))
      (push "\e[?2031h" (terminal-parameter nil 'tty-mode-set-strings))
      (my/tty-query-color-scheme)
      ;; tmux stays silent while its own client theme is unknown; a late
      ;; reply still lands in the dispatcher.
      (unless my/color-scheme
        (my/tty-request-color-scheme))
      (my/load-color-scheme-theme)
      (unless my/focus-requery-installed
        (setq my/focus-requery-installed t)
        (add-function :after after-focus-change-function
                      #'my/tty-on-focus-change)))))

;;; GUI frames.
;;
;; This is the stock NextStep build, which has no `ns-system-appearance'
;; (that variable is an emacs-plus / emacs-mac patch), so there is no
;; notification to hook: poll `defaults' instead.  The poll stands down as
;; soon as a TTY frame exists, since that terminal is authoritative.

(defvar my/gui-appearance-timer nil
  "Timer polling the macOS appearance for GUI frames.")

(defun my/gui-frames-only-p ()
  "Non-nil when every live frame is graphical."
  (and (display-graphic-p)
       (catch 'tty
         (dolist (frame (frame-list))
           (unless (display-graphic-p frame)
             (throw 'tty nil)))
         t)))

(defun my/gui-poll-system-appearance ()
  "Set the color scheme from the macOS appearance."
  (when (my/gui-frames-only-p)
    (my/set-color-scheme (if (my/host-dark-mode-p) 'dark 'light))))

(defun my/gui-follow-system-appearance ()
  "Start polling the macOS appearance, once."
  (when (and (eq system-type 'darwin)
             (not my/gui-appearance-timer))
    (my/gui-poll-system-appearance)
    (setq my/gui-appearance-timer
          (run-with-timer 2 2 #'my/gui-poll-system-appearance))))

(defun my/follow-appearance (&optional frame)
  "Start light/dark tracking for FRAME: terminal reports, or GUI polling."
  (with-selected-frame (or frame (selected-frame))
    (if (display-graphic-p)
        (my/gui-follow-system-appearance)
      (my/tty-follow-client-color-scheme))))

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

(add-hook 'tty-setup-hook #'my/tty-follow-client-color-scheme)
(add-hook 'tty-setup-hook #'my/tty-termius-mouse)
(add-hook 'emacs-startup-hook #'my/tty-termius-mouse)
(add-hook 'after-make-frame-functions #'my/follow-appearance)

;; A GUI frame already exists here, so start polling now; `emacs-startup-hook'
;; is not reliable for this (it does not run before the first redisplay when
;; the startup screen is inhibited).  A TTY frame only gets its theme now --
;; the terminal is not initialised until `tty-setup-hook', so it cannot be
;; queried yet.
(if (display-graphic-p)
    (my/gui-follow-system-appearance)
  (my/load-color-scheme-theme))

;; GUI Settings
(if (display-graphic-p)
    (set-frame-font "FiraCode Nerd Font 15" nil t)
    (setq default-frame-alist '((width . 80) (height . 24))))

;; Display image images inline in org files
(if (display-graphic-p)
   (setq org-startup-with-inline-images t)
   (setq org-display-remote-inline-images t))


(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(use-package nerd-icons
  :defer t)

;; Faces that fight the theme live in `my/apply-face-tweaks', which runs after
;; every theme load.  These two only exist once their package is loaded, so
;; re-run the tweaks then as well.
(with-eval-after-load 'transient (my/apply-face-tweaks))
(with-eval-after-load 'markdown-mode (my/apply-face-tweaks))

;; Emacs 31 draws borders around child frames on TTY frames -- the popups from
;; corfu, corfu-popupinfo and eldoc-box -- using glyphs from
;; `standard-display-table's extra slots. Those slots are empty by default, so
;; nothing is drawn; this fills them with Unicode box-drawing characters. It
;; also upgrades the TTY `vertical-border' between windows from `|' to U+2502.
;; GUI frames ignore these slots and draw real borders instead.
(when (fboundp 'standard-display-unicode-special-glyphs)
  (standard-display-unicode-special-glyphs))

;; Enable undercurl support in terminal Emacs
;; Set the undercurl sequence
(define-coding-system-alias 'undercurl 'utf-8)

;; Add terminal capabilities
(define-key input-decode-map "\e[4:3m" [undercurl])

;;; ui.el ends here
