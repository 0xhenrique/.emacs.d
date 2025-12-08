;;; pache-programming.el --- Functions and Helpers for Programming Modes -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

;; Typescript
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

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook (typescript-mode . eglot-ensure)  
  :bind (:map typescript-mode-map
              ("C-c C-b" . pache/typescript-compile)
              ("C-c C-l" . pache/typescript-lint)
              ("C-c C-t" . pache/typescript-test)))

(defun pache/jump-to-section (section)
  "Jump to a specific SECTION in a Vue file."
  (re-search-forward (concat "^<" section ">") nil t))

;; Vue
(use-package vue-mode
  :ensure t
  :config
  (setq mmm-submode-decoration-level 0)
  :bind (:map vue-mode-map
              ("C-c C-b" . pache/typescript-compile)
              ("C-c C-f" . pache/typescript-format)
              ("C-c C-l" . pache/typescript-lint)
              ("C-c C-t" . pache/typescript-test))
  :hook (vue-mode . lsp-deferred))

;; Clojure
(defun pache/leiningen-run-command (command)
  "Run a Leiningen COMMAND in the root of the current project."
  (let ((default-directory (locate-dominating-file default-directory "project.clj")))
    (unless default-directory
      (error "Not inside a Leiningen project"))
    (compile (concat "lein " command))))

(defun pache/leiningen-build ()
  "Run `lein build` in the current Leiningen project."
  (interactive)
  (pache/leiningen-run-command "build"))

(defun pache/leiningen-test ()
  "Run `lein test` in the current Leiningen project."
  (interactive)
  (pache/leiningen-run-command "test"))

(defun pache/leiningen-run ()
  "Run `lein run` in the current Leiningen project."
  (interactive)
  (pache/leiningen-run-command "run"))

(use-package clojure-mode
  :ensure t
  :hook (clojure-mode . eglot-ensure)
  :bind (:map clojure-mode-map
              ("C-c C-b" . pache/leiningen-build)
              ("C-c C-r" . pache/leiningen-run)
              ("C-c C-t" . pache/leiningen-test)))

(use-package cider
  :ensure t
  :defer t
  :config
  (setq cider-repl-display-help-banner nil
        cider-repl-pop-to-buffer-on-connect 'display-only)
  :bind (:map clojure-mode-map
              ("C-c C-c" . cider-eval-defun-at-point)
              ("C-c C-k" . cider-load-buffer)
              ("C-c C-z" . cider-switch-to-repl-buffer)))

;; Go
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

;; Rust
(defun pache/rust-run-clippy ()
  "Run `cargo clippy`."
  (interactive)
  (compile "cargo clippy"))

(defun pache/rust-run-lens ()
  "Run the code lens provided by rust-analyzer."
  (interactive)
  (lsp-execute-code-action-by-kind "refactor"))

(use-package rust-mode
  :ensure t
  :hook (rust-mode . eglot-ensure)
  :bind (:map rust-mode-map
	      ("C-c C-a" . 'pache/rust-run-lens)
	      ("C-c C-c" . 'pache/rust-compile)
	      ("C-c C-f" . 'pache/rust-format-buffer)
	      ("C-c C-l" . 'pache/rust-run-clippy)
	      ("C-c C-r" . 'pache/rust-run)
	      ("C-c C-t" . 'pache/rust-test)))

(provide 'pache-programming)
;;; pache-programming.el ends here
