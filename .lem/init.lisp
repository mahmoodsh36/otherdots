(in-package :lem-user)

;; Start in vi-mode
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
  ("a" 'lem-lisp-mode:lisp-apropos)
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
;; spc-h for help keys
;; (define-key *global-keymap* "C-z" *frame-keymap*)
(define-key lem-vi-mode:*normal-keymap*
  "Space h"
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

;; keys to find files
(led-key "f f" 'find-file)
(led-key "e" (lambda () (find-file "/home/mahmooz/.lem/init.lisp")))

(led-key "x" 'lem-lisp-mode/eval::lisp-eval-defun)