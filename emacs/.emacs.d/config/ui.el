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

(defun my/system-dark-mode-p ()
  "Return non-nil if this machine's OS appearance is dark.

Fallback only.  TTY Emacs (including a remote session) should use
`my/color-scheme', which tracks the *client* terminal via DSR 996 /
mode 2031 -- Ghostty reports `CSI ? 997 ; 1 n' for dark and
`; 2 n' for light, and tmux forwards that from the attaching client.
Linux hosts have no AppleInterfaceStyle, so this would otherwise
always pick moon."
  (pcase system-type
    ('darwin
     (string= "Dark"
              (string-trim
               (shell-command-to-string
                "defaults read -g AppleInterfaceStyle 2>/dev/null"))))
    (_ t)))

(defvar my/color-scheme nil
  "Client color scheme from the terminal: `dark', `light', or nil.")

(defun my/dark-mode-p ()
  "Return non-nil if the active theme should be the dark variant.

Prefers the client terminal's light/dark report over the host OS, so
Emacs on kubi.lan follows the Ghostty/macOS appearance of the laptop
that SSHed in, not GNOME on the server."
  (pcase my/color-scheme
    ('dark t)
    ('light nil)
    (_ (my/system-dark-mode-p))))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(use-package autothemer :defer t)

;; One theme. The autothemer `rose-pine-*' themes do not define
;; `doom-modeline-*' faces, and `:config' previously loaded both doom
;; variants so dawn always sat on top -- modeline stayed light (and
;; inherited autothemer `italic' = faded for the host segment) regardless
;; of dark mode. `doom-rose-pine-*' already colour the bar and evil states.
(defun my/tty-unspecify-default-bg ()
  "Keep the TTY default face transparent so Ghostty's theme shows through."
  (unless (display-graphic-p)
    (set-face-background 'default "unspecified-bg")))

(defun my/load-rose-pine-theme ()
  "Enable `doom-rose-pine-moon' or `doom-rose-pine-dawn' from `my/dark-mode-p'."
  (let ((theme (if (my/dark-mode-p)
                   'doom-rose-pine-moon
                 'doom-rose-pine-dawn)))
    (unless (eq (car custom-enabled-themes) theme)
      (mapc #'disable-theme (copy-sequence custom-enabled-themes))
      (load-theme theme t)
      (my/tty-unspecify-default-bg))))

(defun my/set-color-scheme (scheme)
  "Record client SCHEME (`dark' or `light') and reload the matching theme."
  (unless (eq my/color-scheme scheme)
    (setq my/color-scheme scheme)
    (my/load-rose-pine-theme)))

(defun my/tty-bind-color-scheme-reports ()
  "Decode Ghostty/tmux DSR 997 replies without inserting them as text."
  (define-key input-decode-map "\e[?997;1n"
              (lambda (&optional _prompt)
                (my/set-color-scheme 'dark)
                []))
  (define-key input-decode-map "\e[?997;2n"
              (lambda (&optional _prompt)
                (my/set-color-scheme 'light)
                [])))

(defun my/tty-follow-client-color-scheme ()
  "Ask the client terminal its light/dark mode and subscribe to changes.

`CSI ? 996 n' is answered with `CSI ? 997 ; 1 n' (dark) or `; 2 n'
(light).  DECSET 2031 makes Ghostty emit that DSR whenever the
client appearance flips, so a remote Emacs tracks the laptop
without polling.

The initial query is synchronous through `xterm--query' with a
0.3s timeout -- `sit-for' does not run `input-decode-map', so an
async 996 reply would be missed during startup.  2031 reports
after that are decoded from `input-decode-map' in the command loop."
  (unless (or (display-graphic-p)
              (terminal-parameter nil 'my/color-scheme-tracking))
    (set-terminal-parameter nil 'my/color-scheme-tracking t)
    (my/tty-bind-color-scheme-reports)
    (send-string-to-terminal "\e[?2031h")
    (push "\e[?2031l" (terminal-parameter nil 'tty-mode-reset-strings))
    (push "\e[?2031h" (terminal-parameter nil 'tty-mode-set-strings))
    (when (fboundp 'xterm--query)
      (let ((xterm-query-timeout 0.3))
        (xterm--query
         "\e[?996n"
         `(("\e[?997;1n" . ,(lambda () (my/set-color-scheme 'dark)))
           ("\e[?997;2n" . ,(lambda () (my/set-color-scheme 'light))))
         t)))))

(add-hook 'tty-setup-hook #'my/tty-follow-client-color-scheme)
(add-hook 'emacs-startup-hook #'my/tty-follow-client-color-scheme)
(my/load-rose-pine-theme)

;; Not working on remote, tramp (rsync) files
;; (use-package auto-dark
;;   :ensure t
;;   :custom
;;   (auto-dark-themes '((doom-rose-pine-moon) (doom-rose-pine-dawn)))
;;   (auto-dark-polling-interval-seconds 2)
;;   :init
;;   (progn
;;     ;; Only enable for MacOS
;;     (when (eq system-type 'darwin)
;;       (setq auto-dark-allow-osascript t)
;;       (auto-dark-mode))))

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

;; Custom fonts
(custom-set-faces
 '(completions-common-part ((t (:foreground "#31748f" :weight bold)))))

;; Transient Menu (magit, gptel, etc) - light mode
(with-eval-after-load 'transient
  (dolist (face '(transient-key-stay transient-key-return))
    (set-face-attribute face nil
                        :foreground "#99aa99")))

;; Current search candidate - light mode
(set-face-attribute 'isearch nil
                    :background "#ff9900"
                    :foreground "black"
                    :inverse-video nil)


;; Other search candidates - light mode
(set-face-attribute 'lazy-highlight nil
                    :background "#ffdd99"
                    :foreground "black"
                    :inverse-video nil)

;; Markdown code blocks
(with-eval-after-load 'markdown-mode
  (set-face-attribute 'markdown-code-face nil
                      :background 'unspecified))

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
