;;; .emacs --- emacs init

;;; Commentary:
;; emacs init file

;;; Code:

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; Make sure /usr/local/bin is at the beginning of the path
(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH"))
(add-to-list 'exec-path "/usr/local/bin"))
(setenv "GOPATH" (concat (getenv "HOME") "/go"))

;; package management
(require 'package)
(add-to-list 'package-archives
	 '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
	'("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	'("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository
(setq package-check-signature nil)
(package-initialize)
;; Uncomment to refresh packages cache -- slows startup
;;(package-refresh-contents)

;; Install needed packages
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

PACKAGES contains the package to install if not already installed

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing - install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

; removed `flymake-easy `flymake-puppet `flymake-ruby -- moving to flycheck
(ensure-package-installed `cedet `dash `color-theme-sanityinc-solarized
			  `dockerfile-mode `better-defaults
			  `elpy
			  `exec-path-from-shell
			  `flycheck
			  `go-mode `go-autocomplete `go-guru
			  `json-mode `magit 'transient 'forge `markdown-mode `lua-mode `yaml-mode
			  `groovy-mode `terraform-mode)
;; enable flycheck everywhere
(global-flycheck-mode)

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; Make next/prev line behave logically
(setq line-move-visual nil)

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(focus-follows-mouse t)
 '(global-font-lock-mode t nil (font-lock))
 '(load-home-init-file t t)
 '(package-selected-packages
   (quote
    (better-defaults transient transient-dwim forge terraform-mode groovy-mode elpy-enable yaml-mode markdown-mode magit lua-mode json-mode go-mode flycheck-gometalinter dockerfile-mode color-theme-sanityinc-solarized cedit)))
 '(query-user-mail-address nil)
 '(user-mail-address "drich@employees.org"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:size "12pt")))))

(provide 'emacs)

;;; emacs ends here
