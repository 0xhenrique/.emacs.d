;;; pache-misc.el --- Everything that doesn't fit the other modules -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(dolist (pkg '(editorconfig
			   which-key
			   magit
			   ivy
			   sudo-edit
			   counsel
			   multiple-cursors
			   drag-stuff
			   yasnippet
			   pache-dark-theme
			   ;; Programming
			   json-mode
			   elixir-mode
			   company
			   rust-mode
			   typescript-mode
			   vue-mode
			   flycheck))
  (unless (package-installed-p pkg)
	(package-install pkg)))

(load-theme 'modus-vivendi t)
(set-frame-parameter (selected-frame) 'alpha '(80 . 80))
(add-to-list 'default-frame-alist '(alpha 90 0))
(setq frame-alpha-lower-limit 0)
(set-frame-font "Aporetic Sans Mono-12" nil t)

;(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
;(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq-default tab-width 4
			  standard-indent 4
			  electric-indent-inhibit t
			  indent-tabs-mode t)

(setq read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      completion-ignore-case t
	  backward-delete-char-untabify-method 'nil
      indent-line-function 'insert-tab
      ivy-use-virtual-buffers t
      counsel-find-file-at-point t
	  ;; UI
	  visible-bell t
      ring-bell-function t
      scroll-conservatively 100
      ivy-use-virtual-buffers nil
      counsel-find-file-at-point nil
      ivy-re-builders-alist
	  '((t . ivy--regex-plus))
      resize-mini-windows 'grow-only)

;; Guess major mode from file name
(setq-default major-mode
              (lambda ()
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")

(use-package yasnippet
  :ensure
  :bind
  (:map yas-minor-mode-map
        ("C-'". yas-expand)
        ([(tab)] . nil)
        ("TAB" . nil)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (scheme . t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Import programming languages specifics ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load "~/.emacs.d/lisp/languages/go.el")
(load "~/.emacs.d/lisp/languages/typescript.el")
(load "~/.emacs.d/lisp/languages/vue.el")
;(load "~/.emacs.d/lisp/languages/rust.el")

;;;;;;;;;;;
;; Hooks ;;
;;;;;;;;;;;
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'prog-mode-hook 'yas-global-mode)

;;;;;;;;;;;
;; Modes ;;
;;;;;;;;;;;
(electric-pair-mode 1)
(global-company-mode 1)
(global-display-line-numbers-mode 0)
(global-hl-line-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(multiple-cursors-mode 1)
(which-key-mode 1)
(counsel-mode 1)
(ivy-mode 1)
(save-place-mode 1)
(flymake-mode 0)
(savehist-mode 1)
(recentf-mode 1)
(editorconfig-mode 1)
(drag-stuff-global-mode 1)
(global-display-line-numbers-mode -1)
(global-visual-line-mode 1)
(blink-cursor-mode -1)

(provide 'pache-misc)
;;; pache-misc.el ends here
