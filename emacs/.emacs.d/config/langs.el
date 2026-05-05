(use-package markdown-mode
  :defer t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package dockerfile-mode :defer t)
(use-package yaml-mode :defer t)
(use-package toml-mode :defer t)
(use-package lua-mode :defer t)
(use-package go-mode :defer t)
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

(use-package poly-markdown :defer t)
(use-package poly-ruby :defer t)

;; Make ruby-mode define '_' as part of a word, not a symbol (e.g. when using *)
(add-hook 'ruby-mode-hook
          (lambda ()
            (superword-mode 1)
            (modify-syntax-entry ?_ "w")))

(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb" . poly-ruby-mode))

(defun platformio-conditionally-enable ()
  "Enable PlatformIO mode if platformio.ini exists in project root."
  (when (locate-dominating-file default-directory "platformio.ini")
    (platformio-mode 1)))

(use-package platformio-mode
  :ensure t
  :hook (c++-mode . platformio-conditionally-enable))

