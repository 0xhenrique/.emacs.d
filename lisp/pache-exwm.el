;;; pache-exwm.el --- EXWM Settings -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(unless (package-installed-p 'exwm)
  (package-install 'exwm))
;; Load EXWM.
(require 'exwm)
(require 'exwm-randr)
(icomplete-vertical-mode 1)
(server-start)

;; Only use the main monitor
(start-process-shell-command
 "xrandr" nil "xrandr --output eDP-1 --off --output HDMI-2 --auto")

;; Set keyboard layout switch (US and ABNT2)
(start-process-shell-command
 "setxkbmap" nil "setxkbmap -layout 'us,br' -option 'grp:alt_shift_toggle'")

;; Set wallpaper
(start-process-shell-command
 "feh" nil "feh --bg-scale ~/Pictures/papes/patchy/3.jpg")

;; Start picom
(start-process-shell-command
 "picom" nil "picom")

(defun pache/exwm-update-title ()
  (pcase exwm-class-name
    ;; This is used to avoid the buffers being named like "librewolf<3>", so we use that window's title as buffer name
    ("LibreWolf" (exwm-workspace-rename-buffer (format "Librewolf: %s" exwm-title)))
    ("multi-vterm" (exwm-workspace-rename-buffer (format "Vterm: %s" exwm-title)))
    ("Transmission-gtk" (exwm-workspace-rename-buffer (format "Transmission: %s" exwm-title)))))

;; When window title updates, use it to set the buffer name
(add-hook 'exwm-update-title-hook #'pache/exwm-update-title)
;; (add-hook 'exwm-init-hook (lambda () (dashboard-refresh-buffer)))
;; (add-hook 'after-init-hook
;; 	  (lambda ()
;; 	    (switch-to-buffer "*dashboard*")))

(display-time-mode t)
(setq exwm-workspace-number 3)

(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))

(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))

;; A Windows PC forced me to do this since I couldn't change the keybinds there lol
(defun pache/exwm-switch-workspace (direction)
  "Choose the DIRECTION."
  (interactive "sDirection: ")
  (let ((current-workspace exwm-workspace-current-index))
    (cond
     ((string= direction "left") (exwm-workspace-switch (1- current-workspace)))
     ((string= direction "right") (exwm-workspace-switch (1+ current-workspace))))))

(setq exwm-input-global-keys
      `(
	;; Match Windows keybinds
	([C-s-left] . (lambda () (interactive) (pache/exwm-switch-workspace "left")))
	([C-s-right] . (lambda () (interactive ) (pache/exwm-switch-workspace "right")))

        ;; Bind "s-r" to exit char-mode and fullscreen mode.
        ([?\s-r] . exwm-reset)

        ;; Bind "s-w" to switch workspace interactively.
        ([?\s-w] . exwm-workspace-switch)
	;; Move between windows
	([s-left] . (pache/exwm-switch-workspace "left"))
	([s-right] . (pache/exwm-switch-workspace "right"))
	([s-up] . windmove-up)
	([s-down] . windmove-down)
        ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))
        ;; Bind "s-&" to launch applications ('M-&' also works if the output
        ;; buffer does not bother you).
        ([?\s-d] . (lambda (command)
		     (interactive (list (read-shell-command "$ ")))
		     (start-process-shell-command command nil command)))
        ;; Bind "s-<f2>" to "slock", a simple X display locker.
        ([s-f2] . (lambda ()
		    (interactive)
		    (start-process "" nil "/usr/bin/slock")))))

(setq exwm-input-simulation-keys
      '(
        ;; movement
        ([?\C-b] . [left])
        ([?\M-b] . [C-left])
        ([?\C-f] . [right])
        ([?\M-f] . [C-right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ([?\C-a] . [home])
        ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete])
        ;; cut/paste.
        ([?\C-w] . [?\C-x])
        ([?\M-w] . [?\C-c])
        ([?\C-y] . [?\C-v])
        ;; search
        ([?\C-s] . [?\C-f])))
;(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)
;(setq exwm-workspace-minibuffer-position 'bottom)

;;(exwm-input-set-key (kbd "<XF86AudioRaiseVolume>")
;;                    (lambda () (interactive)
;;                      (start-process-shell-command "pactl" nil "pactl set-sink-volume @DEFAULT_SINK@ +2%")))
;;(exwm-input-set-key (kbd "<XF86AudioLowerVolume>")
;;                    (lambda () (interactive)
;;                      (start-process-shell-command "pactl" nil "pactl set-sink-volume @DEFAULT_SINK@ -2%")))

;;(exwm-input-set-key (kbd "s-q") (kill-this-buffer))
;;(exwm-input-set-key (kbd "s-f") 'firefox-search-term)
;;(exwm-input-set-key (kbd "s-l") 'librewolf-search-term)
;;(exwm-input-set-key (kbd "s-SPC") 'ivy-switch-buffer)
;;(exwm-input-set-key (kbd "s-k") 'ivy-switch-buffer-kill)
;;(global-set-key (kbd "C-s-<left>") (lambda () (interactive) (pache/exwm-switch-workspace "left")))
;;(global-set-key (kbd "C-s-<right>") (lambda () (interactive) (pache/exwm-switch-workspace "right")))

(exwm-input-set-key (kbd "<XF86AudioRaiseVolume>") (lambda () (interactive) (start-process-shell-command "pactl" nil "pactl set-sink-volume @DEFAULT_SINK@ +2%")))
(exwm-input-set-key (kbd "<XF86AudioLowerVolume>") (lambda () (interactive) (start-process-shell-command "pactl" nil "pactl set-sink-volume @DEFAULT_SINK@ -2%")))
;;(global-set-key (kbd "<XF86AudioRaiseVolume>") (lambda () (interactive) (start-process-shell-command "pactl" nil "pactl set-sink-volume @DEFAULT_SINK@ +2%")))
;;(global-set-key (kbd "<XF86AudioLowerVolume>") (lambda () (interactive) (start-process-shell-command "pactl" nil "pactl set-sink-volume @DEFAULT_SINK@ -2%")))

(exwm-enable)

(provide 'pache-exwm)
;;; pache-exwm.el ends here
