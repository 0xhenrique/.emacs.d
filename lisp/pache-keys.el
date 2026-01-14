;;; pache-keys.el --- Custom Keybindings for Emacs with evil-mode -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

;; Unset
(global-unset-key (kbd "C-x <left>"))
(global-unset-key (kbd "C-x <right>"))
(global-unset-key (kbd "C-x <up>"))
(global-unset-key (kbd "C-x <down>"))
(global-unset-key (kbd "C-x C-r"))
(global-unset-key (kbd "C-t"))

;; ESB
(global-set-key (kbd "C-c e s") 'esb-select-bookmark)
(global-set-key (kbd "C-c e a") 'esb-add-bookmark)
(global-set-key (kbd "C-c e d") 'esb-delete-bookmark)
(global-set-key (kbd "C-c e l") 'esb-list-bookmarks)
(global-set-key (kbd "C-c e e") 'esb-edit-bookmark)
(global-set-key (kbd "C-c e r") 'esb-reload-bookmarks)
(global-set-key (kbd "C-c e i") 'esb-initialize)
(global-set-key (kbd "C-c e f") 'esb-flush-cache)

;; Windows/Panes/Frames
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)

;; Search & Navigation
(global-set-key (kbd "C-x C-f") 'find-file)
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-x /") 'consult-line)
(global-set-key (kbd "C-x C-/") 'pache/occur-thing-at-point)
(global-set-key (kbd "C-x C-r") 'pache/rgrep-selected)

;; Project-wide search
(global-set-key (kbd "C-x p w") 'consult-ripgrep)
(global-set-key (kbd "C-x p f") 'project-find-file)

;; Jump to definition/references
(global-set-key (kbd "M-.") 'xref-find-definitions)
(global-set-key (kbd "M-,") 'xref-pop-marker-stack)
(global-set-key (kbd "M-?") 'xref-find-references)

;; Project Management
(global-set-key (kbd "C-x p p") 'project-switch-project)
(global-set-key (kbd "C-x p c") 'project-compile)
(global-set-key (kbd "C-x p s") 'project-shell)
(global-set-key (kbd "C-x p k") 'project-kill-buffers)

;; Git/Magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)
(global-set-key (kbd "C-c g b") 'magit-blame)
(global-set-key (kbd "C-c g l") 'magit-log-buffer-file)
(global-set-key (kbd "C-c g f") 'magit-file-dispatch)

;; Multiple cursors
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; Comment/uncomment
(global-set-key (kbd "C-c ;") 'comment-line)
(global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region)

;; Move lines up/down
(global-set-key (kbd "M-<up>") 'pache/line-move-up)
(global-set-key (kbd "M-<down>") 'pache/line-move-down)
;; Duplicate line
(global-set-key (kbd "C-c d") 'pache/duplicate-line)

;; Format buffer
(global-set-key (kbd "C-c f") 'format-all-buffer)

;; Compilation & Testing
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c r") 'recompile)
(global-set-key (kbd "C-c C-k") 'kill-compilation)

;; Quick access to compilation buffer
(global-set-key (kbd "C-c C-c") 'next-error)
(global-set-key (kbd "C-c C-p") 'previous-error)

;; LSP/Eglot specific
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l a") 'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l r") 'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l f") 'eglot-format)
  (define-key eglot-mode-map (kbd "C-c l o") 'eglot-code-action-organize-imports)
  (define-key eglot-mode-map (kbd "C-c l h") 'eldoc))

;; Shell/Terminal
(global-set-key (kbd "C-c s") 'pache/create-shell)
(global-set-key (kbd "C-c t") 'ansi-term)

;; Org Mode
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)

;; Misc Utilities
(global-set-key (kbd "C-x u") 'undo-tree-visualize)

(provide 'pache-keys)
;;; pache-keys.el ends here
