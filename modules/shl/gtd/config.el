;;; shl/gtd/config.el -*- lexical-binding: t; -*-

;; org-gtd
(use-package! org-gtd
  :after org
  :custom
  (org-gtd-directory "~/gdrive/gtd")
  (org-edna-use-inheritance t)
  (org-gtd-organize-hooks '(org-gtd-set-area-of-focus org-set-tags-command))
  :config
  (org-edna-mode))

(map! "C-c g c" #'org-gtd-capture
      "C-c g e" #'org-gtd-engage
      "C-c g p" #'org-gtd-process-inbox)
(map! :map org-gtd-clarify-map
      "C-c c" #'org-gtd-organize)
