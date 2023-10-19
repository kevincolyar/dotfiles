;;; ui --- Summary
;;; Commentary:
;;; Code:
(use-package doom-modeline
             :ensure t
             :init (doom-modeline-mode 1)
             :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-Iosvkem t))
  ;; (load-theme 'doom-dark+ t))
  ;; (load-theme 'doom-nord t)
;;   (load-theme 'doom-rouge t)
;;   ;; (load-theme 'doom-one t)
;;   ;; (doom-themes-visual-bell-config)
;;   (doom-themes-org-config))

; (use-package kaolin-themes
;   :config
;   ;; (load-theme 'kaolin-dark t)
;   (load-theme 'kaolin-shiva t))

;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (use-package autothemer
;;   :config
;;   (load-theme 'oxocarbon t))

;; (use-package catppuccin-theme
;;   :config
;;   (load-theme 'catppuccin-mocha t))

;; Make background transparent
(set-face-background 'default "unspecified-bg")

(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;;; ui.el ends here
