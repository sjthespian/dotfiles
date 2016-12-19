;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; package management
(require 'package)
(add-to-list 'package-archives
	 '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
	'("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
	'("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository
(package-initialize)

;; Install needed packages
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed `cedet `dash `color-theme-sanityinc-solarized
			  `dockerfile-mode
			  `flycheck `flymake-easy `flymake-puppet `flymake-ruby
			  `json-mode `magit `markdown-mode `lua-mode `yaml-mode)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)

(load-file (concat (getenv "HOME") "/.emacs.d/init.el"))
