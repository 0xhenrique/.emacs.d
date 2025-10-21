;;; go.el --- Functions and Helpers for Golang Projects -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(defun pache/go-build ()
  "Run `go build` in the project root."
  (interactive)
  (compile "go build ./..."))

(defun pache/go-run ()
  "Run `go run .` in the project root."
  (interactive)
  (compile "go run ."))

(defun pache/go-test ()
  "Run `go test ./...`."
  (interactive)
  (compile "go test ./..."))

(use-package go-mode
  :ensure t
  :hook (go-mode . eglot-ensure)
  :bind (:map go-mode-map
              ("C-c C-b" . (lambda () (interactive) (compile "go build ./...")))
              ("C-c C-t" . (lambda () (interactive) (compile "go test ./...")))
              ("C-c C-r" . (lambda () (interactive) (compile "go run .")))))

(add-hook 'go-mode-hook 
          (lambda () (setq indent-tabs-mode t)))

(provide 'go)
;;; go.el ends here
