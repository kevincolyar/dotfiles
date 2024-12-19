 (use-package format-all
   :commands format-all-mode
   :hook
   (prog-mode . format-all-mode)
   :config
   (setq-default
    format-all-formatters
    '(
      ("C"     (astyle "--mode=c"))
      ("Shell" (shfmt "-i" "4" "-ci"))
      ("Python" ruff)
      ("Rust" rustfmt)
      ;; ("Ruby" rufo)
      ("Ruby" rubocop)
      )))

;; EXAMPLE: Add to dir-locals.el to disable for project
;; ((nil . ((eval .
;;           (format-all-mode 0)
;;           ))))
