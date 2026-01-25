;;; pache-programming.el --- Functions and Helpers for Programming Modes -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Typescript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  ;:hook (typescript-mode . eglot-ensure)
  :bind (:map typescript-mode-map
              ("C-c C-b" . pache/typescript-compile)
              ("C-c C-l" . pache/typescript-lint)
              ("C-c C-t" . pache/typescript-test)))

(defun pache/jump-to-section (section)
  "Jump to a specific SECTION in a Vue file."
  (re-search-forward (concat "^<" section ">") nil t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package vue-mode
  :ensure t
  :config
  (setq mmm-submode-decoration-level 0)
  :bind (:map vue-mode-map
              ("C-c C-b" . pache/typescript-compile)
              ("C-c C-f" . pache/typescript-format)
              ("C-c C-l" . pache/typescript-lint)
              ("C-c C-t" . pache/typescript-test)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Go
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rust
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C/C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun pache/cpp-project-root ()
  "Find the root of the current C/C++ project.
Looks for Makefile, CMakeLists.txt, or falls back to .git."
  (or (locate-dominating-file default-directory "Makefile")
      (locate-dominating-file default-directory "CMakeLists.txt")
      (locate-dominating-file default-directory ".git")
      default-directory))

(defun pache/cpp-build ()
  "Compile the current C/C++ project using make or cmake."
  (interactive)
  (let ((default-directory (pache/cpp-project-root)))
    (cond
     ((file-exists-p "build/Makefile")
      (compile "cmake --build build"))
     ((and (file-exists-p "CMakeLists.txt")
           (not (file-exists-p "Makefile")))
      (compile "cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build"))
     ((file-exists-p "Makefile")
      (compile "make -k"))
     (t
      (message "No build system found (Makefile or CMakeLists.txt)")))))

(defun pache/cpp-run ()
  "Run the compiled binary from project root."
  (interactive)
  (let* ((root (pache/cpp-project-root))
         (default-directory root)
         (candidates (list
                      (expand-file-name "build/main" root)
                      (expand-file-name "build/a.out" root)
                      (expand-file-name (file-name-nondirectory
                                         (directory-file-name root)) root)
                      (expand-file-name "main" root)
                      (expand-file-name "a.out" root)))
         (executable (cl-find-if #'file-executable-p candidates)))
    (if executable
        (compile executable)
      (let ((exe (read-file-name "Executable: " root)))
        (compile exe)))))

(defun pache/cpp-build-and-run ()
  "Build the project and run the executable if successful."
  (interactive)
  (let ((default-directory (pache/cpp-project-root)))
    (compile (pache/cpp--build-command))
    (add-hook 'compilation-finish-functions
              #'pache/cpp--run-after-compile nil t)))

(defun pache/cpp--build-command ()
  "Return the appropriate build command."
  (cond
   ((file-exists-p "build/Makefile") "cmake --build build")
   ((and (file-exists-p "CMakeLists.txt")
         (not (file-exists-p "Makefile")))
    "cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build")
   ((file-exists-p "Makefile") "make -k")
   (t "make")))

(defun pache/cpp--run-after-compile (buffer status)
  "Run the binary after successful compilation."
  (remove-hook 'compilation-finish-functions #'pache/cpp--run-after-compile t)
  (when (string-match-p "finished" status)
    (pache/cpp-run)))

(defun pache/cpp-compile-file ()
  "Compile only the current file with g++."
  (interactive)
  (let* ((file (buffer-file-name))
         (out (concat (file-name-sans-extension file) ".out")))
    (compile (format "g++ -std=c++17 -Wall -Wextra -O2 %s -o %s"
                     (shell-quote-argument file)
                     (shell-quote-argument out)))))

(defun pache/cpp-compile-file-and-run ()
  "Compile current file and run it."
  (interactive)
  (let* ((file (buffer-file-name))
         (out (concat (file-name-sans-extension file) ".out")))
    (compile (format "g++ -std=c++17 -Wall -Wextra -O2 %s -o %s && %s"
                     (shell-quote-argument file)
                     (shell-quote-argument out)
                     (shell-quote-argument out)))))

(defun pache/cpp-test ()
  "Run tests for the C/C++ project."
  (interactive)
  (let ((default-directory (pache/cpp-project-root)))
    (cond
     ((file-exists-p "build/Makefile")
      (compile "cd build && ctest --output-on-failure"))
     (t (compile "make test")))))

(use-package cc-mode
  :ensure nil
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure))
  :bind (:map c-mode-base-map
              ("C-c C-b" . pache/cpp-build)
              ("C-c C-r" . pache/cpp-run)
              ("C-c C-t" . pache/cpp-test)
              ("C-c C-c" . pache/cpp-compile-file)
              ("C-c x" . pache/cpp-build-and-run)
              ("C-c e" . pache/cpp-compile-file-and-run)))

(provide 'pache-programming)
;;; pache-programming.el ends here
