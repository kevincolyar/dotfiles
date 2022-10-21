;;; ui --- Summary
;;; Commentary:
;;; Code:
(use-package doom-modeline
             :ensure t
             :init (doom-modeline-mode 1)
             :custom ((doom-modeline-height 15)))

;; Run the following interactively on a new install
;; M-x all-the-icons-install-fonts
;; TODO: Not sure if this is required for terminal emacs

(use-package all-the-icons
  :if (display-graphic-p))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; (use-package doom-themes
;;   :config
;;   ;; (load-theme 'doom-nord t)
;;   (load-theme 'doom-rouge t)
;;   ;; (load-theme 'doom-one t)
;;   ;; (doom-themes-visual-bell-config)
;;   (doom-themes-org-config))

(use-package kaolin-themes
  :config
  ;; (load-theme 'kaolin-dark t)
  (load-theme 'kaolin-shiva t))

;; Make background transparent
(set-face-background 'default "unspecified-bg")

;;; ui.el ends here
