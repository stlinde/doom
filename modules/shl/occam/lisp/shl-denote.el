;;; shl/occam/lisp/shl-denote.el -*- lexical-binding: t; -*-

(use-package denote
  :ensure t)

;; Remember to check the doc strings of those variables.
(setq denote-directory (expand-file-name "~/Occam/"))
(setq denote-known-keywords '("emacs" "work" "analytics" "risk" "home"))
(setq denote-infer-keywords t)
(setq denote-sort-keywords t)
(setq denote-file-type nil) ; Org is the default, set others here
(setq denote-prompts '(title keywords))
(setq denote-excluded-directories-regexp nil)
(setq denote-excluded-keywords-regexp nil)

;; Pick dates, where relevant, with Org's advanced interface:
(setq denote-date-prompt-use-org-read-date t)


;; Read this manual for how to specify `denote-templates'.  We do not
;; include an example here to avoid potential confusion.

(setq denote-date-format nil) ; read doc string

;; By default, we do not show the context of links.  We just display
;; file names.  This provides a more informative view.
(setq denote-backlinks-show-context t)

;; Generic (great if you rename files Denote-style in lots of places):
(add-hook 'dired-mode-hook #'denote-dired-mode)
;;
;; OR if only want it in `denote-dired-directories':
(add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)


;; Automatically rename Denote buffers using the `denote-rename-buffer-format'.
(denote-rename-buffer-mode 1)

;; Here is a custom, user-level command from one of the examples we
;; show in this manual.  We define it here and add it to a key binding
;; below.  The manual: <https://protesilaos.com/emacs/denote>.
(defun shl/denote-journal ()
  "Create an entry tagged 'journal' with the date as its title.
If a journal for the current day exists, visit it.  If multiple
entries exist, prompt with completion for a choice between them.
Else create a new file."
  (interactive)
  (let* ((today (format-time-string "%A %e %B %Y"))
         (string (denote-sluggify today))
         (files (denote-directory-files-matching-regexp string)))
    (cond
     ((> (length files) 1)
      (find-file (completing-read "Select file: " files nil :require-match)))
     (files
      (find-file (car files)))
     (t
      (denote
       today
       '("journal"))))))


;; Denote DOES NOT define any key bindings.  This is for the user to
;; decide.  For example:
(let ((map global-map))
  (define-key map (kbd "C-c n j") #'shl/denote-journal)
  (define-key map (kbd "C-c n n") #'denote)
  (define-key map (kbd "C-c n c") #'denote-region) ; "contents" mnemonic
  (define-key map (kbd "C-c n N") #'denote-type)
  (define-key map (kbd "C-c n d") #'denote-date)
  (define-key map (kbd "C-c n z") #'denote-signature) ; "zettelkasten" mnemonic
  (define-key map (kbd "C-c n s") #'denote-subdirectory)
  (define-key map (kbd "C-c n t") #'denote-template)
  ;; If you intend to use Denote with a variety of file types, it is
  ;; easier to bind the link-related commands to the `global-map', as
  ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
  ;; `markdown-mode-map', and/or `text-mode-map'.
  (define-key map (kbd "C-c n i") #'denote-link) ; "insert" mnemonic
  (define-key map (kbd "C-c n I") #'denote-add-links)
  (define-key map (kbd "C-c n b") #'denote-backlinks)
  (define-key map (kbd "C-c n F f") #'denote-find-link)
  (define-key map (kbd "C-c n F b") #'denote-find-backlink)
  ;; Note that `denote-rename-file' can work from any context, not just
  ;; Dired bufffers.  That is why we bind it here to the `global-map'.
  (define-key map (kbd "C-c n r") #'denote-rename-file)
  (define-key map (kbd "C-c n R") #'denote-rename-file-using-front-matter))

;; Key bindings specifically for Dired.
(let ((map dired-mode-map))
  (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
  (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-files)
  (define-key map (kbd "C-c C-d C-k") #'denote-dired-rename-marked-files-with-keywords)
  (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter))



(with-eval-after-load 'org-capture
  ()
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (setq org-capture-templates
        '(("n" "New note (with denote.el)" plain
           (file denote-last-path)
           (function
            (lambda ()
              (denote-org-capture-with-prompts :title :keyword :subdirectory :template)))
           :no-save t
           :immediate-finish nil
           :kill-buffer t
           :jump-to-captured t)
          ("t" "Task" entry (file "~/Occam/inbox.org")
           "* TODO %?\n  %U\n"))))
