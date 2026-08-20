;;; -*- lexical-binding: t; -*-
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
  ;; `:general' emits autoloads for the commands it binds, which makes
  ;; use-package defer the package. Every binding above lives in `corfu-map',
  ;; which only exists while a popup is open, so nothing could ever trigger the
  ;; load and `:config' below never ran. Corfu has to be globally active from
  ;; startup anyway, so demand it.
  :demand t
  :init
  (setq corfu-auto t                           ;; Enable auto completion, required for eglot methods, etc
        corfu-cycle t                          ;; Enable cycling for `corfu-next/previous'
        corfu-quit-no-match 'separator         ;; or t
        corfu-auto-prefix 2
        ;; corfu-auto-delay 0.0
        corfu-popupinfo-delay 0.25             ;; docs popup; was `corfu-echo-documentation'
        corfu-preview-current 'insert
        corfu-preselect 'prompt                ;; replaces `corfu-preselect-first' nil
        corfu-min-width 100
        corfu-max-width corfu-min-width
        )       ; Always have the same width
  :config
  (global-corfu-mode)
  ;; Emacs 31 provides `tty-child-frames', which is what `corfu--popup-support-p'
  ;; checks, so the doc popup now renders in terminal frames too.
  (corfu-popupinfo-mode)
  ;; (corfu-history-mode)
  )

;; Cape provides Completion At Point Extensions which can be used in combination with Corfu, Company or the default completion UI.
;; https://kristofferbalintona.me/posts/202203130102/#adding-backends-to-completion-at-point-functions
(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; DISABLED: messing up cursor location
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  )

;; (straight-use-package
;;  '(popon
;;    :type git
;;    :repo "https://codeberg.org/akib/emacs-popon.git"))

;; ;; NOTE: Corfu relies on child frames to show the popup. On Emacs 31 this works even for terminal Emacs, but support is still experimental. Use the corfu-terminal package on older Emacs versions.
;; (straight-use-package
;;  '(corfu-terminal
;;    :type git
;;    :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))

;; Currently broken
;; (quelpa '(corfu-doc-terminal
;;           :fetcher git
;;           :url "https://codeberg.org/akib/emacs-corfu-doc-terminal.git"))

;; (unless (display-graphic-p)
;;   (corfu-terminal-mode +1))

(use-package nerd-icons-corfu
  :defer t)

(unless (display-graphic-p)
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
