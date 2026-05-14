;;; pache-utils.el --- General Utilities -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Set keyboard layout switch (US and ABNT2)
;(start-process-shell-command
;  "setxkbmap" nil "setxkbmap -layout 'us,br' -option 'grp:win_space_toggle'")

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
  "Convert MP4 to small VP9 WebM (no audio) for 4MB limit."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (output-dir (expand-file-name "~/Videos/dump/"))
         (base (file-name-base file))
         (output-file (expand-file-name (concat base ".webm") output-dir)))
    (unless (file-exists-p output-dir)
      (make-directory output-dir t))
    (let ((command (format
                    "ffmpeg -i %S -c:v libvpx-vp9 -crf 30 -b:v 250k -maxrate 250k -bufsize 500k -vf scale=854:480 -an %S"
                    file output-file)))
      (shell-command command)
      (message "Converted %s to %s (target ~4MB)" file output-file))))

(defun pache/convert-mp4-to-webm-2pass ()
  "Two-pass VP9 WebM for 4MB limit (no audio)."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (output-dir (expand-file-name "~/Videos/dump/"))
         (base (file-name-base file))
         (output-file (expand-file-name (concat base ".webm") output-dir))
         (passlog (expand-file-name (concat base "_pass") output-dir)))
    (unless (file-exists-p output-dir)
      (make-directory output-dir t))
    ;; Pass 1
    (shell-command (format "ffmpeg -y -i %S -c:v libvpx-vp9 -b:v 250k -pass 1 -passlogfile %S -vf scale=854:480 -an -f webm NUL" file passlog))
    ;; Pass 2
    (shell-command (format "ffmpeg -i %S -c:v libvpx-vp9 -b:v 250k -pass 2 -passlogfile %S -vf scale=854:480 -an %S" file passlog output-file))
    ;; Cleanup
    (delete-file (concat passlog "0.log"))
    (message "2-pass converted %s to %s" file output-file)))

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
;; (start-process-shell-command
;;  "xinput" nil "xinput set-button-map 12 1 0 3 0 0 0 0 0")

(defun pache/screenshot-with-flameshot ()
  "Make a screenshot using Flameshot."
  (interactive)
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

(defun pache/occur-thing-at-point ()
  "Run `occur` with the word at point."
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

;;; Stolen from https://github.com/rexim/dotfiles/blob/master/.emacs.rc/misc-rc.el
(defun pache/rgrep-selected (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (rgrep (buffer-substring-no-properties beg end) "*" (pwd)))

;;; Env problems in Guix
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH from the shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$" "" (shell-command-to-string
                                          "$SHELL --login -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(defun pache/my-erc-set-nick-and-full-name (&rest _args)
  "Set a different ERC nickname and full name based on the server."
  (when (and (boundp 'erc-session-server) erc-session-server)
    (if (string-match-p (regexp-quote "colonq.computer") erc-session-server)
        (progn
          (setq erc-nick "0xhenrique")
          (setq erc-user-full-name "0xhenrique")) ;; Use real name
      (setq erc-nick (format "Anon%d" (random 9999)))  ;; Use random nick
      (setq erc-user-full-name (format "User%d" (random 9999)))))) ;; Use random full name

(defun pache/line-move-up ()
  "Move current line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun pache/line-move-down ()
  "Move current line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun pache/get-project-relative-path ()
  "Get the path of the current file relative to the project root.
Returns the path starting from the project root directory name."
  (interactive)
  (let* ((file-path (buffer-file-name))
         (project-root (when (project-current)
                         (project-root (project-current))))
         (result
          (if (and file-path project-root)
              (let* ((root-parent (file-name-directory (directory-file-name project-root)))
                     (root-name (file-name-nondirectory (directory-file-name project-root))))
                (concat root-name "/" (file-relative-name file-path project-root)))
            (or file-path "No file or project"))))
    (when (called-interactively-p 'any)
      (message "%s" result)
      (kill-new result))
    result))

;; Deluge Daemon + Web
;;(start-process-shell-command
;; "deluged" nil "deluged")
(start-process-shell-command
 "deluge-web" nil "deluge-web")

(provide 'pache-utils)
;;; pache-utils.el ends here

