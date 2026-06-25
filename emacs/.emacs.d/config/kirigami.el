(use-package kirigami
  :config
  (with-eval-after-load 'evil
    (define-key evil-normal-state-map "zo" 'kirigami-open-fold)
    (define-key evil-normal-state-map "zO" 'kirigami-open-fold-rec)
    (define-key evil-normal-state-map "zc" 'kirigami-close-fold)
    (define-key evil-normal-state-map "za" 'kirigami-toggle-fold)
    (define-key evil-normal-state-map "zr" 'kirigami-open-folds)
    (define-key evil-normal-state-map "zm" 'kirigami-close-folds)))
  
