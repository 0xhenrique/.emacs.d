;;; typescript.el --- Functions and Helpers for Typescript Projects -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(defun pache/typescript-compile ()
  "Run `npm run build` in the project root."
  (interactive)
  (compile "npm run build"))

(defun pache/typescript-lint ()
  "Run `npm run lint` only on the current file."
  (interactive)
  (let ((file (shell-quote-argument (buffer-file-name))))
    (compile (format "npm run lint -- %s" file))))

(defun pache/typescript-test ()
  "Run `npm run test` in the project root."
  (interactive)
  (compile "npm run test"))

(defun pache/typescript-format ()
  "Format the current file with Prettier."
  (interactive)
  (let ((file (shell-quote-argument (buffer-file-name))))
    (compile (format "npx prettier --write %s" file))))

(defun pache/format-buffer-with-prettier ()
  "Format buffer with Prettier silently."
  (when (and buffer-file-name
             (or (derived-mode-p 'typescript-mode)
                 (derived-mode-p 'vue-mode)))
    (let ((file (shell-quote-argument buffer-file-name)))
      (shell-command (format "npx prettier --write %s" file) nil nil)
      (revert-buffer t t t))))

;; (add-hook 'after-save-hook #'pache/format-buffer-with-prettier)

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook (typescript-mode . eglot-ensure)
  :bind (:map typescript-mode-map
              ("C-c C-b" . pache/typescript-compile)
              ("C-c C-f" . pache/typescript-format)
              ("C-c C-l" . pache/typescript-lint)
              ("C-c C-t" . pache/typescript-test)))

(provide 'typescript)
;;; typescript.el ends here
