(use-package markdown-mode
  :defer t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package dockerfile-mode :defer t)
(use-package yaml-mode :defer t)
(use-package toml-mode :defer t)
(use-package lua-mode :defer t)

;; Code folding
(use-package origami
  :init (global-origami-mode))
