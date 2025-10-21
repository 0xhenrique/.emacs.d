;;; vue.el --- Functions and Helpers for Vue Projects -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(defun pache/jump-to-section (section)
  "Jump to a specific SECTION in a Vue file."
  (re-search-forward (concat "^<" section ">") nil t))

(use-package vue-mode
  :ensure t
  :config
  (setq mmm-submode-decoration-level 0)
  :bind (:map vue-mode-map
              ("C-c C-b" . pache/typescript-compile)
              ("C-c C-f" . pache/typescript-format)
              ("C-c C-l" . pache/typescript-lint)
              ("C-c C-t" . pache/typescript-test)))

(provide 'vue)
;;; vue.el ends here
