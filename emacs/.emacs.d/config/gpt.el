(use-package gptel
  :general
  (:states '(normal visual)
    :prefix "SPC"
    "ab"  'gptel
    "as"  'gptel-send
    "am"  'gptel-menu
    )
  :config

  (setq gptel-default-mode 'org-mode)
  (custom-set-faces
   '(pulse-highlight-start-face ((t (:background "#222233")))))
  )
