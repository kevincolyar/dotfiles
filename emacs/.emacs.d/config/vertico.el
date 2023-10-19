;; Vertico provides a performant and minimalistic vertical completion UI based on the default completion system. The main focus of Vertico is to provide a UI which behaves correctly under all circumstances.
;; https://github.com/minad/vertico
;; https://kristofferbalintona.me/posts/202202211546/
(use-package vertico
  :ensure t
  :diminish
  :general
  (:keymaps 'vertico-map
            "<tab>" #'vertico-insert  ; Insert selected candidate into text area
            "<escape>" #'minibuffer-keyboard-quit ; Close minibuffer
            ;; NOTE 2022-02-05: Cycle through candidate groups
            "C-j" #'vertico-next
            "C-k" #'vertico-previous)
  (nmap
    :prefix "SPC"
    "sl"  'vertico-repeat ;; TODO: Not working
    )
  :config
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t)
  (vertico-mode))

(add-hook 'minibuffer-setup-hook #'vertico-repeat-save)

(use-package compat :ensure t)
(use-package wgrep :ensure t)
(use-package vertico-posframe :ensure t)



