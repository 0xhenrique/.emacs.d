;;; pache-platform.el --- Custom Behaviour for Windows and GNU Linux -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(defconst pache/linux-p (eq system-type 'gnu/linux))
(defconst pache/windows-p (eq system-type 'windows-nt))

(if pache/windows-p
    (progn
      (setq gc-cons-threshold 10000000)  ; 10MB
      (setq inhibit-compacting-font-caches t)  ; Windows font rendering issue
      ;(setq w32-pipe-read-delay 0.001)  ; Faster pipe reads
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

(defun pache/load-linux-config ()
  "Load Linux-specific configuration."
  (when pache/linux-p
    ;(erc-tls :server "colonq.computer" :port 26697 :nick "HenriqMarq") ;; https://www.twitch.tv/LCOLONQ
    (load "~/.emacs.d/lisp/pache-blog.el")
    					;(load "~/.emacs.d/lisp/pache-exwm.el")
                                        ;(load "~/.emacs.d/lisp/pache-irc.el")
                                        ;(setq epa-pinentry-mode 'loopback)
                                        ;(setq epa-file-select-keys nil)
                                        ;(setq esb-bookmarks-file "~/workspace/0xhenrique/bookmarks/bookmarks.gpg")
    (when (daemonp)
      (set-exec-path-from-shell-PATH))
    ))

(provide 'pache-platform)
(pache/load-linux-config)
;;; pache-platform.el ends here
