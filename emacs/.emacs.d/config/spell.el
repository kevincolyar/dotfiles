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
  (flyspell-duplicate ((t (:underline (:color "#50fa7b" :style wave))))))

;; TODO: This is triggering in insert mode
;; (use-package flyspell-correct
;;   :after flyspell
;;   :init '(flyspell-mode)
;;   :bind (:map flyspell-mode-map ("z=" . flyspell-correct-wrapper)))
