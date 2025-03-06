(defpackage :lem-user
  ;; (:use :cl :lem :lem-elisp-mode :lem-sdl2 :lem/buffer/internal :lem-sdl2/graphics)
  (:use :cl :lem :lem-elisp-mode :lem/buffer/internal :lem-core)
  )
(in-package :lem-user)

;; so we dont have to use `define-command' explicitly
(defmacro cmd (&body body)
  (let ((name (gensym "lambda-command-")))
    `(progn
       (define-command ,name () () ,@body)
       ',name))) ;; return the generated command name

;; start in vi-mode
(lem-vi-mode:vi-mode)

(setf lem-core::*default-prompt-gravity* :bottom-display)
(setf lem/prompt-window::*prompt-completion-window-gravity* :horizontally-above-window)
(setf lem/prompt-window::*fill-width* t)

;; C-h is initially bound to delete-previous-char
(defvar *help-keymap*
  (make-keymap :name '*my-help-keymap*)
  "keymap for help commands.")
(define-keys *help-keymap*
  ("b" 'describe-bindings)
  ("k" 'describe-key)
  ("A" 'lem-lisp-mode:lisp-apropos)
  ("a" 'lem-lisp-mode/internal::lisp-search-symbol)
  ("c" 'apropos-command)
  ("p" 'lem-lisp-mode:lisp-apropos-package)
  ("f" 'lem-lisp-mode:lisp-describe-symbol))

(defvar *frame-keymap*
  (make-keymap :name '*frame-multiplexer-keymap*)
  "keymap for commands related to the frame-multiplexer.")
(define-key *frame-keymap* "c" 'frame-multiplexer-create-with-new-buffer-list)
(define-key *frame-keymap* "d" 'frame-multiplexer-delete)
(define-key *frame-keymap* "p" 'frame-multiplexer-prev)
(define-key *frame-keymap* "n" 'frame-multiplexer-next)
(define-key *frame-keymap* "r" 'frame-mulitplexer-rename)

(defvar *window-keymap*
  (make-keymap :name '*my-window-keymap*)
  "keymap for window related commands.")
(define-keys *window-keymap*
  ("l" 'lem-vi-mode/binds::vi-window-move-right)
  ("h" 'lem-vi-mode/binds::vi-window-move-left)
  ("j" 'lem-vi-mode/binds::vi-window-move-down)
  ("k" 'lem-vi-mode/binds::vi-window-move-up)
  ("s" 'lem-vi-mode/binds::vi-window-split-vertically)
  ("v" 'lem-vi-mode/binds::vi-window-split-horizontally)
  ("c" 'lem-vi-mode/binds::vi-close)
  ("o" 'lem-vi-mode/binds::delete-other-windows)
  )

;; relative line numbers
(lem/line-numbers:toggle-line-numbers)
(setf lem/line-numbers:*relative-line* t)

;; spc spc to run commands
(define-key lem-vi-mode:*normal-keymap*
  "Space Space"
  'execute-command)
;; s to save
(define-key lem-vi-mode:*normal-keymap*
  "s"
  'save-current-buffer)
;; r instead of C-r to redo
(define-key lem-vi-mode:*normal-keymap*
  "r"
  'lem-vi-mode/commands:vi-redo)
;; spc-h for help keys
;; (define-key *global-keymap* "C-z" *frame-keymap*)
(define-key lem-vi-mode:*normal-keymap*
  "Space h"
  *help-keymap*)
(define-key lem-vi-mode:*insert-keymap*
  "C-h"
  *help-keymap*)
(define-key lem-vi-mode:*normal-keymap*
  "Space w"
  *window-keymap*)

(defun led-key (key command)
  (define-key lem-vi-mode:*normal-keymap*
              (concatenate 'string "Space " key)
              command))

;; show completions in minibuffer instantly
(add-hook *prompt-after-activate-hook*
          (lambda ()
            (call-command 'lem/prompt-window::prompt-completion nil)))
(add-hook *prompt-deactivate-hook*
          (lambda ()
            (lem/completion-mode:completion-end)))

(led-key "x" 'lem-lisp-mode/eval::lisp-eval-defun)

;; buffer-related keys
(led-key "b s" 'select-buffer)
(define-command my-kill-current-buffer () ()
  (kill-buffer (current-buffer)))
(define-command my-kill-current-buffer-and-window () ()
  (kill-buffer (current-buffer))
  (lem-core/commands/window:delete-active-window))
(led-key "b k" 'my-kill-current-buffer)
(led-key "b K" 'my-kill-current-buffer-and-window)

(define-key lem-vi-mode:*normal-keymap* "g d" 'lem/language-mode::find-definitions)

;; update completion after backspace
(define-command completion-backspace () ()
  (ignore-errors
    (delete-previous-char)
    (ignore-errors
      (lem/completion-mode::continue-completion
       lem/completion-mode::*completion-context*))))

;; accept current prompt completion entry without trying to complete
(define-command prompt-execute-auto-accept () ()
  (let ((input (lem/prompt-window::get-input-string)))
    (when (or (null (lem/prompt-window::prompt-window-existing-test-function (lem/prompt-window::current-prompt-window)))
              (funcall (lem/prompt-window::prompt-window-existing-test-function (lem/prompt-window::current-prompt-window)) input))
      (lem/common/history:add-history (lem/prompt-window::prompt-window-history (lem/prompt-window::current-prompt-window)) input)
      (error 'lem/prompt-window::execute-condition :input input))))

(undefine-key lem/completion-mode::*completion-mode-keymap* "Return")
(define-keys lem/completion-mode::*completion-mode-keymap*
  ("Backspace" 'completion-backspace)
  ("Return" (cmd
              (lem/completion-mode::completion-select)
              (when (lem/prompt-window::current-prompt-window)
                (lem/prompt-window::prompt-execute)))))

(define-command fp-find-file () ()
  "find-file with backspace bound to up-directory."
  (let ((keys (make-keymap)))
    (define-key keys "Backspace" 'fp-up-directory)
    (with-special-keymap (keys)
      (call-command 'find-file (universal-argument-of-this-command)))))
(define-command fp-up-directory () ()
  "Delete the last path segment in file prompt."
  (alexandria:when-let*
      ((pwindow (lem/prompt-window::current-prompt-window))
       (wstring (and pwindow (lem/prompt-window::get-input-string))))
    (lem/prompt-window::replace-prompt-input
     (ignore-errors
       (let* ((trimmed (str:trim-right wstring :char-bag '(#\/ )))
              (endp (1+ (position #\/ trimmed :from-end t :test #'char-equal))))
         (subseq trimmed 0 endp))))
    (lem/completion-mode::completion-end)
    (ignore-errors (lem/prompt-window::prompt-completion))))

;; keys to find files
(led-key "f f" 'fp-find-file)
(define-command find-config () ()
  (find-file "/home/mahmooz/.lem/init.lisp"))
(led-key "e" 'find-config)

(define-command python-eval-region (start end) (:region)
  (unless (alive-process-p)
    (editor-error "Python process doesn't exist."))
  (lem-process:process-send-input *process* (points-to-string start end)))

(defun test50 ()
  (let ((image (sdl2-image:load-image "/home/mahmooz/dl/icon-for-lem.png")))
    (insert-string
     (buffer-point (current-buffer))
     "test"
     :attribute (lem:make-attribute :plist (list :image image)))
    (map () #'lem:stop-timer lem/common/timer::*idle-timer-list*)
    ))

(define-command my-find-definition () ()
  (lem-lisp-mode/internal::check-connection)
  (let ((symbol-name
          (lem-lisp-mode/internal::prompt-for-symbol-name "Describe symbol: "
                                                          (or (lem/buffer/internal::symbol-string-at-point (current-point)) ""))))
    (format t "looking up ~A~%" symbol-name)
    (lem-lisp-mode/internal::find-definitions-by-name symbol-name)))

(define-command my-menu () ()
  (prompt-for-string
   "test"
   :completion-function (lambda (val) (list "test1" "test2" "test3"))))