;;; ui --- Summary
;;; Commentary:
;;; Code:

(use-package doom-modeline
  ;; :after eglot
  :config (doom-modeline-mode 1))

;; (use-package smart-mode-line)

;; (use-package beacon
;;   :init (beacon-mode 1))

(use-package rainbow-delimiters
  :defer t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-themes
  :config
  ;; (load-theme 'doom-Iosvkem t)
  ;; (load-theme 'doom-pine t)
  (load-theme 'doom-sourcerer t)
  ;; (load-theme 'doom-dark+ t))
  ;; (load-theme 'doom-nord t)
;;   (load-theme 'doom-rouge t)
;;   ;; (load-theme 'doom-one t)
;;   ;; (doom-themes-visual-bell-config)
;;   (doom-themes-org-config))
  )

;; (use-package kaolin-themes
;;   :config
;;   ;; (load-theme 'kaolin-dark t)
;;   (load-theme 'kaolin-shiva t))

;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (use-package autothemer
;;   :config
;;   (load-theme 'oxocarbon t))

;; Make background transparent
(unless (display-graphic-p)
  (set-face-background 'default "unspecified-bg"))
;; (defun kc-transparent-bg ()
;;     (set-face-background 'default "unspecified-bg"))

;; GUI Settings
(if (display-graphic-p)
    (set-frame-font "Fisa Code 16" nil t)
    (setq default-frame-alist '((width . 80) (height . 24))))

(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(use-package nerd-icons
  :defer t)

;;; ui.el ends here
