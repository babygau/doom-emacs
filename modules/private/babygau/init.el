;;; private/babygau/init.el -*- lexical-binding: t; -*-

(setq
    user-mail-address "braden.truong@gmail.com"
    user-full-name    "Thanh Dung TRUONG")

;; Change keybinding specifically for macOS
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'alt
        mac-command-modifier 'meta))

;; An extra measure to prevent the flash of unstyled mode-line while Emacs is
;; booting up (when Doom is byte-compiled).
(setq-default mode-line-format nil)

;; (set! :theme 'doom-one-light)
;; (set! :theme 'doom-vibrant)
;; (set! :theme 'doom-molokai)
;; (set! :theme 'doom-tomorrow-night)

(set! :font "Operator Mono" :size 18)
(set! :big-font "Operator Mono" :size 18)
(set! :variable-font "Operator Mono" :size 18)
(set! :unicode-font "Operator Mono" :size 18)

;; My favarite color scheme
;; ------------------------
;; Gruvbox #1d2021
;; Dark Navy #00000c
;; Solarized Light #fdf6e3
(custom-set-faces
  '(default ((t (:background "#151e32"))))
  '(hl-line ((t (:background nil))))
  '(solaire-default-face ((t (:background "#151e32"))))
  '(solaire-minibuffer-face ((t (:background "#151e32"))))
  '(solaire-org-hide-face ((t (:background "#151e32"))))
  '(solaire-hl-line-face ((t (:background "#151e32"))))
  '(solaire-mode-line-face ((t (:background "#151e32"))))
  '(solaire-mode-line-inactive-face ((t (:background "#151e32"))))
  '(solaire-line-number-face ((t (:background "#151e32"))))
  '(neo-banner-face ((t (:background "#151e32"))))
  '(neo-header-face ((t (:background "#151e32"))))
  '(neo-button-face ((t (:background "#151e32"))))
  '(neo-expand-btn-face ((t (:background "#151e32"))))
  '(neo-root-dir-face ((t (:background "#151e32"))))
  '(neo-dir-link-face ((t (:background "#151e32"))))
  '(neo-vc-default-face ((t (:background "#151e32"))))
  '(org-hide ((t (:background nil :foreground nil))))
  '(org-block ((t (:background nil))))
  '(org-level-1 ((t (:background nil))))
  '(org-level-2 ((t (:background nil))))
  '(org-level-3 ((t (:background nil))))
  '(org-level-4 ((t (:background nil))))
  '(org-level-5 ((t (:background nil))))
  '(org-level-6 ((t (:background nil))))
  '(org-level-7 ((t (:background nil))))
  '(org-level-8 ((t (:background nil))))
  '(markdown-code-face ((t (:background nil))))
  '(markdown-blockquote-face ((t (:background nil))))
  )

