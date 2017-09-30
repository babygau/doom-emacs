;;; private/babygau/config.el -*- lexical-binding: t; -*-

(when (featurep! :feature evil)
  (load! +bindings)  ; my key bindings
  (load! +commands)) ; my custom ex commands

(defvar +babygau-dir (file-name-directory load-file-name))
(defvar +babygau-snippets-dir (expand-file-name "snippets/" +babygau-dir))
(defvar +babygau-projects '(
                            "~/Dropbox/workspace"
                            "~/Dropbox/workspace/blog"
                            "~/Dropbox/workspace/emacs-setup"
                            "~/Dropbox/workspace/challenges/egghead"
                            "~/Dropbox/workspace/challenges/freecodecamp"
                            "~/workspace/doom-emacs"
                            "~/workspace/spacemacs"
                            ))

;; Disable tildes
(fringe-mode 0)
;; (def-package-hook! vi-tilde-fringe :disable)
;; (def-package-hook! git-gutter-fringe :disable)

;; Set `Info Manual' window to the right
(set! :popup "*info*" :align 'right :size 0.5 :select t :autokill t)

(def-package! sublimity
  :demand t
  :commands (sublimity-mode)
  :config
  (require 'sublimity)
  (require 'sublimity-scroll)
  (sublimity-mode 1)
  (setq sublimity-scroll-weight 10
        sublimity-scroll-drift-length 5))

(after! projectile
  (dolist (project +babygau-projects)
    (projectile-add-known-project project)))

;;
(after! smartparens
  ;; Auto-close more conservatively
  (let ((unless-list '(sp-point-before-word-p
                       sp-point-after-word-p
                       sp-point-before-same-p)))
    (sp-pair "'"  nil :unless unless-list)
    (sp-pair "\"" nil :unless unless-list))
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "(" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "[" nil :post-handlers '(("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p)))

(after! evil-escape
  (setq evil-escape-key-sequence "fd"))

 (after! evil-mc
  ;; if I'm in insert mode, chances are I want cursors to resume
  (add-hook! 'evil-mc-before-cursors-created
    (add-hook 'evil-insert-state-entry-hook #'evil-mc-resume-cursors nil t))
  (add-hook! 'evil-mc-after-cursors-deleted
    (remove-hook 'evil-insert-state-entry-hook #'evil-mc-resume-cursors t)))


;; Don't use default snippets, use mine.
(after! yasnippet
  (setq yas-snippet-dirs
        (append (list '+babygau-snippets-dir)
                (delq 'yas-installed-snippets-dir yas-snippet-dirs))))

;; Overwrite path set in Doom `org' module
;; NOTE:
(setq +org-dir (expand-file-name "~/Dropbox/workspace/"))

(after! org-bullets
  (setq org-bullets-bullet-list '("◉" "◎" "➥" "⚡" "⚡" "⚡" "⚡" "⚡" "⚡")))

(after! org
  ;; Working with TODO
  ;; -----------------------------

  ;; Extend TODO keywords
  ;; Prefer emoji in keyword, yay!
  ;; NOTE:
  ;; @: add note with a timestamp to a state
  ;; !: add timestamp to a state
  ;; @/!: in addition to a note taken when entering the state
  ;;      a timestamp shoud be recorded when leaving that state,
  ;;      if and only if the target/next state doesn't configue logging
  ;;      for entering it

  (setq org-startup-folded 'showeverything)
  (setq org-todo-keywords '(
                            ;; Subset for general todo
                            (sequence "TODO(t)" "STARTED(s)" "NEXT(n)" "BLOCKED(b)" "WAITING(w)" "MAYBE(m)" "|" "DONE(d)")
                            ;; Subset for reading
                            (sequence "TOREAD" "READING" "|" "DONE")
                            ;; Subset for general use
                            (sequence "|" "CANCELLED(c)")))


  (setq org-todo-keyword-faces '(
                                 ("TODO" . "red")
                                 ("TOREAD" . "red")
                                 ("STARTED" . "#cc3e44")
                                 ("READING" . "#cc3e44")
                                 ("NEXT" . "green")
                                 ("BLOCKED" . "pink")
                                 ("WAITING" . "yellow")
                                 ("MAYBE" . "purple")
                                 ("DONE" . "#8dc149")
                                 ("CANCELLED" . "orange")))

  ;; Add or remove tags on state change
  ;; (setq org-todo-state-tags-triggers
  ;;       '(("CANCELLED" ("CANCELLED" . t) ("STARTED") ("NEXT") ("BLOCKED") ("CANCELLED") ("MAYBE"))
  ;;         ("WAITING" ("WAITING" . t) ("STARTED") ("NEXT") ("BLOCKED") ("CANCELLED") ("MAYBE"))
  ;;         ("BLOCKED" ("BLOCKED" . t) ("STARTED") ("NEXT") ("WAITING") ("CANCELLED") ("MAYBE"))
  ;;         ("STARTED" ("STARTED" . t) ("NEXT") ("WAITING") ("CANCELLED") ("BLOCKED") ("MAYBE"))
  ;;         ("NEXT" ("NEXT" . t) ("STARTED") ("BLOCKED") ("WAITING") ("CANCELLED") ("MAYBE"))
  ;;         ("MAYBE" ("MAYBE" . t) ("STARTED") ("NEXT") ("WAITING") ("CANCELLED") ("BLOCKED"))
  ;;         ("TODO" ("STARTED") ("NEXT") ("WAITING") ("BLOCKED") ("MAYBE"))
  ;;         (done ("STARTED") ("NEXT") ("WAITING") ("BLOCKED") ("MAYBE"))
  ;;         ("" ("STARTED") ("NEXT") ("WAITING") ("BLOCKED") ("MAYBE"))))

  ;; Force children of the entry to complete before completing entry
  (setq org-enforce-todo-dependencies t)

  ;; Force children of a checkbox entry to complete before completing entry
  (setq org-enforce-todo-checkbox-dependencies t)

  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel              . 9)
                                   (org-agenda-files :maxlevel . 9))))

  ;; Use full outline paths for refile targets - we file directly with ido
  (setq org-refile-use-outline-path t)

  ;; Targets complete directly with ido
  (setq org-outline-path-complete-in-steps nil)

  ;; Add timestamp to a TODO entry
  ;; A `CLOSED' timestamp will be appended when TODO state is `DONE'
  (setq org-log-done 'time)
  ;; Add note to a TODO entry
  ;; (setq org-log-done 'note)

  ;; Add those properties to a drawer =LOGBOOK=
  ;; (setq org-log-into-drawer t)

  ;; Make TODO entry automatically change to DONE when all children are done
  ;; NOTE: not working properly at the moment, will fix it later
  ;; when i have decent knowledge of clojure/emacs-lisp language

  ;; (defun org-summary-todo (n-done n-not-done)
  ;;   "switch entry to DONE when all subentries are done, to TODO otherwise."
  ;;   (let (org-log-done org-log-states) ; turn off logging
  ;;     (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
  ;; (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

  ;; Set tags list
  (setq org-tag-alist '(;; Where
                        (:startgrouptag)
                        ("@where")
                        (:grouptags)
                        ("@work" . ?w)
                        ("@home" . ?h)
                        (:endgrouptag)

                        ;; Programming group
                        (:startgrouptag)
                        ("#programming")
                        (:grouptags)
                        ("#js")
                        ("#react")
                        ("#elm")
                        ("#css3")
                        ("#clj")
                        ("#haskell")
                        (:endgrouptag)

                        ;; Workflow
                        (:startgrouptag)
                        ("#workflow")
                        (:grouptags)
                        ("#windows")
                        ("#linux")
                        ("#macos")
                        ("#emacs")
                        (:endgrouptag)

                        ;; None group
                        ("#writing")
                        ("#bookmarks")
                        ("#read-later")
                        ("#tips")))


  ;; Save the clock history across emacs sessions
  ;; REF: Org Manual
  ;; (setq org-clock-persist 'history)
  ;; (org-clock-persistence-insinuate)

  ;; Set idle time when i'm away from keyboard
  ;; Might be 10 or 15mins
  ;; (setq org-clock-idle-time 15)

  ;; Capture templates
  ;; REF: http://bit.ly/2i2Iyte
  ;; --------------------------------

  (setq org-capture-templates
        '(
          ("t" "Put in the *TODOLIST*")
          ("tp" "Personal TODO" entry (file+headline "~/Dropbox/workspace/todo.org" "PERSONAL TODO")
           "* TODO %?\n  - Created at %U" :prepend t)
          ("td" "Dev TODO" entry (file+headline "~/Dropbox/workspace/todo.org" "DEV TODO")
           "* TODO %?\n  - Created at %U" :prepend t)
          ("ts" "Shopping List" entry (file+headline "~/Dropbox/workspace/todo.org" "SHOPPING LISTS")
           "* TODO %U [/]\n  - [ ] %?" :prepend t)
          ("tb" "Bill to Pay | Don't forget to give me a deadline!" entry (file+headline "~/Dropbox/workspace/todo.org" "BILL")
           "* TODO %^{Description|Vodafone|Internet|Bupa Insurance|Gas|Electricity}: %?AUD" :prepend t)
          ("tv" "Video/Course to Watch" entry (file+headline "~/Dropbox/workspace/todo.org" "VIDEO/COURSE TO WATCH")
           "* TODO %?\n  - Created at %U" :prepend t)
          ("tm" "Movies to Watch" item (file+headline "~/Dropbox/workspace/todo.org" "MOVIES TO WATCH")
           "[ ] %?" :prepend t)
          ("tr" "Books to Read" entry (file+headline "~/Dropbox/workspace/todo.org" "BOOKS TO READ")
           "* TOREAD %?" :prepend t)
          ("tw" "Wishing List" item (file+headline "~/Dropbox/workspace/todo.org" "WISHING LIST")
           "[ ] %?" :prepend t)

          ("w" "Write Me Down")
          ("wb" "I want to write a blog post" entry (file "~/Dropbox/workspace/blog/blog-todo.org")
           "* TODO %?\n  - Created at %U" :prepend t)
          ))

  ;; Agenda view
  ;; --------------------------------

  (setq org-agenda-files '(;; Main GTD list
                           "~/Dropbox/workspace/todo.org"
                           ;; Extra list from big scenario
                           ))

  ;; set agenda custom commands
  ;; (setq org-agenda-custom-commands
  ;;       '(("x" agenda)
  ;;         ("y" agenda*)
  ;;         ("w" todo "WAITING")
  ;;         ("W" todo-tree "WAITING")
  ;;         ("u" tags "+boss-urgent")
  ;;         ("v" tags-todo "+boss-urgent")
  ;;         ("U" tags-tree "+boss-urgent")
  ;;         ("f" occur-tree "\\<FIXME\\>")
  ;;         ("h" . "HOME+Name tags searches") ; description for "h" prefix
  ;;         ("hl" tags "+home+Lisa")
  ;;         ("hp" tags "+home+Peter")
  ;;         ("hk" tags "+home+Kim")))
    )
