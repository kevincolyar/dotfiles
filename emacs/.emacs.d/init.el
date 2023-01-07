;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Load private config
(setq-default private-config (expand-file-name "~/.emacs.private"))
(when (file-exists-p private-config)
  (load-file private-config))

(load "~/.emacs.d/config/globals.el")
(load "~/.emacs.d/config/evil.el")
(load "~/.emacs.d/config/ui.el")
(load "~/.emacs.d/config/key-mapping.el")

;; Command/File/Buffer Completion  (eg: ivy, helm, ido, etc)
;; (load "~/.emacs.d/config/ivy.el")
(load "~/.emacs.d/config/vertico.el")
(load "~/.emacs.d/config/marginalia.el")
(load "~/.emacs.d/config/orderless.el")

(load "~/.emacs.d/config/misc.el")
(load "~/.emacs.d/config/projectile.el")
(load "~/.emacs.d/config/lsp.el")
;; (load "~/.emacs.d/config/dap.el")
(load "~/.emacs.d/config/tree-sitter.el")
;; (load "~/.emacs.d/config/ruby.el")
;; (load "~/.emacs.d/config/python.el")
(load "~/.emacs.d/config/rust.el")
(load "~/.emacs.d/config/typescript.el")
(load "~/.emacs.d/config/langs.el")
(load "~/.emacs.d/config/flycheck.el")
(load "~/.emacs.d/config/spell.el")
(load "~/.emacs.d/config/yas-snippet.el")
(load "~/.emacs.d/config/dumb-jump.el")
(load "~/.emacs.d/config/orgmode.el")
(load "~/.emacs.d/config/embark.el")
(load "~/.emacs.d/config/tramp.el")

;; Code Completion (eg: company, corfu, etc)
(load "~/.emacs.d/config/company.el")
;; (load "~/.emacs.d/config/corfu.el")

;; Don't let Emacs' customize system pollute our configs
(setq custom-file "~/.emacs.d/custom-vars.el")
(load custom-file 'noerror 'nomessage)
