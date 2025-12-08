;;; pache-misc.el --- Everything that doesn't fit the other modules -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(set-frame-font "Iosevka Term-12" nil t)
(add-to-list 'default-frame-alist '(alpha-background . 0.9))
(set-frame-parameter nil 'alpha-background 90)

(setq-default indent-tabs-mode t
              tab-width 4
              standard-indent 4
              electric-indent-inhibit t
              indent-line-function 'insert-tab)

(setq read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
	  backward-delete-char-untabify-method 'nil
      indent-line-function 'insert-tab
      confirm-kill-emacs #'yes-or-no-p
      window-resize-pixelwise t
      frame-resize-pixelwise t
      auto-save-default nil
      visual-line-mode nil
      custom-file (expand-file-name "custom-vars.el" user-emacs-directory)
      context-menu-mode t
      scroll-step 1
      ring-bell-function 'ignore
      visible-bell nil
      inhibit-startup-screen t
      sentence-end-double-space nil
      backup-directory-alist `(("." . "~/.saves"))
	  ;; UI
	  visible-bell t
      ring-bell-function t
      scroll-conservatively 100
      resize-mini-windows 'grow-only)

;; Guess major mode from file name
(setq-default major-mode
              (lambda ()
                (unless buffer-file-name
                  (let ((buffer-file-name (buffer-name)))
                    (set-auto-mode)))))

(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (scheme . t)))

;; Hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'flymake-mode)

;; Modes
(electric-pair-mode 1)
(column-number-mode 1)
(global-hl-line-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(which-key-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(editorconfig-mode 1)
(blink-cursor-mode -1)
(global-auto-revert-mode 1)
(fido-mode 1)
(fido-vertical-mode 1)
;(yas-global-mode t)

(provide 'pache-misc)
;;; pache-misc.el ends here
