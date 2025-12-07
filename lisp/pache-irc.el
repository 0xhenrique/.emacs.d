;;; pache-irc.el --- IRC/ERC Settings -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defun pache/my-erc-set-nick-and-full-name (&rest _args)
  "Set a different ERC nickname and full name based on the server."
  (when (and (boundp 'erc-session-server) erc-session-server)
    (if (string-match-p (regexp-quote "colonq.computer") erc-session-server)
        (progn
          (setq erc-nick "0xhenrique")
          (setq erc-user-full-name "0xhenrique")) ;; Use real name
      (setq erc-nick (format "Anon%d" (random 9999)))  ;; Use random nick
      (setq erc-user-full-name (format "User%d" (random 9999)))))) ;; Use random full name

;;(add-hook 'erc-connect-pre-hook #'pache/my-erc-set-nick-and-full-name)

;; https://www.twitch.tv/LCOLONQ
(erc-tls :server "colonq.computer" :port 26697 :nick "HenriqMarq")

(provide 'pache-irc)
;;; pache-irc.el ends here
