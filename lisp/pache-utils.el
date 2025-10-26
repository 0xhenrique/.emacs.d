;;; pache-utils.el --- General Utilities -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Set keyboard layout switch (US and ABNT2)
(start-process-shell-command
 "setxkbmap" nil "setxkbmap -layout 'us,br' -option 'grp:win_space_toggle'")
;; Transparency
(start-process-shell-command
 "picom" nil "picom")

(defun pache/my-consult-bookmark ()
  "Select a bookmark using `completing-read` and copy it to the clipboard."
  (interactive)
  (let* ((candidates (split-string (shell-command-to-string "java -jar ~/workspace/personal/lum/target/uberjar/lum-1.0.0-SNAPSHOT-standalone.jar -l") "\n" t))
         (selection (completing-read "Select bookmark: " candidates)))
    (when selection
      (kill-new selection)
      (message "Copied to clipboard: %s" selection))))
;;(global-set-key (kbd "C-c b") 'pache/my-consult-bookmark)

(defun pache/download-yt ()
  "Download a YouTube video URL interactively to ~/Videos."
  (interactive)
  (let* ((url (read-string "Enter YouTube URL: "))
         (quality (completing-read "Choose video quality: " '("Audio" "144p" "Best Quality") nil t))
         (videos-dir (expand-file-name "~/Videos/"))
         (command "")
         (file-name-template "%(title)s"))
    (cond
     ((equal quality "144p")
      (setq command (format "yt-dlp -f 'bestvideo[height<=144]+bestaudio' -o '%s%s' %s"
                           videos-dir file-name-template url)))
     ((equal quality "Best Quality")
      (setq command (format "yt-dlp -f 'bestvideo+bestaudio' -o '%s%s' %s"
                           videos-dir file-name-template url))))
    (start-process-shell-command "yt-dlp" "*yt-dlp*" command)
    (message "Downloading video: %s at %s quality" url quality)))

(defun pache/download-yt-audio ()
  "Download the audio from a YouTube video URL to a user-selected directory."
  (interactive)
  (let* ((url (read-string "Enter YouTube URL: "))
         (music-dir (read-directory-name "Choose download directory: " "~/Music/"))
         (command "")
         (file-name-template "%(title)s"))
    (setq command (format "yt-dlp -x --embed-metadata --audio-quality 0 --format bestaudio -o '%s%s.%%(ext)s' %s"
                          (file-name-as-directory music-dir) file-name-template url))
    (start-process-shell-command "yt-dlp" "*yt-dlp*" command)
    (message "Downloading audio: %s to %s" url music-dir)))

(defun pache/convert-mp4-to-webm ()
  "Convert file from MP4 to WEBM without audio and move it to ~/Videos/dump/."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (output-dir (expand-file-name "~/Videos/dump/"))
         (output-file (concat output-dir (file-name-base file) ".webm"))
         (command (format "ffmpeg -i \"%s\" -an \"%s\"" file output-file)))
    (shell-command command)
    (message "Converted %s to %s" file output-file)))

;; Firefox Search
(defun pache/firefox-search-term (term)
  "Prompt for a search TERM and open Firefox to search for it."
  (interactive "sFirefox search term: ")
  (start-process-shell-command
   "firefox" nil (concat "firefox --search " (shell-quote-argument term))))

;; Librewolf Search
(defun pache/librewolf-search-term (term)
  "Prompt for a search TERM and open Librewolf to search for it."
  (interactive "sLibrewolf search term: ")
  (start-process-shell-command
   "librewolf" nil (concat "librewolf --search " (shell-quote-argument term))))

;; Kensington Orbit scroll utility - change the '11' to the actual ID from 'xinput list' command
;; You can also use 'xev | grep ButtonPress' to know identify the buttons
;(start-process-shell-command
; "xinput" nil "xinput set-prop 12 'libinput Middle Emulation Enabled' 1")
;(start-process-shell-command
; "xinput" nil "xinput set-prop 12 'libinput Scroll Method Enabled' 0 0 1")

;; Disable top buttons in Kensington Expert (2 and 8), keep bottom buttons (1 and 3)
(start-process-shell-command
 "xinput" nil "xinput set-button-map 12 1 0 3 0 0 0 0 0")


(defun pache/screenshot-with-flameshot ()
  "Make a screenshot using Flameshot."
  (start-process-shell-command "flameshot" nil "flameshot gui"))

(defun pache/create-shell ()
    "Create a shell with a given name."
    (interactive);; "Prompt\n shell name:")
    (let ((shell-name (read-string "shell name: " nil)))
    (shell (concat "*" shell-name "*"))))

(defun pache/random-theme ()
  "Load a random theme from a predefined list of themes."
  (let ((themes '(catppuccin gruvbox-dark-hard modus-vivendi)))
    (load-theme (nth (random (length themes)) themes) t)))

(defun pache/swiper-isearch-thing-at-point ()
  "Call `consult-line` with the word at point as the initial input."
  (interactive)
  (let ((word (thing-at-point 'word t)))
    (if word
        (consult-line word)
      (consult-line))))

(defun pache/suspend-system ()
  "Suspend the system using shell command."
  (start-process-shell-command "suspend" nil "sudo sh -c 'echo mem > /sys/power/state'"))

(defun pache/hibernate-system ()
  "Hibernate the system using shell command."
  (start-process-shell-command "hibernate" nil "sudo sh -c 'echo disk > /sys/power/state'"))

(defun pache/make-project-command (command)
  "Create an interactive compile function for COMMAND."
  (lambda ()
    (interactive)
    (compile command)))

(defun pache/duplicate-line ()
  "Duplicate the current line."
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

;; Deluge Daemon + Web
;;(start-process-shell-command
;; "deluged" nil "deluged")
;;(start-process-shell-command
;; "deluge-web" nil "deluge-web")

(provide 'pache-utils)
;;; pache-utils.el ends here

