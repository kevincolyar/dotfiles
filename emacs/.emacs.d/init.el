;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(when (< emacs-major-version 27) (package-initialize))

(require 'use-package)
(setq use-package-always-ensure t)
(setq inhibit-startup-screen t)

;; (unless package-archive-contents
;;   (package-refresh-contents))

(load "~/.emacs.d/config/globals.el")
(load "~/.emacs.d/config/evil.el")
(load "~/.emacs.d/config/ui.el")
(load "~/.emacs.d/config/key-mapping.el")
(load "~/.emacs.d/config/crux.el")

;; Command/File/Buffer Completion
(load "~/.emacs.d/config/vertico.el")
(load "~/.emacs.d/config/consult.el")
(load "~/.emacs.d/config/marginalia.el")
(load "~/.emacs.d/config/orderless.el")
(load "~/.emacs.d/config/misc.el")
(load "~/.emacs.d/config/projectile.el")
(load "~/.emacs.d/config/tempel.el")
(load "~/.emacs.d/config/corfu.el")

;; Development
(load "~/.emacs.d/config/ruby.el")
(load "~/.emacs.d/config/tree-sitter.el")
(load "~/.emacs.d/config/eglot.el")
(load "~/.emacs.d/config/rust.el")
(load "~/.emacs.d/config/typescript.el")
(load "~/.emacs.d/config/python.el")
(load "~/.emacs.d/config/langs.el")
(load "~/.emacs.d/config/flycheck.el")
(load "~/.emacs.d/config/dape.el")
(load "~/.emacs.d/config/spell.el")
;; (load "~/.emacs.d/config/yas-snippet.el")
(load "~/.emacs.d/config/dumb-jump.el")
(load "~/.emacs.d/config/format-all.el")
(load "~/.emacs.d/config/eldoc.el")
;; (load "~/.emacs.d/config/ellama.el")
(load "~/.emacs.d/config/gpt.el")
(load "~/.emacs.d/config/nix.el")

;; Org
(load "~/.emacs.d/config/orgmode.el")
(load "~/.emacs.d/config/embark.el")
(load "~/.emacs.d/config/tramp.el")

;; Don't let Emacs' customize system pollute our configs
(setq custom-file "~/.emacs.d/custom-vars.el")
(load custom-file 'noerror 'nomessage)

;; Load private config
(setq-default private-config (expand-file-name "~/.emacs.private"))
(when (file-exists-p private-config)
  (load-file private-config))
