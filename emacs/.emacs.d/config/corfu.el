;;; -*- lexical-binding: t; -*-
;; Corfu enhances in-buffer completion with a small completion popup.
;; https://github.com/minad/corfu
;; https://youtu.be/Vx0bSKF4y78?t=570

(use-package corfu
  :general
  (:keymaps 'corfu-map
            "C-j" #'corfu-next
            "C-k" #'corfu-previous
            "C-u" #'corfu-scroll-up
            "C-d" #'corfu-scroll-down
            "C-[" #'corfu-quit)
  ;; `:general' emits autoloads for the commands it binds, which makes
  ;; use-package defer the package. Every binding above lives in `corfu-map',
  ;; which only exists while a popup is open, so nothing could ever trigger the
  ;; load and `:config' below never ran. Corfu has to be globally active from
  ;; startup anyway, so demand it.
  :demand t
  :init
  (setq corfu-auto t                           ;; Enable auto completion, required for eglot methods, etc
        corfu-cycle t                          ;; Enable cycling for `corfu-next/previous'
        corfu-quit-no-match 'separator         ;; or t
        corfu-auto-prefix 2
        ;; corfu-auto-delay 0.0
        corfu-popupinfo-delay 0.25             ;; docs popup; was `corfu-echo-documentation'
        ;; Below the candidate list rather than beside it. Plain `vertical' is
        ;; only tried when it fits and otherwise falls back to left/right
        ;; (corfu-popupinfo.el:340-349); `force-vertical' never goes sideways
        ;; and clamps its height to the space available (:323-326).
        corfu-popupinfo-direction '(force-vertical)
        corfu-preview-current 'insert
        corfu-preselect 'prompt                ;; replaces `corfu-preselect-first' nil
        corfu-min-width 100
        corfu-max-width corfu-min-width
        )       ; Always have the same width
  :config
  (global-corfu-mode)
  ;; Emacs 31 provides `tty-child-frames', which is what `corfu--popup-support-p'
  ;; checks, so the doc popup now renders in terminal frames too.
  (corfu-popupinfo-mode)

  ;; Emacs 31 draws a border around a TTY child frame only when it is not
  ;; `undecorated'; the glyphs come from
  ;; `standard-display-unicode-special-glyphs' in config/ui.el. corfu's own
  ;; `corfu-border-width' is documented as GUI-only and its terminal placement
  ;; math assumes a zero-width border (corfu.el:1062), so the popup can sit a
  ;; cell off from where it would land unbordered.
  (setf (alist-get 'undecorated corfu--frame-parameters) nil)

  ;; ...and that placement is the problem: a TTY border is painted over the
  ;; parent frame's neighbouring cells instead of inside the child frame, while
  ;; corfu puts the frame on the row directly below point. Measured: point on
  ;; row 8, frame at row 9, so the top border lands on row 8 -- over the line
  ;; being typed. Nudge the frame one row further from point, but only when it
  ;; would actually collide, so the popupinfo frame is left aligned as corfu
  ;; placed it.
  (defun my-corfu-keep-point-visible (fn frame x y width height)
    "Call FN with Y shifted so a decorated popup never covers point's row."
    (if (or (display-graphic-p) (frame-parameter frame 'undecorated))
        (funcall fn frame x y width height)
      ;; `corfu--popup-show' runs inside `with-current-buffer " *corfu*"', so a
      ;; bare `posn-at-point' would take point from the popup buffer and apply
      ;; it to the source window. Ask the window for its own point.
      (let* ((win (selected-window))
             (posn (posn-at-point (window-point win) win))
             (cur (and posn (+ (cadr (window-inside-pixel-edges win))
                               (or (cdr (posn-x-y posn)) 0))))
             ;; A second frame stacked against the candidate list
             ;; (`corfu-popupinfo' with `force-vertical') is abutted exactly:
             ;; corfu places it at cfy+cfh below, or cfy-height above
             ;; (corfu-popupinfo.el:323-326), because in a GUI the border lives
             ;; inside the frame. In a terminal it is painted on the parent's
             ;; cells, so two rows are in play, not one: the candidate frame's
             ;; own border row, and ours. Hence a two-row shift either way.
             (other (and (bound-and-true-p corfu--frame)
                         (frame-live-p corfu--frame)
                         (not (eq frame corfu--frame))
                         (frame-visible-p corfu--frame)
                         corfu--frame))
             (cfy (and other (cdr (frame-position other))))
             (cfh (and other (frame-height other)))
             (y (cond
                 ;; Below: our top border would land on the list's bottom border.
                 ((and other (= y (+ cfy cfh))) (+ y 2))
                 ;; Above: our bottom border would land on the first candidate
                 ;; row, and the list's top border on our last row.
                 ((and other (= (+ y height) cfy)) (max 0 (- y 2)))
                 ((null cur) y)
                 ;; Popup below point: top border would sit on point's row.
                 ((= (1- y) cur)
                  (min (1+ y) (max 0 (- (frame-height) height 1))))
                 ;; Popup above point: bottom border would sit on it.
                 ((= (+ y height) cur) (max 0 (1- y)))
                 (t y))))
        (funcall fn frame x y width height))))

  (advice-add 'corfu--make-frame :around #'my-corfu-keep-point-visible)

  ;; (corfu-history-mode)
  )

;; Cape provides Completion At Point Extensions which can be used in combination with Corfu, Company or the default completion UI.
;; https://kristofferbalintona.me/posts/202203130102/#adding-backends-to-completion-at-point-functions
(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  ;; DISABLED: messing up cursor location
  ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  )

;; (straight-use-package
;;  '(popon
;;    :type git
;;    :repo "https://codeberg.org/akib/emacs-popon.git"))

;; ;; NOTE: Corfu relies on child frames to show the popup. On Emacs 31 this works even for terminal Emacs, but support is still experimental. Use the corfu-terminal package on older Emacs versions.
;; (straight-use-package
;;  '(corfu-terminal
;;    :type git
;;    :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))

;; Currently broken
;; (quelpa '(corfu-doc-terminal
;;           :fetcher git
;;           :url "https://codeberg.org/akib/emacs-corfu-doc-terminal.git"))

;; (unless (display-graphic-p)
;;   (corfu-terminal-mode +1))

(use-package nerd-icons-corfu
  :defer t)

(unless (display-graphic-p)
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
