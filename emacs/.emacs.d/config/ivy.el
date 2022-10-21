;;Ivy is an interactive interface for completion in Emacs
;; https://github.com/abo-abo/swiper#ivy
(use-package ivy
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
             (ivy-mode 1))

;; Counsel takes this further, providing versions of common Emacs commands that are customised to make the best use of Ivy.
;; https://github.com/abo-abo/swiper#counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x Cf" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; TODO: Doomemacs ivy setup:
;; https://github.com/doomemacs/doomemacs/tree/master/modules/completion/ivy

;; Smex
;; Smex is a M-x enhancement for Emacs.
;; Built on top of Ido, it provides a convenient interface to your recently and most frequently used commands. And to all the other commands, too.
(use-package smex)

(use-package marginalia
  :after ivy
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))
