;; https://github.com/minad/corfu
;; https://youtu.be/Vx0bSKF4y78?t=570

(use-package corfu
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (org-mode . corfu-mode))
  :bind
  (:map corfu-map
        ("C-j" . corfu-next)
        ("C-k" . corfu-previous))
  ;; :general
  ;; (evil-insert-state-map "C-k" nil)
  :custom
  (setq corfu-auto t)                 ;; Enable auto completion
  (setq corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (setq corfu-auto-prefix 2 )
  (setq corfu-auto-delay 0.0)
  (setq corfu-echo-documentation 0.25)
  (setq corfu-preview-current 'insert)
  (setq corfu-preselect-first nil)
  (setq corfu-min-width 80)
  (setq corfu-max-width corfu-min-width)       ; Always have the same width
  ;; Enable auto completion and configure quitting
  ;; (setq corfu-auto t
  ;;       corfu-quit-no-match 'separator) ;; or t
  :init
  (global-corfu-mode)
  (corfu-terminal-mode)
  (corfu-doc-terminal-mode)
  (corfu-history-mode)
  :config
  (corfu-mode))

(use-package cape
:init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package quelpa
  :config
  (setq quelpa-update-melpa-p nil)) ;; Don't update at startup

;; (quelpa '(popon :fetcher git
;;                 :url "https://codeberg.org/akib/emacs-popon.git"))

(use-package popon)

(quelpa '(corfu-terminal
          :fetcher git
          :url "https://codeberg.org/akib/emacs-corfu-terminal.git"))
(quelpa '(corfu-doc-terminal
          :fetcher git
          :url "https://codeberg.org/akib/emacs-corfu-doc-terminal.git"))
