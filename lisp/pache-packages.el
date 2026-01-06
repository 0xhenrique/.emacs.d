;;; pache-packages.el --- Almost all packages -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(use-package company :ensure t :defer t)
(use-package consult :ensure t :defer t)
(use-package which-key :ensure t :defer t)
(use-package markdown-mode :ensure t :defer t)
(use-package sudo-edit :ensure t :defer t)
;(use-package pache-dark-theme :ensure t :config (load-theme 'pache-dark :noconfirm))
(add-to-list 'custom-theme-load-path
             "~/workspace/0xhenrique/pache-dark-theme/")
(load-theme 'modus-vivendi :noconfirm)
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

(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1))

(use-package magit
  :ensure t
  :defer t
  :config
  (when pache/windows-p
    (setq magit-refresh-status-buffer nil)
    (setq magit-diff-refine-hunk nil)
    (setq magit-revision-show-gravatars nil)))

(use-package yasnippet
  :ensure t
  :defer t
  :commands (yas-minor-mode yas-expand)
  :config
  (when pache/windows-p
    (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
    (yas-reload-all)))

(use-package project
  :config
  (when pache/windows-p
    ;; Limit project search depth on Windows
    (setq project-vc-merge-submodules nil)))

(use-package geiser-guile
  :ensure t
  :defer t
  :config
  (setq geiser-guile-binary "guile"))

(use-package dired
  :config
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-dwim-target t))

(use-package exec-path-from-shell
  :ensure t
  :when pache/linux-p
  :config
  (setq exec-path-from-shell-variables '("PATH" "MANPATH" "NPM_CONFIG_PREFIX"))
  (exec-path-from-shell-initialize))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

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
