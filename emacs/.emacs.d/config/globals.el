(use-package better-defaults)

(scroll-bar-mode -1) ; Disable the visible scrollbar
(tool-bar-mode -1) ; Disable the Toolbar
(tooltip-mode -1) ; Disable tooltips
(set-fringe-mode 10) ;
(menu-bar-mode -1) ; Disable menu bar
;; (global-hl-line-mode 1) ;; Highlight cursor line
(column-number-mode)
(global-display-line-numbers-mode 1)
(recentf-mode 1)
(setq recentf-auto-cleanup 'never)

;; store all backup and autosave files in the tmp dir
; (setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
; (setq auto-save-file-name-transforms `(("." . "~/.emacs.d/backups")) t)
; (setq backup-by-copying t)
; (setq delete-old-versions t
;   kept-new-versions 6
;   kept-old-versions 2
;   version-control t)

(setq
 fill-column  80
 visible-bell nil
 ring-bell-function 'ignore
 )                         ; Set width for automatic line breaks


;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))
