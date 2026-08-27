;;; agent-shell --- Summary  -*- lexical-binding: t; -*-
(use-package agent-shell
  :defer t
  :config
  (setq agent-shell-preferred-agent-config (agent-shell-omp-make-agent-config))
  ;; Suppress the ASCII-art/welcome banner written into each new shell buffer.
  (setq agent-shell-show-welcome-message nil)

  ;; Stream reasoning in the open.  Response text (`agent_message_chunk')
  ;; already renders inline with no header, but thought chunks default to a
  ;; collapsed "Thinking" section, so the agent's narration is invisible until
  ;; manually expanded.  `agent-shell-activity-group-expand-by-default' stays
  ;; at `latest', so the group folds back once the agent moves on: live while
  ;; it happens, tidy afterwards.  Tool use stays collapsed
  ;; (`agent-shell-tool-use-expand-by-default' nil) -- diffs and command
  ;; output are the bulky part, not the reasoning.
  (setq agent-shell-thought-process-expand-by-default t)

  ;; C-j / C-k step through items (prompts, tool-call blocks, images, links),
  ;; matching the C-j/C-k = next/previous convention already used for corfu,
  ;; vertico and tempel.  `agent-shell-mode-map' only ships TAB/<backtab> for
  ;; this, and evil-collection binds nothing here (its `next-section-2' /
  ;; `prev-section-2' aliases are C-j/C-k, but the agent-shell module skips
  ;; them).
  ;;
  ;; Normal state only: insert state is for typing the prompt, where RET is
  ;; `newline' (see below) and C-j/C-k stay out of the way.
  (evil-define-key 'normal agent-shell-mode-map
    (kbd "C-j") #'agent-shell-next-item
    (kbd "C-k") #'agent-shell-previous-item)

  ;; S-RET submits, in both states.
  ;;
  ;; `evil-collection-shell-maker' binds RET/S-RET on `shell-maker-mode-map'
  ;; through the `repl-submit' / `repl-newline' / `repl-force-newline' roles:
  ;; with `evil-collection-repl-submit-state' at its default `normal', RET
  ;; submits in normal state, RET inserts a newline in insert state, and
  ;; S-RET is `newline' in both.  So typing a prompt and submitting it
  ;; otherwise means ESC RET.
  ;;
  ;; Those live in an evil auxiliary keymap, which outranks any plain
  ;; `agent-shell-mode-map' entry -- a `keymap-set' here would be dead.  The
  ;; override has to be an auxiliary binding on the derived map, which the
  ;; composed aux keymap consults before the inherited shell-maker one (this
  ;; is the escape hatch `evil-collection-shell-maker' documents).  RET keeps
  ;; inserting newlines in insert state.
  (evil-define-key '(normal insert) agent-shell-mode-map
    (kbd "S-<return>") #'agent-shell-submit))
