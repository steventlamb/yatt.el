;;; yatt.el --- yet another tea timer

;;; Commentary:

;; todo: try to hide/protect some of these variables
;; todo: make a customization group
;; todo: make the modeline update automatically
;; todo: better styling in the modeline
;; todo: put a temp message in modline that clicking clears.
;; todo: generalize to any kind of timer?
;; todo: do init more gracefully

;;; Code:

(defvar yatt/mode-line-string "")
(defvar yatt/tea-time-message "TEA TIME!")
(defvar yatt/n 0)
(defvar yatt/timer nil)
(defvar yatt/lock nil)
(defvar yatt/initialized? nil)

(defun yatt/init ()
  (or global-mode-string (setq global-mode-string '("")))
  (add-to-list 'global-mode-string 'yatt/mode-line-string t)
  (put 'yatt/mode-line-string 'risky-local-variable t)
  (put 'yatt/n 'risky-local-variable t)
  (put 'yatt/timer 'risky-local-variable t)
  (put 'yatt/lock 'risky-local-variable t)
  (setq yatt/initialized? t))

(defun yatt/write (string) (setq yatt/mode-line-string (list " " string " ")))

(defun yatt/make-timer (fn) (run-at-time nil 1 fn))

(defun yatt/clear () (interactive) (setq yatt/mode-line-string ""))

(defun tea-timer (seconds)
  (interactive "sSeconds:")
  (unless yatt/initialized? (yatt/init))

  (if yatt/lock (error "tea timer is locked"))

  (setq yatt/n (string-to-number seconds))
  (setq yatt/lock t)

  (setq yatt/timer
        (yatt/make-timer
         (lambda ()
           (if (> yatt/n 0)
               (progn
                 (yatt/write (number-to-string yatt/n))
                 (setq yatt/n (- yatt/n 1)))
             (progn
               (cancel-timer yatt/timer)
               (setq yatt/lock nil)
               (yatt/clear)
               (message yatt/tea-time-message)))))))

(provide 'yatt)

;;; yatt.el ends here
