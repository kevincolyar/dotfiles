(use-package company
  :custom
  (company-idle-delay 0.1) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :init (global-company-mode)
  :bind
  (:map company-active-map
	      ("C-j". company-select-next)
	      ("C-k". company-select-previous)
	      ("C-h". company-select-first)
	      ("C-l". company-select-last)))

;; GUI VERSION ONLY
(use-package company-quickhelp
  :after company
  :init (company-quickhelp-mode))

(use-package company-box
  :after company
  :hook (company-mode . company-box-mode))

