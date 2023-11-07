;;; shl/gtd/config.el -*- lexical-binding: t; -*-

;; Org
(setq org-directory "~/gdrive/org")
(setq org-default-notes-file (expand-file-name "inbox.org" org-directory))
(setq org-agenda-files (quote ((expand-file-name "inbox.org" org-directory)
                               (expand-file-name "projects.org" org-directory)
                               (expand-file-name "tickler.org" org-directory)
                               (expand-file-name "archive.org" org-directory)
                               (expand-file-name "calendar.org" org-directory))))
