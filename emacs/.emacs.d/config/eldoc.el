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

;; Both elisp backends cut the docstring at `elisp-eldoc-docstring-length-limit'
;; characters and append a `[Nc more]' marker (elisp-mode.el:2299-2305,
;; 2350-2358). That happens in `eldoc-documentation-functions', i.e. before any
;; display function sees the text, so the 1000-character default amputated the
;; childframe *and* the `*eldoc*' buffer that K opens (config/evil.el) -- and
;; the marker's advice, `M-x eldoc-doc-buffer', led to the same truncated text.
;; Truncation belongs to the display, not the source: the childframe is capped
;; at two thirds of the frame height by `my-eldoc-box-tty-geometry' below and
;; simply shows what fits, while the buffer scrolls through the rest.
(setq elisp-eldoc-docstring-length-limit most-positive-fixnum)

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
  ;;
  ;; The terminal width is deliberately close to the whole pane: the doc buffer
  ;; wraps (`visual-line-mode', eldoc-box.el:480), so a narrow box does not
  ;; drop the overflow sideways, it turns every wide line into several rows and
  ;; spends the height budget instead. At half a 120-column pane the `sort'
  ;; docstring needs 34 rows; at full width it needs 24. The box still shrinks
  ;; to fit its content, so short docs stay small.
  (setq eldoc-box-max-pixel-width
        (lambda () (if (display-graphic-p) 800 (max 40 (- (frame-width) 4))))
        eldoc-box-max-pixel-height
        (lambda () (if (display-graphic-p) 700
                     (max 8 (/ (* 2 (frame-height)) 3)))))

  ;; `eldoc-box--update-childframe-geometry' (eldoc-box.el:596-648) is written
  ;; for pixels and breaks twice over on a terminal, where a "pixel" is a cell:
  ;;
  ;;   1. It clamps the box to `(- (frame-pixel-height parent) 32)' -- 32
  ;;      pixels of slack on a GUI, but 32 *rows* here. A 40-row tmux pane
  ;;      capped the box at 8 rows regardless of the maximums above, which is
  ;;      what truncated long docs; a pane under 33 rows caps it at nothing.
  ;;   2. It measures the text before resizing the frame, so the row count it
  ;;      gets describes the wrapping of the *previous* width; once the frame
  ;;      is resized the text rewraps into more rows than the frame now has,
  ;;      and the overflow is cut off.
  ;;
  ;; Sizing width-first fixes both: pin the width, let the buffer wrap at it,
  ;; then count the rows that wrapping actually needs.
  ;;
  ;; The rows are counted rather than measured. `window-text-pixel-size'
  ;; under-reports whenever the doc carries a `(space :width text)' display
  ;; property or a fractional `:height' face -- both of which eldoc-box puts on
  ;; the markdown separators in eglot's output (eldoc-box.el:91-93, 1069-1092,
  ;; and the issue#68 comment at eldoc-box.el:599-618). A clangd hover measured
  ;; 18 rows for a layout that needs 19, so the last line was cut off. On a
  ;; character grid `count-screen-lines' is both exact and cheaper: it walks
  ;; the same wrapping the terminal will draw.

  ;; Functional core: widest line in columns, no frames involved.
  (defun my-eldoc-box--text-width ()
    "Return the width in columns of the widest line in the current buffer."
    (save-excursion
      (goto-char (point-min))
      (let ((width 0))
        (while (not (eobp))
          (setq width (max width (string-width
                                  (buffer-substring-no-properties
                                   (line-beginning-position)
                                   (line-end-position)))))
          (forward-line))
        width)))

  (defun my-eldoc-box-tty-geometry (frame window)
    "Size and place the terminal childframe FRAME showing WINDOW."
    (let* ((parent (frame-parent frame))
           ;; A TTY childframe's border is drawn around the frame rectangle,
           ;; not inside it (`window-body-width' equals `frame-width'), so it
           ;; costs nothing in text but does need a cell of clearance per side.
           (chrome 2)
           (max-width (min (funcall eldoc-box-max-pixel-width)
                           (- (frame-width parent) chrome)))
           (max-height (min (funcall eldoc-box-max-pixel-height)
                            (- (frame-height parent) chrome)))
           (frame-resize-pixelwise t))
      ;; Restore line continuation for this frame; see the
      ;; `no-special-glyphs' note below. Set per frame rather than in
      ;; `eldoc-box-frame-parameters' so graphical boxes keep eldoc-box's
      ;; own choice and gain no fringe continuation arrows.
      (set-frame-parameter frame 'no-special-glyphs nil)
      (when (and (> max-width 0) (> max-height 0))
        (let ((width (max 1 (min max-width
                                 ;; One spare column keeps the last glyph off
                                 ;; the border.
                                 (1+ (with-current-buffer (window-buffer window)
                                       (my-eldoc-box--text-width)))))))
          ;; Wrap at the final width before counting, so the count describes
          ;; the layout that will be displayed.
          (set-frame-size frame width max-height t)
          (let* ((rows (with-selected-window window
                         (count-screen-lines (point-min) (point-max))))
                 (height (max 1 (min max-height rows)))
                 (pos (funcall eldoc-box-position-function width height)))
            (set-frame-size frame width height t)
            (set-frame-position frame (car pos) (cdr pos)))))))

  (defun my-eldoc-box-geometry (orig frame window)
    "Use terminal-aware geometry for FRAME; ORIG handles graphical frames."
    (if (display-graphic-p frame)
        (funcall orig frame window)
      (my-eldoc-box-tty-geometry frame window)))

  (advice-add 'eldoc-box--update-childframe-geometry
              :around #'my-eldoc-box-geometry)

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

  ;; eldoc-box sets `(no-special-glyphs . t)' (eldoc-box.el:158). On a terminal
  ;; that does not merely hide the continuation glyph, it disables continuation
  ;; altogether: a line wider than the frame is cut at the edge and its
  ;; remainder never drawn, whatever `truncate-lines' and `word-wrap' say in
  ;; the buffer. Verified with a bare `make-frame' child frame under `emacs -Q'
  ;; -- identical frames, and the parameter alone decides whether a 200-column
  ;; line renders as four wrapped rows or one truncated row. This is why long
  ;; eglot signatures came out clipped while `vertical-motion' in the same
  ;; window still reported the line as wrapped. `my-eldoc-box-tty-geometry'
  ;; above clears it, per frame, on every terminal display.

  ;; Functional core: one axis, no frames touched.
  (defun my-eldoc-box--clamp (start size limit)
    "Return START moved so a SIZE-long box keeps a cell of border clearance.
LIMIT is the parent frame's extent on the same axis.  A box too large to
clear both edges is pinned at 1, so the near border stays visible and the
far one is the side that gets clipped."
    (max 1 (min start (- limit size 1))))

  ;; The border ring is drawn around the frame rectangle, not inside it, so it
  ;; sits in the cell either side of the box: at x=0 the left border would be
  ;; at column -1 and is simply not drawn, which is what hid the left edge of
  ;; wide boxes -- `eldoc-box--default-at-point-position-function-1' floors x
  ;; at 0 (eldoc-box.el:567) and wide boxes land exactly there. Keep a column,
  ;; and a row, of clearance on every side. The y clamp subsumes the old nudge
  ;; that kept the top border off the line being inspected.
  (defun my-eldoc-box-at-point-position (width height)
    "Place the box below point, leaving the cursor's own row uncovered.
WIDTH and HEIGHT are the childframe's text dimensions."
    (let ((pos (eldoc-box--default-at-point-position-function width height)))
      (if (display-graphic-p)
          pos
        (let ((x (car pos))
              (y (cdr pos)))
          (cons (my-eldoc-box--clamp x width (frame-inner-width))
                (my-eldoc-box--clamp
                 (if (>= (+ y height 2) (frame-inner-height)) y (1+ y))
                 height (frame-inner-height)))))))

  (setq eldoc-box-at-point-position-function #'my-eldoc-box-at-point-position))
