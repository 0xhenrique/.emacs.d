;;; pache-slop.el --- AI-related stuff -*- lexical-binding: t -*-
;;; Code:
;;; Commentary:

(use-package copilot
  :ensure t
  :defer t
  :config
  (define-key copilot-completion-map (kbd "C-t") 'copilot-accept-completion))

(use-package copilot-chat
  :ensure t
  :defer t)

(provide 'pache-slop)
;;; pache-slop.el ends here
