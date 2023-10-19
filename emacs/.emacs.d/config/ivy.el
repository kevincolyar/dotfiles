;;Ivy is an interactive interface for completion in Emacs
;; https://github.com/abo-abo/swiper#ivy
(use-package ivy
             :ensure t
             :diminish
             :bind (("C-s" . swiper)
                    :map ivy-minibuffer-map
                    ("TAB" . ivy-alt-done)
                    ("C-l" . aviy-alt-done)
                    ("C-j" . ivy-next-line)
                    ("C-k" . ivy-previous-line)
		    :map ivy-switch-buffer-map
		    ("C-k" . ivy-previous-line)
		    ("C-l" . ivy-one)
		    ("C-d" . ivy-switch-buffer-kill)
		    :map ivy-reverse-i-search-map
                    ("C-k" . ivy-previous-line)
                    ("C-d" . ivy-reverse-i-search-kill))
             :config
             (setq ivy-height 25)
             (ivy-mode 1))

;; Counsel takes this further, providing versions of common Emacs commands that are customised to make the best use of Ivy.
;; https://github.com/abo-abo/swiper#counsel
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x Cf" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))

  :general
  (nmap
    :prefix "SPC"
    ":"   'counsel-M-x
    "/"   'counsel-rg
    "*"   'counsel-projectile-rg
    "tt"  '(counsel-load-theme :which-key "choose theme")
    "bb"  'counsel-switch-buffer
    "pf" 'counsel-projectile-find-file
    "ff" 'counsel-find-file
    "fr" 'counsel-recentf
    "sl"  'ivy-resume)

  :config
  (setq ivy-initial-inputs-alist nil))

(use-package counsel-projectile
  :ensure t
  :after projectile
  :config
  (counsel-projectile-mode 1)
  (setq counsel-projectile-rg-initial-input '(ivy-thing-at-point)))

(use-package ivy-rich
  :ensure t
  :init
  (ivy-rich-mode 1))

(use-package flyspell-correct-ivy
  :ensure t
  :after flyspell-correct)

;; TODO: Doomemacs ivy setup:
;; https://github.com/doomemacs/doomemacs/tree/master/modules/completion/ivy

;; Smex
;; Smex is a M-x enhancement for Emacs.
;; Built on top of Ido, it provides a convenient interface to your recently and most frequently used commands. And to all the other commands, too.
(use-package smex
  :ensure t)
