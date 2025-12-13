;;; init --- personal init -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Enable MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(load "~/.emacs.d/lisp/pache-platform.el")
(load "~/.emacs.d/lisp/pache-packages.el")
(load "~/.emacs.d/lisp/pache-misc.el")
(load "~/.emacs.d/lisp/pache-keys.el")
(load "~/.emacs.d/lisp/pache-utils.el")
(load "~/.emacs.d/lisp/pache-programming.el")

(load custom-file 'noerror 'nomessage)
(defalias 'yes-or-no #'y-or-n-p)

(provide 'init)
;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
