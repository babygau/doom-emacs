;;; app/rss/config.el

;; This is an opinionated workflow that turns Emacs into an RSS reader, inspired
;; by apps Reeder and Readkit. It can be invoked via `=rss'. Otherwise, if you
;; don't care for the UI you can invoke elfeed directly with `elfeed'.

(defvar +rss-org-dir (concat +org-dir "/rss/")
  "Where RSS org files are located.")

(defvar +rss-elfeed-files (list "elfeed.org")
  "The files that configure `elfeed's rss feeds.")

(defvar +rss-workspace-name "RSS"
  "The name of the transient workspace for elfeed to run in.")

(defvar +rss-split-direction 'below
  "What direction to pop up the entry buffer in elfeed.")


;;
;; Packages
;;

(def-package! elfeed
  :commands elfeed
  :config
  (setq-default elfeed-search-filter "@2-week-ago ")
  (setq elfeed-db-directory (concat doom-local-dir "elfeed/")
        elfeed-show-entry-switch '+rss-popup-pane
        elfeed-show-entry-delete '+rss/delete-pane)

  ;; Ensure elfeed buffers are treated as real
  (push (lambda (buf) (string-match-p "^\\*elfeed" (buffer-name buf)))
        doom-real-buffer-functions)

  (add-hook! (elfeed-search-mode elfeed-show-mode)
    'doom-hide-modeline-mode)
  (add-hook 'elfeed-show-mode-hook '+rss|elfeed-wrap)

  (after! doom-themes
    (add-hook 'elfeed-show-mode-hook 'doom-buffer-mode))

  (map! :map elfeed-search-mode-map
        :n "r"   'elfeed-update
        :n "RET" 'elfeed-search-show-entry

        :map elfeed-show-mode-map
        [remap doom/kill-this-buffer] 'elfeed-kill-buffer
        :n "q"  'elfeed-kill-buffer
        :m "j"  'evil-next-visual-line
        :m "k"  'evil-previous-visual-line
        :n "]b" '+rss/next
        :n "[b" '+rss/previous))

(def-package! elfeed-org
  :after elfeed
  :config
  (setq rmh-elfeed-org-files
        (let ((default-directory +rss-org-dir))
          (mapcar 'expand-file-name +rss-elfeed-files)))
  (elfeed-org))