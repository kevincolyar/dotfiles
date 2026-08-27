;;; -*- lexical-binding: t; -*-

(use-package markdown-ts-mode
  ;; Built-in on Emacs 31. `straight-use-package-by-default' would
  ;; install MELPA markdown-ts-mode, which errors on 31 and leaves
  ;; buffers in fundamental-mode.
  :straight nil
  :ensure nil
  :mode ("\\.md\\'" "\\.mdx\\'" "\\.markdown\\'")
  :config
  (require 'markdown-ts-mode-x))

(use-package clojure-mode :defer t)
(use-package basic-mode :defer t)

(use-package web-mode
  :defer t
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))

;; poly-markdown's autoload maps .md to itself. Fenced python chunks
;; then run python-ts-mode-hook → eglot-ensure → `ty` on the whole
;; markdown file. markdown-ts-mode fontifies and indents fences without
;; those hooks.
;; (use-package poly-markdown :defer t)
(use-package poly-ruby :defer t)

;; Make ruby-mode define '_' as part of a word, not a symbol (e.g. when using *)
(add-hook 'ruby-mode-hook
          (lambda ()
            (superword-mode 1)
            (modify-syntax-entry ?_ "w")))

;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb" . poly-ruby-mode))

(defun platformio-conditionally-enable ()
  "Enable PlatformIO mode if platformio.ini exists in project root."
  (when (locate-dominating-file default-directory "platformio.ini")
    (platformio-mode 1)))

(use-package platformio-mode
  :hook (c++-mode . platformio-conditionally-enable))

