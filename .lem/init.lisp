(in-package :lem-user)

;; Start in vi-mode
(lem-vi-mode:vi-mode)

(setf lem-core::*default-prompt-gravity* :bottom-display)
(setf lem/prompt-window::*prompt-completion-window-gravity* :horizontally-above-window)
(setf lem/prompt-window::*fill-width* t)

;; C-h is initially bound to delete-previous-char
(define-keys *global-keymap*
  ("C-h b" 'describe-bindings)
  ("C-h k" 'describe-key)
  ("C-h a" 'lem-lisp-mode:lisp-apropos)
  ("C-h c" 'apropos-command)
  ("C-h p" 'lem-lisp-mode:lisp-apropos-package)
  ("C-h f" 'lem-lisp-mode:lisp-describe-symbol))

(defvar *frame-keymap*
  (make-keymap :name '*frame-multiplexer-keymap*)
  "keymap for commands related to the frame-multiplexer.")
(define-key *frame-keymap* "c" 'frame-multiplexer-create-with-new-buffer-list)
(define-key *frame-keymap* "d" 'frame-multiplexer-delete)
(define-key *frame-keymap* "p" 'frame-multiplexer-prev)
(define-key *frame-keymap* "n" 'frame-multiplexer-next)
(define-key *frame-keymap* "r" 'frame-mulitplexer-rename)
(define-key *global-keymap* "C-z" *frame-keymap*)

;; relative line numbers
(lem/line-numbers:toggle-line-numbers)
(setf lem/line-numbers:*relative-line* t)

(define-key lem-vi-mode:*normal-keymap*
  "Space Space"
  'execute-command)

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

(led-key "f f" 'find-file)
