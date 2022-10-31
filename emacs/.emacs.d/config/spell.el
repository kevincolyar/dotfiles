
;; Set spell correction language
;; (setq ispell-dictionary "en")

;; (use-package flyspell
;; :hook
;;   ((org-mode yaml-mode markdown-mode git-commit-mode) . flyspell-mode)
;;   :custom
;;   (flyspell-issue-message-flag nil)
;;   (ispell-program-name "aspell")
;;   (ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
;;   :custom-face
;;   (flyspell-incorrect ((t (:underline (:color "#f1fa8c" :style wave)))))
;;   (flyspell-duplicate ((t (:underline (:color "#50fa7b" :style wave)))))
  

(use-package flyspell
  :defer 5
  :diminish
  :if (executable-find "aspell")
  :hook
  ((org-mode yaml-mode markdown-mode git-commit-mode) . flyspell-mode)
  (prog-mode . flyspell-prog-mode)
  (before-save-hook . flyspell-buffer)
  (flyspell-mode . (lambda ()
                     (dolist (key '("C-;" "C-," "C-."))
                       (unbind-key key flyspell-mode-map))))
  :custom
  (flyspell-issue-message-flag nil)
  (ispell-program-name "aspell")
  (ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
  :custom-face
  (flyspell-incorrect ((t (:underline (:color "#f1fa8c" :style wave)))))
  (flyspell-duplicate ((t (:underline (:color "#50fa7b" :style wave)))))
  :preface
  (defun message-off-advice (oldfun &rest args)
    "Quiet down messages in adviced OLDFUN."
    (let ((message-off (make-symbol "message-off")))
      (unwind-protect
          (progn
            (advice-add #'message :around #'ignore (list 'name message-off))
            (apply oldfun args))
        (advice-remove #'message message-off))))
  :config
  (advice-add #'ispell-init-process :around #'message-off-advice)
  (use-package flyspell-correct-ivy
    :bind ("C-M-:" . flyspell-correct-at-point)
    :config
    (when (eq system-type 'darwin)
      (progn
        (global-set-key (kbd "C-M-;") 'flyspell-correct-at-point)))
    (setq flyspell-correct-interface #'flyspell-correct-ivy)))

;; TODO: This is triggering in insert mode
;; (use-package flyspell-correct
;;   :after flyspell
;;   :init '(flyspell-mode)
;;   :bind (:map flyspell-mode-map ("z=" . flyspell-correct-wrapper)))
