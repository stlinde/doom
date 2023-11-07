;;; shl/occam/lisp/shl-org.el -*- lexical-binding: t; -*-

;; Mappings
(map! "C-c c" #'org-capture
      "C-c a" #'org-agenda)

;; Agenda
(setq org-agenda-files '("~/Occam"
                         "~/Occam/Projects"
                         "~/Occam/Areas"))
