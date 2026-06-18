;;; ui --- Summary
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
  (pcase system-type
    ('darwin
     (string= "Dark"
              (string-trim
               (shell-command-to-string
                "defaults read -g AppleInterfaceStyle 2>/dev/null"))))
    (_ t)))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(use-package autothemer
  :config
  (load-theme 'doom-rose-pine-moon t)
  (load-theme 'doom-rose-pine-dawn t)
  :init
  ;; Set light/dark theme based on system
  (if (my/system-dark-mode-p)
      (load-theme 'rose-pine-moon t)
    (load-theme 'rose-pine-dawn t))
  )

(use-package auto-dark
  :ensure t
  :custom
  (auto-dark-themes '((doom-rose-pine-moon) (doom-rose-pine-dawn)))
  (auto-dark-polling-interval-seconds 2)
  :init
  (progn
    ;; Only enable for MacOS
    (when (eq system-type 'darwin)
      (setq auto-dark-allow-osascript t)
      (auto-dark-mode))))

;; Make background transparent
(unless (display-graphic-p)
  (set-face-background 'default "unspecified-bg"))
;; (defun kc-transparent-bg ()
;;     (set-face-background 'default "unspecified-bg"))

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


;;; ui.el ends here
