;;; pache-packages.el --- Almost all packages -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(use-package which-key :ensure t :defer t)
(use-package markdown-mode :ensure t :defer t)
(use-package yaml-mode :ensure t :defer t)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package magit
  :ensure t
  :defer t
  :config
  (when pache/windows-p
    ;; Disable auto-refresh on Windows
    (setq magit-refresh-status-buffer nil)
    (setq magit-diff-refine-hunk nil)))

(when pache/linux-p
  (use-package git-gutter
    :ensure t
    :hook (prog-mode . git-gutter-mode)))

(when pache/windows-p
  (use-package diff-hl
    :ensure t
    :config
    (setq diff-hl-draw-borders nil)
    :hook ((prog-mode . diff-hl-mode)
           (magit-pre-refresh . diff-hl-magit-pre-refresh)
           (magit-post-refresh . diff-hl-magit-post-refresh))))

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

(if pache/windows-p
    (progn
      (setq tab-always-indent 'complete)
      (setq completion-cycle-threshold 3))
  (use-package company
    :ensure t
    :config
    (global-company-mode 1)))

(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2))

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(provide 'pache-packages)
;;; pache-packages.el ends here
