;;; -*- lexical-binding: t; -*-
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :config
  (custom-set-faces
   '(jinx-misspelled ((t (:underline (:color "#af4400" :style wave :position nil))))))
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))

  :general
  (nmap
    :keymaps 'override
    :prefix "SPC"
    "z="  'jinx-correct
    "zw"  'jinx-correct
    "zz"  'jinx-correct
    "za"  'jinx-correct-all
    "zn"  'jinx-next
    "zp"  'jinx-previous
    )
  )
