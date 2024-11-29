(use-package python-pytest
  :defer t
  :general
  (nmap
   'python-ts-mode-map
   :prefix ","
   "t"  '(:ignore t :which-key "Tests")
   "tt" '(python-pytest-run-def-at-point-treesit :which-key "Test Current")
   "ta" '(python-pytest :which-key "Test All")
   "tf" '(python-pytest-file :which-key "Test File")
   "tl" '(python-pytest-last-failed :which-key "Test Last Failed")))
