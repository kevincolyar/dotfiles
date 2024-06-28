(use-package markdown-mode
  :defer t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package dockerfile-mode :defer t)
(use-package yaml-mode :defer t)
(use-package toml-mode :defer t)
(use-package lua-mode :defer t)
(use-package go-mode :defer t)

(use-package poly-markdown :defer t)
(use-package poly-ruby :defer t)

(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.erb" . poly-ruby-mode))

;; Code folding
(use-package origami
  :init (global-origami-mode))
