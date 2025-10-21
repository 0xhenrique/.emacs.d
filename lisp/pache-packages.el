;;; pache-packages.el --- Almost all packages -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(use-package which-key :ensure t :defer t)
(use-package markdown-mode :ensure t :defer t)
(use-package yaml-mode :ensure t :defer t)

(use-package multiple-cursors
  :ensure t
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)))

(use-package drag-stuff
  :ensure t
  :config
  (drag-stuff-global-mode 1))

(use-package diff-hl
  :ensure t
  :config
  (setq diff-hl-draw-borders nil)
  (setq diff-hl-flydiff-mode nil)
  :hook (prog-mode . diff-hl-mode))

(use-package magit
  :ensure t
  :defer t
  :config
  (when pache/windows-p
    (setq magit-refresh-status-buffer nil)
    (setq magit-diff-refine-hunk nil)
    (setq magit-revision-show-gravatars nil)))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (when pache/windows-p
    (add-hook 'prog-mode-hook
              (lambda ()
                (when (< (buffer-size) 100000)  ; only files < 100KB
                  (rainbow-delimiters-mode))))))

(use-package yasnippet
  :ensure t
  :defer t
  :commands (yas-minor-mode yas-expand)
  :hook (prog-mode . yas-minor-mode)
  :config
  (when pache/windows-p
    (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
    (yas-reload-all)))

(use-package project
  :config
  (when pache/windows-p
    ;; Limit project search depth on Windows
    (setq project-vc-merge-submodules nil)))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt))

(use-package eglot
  :ensure t
  :defer t
  :config
  (setq eglot-events-buffer-size 0)
  (setq eglot-sync-connect nil)
  (when pache/windows-p
    (setq eglot-send-changes-idle-time 1.0)
    (setq eglot-ignored-server-capabilities 
          '(:inlayHintProvider))))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ;; M-g bindings (goto-map)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop))
  :config
  (setq consult-narrow-key "<"))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package flymake
  :bind (:map flymake-mode-map
              ("C-c ! n" . flymake-goto-next-error)
              ("C-c ! p" . flymake-goto-prev-error)
              ("C-c ! l" . flymake-show-buffer-diagnostics)))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package geiser
  :ensure t
  :defer t)

(use-package geiser-guile
  :ensure t
  :defer t
  :config
  (setq geiser-guile-binary "guile"))

(use-package dired
  :config
  (setq dired-listing-switches "-alh --group-directories-first"
        dired-dwim-target t)
  (when pache/linux-p
    (setq dired-guess-shell-alist-user
          '(("\\.pdf\\'" "zathura")
            ("\\.mkv\\'" "mpv")
            ("\\.mp3\\'" "mpv")
            ("\\.flac\\'" "mpv")
            ("\\.mp4\\'" "mpv")))))

(use-package all-the-icons-dired
  :ensure t
  :when pache/linux-p
  :hook (dired-mode . all-the-icons-dired-mode))

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

(provide 'pache-packages)
;;; pache-packages.el ends here
