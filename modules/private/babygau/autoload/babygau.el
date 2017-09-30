;;; private/babygau/autoload/babygau.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +babygau/install-snippets ()
  "Install snippets from https://github.com/hlissner/emacs-snippets into
private/babygau/snippets."
  (interactive)
  (doom-fetch :github "hlissner/emacs-snippets"
              (expand-file-name "snippets" (doom-module-path :private 'babygau))))

;;;###autoload
(defun +babygau/yank-buffer-filename ()
  "Copy the current buffer's path to the kill ring."
  (interactive)
  (if-let (filename (or buffer-file-name (bound-and-true-p list-buffers-directory)))
      (message (kill-new (abbreviate-file-name filename)))
    (error "Couldn't find filename in current buffer")))
