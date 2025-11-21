;;; init --- personal init -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Enable MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Modules for Pachemacs
(load "~/.emacs.d/lisp/pache-misc.el")
(load "~/.emacs.d/lisp/pache-keys.el")
(load "~/.emacs.d/lisp/pache-utils.el")
(load "~/.emacs.d/lisp/pache-platform.el")
(load "~/.emacs.d/lisp/pache-packages.el")

(setq confirm-kill-emacs #'yes-or-no-p
      window-resize-pixelwise t
      frame-resize-pixelwise t
      auto-save-default nil
      visual-line-mode nil
      custom-file (locate-user-emacs-file "~/.emacs.d/.custom-vars.el")
      context-menu-mode t
      scroll-step 1
      ring-bell-function 'ignore
      visible-bell 1
      inhibit-startup-screen t
      sentence-end-double-space nil
      backup-directory-alist `(("." . "~/.saves")))

(load custom-file 'noerror 'nomessage)
(defalias 'yes-or-no #'y-or-n-p)

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
