;;; -*- lexical-binding: t; -*-
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :init
  ;; jinx compiles jinx-mod.c with `pkg-config enchant-2'. nix home.nix
  ;; installs enchant.dev, but nothing exports the profile's pkgconfig dir
  ;; (zsh is not home-manager managed, GUI Emacs sees no shell at all).
  (when-let* ((dir (seq-find #'file-directory-p
                             (list (format "/etc/profiles/per-user/%s/lib/pkgconfig"
                                           user-login-name)
                                   (expand-file-name "~/.nix-profile/lib/pkgconfig")))))
    (setenv "PKG_CONFIG_PATH"
            (string-join (delq nil (list dir (getenv "PKG_CONFIG_PATH"))) ":")))
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
