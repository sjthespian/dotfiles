(defvar autosave 500
  "The interval between file autosaves")

;;; Setup directory and path information
(setq home-directory (getenv "HOME"))
(setq lisp-directory (concat home-directory "/Lisp"))
(add-to-list 'load-path lisp-directory)

(custom-set-variables
 '(ldap-host-parameters-alist (quote (("ldaprr.pdi.com" base "dc=pdi,dc=dreamworks,dc=com"))))
 '(default-input-method "latin-1-prefix")
 '(load-home-init-file t t)
 '(focus-follows-mouse t)
 '(case-fold-search t)
 '(global-font-lock-mode t nil (font-lock))
 '(current-language-environment "Latin-1" t)
 '(user-mail-address "drich@pdi.com" t)
 '(query-user-mail-address nil))
(custom-set-faces
 '(default ((t (:size "12pt"))) t))

;; Visual Basic mode settings
(autoload 'visual-basic-mode "visual-basic-mode" "Visual Basic editing mode" t)
(add-to-list 'auto-mode-alist '("\\.vbs\\'" . visual-basic-mode))
;; Javascript
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; PHP mode settings
(autoload 'php-mode "php-mode" "PHP editing mode" t)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))

;; Ruby
(add-to-list 'load-path (concat lisp-directory "/dash.el"))
(autoload 'dash "dash" "Dash" t)
(autoload 'rubocop-mode "rubocop" "Rubocop syntax checking" t)
(add-hook 'ruby-mode-hook 'rubocop-mode)
(require 'flymake-ruby)
(add-hook 'ruby-mode-hook (lambda () (flymake-ruby-load)))

;; YAML
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Perl mode settings
;(autoload 'perl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(setq cperl-hairy t)
(setq auto-mode-alist (append (list (cons "\\.[pP][lL]$" 'cperl-mode))
                              auto-mode-alist))
(setq auto-mode-alist (append (list (cons "\\.cgi$" 'cperl-mode))
                              auto-mode-alist))
(setq interpreter-mode-alist (append interpreter-mode-alist
                                     '(("miniperl" . cperl-mode))))

(defun perl-retab-buffer ()
  "Convert a buffer to the proper perl tabs."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (beginning-of-line)
      (cperl-indent-command)
      (forward-line 1))))

(defun perl-retab-comments ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward comment-start (eobp) t)
      (indent-for-comment)
      (perl-indent-command))))

(turn-on-font-lock)

;;
;; Load nxhtml for jsp editing
(load "nxhtml/autostart.el")

;;
;; Puppet automation
(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(require 'flymake-puppet)
(add-hook 'puppet-mode-hook (lambda () (flymake-puppet-load)))

;;;; requires emacs 23.2 :-(
;;;;
;;;; magit for git
;;(add-to-list 'load-path (concat home-directory "/Lisp/git-modes"))
;;(add-to-list 'load-path (concat home-directory "/Lisp/magit"))
;;(eval-after-load 'info
;;  '(progn (info-initialize)
;;          (add-to-list 'Info-directory-list (concat home-directory "/Lisp/magit"))))
;;(require 'magit)

;; RCS
;; automatically check-in check-out when under rcs
(load-library "vc-rcs")
(defun rcs-ci-co nil
  "check in check out the file if it is under vc with rcs
        with a prefix other than 1 only check-in"
  (when (eq (vc-backend (buffer-file-name)) 'RCS)
    (if (= args 1)
	    (save-window-excursion 
	      (vc-toggle-read-only)
	      (call-interactively 'log-edit-done)
	      (vc-toggle-read-only))
	  (vc-toggle-read-only))))

(add-hook 'after-save-hook 'rcs-ci-co)

(defun my-vc-diff (historic &optional not-urgent)
  "my vc diff, sames as vc-diff but in case of rcs, display the 
diffs between current version and previous one (with a prefix 
calls vc-diff)"
  (interactive (list current-prefix-arg t))
  (let ((file (buffer-file-name)))
  (if historic
      (call-interactively 'vc-version-diff)
    (if (eq (vc-backend file) 'RCS)
	(vc-version-diff file  (vc-previous-version (vc-working-version file)) (vc-working-version file))
      (call-interactively 'vc-diff)))))

(global-set-key  (kbd "C-x v=") 'my-vc-diff)

;; speedbar - http://cedet.sourceforge.net/speedbar.shtml
(add-to-list 'load-path (concat lisp-directory "/cedet"))

;; Solarized color scheme
(add-to-list 'load-path (concat lisp-directory "/emacs-color-theme-solarized"))
;; For emacs 24
;;(load-theme 'solarized-light t)
;; -- end of emacs 24
;; For emacs 23
(add-to-list 'load-path (concat lisp-directory "/color-theme"))
(require 'color-theme "color-theme")
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))
(require 'color-theme-solarized)
(color-theme-solarized-light)
;; -- end of emacs 23

;; Emacs-for-python
;; https://github.com/gabrielelanaro/emacs-for-python
(load-file (concat lisp-directory "/emacs-for-python/epy-init.el"))

;;
;; Markdown mode
(add-to-list 'load-path (concat lisp-directory "/markdown-mode"))
(autoload 'markdown-mode "markdown-mode"
	     "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Don't start the server unless we can verify that it isn't running.
(require 'server)
(when (and (functionp 'server-running-p) (not (server-running-p)))
(server-start))
