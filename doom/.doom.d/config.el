;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

;; Load private config
;;(load-file (expand-file-name "~/.emacs.private"))
(setq-default private-config (expand-file-name "~/.emacs.private"))
(when (file-exists-p private-config)
  (load-file private-config))

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
;; (setq doom-font (font-spec :family "monospace" :size 14)
;;       doom-variable-pitch-font (font-spec :family "sans"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-nord)
;; (setq doom-theme 'doom-dracula)
;; (setq doom-theme 'doom-spacegrey)
;; (setq doom-theme 'doom-solarized-dark)

;; If you intend to use org, it is recommended you change this!
;; (setq org-directory "~/mnt/imac_dropbox/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
;; (setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Make SPC menu show up faster
(setq which-key-idle-delay 0.4)

;; Disable quit confirmation
(setq confirm-kill-emacs nil)

;; Use OSX clipboard
(remove-hook 'doom-post-init-hook #'osx-clipboard-mode)

;; Set nose-mode when using pyton
(add-hook! python-mode (nose-mode))

;; LSP
(setq lsp-ui-doc-show-with-cursor 1)

;; Disable git in dired, enabled causes delay in navigating
(setq dired-git-info-mode nil)

;; auto refresh dired when file changes
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; auto revert modes
(setq global-auto-revert-mode 1)
(setq auto-revert-remote-files 1)

;; Indent styles
(setq
  standard-indent 2
  tab-width 2
  indent-tabs-mode nil
  lisp-indent-offset 2
  )

;; Set localleader to ,
(setq doom-leader-key "SPC"
      doom-localleader-key ",")

;; Set spell correction language
(setq ispell-dictionary "en")

;; Org mode
(setq org-log-done 'time)
(setq org-html-checkbox-type 'html)

(setq org-todo-keyword-faces
  '(
     ("HOLD" . "orange")
     ("WAIT" . "red")
     ("STRT" . "red")
     ;; ("CANCELED" . (:foreground "blue" :weight bold))
     ))

;; Global Key Mappings
;; -----------------------------------------------------------------------------
(map! :leader
  :desc "Start Ranger"
  "o r" #'ranger)

(map! :leader
  :desc "Previous Buffer"
  "TAB" #'evil-switch-to-windows-last-buffer)

(map! :leader
  :desc "Resume search"
  "s l" #'vertico-repeat)

;; Local Leader Key Mappings
;; -----------------------------------------------------------------------------
(map! :localleader
      :map org-mode-map
      (:prefix ("s" . "tree/subtree")
      "i" #'+org/insert-item-below))

;; From packages.el
;; -----------------------------------------------------------------------------
(beacon-mode 1)
