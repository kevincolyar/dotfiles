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
