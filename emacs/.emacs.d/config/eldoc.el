;;; -*- lexical-binding: t; -*-

;; `eldoc-current-idle-delay' is eldoc's internal shadow of `eldoc-idle-delay'
;; (eldoc.el:192, "used to determine if `eldoc-idle-delay' is changed by the
;; user"). eldoc overwrites it from `eldoc-idle-delay' the moment the two
;; differ, so setting it directly did nothing. Set the real knob.
;;
;; This MUST stay above 0.5s. In `eldoc-box-hover-at-point-mode' every command
;; that is not a self-insert runs `eldoc-box--follow-cursor', which hides the
;; box and sets `eldoc-box--inhibit-childframe' for 0.5s of idle time
;; (eldoc-box.el:650-667). An eldoc idle timer shorter than that always fires
;; inside the inhibit window, gets swallowed by `eldoc-box--get-frame', and
;; nothing re-triggers it -- so the box never appears at all. 0.6s clears the
;; window and gives the intended behaviour: box hides while moving, returns
;; once the cursor settles.
(setq eldoc-idle-delay 0.6)

;; In an elisp buffer `emacs-lisp-mode' installs `elisp-eldoc-funcall' and
;; `elisp-eldoc-var-docstring' (elisp-mode.el:763-766), which report only the
;; call signature and a one-line variable doc -- which is why the hover box
;; showed `car: (LIST)' and nothing else. corfu's popupinfo looks richer
;; because it reads a different source entirely: the completion metadata's
;; `:company-doc-buffer', i.e. `describe-function' output.
;;
;; Emacs 31 ships fuller backends. `eldoc-documentation-strategy' defaults to
;; `eldoc-documentation-default', which stops at the first function returning
;; non-nil, so order matters -- `add-hook' prepends, hence adding the funcall
;; one last to keep it ahead of the variable one, as upstream has it.
(defun my-elisp-eldoc-full-docs ()
  "Report docstrings, not just signatures, for elisp at point."
  (remove-hook 'eldoc-documentation-functions #'elisp-eldoc-funcall t)
  (remove-hook 'eldoc-documentation-functions #'elisp-eldoc-var-docstring t)
  (add-hook 'eldoc-documentation-functions
            #'elisp-eldoc-var-docstring-with-value nil t)
  (add-hook 'eldoc-documentation-functions
            #'elisp-eldoc-funcall-with-docstring nil t))

(add-hook 'emacs-lisp-mode-hook #'my-elisp-eldoc-full-docs)

;; `short' (the default) truncates to the first sentence.
(setq elisp-eldoc-funcall-with-docstring-length 'full)

;; `eldoc-mode-hook' fires more than once per buffer -- eglot toggles
;; `eldoc-mode' in the buffers it manages -- and `eldoc-box--enable' conses its
;; display function onto `eldoc-display-functions' without checking whether it
;; is already there (eldoc-box.el:295-298). An unguarded hook therefore ends up
;; composing and displaying every doc twice, and leaves
;; `eldoc-box--old-eldoc-functions' holding an already-modified list.
(defun my-eldoc-box-setup ()
  "Turn on the at-point documentation box, once per buffer."
  (unless (bound-and-true-p eldoc-box-hover-at-point-mode)
    (eldoc-box-hover-at-point-mode 1)))

(use-package eldoc-box
  ;; `eldoc-box-hover-mode' pins the box to a frame corner. This mode instead
  ;; binds `eldoc-box-position-function' to `eldoc-box-at-point-position-function'
  ;; buffer-locally and repositions from `post-command-hook', so the box tracks
  ;; the cursor. Upstream only offers buffer-local modes, so hang it off
  ;; `eldoc-mode'. It also turns on `eldoc-box-clear-with-C-g', and `K' is bound
  ;; to the on-demand box in config/evil.el.
  :hook (eldoc-mode . my-eldoc-box-setup)
  :config
  ;; eldoc-box sizes the childframe in pixels, but on a terminal frame
  ;; `frame-char-width' and `frame-char-height' are both 1, so one "pixel" is
  ;; one character cell -- the 800x700 defaults can never cap a box on a
  ;; 120x40 terminal, leaving its size (and therefore its placement) driven
  ;; entirely by the length of the docstring. Both maximums accept a function,
  ;; re-evaluated on every display, so scale them to the frame in use.
  (setq eldoc-box-max-pixel-width
        (lambda () (if (display-graphic-p) 800 (max 40 (/ (frame-width) 2))))
        eldoc-box-max-pixel-height
        (lambda () (if (display-graphic-p) 700 (max 8 (/ (frame-height) 3)))))

  ;; `eldoc-box-body' ships with no attributes at all (eldoc-box.el:88), so the
  ;; box is painted in whatever `default' resolves to -- and in a terminal this
  ;; theme leaves that as `unspecified-bg', i.e. the terminal's own background.
  ;; The box then has no edge against the buffer behind it. corfu's palette is
  ;; themed (`corfu-default' resolves to #fffaf3 here), so inherit it and both
  ;; popups match. Neither theme styles `eldoc-box-*', so these survive a
  ;; theme reload.
  (set-face-attribute 'eldoc-box-body nil :inherit 'corfu-default :extend t)
  ;; `eldoc-box-border' does set its own `:background' (eldoc-box.el:84-86), and
  ;; an explicit attribute beats an inherited one, so clear it first.
  (set-face-attribute 'eldoc-box-border nil
                      :background 'unspecified :inherit 'corfu-border)

  ;; A TTY child frame only gets a border drawn if it is not `undecorated'
  ;; (verified: that parameter alone flips it; `no-special-glyphs' does not
  ;; interfere). The glyphs themselves come from
  ;; `standard-display-unicode-special-glyphs' in config/ui.el.
  (setf (alist-get 'undecorated eldoc-box-frame-parameters) nil)

  ;; The border adds a row above the text, which would otherwise land on the
  ;; line being inspected. Nudge the box down one row when there is space.
  (defun my-eldoc-box-at-point-position (width height)
    "Place the box below point, leaving the cursor's own row uncovered.
WIDTH and HEIGHT are the childframe's text dimensions."
    (let* ((pos (eldoc-box--default-at-point-position-function width height))
           (y (cdr pos)))
      (if (or (display-graphic-p)
              (>= (+ y height 2) (frame-inner-height)))
          pos
        (cons (car pos) (1+ y)))))

  (setq eldoc-box-at-point-position-function #'my-eldoc-box-at-point-position))
