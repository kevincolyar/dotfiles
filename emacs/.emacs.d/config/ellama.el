
;; After ollama is installed via brew, run
;; ollama pull zephyr

(use-package ellama
  :general
  (nmap
    :keymaps 'override
    :prefix "SPC"
    "ah"  'ellama-chat
    "ad"  'ellama-define-word
    "al"  'ellama-ask-line
    ;; "as"  'ellama-ask-selection
    "acc" 'ellama-code-complete
    "aci" 'ellama-code-improve
    "acr" 'ellama-code-review
    )
  )
