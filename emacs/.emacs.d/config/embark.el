(use-package embark
  :defer t
  :general
  (nmap
    :keymaps 'override
    :prefix "SPC"
    "ea" 'embark-act
    "ed" 'embark-dwim
    "eb" 'embark-bindings)

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))
