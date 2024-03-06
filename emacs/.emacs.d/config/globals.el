(use-package auto-package-update)
(use-package better-defaults)
(use-package no-littering)
;; Below is more useful for GUI emacs
;; (use-package exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-initialize) ; Load path from shell $PATH
;;   )

; (scroll-bar-mode -1) ; Disable the visible scrollbar
(tool-bar-mode -1) ; Disable the Toolbar
(tooltip-mode -1) ; Disable tooltips
; (set-fringe-mode 10) ;
(menu-bar-mode -1) ; Disable menu bar
(ido-mode -1) ; Disable ido mode
(global-hl-line-mode 1) ;; Highlight cursor line
(column-number-mode)
(global-display-line-numbers-mode 1)
(recentf-mode 1) ;; Save recent files
(setq recentf-auto-cleanup 'never)

;; Max echo area height
(setq max-mini-window-height 10)


;; Ignore case when using completion system (emacs, vertico, etc)
(setq completion-ignore-case t)

;; Profile startup. Use M-x use-package-report to see times. 
;; emacs -f use-package-report
(setq use-package-compute-statistics t)

;; Update files and buffers when changed
(global-auto-revert-mode 1) ; Revert buffers when the underlying file has changed
(setq auto-revert-remote-files t) ; Also revert tramp files when changed, too
(setq global-auto-revert-non-file-buffers t) ; Also revert dired buffers

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
;; (setq auto-save-file-name-transforms `(("." . "~/.emacs.d/backups")) t)
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq
 fill-column  80
 tab-width 2
 visible-bell nil
 ring-bell-function 'ignore
 )                         ; Set width for automatic line breaks

;; Supress compilation warnings
(setq warning-suppress-types '(comp))

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))
