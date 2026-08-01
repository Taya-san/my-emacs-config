;; ============================================================
;; Auto-hide cursor + modeline after 60s idle
;; Works in GUI AND terminal (Kitty), with Evil + ETCC
;; ============================================================

;; --- State ---
(defvar my/cursor-type-original nil)      ; global cursor shape before hide
(defvar my/cursor-locals nil)             ; per-buffer cursor shapes
(defvar my/cursor-hidden nil)             ; is cursor hidden?
(defvar my/cursor-blink-was-on nil)       ; was blink-cursor-mode on?

(defvar my/modeline-format-original nil)  ; global modeline before hide
(defvar my/modeline-formats-local nil)    ; per-buffer modelines
(defvar my/modeline-hidden nil)           ; is modeline hidden?

;; --- Helpers ---
(defun my/save-buffer-locals (varname alistvar)
  "For variable VARNAME, save current buffer's local value into ALISTVAR."
  (let ((var (symbol-value varname)))
    (when (local-variable-p varname (current-buffer))
      (push (cons (current-buffer) var) (symbol-value alistvar))
      (set varname nil))))

(defun my/hide-all ()
  "Hide cursor and modeline in ALL buffers/windows."
  (unless my/cursor-hidden
    (setq my/cursor-hidden t)

    ;; === CURSOR ===
    (setq my/cursor-type-original (default-value 'cursor-type))
    (setq-default cursor-type nil)
    (setq my/cursor-locals nil)
    (setq my/cursor-blink-was-on blink-cursor-mode)
    (when blink-cursor-mode (blink-cursor-mode -1))   ; stop 0.5s re-show timer
    (internal-show-cursor nil nil)                    ; display-level hide (GUI)
    (unless (display-graphic-p)
      (send-string-to-terminal "\e[?25l"))            ; terminal hide

    ;; === MODELINE ===
    (setq my/modeline-format-original (default-value 'mode-line-format))
    (setq-default mode-line-format nil)
    (setq my/modeline-formats-local nil)

    (dolist (win (window-list))
      (let ((buf (window-buffer win)))
        (with-current-buffer buf
          ;; save+hide buffer-local cursor-type
          (when (local-variable-p 'cursor-type (current-buffer))
            (push (cons (current-buffer) cursor-type) my/cursor-locals)
            (setq cursor-type nil))
          ;; save+hide buffer-local mode-line-format
          (when (local-variable-p 'mode-line-format (current-buffer))
            (push (cons (current-buffer) mode-line-format) my/modeline-formats-local)
            (setq mode-line-format nil)))))

    (redisplay t)))

(defun my/restore-all ()
  "Restore cursor and modeline on any input."
  (when my/cursor-hidden
    (setq my/cursor-hidden nil)

    ;; === CURSOR RESTORE ===
    (when my/cursor-type-original
      (setq-default cursor-type my/cursor-type-original))
    (dolist (pair my/cursor-locals)
      (when (buffer-live-p (car pair))
        (with-current-buffer (car pair)
          (setq cursor-type (cdr pair)))))
    (setq my/cursor-locals nil)
    (internal-show-cursor nil t)                      ; display-level show (GUI)
    (when my/cursor-blink-was-on (blink-cursor-mode 1))
    (unless (display-graphic-p)
      (send-string-to-terminal "\e[?25h")             ; terminal show
      (when (fboundp 'etcc--set-cursor)               ; re-apply Evil shape
        (etcc--set-cursor)))

    ;; === MODELINE RESTORE ===
    (when my/modeline-format-original
      (setq-default mode-line-format my/modeline-format-original))
    (dolist (pair my/modeline-formats-local)
      (when (buffer-live-p (car pair))
        (with-current-buffer (car pair)
          (setq mode-line-format (cdr pair)))))
    (setq my/modeline-formats-local nil)

    (redisplay t)))

;; --- Wiring ---
;; Wall-clock timer: fires every second, checks idle itself
(run-with-idle-timer 60 t #'my/hide-all)

;; Any keypress restores everything
(add-hook 'pre-command-hook #'my/restore-all)

(provide 'idle)
