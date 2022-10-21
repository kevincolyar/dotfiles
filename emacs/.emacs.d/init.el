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

;; Command/File/Buffer Completion  (eg: ivy, helm, ido, etc)
(load "~/.emacs.d/config/ivy.el")
;; (load "~/.emacs.d/config/vertico.el")

;; Code Completion (eg: company, corfu, etc)
;; (load "~/.emacs.d/config/completion.el")
(load "~/.emacs.d/config/corfu.el")

(load "~/.emacs.d/config/misc.el")
(load "~/.emacs.d/config/projectile.el")
(load "~/.emacs.d/config/lsp.el")
;; (load "~/.emacs.d/config/ruby.el")
;; (load "~/.emacs.d/config/python.el")
(load "~/.emacs.d/config/rust.el")
(load "~/.emacs.d/config/langs.el")
(load "~/.emacs.d/config/key-mapping.el")
(load "~/.emacs.d/config/spell.el")
(load "~/.emacs.d/config/orgmode.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(better-defaults selectrum yasnippet xclip which-key use-package undo-tree undo-fu-session undo-fu tree-sitter-langs rustic rainbow-delimiters org-bullets no-littering marginalia magit lsp-ui lsp-ivy ivy-rich helpful git-gutter-fringe general flycheck evil-terminal-cursor-changer evil-commentary evil-collection embark-consult dumb-jump doom-themes doom-modeline dockerfile-mode dap-mode counsel-projectile company command-log-mode all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
