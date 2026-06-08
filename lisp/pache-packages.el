;;; pache-packages.el --- Almost all packages -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(use-package company :ensure t :defer t)
(use-package undo-tree :ensure t :defer t)
(use-package consult :ensure t :defer t)
;(use-package dired :ensure t :defer t)
(use-package magit :ensure t :defer t)
(use-package sudo-edit :ensure t :defer t)
(use-package drag-stuff :ensure t :defer t)
(use-package naysayer-theme :ensure t :defer t)
(use-package pache-dark-theme :ensure t :config (load-theme 'naysayer :noconfirm))
(use-package envrc :ensure t :config (envrc-global-mode))
(use-package geiser :ensure t :defer t)

(use-package esb
  :ensure t
  :defer t
  :config
  (setq epa-pinentry-mode 'loopback)
  (setq esb-bookmarks-file "~/bookmarks/bookmarks.gpg")
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)
  (setq epa-file-select-keys nil))

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)))

(use-package yasnippet
  :ensure t
  :defer t
  :commands (yas-minor-mode yas-expand)
  :config
  (when pache/windows-p
    (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
    (yas-reload-all)))

(use-package exec-path-from-shell
  :ensure t
  :when pache/linux-p
  :config
  (setq exec-path-from-shell-variables '("PATH" "MANPATH" "NPM_CONFIG_PREFIX"))
  (exec-path-from-shell-initialize))

(use-package eglot
  :defer t
  :config
  (setq eglot-events-buffer-size 0
        eglot-sync-connect nil
        eglot-autoshutdown t)
  (when pache/windows-p
    (setq eglot-send-changes-idle-time 1.0
          eglot-ignored-server-capabilities
          '(:inlayHintProvider))))

(use-package lsp-mode
  :ensure t
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-enable-file-watchers nil
        lsp-signature-auto-activate nil
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil)
  :config
  (when pache/windows-p
    (setq lsp-idle-delay 1.0
          lsp-log-io nil)))

(provide 'pache-packages)
;;; pache-packages.el ends here
