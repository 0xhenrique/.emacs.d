;;; pache-misc.el --- Everything that doesn't fit the other modules -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:
(dolist (pkg '(editorconfig
			   sudo-edit
			   pache-dark-theme
			   json-mode
			   flycheck))
  (unless (package-installed-p pkg)
	(package-install pkg)))

(load-theme 'pache-dark :noconfirm)
(set-frame-font "Aporetic Sans Mono-12" nil t)
(set-frame-parameter nil 'alpha-background 92)

(setq-default tab-width 4
			  standard-indent 4
			  electric-indent-inhibit t
			  indent-tabs-mode nil)

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

(add-to-list 'default-frame-alist '(alpha-background . 92))
(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")

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
(add-hook 'prog-mode-hook 'yas-global-mode)

;;;;;;;;;;;
;; Modes ;;
;;;;;;;;;;;
(electric-pair-mode 1)
(column-number-mode 1)
(global-display-line-numbers-mode 0)
(global-hl-line-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(which-key-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(editorconfig-mode 1)
(global-display-line-numbers-mode 1)
(global-visual-line-mode 1)
(blink-cursor-mode -1)
(doom-modeline-mode 1)

(provide 'pache-misc)
;;; pache-misc.el ends here
