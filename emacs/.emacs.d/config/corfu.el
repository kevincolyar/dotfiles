;; Corfu enhances in-buffer completion with a small completion popup.
;; https://github.com/minad/corfu
;; https://youtu.be/Vx0bSKF4y78?t=570

(use-package corfu
  :general
  (:keymaps 'corfu-map
            "C-j" #'corfu-next
            "C-k" #'corfu-previous
            "C-u" #'corfu-scroll-up
            "C-d" #'corfu-scroll-down
            "C-[" #'corfu-quit)
  :init
  (setq corfu-auto t                           ;; Enable auto completion
        corfu-cycle t                          ;; Enable cycling for `corfu-next/previous'
        corfu-quit-no-match 'separator         ;; or t
        ;; corfu-auto-prefix 2
        ;; corfu-auto-delay 0.0
        corfu-echo-documentation 0.25
        corfu-preview-current 'insert
        corfu-preselect-first nil
        corfu-min-width 100
        corfu-max-width corfu-min-width
        )       ; Always have the same width
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode) ;; TODO not working in terminal yet
  :config
  (corfu-mode))

(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; DISABLED: messing up cursor location
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; (add-to-list 'completion-at-point-functions #'cape-file)
  )

(use-package quelpa
  :defer t
  :config
  (setq quelpa-update-melpa-p nil)) ;; Don't update at startup

(quelpa '(popon :fetcher git
                :url "https://codeberg.org/akib/emacs-popon.git"))

(quelpa '(corfu-terminal
          :fetcher git
          :url "https://codeberg.org/akib/emacs-corfu-terminal.git"))

;; Currently broken
;; (quelpa '(corfu-doc-terminal
;;           :fetcher git
;;           :url "https://codeberg.org/akib/emacs-corfu-doc-terminal.git"))

(unless (display-graphic-p)
  (corfu-terminal-mode +1))

(use-package nerd-icons-corfu
  :defer t)

(add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
