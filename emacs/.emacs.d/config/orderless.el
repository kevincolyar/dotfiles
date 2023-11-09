;; This package provides an orderless completion style that divides the pattern into space-separated components, and matches candidates that match all of the components in any order. 
;; https://github.com/oantolin/orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
