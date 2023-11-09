 (use-package format-all
   :commands format-all-mode
   :hook
   (prog-mode . format-all-mode)
   ;; :config
   ;; (setq-default format-all-formatters '(("C"     (astyle "--mode=c"))
   ;;                                       ("Shell" (shfmt "-i" "4" "-ci")))))
   )
