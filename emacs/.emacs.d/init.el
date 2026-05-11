;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install and integrate use-package with straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t) ;; replaces :ensure t

(load "~/.emacs.d/config/globals.el")
(load "~/.emacs.d/config/evil.el")
(load "~/.emacs.d/config/ui.el")
(load "~/.emacs.d/config/key-mapping.el")
(load "~/.emacs.d/config/crux.el")
(load "~/.emacs.d/config/kirigami.el")

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
(load "~/.emacs.d/config/jinx.el")
(load "~/.emacs.d/config/dumb-jump.el")
(load "~/.emacs.d/config/format-all.el")
(load "~/.emacs.d/config/eldoc.el")
(load "~/.emacs.d/config/nix.el")

;; Org
(load "~/.emacs.d/config/orgmode.el")
(load "~/.emacs.d/config/embark.el")
(load "~/.emacs.d/config/tramp.el")

;; Don't let Emacs' customize system pollute our configs
(setq custom-file "~/.emacs.d/custom-vars.el")
(load custom-file 'noerror 'nomessage)

;; Load private config
(setq-default private-config (expand-file-name "~/.emacs.private.gpg"))
(when (file-exists-p private-config)
  (load-file private-config))
