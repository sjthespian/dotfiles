;;; init.el --- Emacs init file

;;; Commentary:
;; init file for drich
;;

;;; Code:

;; Turn on better defaults
(require 'better-defaults)
(setq visible-bell nil)                 ; I hate visible bell

(defvar autosave 500
  "The interval between file autosaves")

;;; Setup directory and path information
(setq home-directory (getenv "HOME"))
(setq lisp-directory (concat home-directory "/.emacs.d/lisp"))
(add-to-list 'load-path lisp-directory)

(custom-set-variables
 '(default-input-method "latin-1-prefix")
 '(load-home-init-file t t)
 '(focus-follows-mouse t)
 '(case-fold-search t)
 '(global-font-lock-mode t nil (font-lock))
 '(current-language-environment "Latin-1" t)
 '(user-mail-address "drich@employees.org" t)
 '(query-user-mail-address nil))
(custom-set-faces
 '(default ((t (:size "12pt"))) t))

;; Default window size and position
(if window-system
    (progn
      ; if height/width < .5, assume multiple monitors
      ; I want my Emacs window to be roughly 10% of the way across the
      ; second monitor
      (setq default-frame-alist
	    '((top . 100) (left . 100)
	      (width . 120) (height . 45)
	      (menu-bar-lines . 1)))
      (setq frameheight 45)
      (setq framewidth 120)
      (setcdr (assq 'height default-frame-alist) frameheight)
      (setcdr (assq 'width default-frame-alist) framewidth)
      (if (< (/ (float (display-pixel-height)) (display-pixel-width)) 0.5)
	  (progn
	    (setq frametop (- (/ (display-pixel-height) 2) (/ (* 14 frameheight) 2)))
	    (setq frameleft (- (/ (display-pixel-width) 2) (* 12 framewidth)))
	    )
	(progn
	    (setq frametop (- (/ (display-pixel-height) 2) (/ (* 14 frameheight) 2)))
	    (setq frameleft (- (display-pixel-width) (* 12 framewidth)))
	  )
	)
      (setcdr (assq 'top default-frame-alist) frametop)
      (setcdr (assq 'left default-frame-alist) frameleft)
      )
  )

;;; Use the better speedbar
(require 'speedbar)
(require 'sr-speedbar)
(with-eval-after-load "speedbar"
  (autoload 'sr-speedbar-toggle "sr-speedbar" nil t)
  (global-set-key (kbd "s-s") 'sr-speedbar-toggle)
  (setq sr-speedbar-right-side nil)
  (setq sr-speedbar-max-width 25)
  (setq speedbar-show-unknown-files t)
  (make-face 'speedbar-face)
  (set-face-font 'speedbar-face "-*-Menlo-normal-normal-normal-*-10-*-*-*-m-0-iso10646-1")
  (setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))
  (sr-speedbar-open)
;  (with-current-buffer sr-speedbar-buffer-name
;    (setq window-size-fixed 'width))
  )

;;; Settings for various languages

;; Python
;; Some of this from https://realpython.com/emacs-the-best-python-editor/
(setenv "WORKON_HOME" (concat home-directory "/.virtualenvs"))
(elpy-enable)
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))
(setq elpy-rpc-python-command "python3"
      python-check-command "flake8"
      python-shell-interpreter "python3"
      elpy-rpc-timeout 10
      elpy-remove-modeline-lighter t)
;; prefer black for formatting
(add-hook 'elpy-mode-hook (lambda ()
                            (add-hook 'before-save-hook
                                      'elpy-black-fix-code nil t)))

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
(autoload 'dash "dash" "Dash" t)
(add-hook 'ruby-mode-hook 'flycheck-mode)
(flycheck-add-next-checker 'ruby-chef-cookstyle 'ruby-rubocop)

;; YAML
;(add-to-list 'load-path (concat lisp-directory "/yaml-mode"))
(autoload 'yaml-mode "yaml-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;
;; Markdown mode
;(add-to-list 'load-path (concat lisp-directory "/markdown-mode"))
(autoload 'markdown-mode "markdown-mode"
	     "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Lua mode settings
(setq lua-indent-level 2)

;; Go mode settings
(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)
(defun auto-complete-for-go ()
(auto-complete-mode 1))
 (add-hook 'go-mode-hook 'auto-complete-for-go)
(with-eval-after-load 'go-mode
   (require 'go-autocomplete)
   (require 'go-guru))

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

;; Load nxhtml for jsp editing
;(load-file (concat lisp-directory "/nxhtml/autostart.el"))

;;;; magit for git
(global-set-key (kbd "C-x g") 'magit-status)
;(with-eval-after-load 'magit
;  (require 'forge)
;  ;; See https://logc.github.io/blog/2019/08/23/setting-up-magit-forge-with-github-enterprise-server/ for info on these settings
;  (push '("github.wdig.com" "github.wdig.com/api/v3"
;          forge-github-repository)
;        forge-alist)
;  )
  

;; speedbar - http://cedet.sourceforge.net/speedbar.shtml
;(add-to-list 'load-path (concat lisp-directory "/cedet"))

;; Solarized color scheme
;(add-to-list 'load-path (concat lisp-directory "/emacs-color-theme-solarized"))
(if (>= emacs-major-version 24)
;; For emacs 24
    (load-theme 'sanityinc-solarized-light t)
;; -- end of emacs 24
;; For emacs 23
  (progn
    (add-to-list 'load-path (concat lisp-directory "/color-theme"))
    (require 'color-theme "color-theme")
    (eval-after-load "color-theme"
      '(progn
	 (color-theme-initialize)
	 (color-theme-hober)))
    (require 'color-theme-solarized)
    (color-theme-solarized-light)
    ))
;; -- end of emacs 23

;;
;; ensure we can talk to ssh agent for magit
(setq exec-path-from-shell-arguments nil)
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize))
(exec-path-from-shell-copy-env "SSH_AGENT_PID")
(exec-path-from-shell-copy-env "SSH_AUTH_SOCK")

;;
;; Tramp setup
(setq tramp-default-method "ssh")

;; Don't start the server unless we can verify that it isn't running.
(require 'server)
(when (and (functionp 'server-running-p) (not (server-running-p)))
(server-start))

;;; init.el ends here
