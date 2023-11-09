(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-undo-system 'undo-fu)
  ;; https://evil.readthedocs.io/en/latest/faq.html#problems-with-the-escape-key-in-the-terminal
  (setq evil-esc-delay 0)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
					; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-global-set-key 'normal "K" 'helpful-at-point)

  ;; (evil-define-key 'normal 'lsp-mode "K" 'lsp-describe-thing-at-point)
  ;; (evil-define-key 'normal 'lsp-mode "K" 'lsp-ui-doc-glance)
  (evil-define-key 'normal 'eldoc-mode "K" 'eldoc)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)

  )

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :init (evil-commentary-mode))
