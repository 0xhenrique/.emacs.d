;;; pache-platform.el --- Custom Behaviour for Windows and GNU Linux -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(defconst pache/linux-p (eq system-type 'gnu/linux))
(defconst pache/windows-p (memq system-type '(windows-nt ms-dos)))

(if pache/windows-p
    (progn
      (setq gc-cons-threshold 10000000)  ; 10MB
      (setq inhibit-compacting-font-caches t)  ; Windows font rendering issue
      (setq w32-pipe-read-delay 0.001)  ; Faster pipe reads
      (setq w32-pipe-buffer-size (* 64 1024)))  ; 64KB pipe buffer
  (setq gc-cons-threshold 100000000))

(when pache/windows-p
  (setq package-native-compile nil)
  
  ;; File operations
  (setq w32-get-true-file-attributes nil)  ; do not query file attributes
  (setq inhibit-compacting-font-caches t)
  (setq vc-handled-backends '(Git))
  
  ;; Process optimization
  (setq read-process-output-max (* 64 1024))
  (setq process-adaptive-read-buffering nil)
  (setq read-process-output-max (* 64 1024))
  
  (with-eval-after-load 'ivy
    (setq ivy-dynamic-exhibit-delay-ms 100))  ; delay before updating
  
  (with-eval-after-load 'flycheck
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (setq flycheck-idle-change-delay 4.0)))  ; Longer delay

;; Used to test new packages on Windows
(defun pache/profile-startup ()
  "Profile Emacs startup."
  (interactive)
  (profiler-start 'cpu)
  (run-with-timer 5 nil (lambda ()
                          (profiler-stop)
                          (profiler-report)
                          (profiler-report-write-profile "~/startup-profile.txt"))))

(provide 'pache-platform)
;;; pache-platform.el ends here
