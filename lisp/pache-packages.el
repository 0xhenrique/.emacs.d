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

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (setq lsp-keymap-prefix "C-c l")
  (when pache/windows-p
    (setq lsp-idle-delay 0.500
          lsp-log-io nil
          lsp-enable-file-watchers nil
          lsp-signature-render-documentation nil)))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover nil))

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

(provide 'pache-packages)
;;; pache-packages.el ends here
