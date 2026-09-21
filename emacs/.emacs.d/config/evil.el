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
  ;; transient and capped at two thirds of the frame height, so it still
  ;; truncates the longest docstrings. K toggles a real window on the same
  ;; documentation, which scrolls and can show examples in full.
  ;; `eldoc-display-in-buffer' stays on
  ;; `eldoc-display-functions' while eldoc-box is active, so the box and this
  ;; buffer are fed from the same request -- the hover box keeps working
  ;; untouched. `helpful-at-point' above remains K in buffers without eldoc.
  ;;
  ;; The selection has to happen on the display side: with the callback
  ;; protocol `eldoc--invoke-strategy' only promises that some callback will
  ;; eventually run `eldoc-display-functions' (eldoc.el:918-927, 957-968), so
  ;; for eglot `eldoc-print-current-symbol-info' returns before the LSP reply
  ;; exists and there is no window to select yet -- selecting straight after
  ;; the call only ever worked for synchronous backends such as elisp's.
  ;;
  ;; The hook must be buffer-local: `eldoc-box--enable' replaces
  ;; `eldoc-display-functions' with a `setq-local' copy that has no `t' in it
  ;; (eldoc-box.el:293-298), so global members are not run in these buffers.
  ;; `add-hook' with LOCAL only appends `t' when it has to create the local
  ;; value, hence eldoc-box's removal of `eldoc-display-in-echo-area' stands.
  (defun my-eldoc--select-doc-window (_docs interactive)
    "Select the window `eldoc-display-in-buffer' opened for the docs.
One-shot member of `eldoc-display-functions' installed by
`my-eldoc-toggle'.  INTERACTIVE tells that request apart from the idle
ones, which must not move the cursor."
    (when interactive
      (remove-hook 'eldoc-display-functions #'my-eldoc--select-doc-window t)
      ;; Async docs can arrive after the cursor has left for another window;
      ;; only follow them while point is still where K was pressed.
      (when-let* (((eq (window-buffer) (current-buffer)))
                  (win (and (buffer-live-p eldoc--doc-buffer)
                            (get-buffer-window eldoc--doc-buffer))))
        ;; Select it so it can be scrolled straight away; `q' quits back.
        (select-window win))))

  (defun my-eldoc-toggle ()
    "Toggle a window showing the full eldoc documentation buffer."
    (interactive)
    (let ((win (and (buffer-live-p eldoc--doc-buffer)
                    (get-buffer-window eldoc--doc-buffer))))
      (if win
          (quit-window nil win)
        ;; Depth 90 appends, keeping it behind `eldoc-display-in-buffer'.
        (add-hook 'eldoc-display-functions #'my-eldoc--select-doc-window 90 t)
        ;; INTERACTIVE t makes eldoc recompute and hand the docs to
        ;; `eldoc-display-in-buffer', which creates `eldoc--doc-buffer' and
        ;; displays it. Going through eldoc rather than `eldoc-doc-buffer'
        ;; avoids its `user-error' when nothing has been documented yet.
        (eldoc-print-current-symbol-info t))))

  ;; The doc buffer is a `special-mode' buffer (eldoc.el:536), not an
  ;; `eldoc-mode' one, so the `evil-define-key' below never reached it and K
  ;; there still ran the global `helpful-at-point'. Bind it in the buffer's
  ;; evil local maps, which outrank both the global state maps and
  ;; evil-collection's `special-mode' bindings. `eldoc--format-doc-buffer'
  ;; re-runs `special-mode' on every refresh; the local state maps are
  ;; permanent-local so they survive its `kill-all-local-variables', and
  ;; re-binding is idempotent anyway. Motion state is covered too in case the
  ;; buffer is not in normal state.
  (defun my-eldoc--bind-toggle-key (&rest _)
    "Bind K to `my-eldoc-toggle' inside `eldoc--doc-buffer'."
    (when (buffer-live-p eldoc--doc-buffer)
      (with-current-buffer eldoc--doc-buffer
        (evil-local-set-key 'normal "K" #'my-eldoc-toggle)
        (evil-local-set-key 'motion "K" #'my-eldoc-toggle))))

  ;; `:after' runs outside the function's own `with-current-buffer', hence the
  ;; explicit one above.
  (advice-add 'eldoc--format-doc-buffer :after #'my-eldoc--bind-toggle-key)

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
