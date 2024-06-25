;; https://github.com/joaotavora/yasnippet
;; Use TAB to expand snippet
(use-package yasnippet
  :defer 10 ;; takes a while to load, so do it async
  :diminish (yas-minor-mode)
  :config (yas-global-mode)
  :custom (yas-prompt-functions '(yas-completing-prompt))
  
  :general
  (:states '(normal visual)
    :prefix "SPC"
    "ys"   'consult-yasnippet
    )
  
  :hook (
         (rust-mode . yas-minor-mode)
         (python-mode . yas-minor-mode)
         (javascript-mode . yas-minor-mode)
         (ruby-mode . yas-minor-mode)
         (lsp-mode . yas-minor-mode)
         ))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package yasnippet-capf
  :defer t
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))
