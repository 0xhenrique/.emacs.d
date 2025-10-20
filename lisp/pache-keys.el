;;; pache-keys.el --- Custom Keybindings for Emacs with evil-mode -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

;; Unbind default keys
(global-unset-key (kbd "C-x <left>"))
(global-unset-key (kbd "C-x <right>"))
(global-unset-key (kbd "C-x <up>"))
(global-unset-key (kbd "C-x <down>"))

;; Windows/Panes/Frames
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)

;; ESB
(global-set-key (kbd "C-c e s") 'esb-select-bookmark)
(global-set-key (kbd "C-c e a") 'esb-add-bookmark)
(global-set-key (kbd "C-c e d") 'esb-delete-bookmark)
(global-set-key (kbd "C-c e l") 'esb-list-bookmarks)
(global-set-key (kbd "C-c e e") 'esb-edit-bookmark)
(global-set-key (kbd "C-c e r") 'esb-reload-bookmarks)
(global-set-key (kbd "C-c e i") 'esb-initialize)
(global-set-key (kbd "C-c e f") 'esb-flush-cache)

;; Other
(global-set-key (kbd "C-x C-f") 'find-file)
(global-set-key (kbd "C-x p w") 'consult-ripgrep)
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-x /") 'consult-line)
(global-set-key (kbd "C-x C-/") 'pache/swiper-isearch-thing-at-point)
;(global-set-key (kbd "M-y") 'counsel-yank-pop)
;(global-set-key (kbd "M-x") 'counsel-M-x)
;(global-set-key (kbd "C-x C-/") 'pache/swiper-isearch-thing-at-point)
;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;(global-set-key (kbd "C-x p f") 'project-find-file)
;(global-set-key (kbd "C-x p w") 'counsel-rg)
;(global-set-key (kbd "C-x b") 'counsel-switch-buffer)
;(global-set-key (kbd "C-x /") 'swiper-isearch)

;; Unused
;(global-set-key (kbd "C-c c") 'counsel-compile)
;(global-set-key (kbd "C-c g") 'counsel-git)
;(global-set-key (kbd "C-x C-f") 'counsel-find-file)
;(global-set-key (kbd "C-c L") 'counsel-git-log)
;(global-set-key (kbd "C-c m") 'counsel-linux-app)
;(global-set-key (kbd "C-c n") 'counsel-fzf)
;(global-set-key (kbd "C-x l") 'counsel-locate)
;(global-set-key (kbd "C-c J") 'counsel-file-jump)
;(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;(global-set-key (kbd "C-c w") 'counsel-wmctrl)

(provide 'pache-keys)
;;; pache-keys.el ends here
