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
  :hook (prog-mode . indent-bars-mode))

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

;; Emacs turns on xterm's modifyOtherKeys (`\e[>4;1m', term/xterm.el), so tmux
;; reports S-SPC as `\e[27;2;32~'. xterm.el only decodes S-RET and S-TAB under
;; `\e[27;2;', so that sequence fell apart and its tail was inserted as text:
;; typing "TODO " with shift still held gave "TODO2~". Decode SPC with every
;; modifier combination. The parameter is 1 + a bit mask: shift 1, meta 2,
;; control 4. Unbound shifted keys fall back to their unshifted binding, so
;; S-SPC still self-inserts a space, and can be bound on its own.
;;
;; `xterm-function-map' rather than `input-decode-map': `terminal-init-xterm'
;; copies it into each new terminal's decode map, so every TTY frame
;; (emacsclient included) picks this up. The map is only modified after
;; term/xterm loads, which happens before that copy.
(with-eval-after-load 'term/xterm
  (dolist (mods '((2 shift) (3 meta) (4 meta shift) (5 control)
                  (6 control shift) (7 control meta) (8 control meta shift)))
    (define-key xterm-function-map (format "\e[27;%d;32~" (car mods))
                (vector (event-convert-list (append (cdr mods) '(?\s)))))))

;;; ui.el ends here
