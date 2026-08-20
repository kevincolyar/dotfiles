;;; -*- lexical-binding: t; -*-
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq  evil-want-Y-yank-to-eol t)
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

  ;; The `eldoc-box-hover-at-point-mode' childframe (config/eldoc.el) is
  ;; transient and capped at a third of the frame height, so it truncates long
  ;; docstrings. K toggles a real window on the same documentation, which
  ;; scrolls and can show examples in full. `eldoc-display-in-buffer' stays on
  ;; `eldoc-display-functions' while eldoc-box is active, so the box and this
  ;; buffer are fed from the same request -- the hover box keeps working
  ;; untouched. `helpful-at-point' above remains K in buffers without eldoc.
  (defun my-eldoc-toggle ()
    "Toggle a window showing the full eldoc documentation buffer."
    (interactive)
    (let ((win (and (buffer-live-p eldoc--doc-buffer)
                    (get-buffer-window eldoc--doc-buffer))))
      (if win
          (quit-window nil win)
        ;; INTERACTIVE t makes eldoc recompute and hand the docs to
        ;; `eldoc-display-in-buffer', which creates `eldoc--doc-buffer' and
        ;; displays it. Going through eldoc rather than `eldoc-doc-buffer'
        ;; avoids its `user-error' when nothing has been documented yet.
        (eldoc-print-current-symbol-info t)
        (when-let* ((new (and (buffer-live-p eldoc--doc-buffer)
                              (get-buffer-window eldoc--doc-buffer))))
          ;; Select it so it can be scrolled straight away; `q' quits back.
          (select-window new)))))

  (evil-define-key 'normal 'eldoc-mode "K" 'my-eldoc-toggle)

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

;;; Use escape to escape from everything
(use-package evil-escape
  :ensure
  :after evil)
