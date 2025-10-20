;;; pache-packages.el --- Almost all packages -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(use-package which-key :ensure t :defer t)
(use-package markdown-mode :ensure t :defer t)
(use-package yaml-mode :ensure t :defer t)

(when pache/linux-p
  (use-package git-gutter
    :ensure t
    :hook (prog-mode . git-gutter-mode)))

(when pache/windows-p
  (use-package diff-hl
    :ensure t
    :config
    (setq diff-hl-draw-borders nil)
    (setq diff-hl-flydiff-mode nil)  ; Disable live diff
    :hook (prog-mode . diff-hl-mode)))

(use-package magit
  :ensure t
  :defer t
  :config
  (when pache/windows-p
    (setq magit-refresh-status-buffer nil)
    (setq magit-diff-refine-hunk nil)
    (setq magit-revision-show-gravatars nil)))  ; Disable gravatars

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
        corfu-auto-delay (if pache/windows-p 0.3 0.1)  ; slower on Windows
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt)
  (when pache/windows-p
    (setq corfu-count 10)))  ; show fewer candidates

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package flycheck
  :ensure t
  :defer t
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically 
        (if pache/windows-p
            '(save mode-enabled)  ; Only on save for Windows
            '(save idle-change mode-enabled)))
  (setq flycheck-idle-change-delay 
        (if pache/windows-p 4.0 1.5))
  ;; Disable checkers that are slow on Windows
  (when pache/windows-p
    (setq-default flycheck-disabled-checkers 
                  '(emacs-lisp-checkdoc))))

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

(provide 'pache-packages)
;;; pache-packages.el ends here
