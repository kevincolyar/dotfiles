;;; gptel --- Summary  -*- lexical-binding: t; -*-

(use-package gptel
  :general
  (:states '(normal visual)
    :prefix "SPC"
    "aa"  'gptel-abort
    "ab"  'gptel
    "ae"  'gptel-end-of-response
    "as"  'gptel-send
    "am"  'gptel-menu
    "ap"  'gptel-preset
    "ar"  'gptel-rewrite
    "ao"  'gptel-org-set-properties
    )

  ;; `:general' emits autoloads for the commands it binds, so gptel is
  ;; deferred -- config/gptel.el itself costs 0.001s at startup. The cost lands
  ;; on the first gptel command instead: 0.202s, of which 0.184s is Emacs's own
  ;; `url' stack (url, url-cookie, url-util, url-parse, auth-source, mailcap,
  ;; url-methods, url-history, ...) which gptel requires at top level. Warm it
  ;; once the session goes idle so the first invocation is instant, without
  ;; putting any of it back on the startup path.
  :init
  (run-with-idle-timer 2 nil (lambda () (require 'gptel nil t)))

  ;; :hook
  ;; ((org-mode . (lambda ()
  ;;                (setq-local gptel-backend (gptel-make-openai "llama-cpp-gemma3"
  ;;                                            :stream t
  ;;                                            :protocol "http"
  ;;                                            :host "127.0.0.1:7072"
  ;;                                            :models '(gemma3)))
  ;;                (message "GPTel gemma3 for Org mode")))
  ;;  (prog-mode . (lambda ()
  ;;                 (setq-local gptel-backend (gptel-make-openai "llama-cpp-qwen3-coder"
  ;;                                             :stream t
  ;;                                             :protocol "http"
  ;;                                             :host "127.0.0.1:7072"
  ;;                                             :models '(qwen3-coder)))
  ;;                 (message "GPTel set to qwen3-coder for code"))))

  :config
  
  ;; gptel, don't highlight context 
  (set-face-attribute 'gptel-response-highlight nil :background "unspecified")

  ;; Remove default gpt models
  ;; (setq  gptel--known-backends nil)

  ;; Don't use proxy for localhost connections (e.g. Ollama, Llama.cpp)
  (setenv "NO_PROXY" "localhost,127.0.0.1")

  (gptel-make-anthropic "Claude"
    :stream t
    :key (gptel-api-key-from-auth-source "api.anthropic.com"))

    ;; Cerebras offers an instant OpenAI compatible API
  (gptel-make-openai "Cerebras"
    :host "api.cerebras.ai"
    :endpoint "/v1/chat/completions"
    :stream t                             ;optionally nil as Cerebras is instant AI
    :key (gptel-api-key-from-auth-source "api.cerebras.ai")  ;can be a function that returns the key
    :models '(llama3.3-70b
                llama3.3-8b))


  ;; Setup Llama.cpp
  ;; ---------------------------------------------------------------------------
  ;; Llama.cpp offers an OpenAI compatible API
  (gptel-make-openai "llama-cpp-7071"
    :stream t
    :protocol "http"
    :host "127.0.0.1:7071"
    :models '(qwen3-coder))

  (gptel-make-openai "llama-cpp-7072"
    :stream t
    :protocol "http"
    :host "127.0.0.1:7072"
    :models '(gemma3))

  ;; Setup Ollama
  ;; ---------------------------------------------------------------------------
  (gptel-make-ollama "Ollama"
    :host "localhost:11434"
    :stream t
    ;; First model is default
    :models '("gemma4:12b-mlx" "qwen3.5:35b-a3b-coding-nvfp4"))

  ;; Presets
  ;; ---------------------------------------------------------------------------
  (gptel-make-preset 'ollama-gemma-4
    :description "Ollama - Gemma 4"
    :backend "Ollama"
    :model 'gemma4:12b-mlx
    :system "You are a large language model living in Emacs and a helpful assistant. Respond concisely.")

  (gptel-make-preset 'ollama-gemma-4-coder
    :description "Ollama - Gemma 4"
    :backend "Ollama"
    :model 'gemma4:12b-mlx
    :system "You are an expert coding assistant living in Emacs. Your role is to provide high-quality code solutions, refactoring, testing, and explanations.")

  (gptel-make-preset 'ollama-qwen-3.5-coder
    :description "Ollama - Qwen 3.5 Coder"
    :backend "Ollama"
    ;; :model 'qwen3.5:35b-a3b-coding-nvfp4
    :model 'qwen3.5:9b
    :system "You are an expert coding assistant living in Emacs. Your role is to provide high-quality code solutions, refactoring, testing, and explanations.")

  (gptel-make-preset 'ollama-qwen-3.6-coder
    :description "Ollama - Qwen 3.6 Coder"
    :backend "Ollama"
    :model 'qwen3.6:27b-mlx
    :system "You are an expert coding assistant living in Emacs. Your role is to provide high-quality code solutions, refactoring, testing, and explanations.")

  (gptel-make-preset 'claude-opus
    :description "Claude Opus 4.8"
    :backend "Claude"
    :model 'claude-opus-4-8
    :system "You are a large language model living in Emacs and a helpful assistant. Respond concisely.")

  ;; Claude Coding
  (gptel-make-preset 'claude-sonnet
    :description "Claude Sonnet 4.8 (coding model)"
    :backend "Claude"
    :model 'claude-sonnet-4-8
    :system "You are an expert coding assistant living in Emacs. Your role is to provide high-quality code solutions, refactoring, testing, and explanations.")

  ;; Claude Fable Coding
  (gptel-make-preset 'claude-sonnet
    :description "Claude Fable 5 (coding model)"
    :backend "Claude"
    :model 'claude-fable-5
    :system "You are an expert coding assistant living in Emacs. Your role is to provide high-quality code solutions, refactoring, testing, and explanations.")

  (gptel-make-preset 'coder
    :description "Preset for coding tasks"
    :backend "llama-cpp-7071"
    :model 'qwen3-coder
    :system "You are an expert coding assistant living in Emacs. Your role is to provide high-quality code solutions, refactorings, and explanations.")

  (gptel-make-preset 'theology
    :description "Preset for theological study"
    :backend "llama-cpp-7072"
    :model 'gemma4:12b
    :system "You are an expert theologian and bible historian living in Emacs. Your role is to provide high-quality theological and biblical explanations.")

  (gptel-make-preset 'finance
    :description "Preset for finance study"
    :backend "Ollama"
    :model 'gemma4:12b
    :system "You are an expert financial advisor living in Emacs. Your role is to provide high-quality financial advice and explanations.")

  ;; Setup Backend
  (setq
   gptel-backend (gptel-get-backend "Ollama")
   gptel-default-mode 'org-mode
   gptel-org-set-topic t
   gptel-track-media t
   gptel-include-reasoning "gptel-reasoning" ;; Write reasoning to this buffer
   gptel-proxy "socks5://127.0.0.1:8082"
   gptel-post-response-functions nil ;; Don't flash the response when done.
   )

  (custom-set-faces
   '(pulse-highlight-start-face ((t (:background "#222233")))))
  )
