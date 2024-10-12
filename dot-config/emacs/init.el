;;;;;;;;;;;;;;;;;;;;;;;;
;; Set up use-package ;;
;;;;;;;;;;;;;;;;;;;;;;;;
 
;; Package archives
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
 
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
 
;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
 
;; Set up use-package
(require 'use-package)
(setq use-package-always-ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General customizations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package emacs
  :init
  ;; On macOS, bind the Command key to Meta 
  (setq mac-option-key-is-meta nil
	mac-command-key-is-meta t
	mac-command-modifier 'meta
	mac-option-modifier 'none)
  
  ;; Enable indentation+completion using the TAB key.
  (setq tab-always-indent 'complete)
  (setq read-extended-command-predicate #'command-completion-default-include-p)
 
  ;; Tweak backup settings
  (if (not (file-directory-p "~/.backups"))
      (make-directory "~/.backups"))
  (if (not (file-directory-p "~/.auto-saves"))
      (make-directory "~/.auto-saves"))

  (setq
   backup-by-copying t       ; don't clobber symlinks
   backup-directory-alist
   '(("." . "~/.backups/"))  ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2)      ; use versioned backups
  (setq auto-save-file-name-transforms `((".*" "~/.auto-saves/" t)))
 
  ;; Minibuffer and command settings from vertico.el
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-separator)
		  (car args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
 
  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
 
  ;; Support opening new minibuffers from inside existing minibuffers.
  (setq enable-recursive-minibuffers t)
 
  ;; Emacs 28 and newer: Hide commands in M-x which do not work in the current
  ;; mode.  Vertico commands are hidden in normal buffers. This setting is
  ;; useful beyond Vertico.
  (setq read-extended-command-predicate #'command-completion-default-include-p)
 
  :config
 
  ;; Tweak interface
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (set-fringe-mode 0)
  (menu-bar-mode -1)
  (global-display-line-numbers-mode)
 
  ;; Auto-close brackets
  (electric-pair-mode)
  (add-function :before-until
		electric-pair-inhibit-predicate
		(lambda
		  (c) (eq c ?<)))
 
  (add-to-list 'default-frame-alist '(width  . 160))
  (add-to-list 'default-frame-alist '(height . 60))
  (add-to-list 'default-frame-alist '(left . 60))
  (add-to-list 'default-frame-alist '(top . 60))
  ; Make macos title bar transparent
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  ;; Set font face
  (set-face-attribute 'default nil :font "Iosevka" :height 120 :weight 'Medium)
  (set-face-attribute 'variable-pitch nil :family "Iosevka" :height 120 :weight 'Medium)
  (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :height 120 :weight 'Medium)
 
  ;; Config built-in tree-sitter
  ;; blog: https://www.masteringemacs.org/article/how-to-get-started-tree-sitter
  ;; starter guide: https://github.com/emacs-mirror/emacs/blob/master/admin/notes/tree-sitter/starter-guide
  (setq treesit-language-source-alist
	'((bash "https://github.com/tree-sitter/tree-sitter-bash")
	  (elisp "https://github.com/Wilfred/tree-sitter-elisp")
	  (json "https://github.com/tree-sitter/tree-sitter-json")
	  (make "https://github.com/alemuller/tree-sitter-make")
	  (python "https://github.com/tree-sitter/tree-sitter-python")
	  (toml "https://github.com/tree-sitter/tree-sitter-toml")
	  (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
 
  ;; Enable tree-sitter for various languages
  ;; AucTex package utilizes variable major-mode-remap-alist
  ;; So we must use add-to-list instead of setq to not break AucTex
  ;; (add-to-list 'major-mode-remap-alist '(elisp-mode . elisp-ts-mode))
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))
  (add-to-list 'major-mode-remap-alist '(bash-mode . bash-ts-mode))
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode))
  (setq treesit-font-lock-level 4))

(use-package which-key)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load themes, icon packs and modeline theme ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode))
 
(use-package modus-themes
  :custom
  (modus-themes-mixed-fonts t)
  :config
  (load-theme 'modus-vivendi :no-confirm))
 
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  :config
  (setq nerd-icons-scale-factor 1.1))

;; Uncomment the following region to enable spaceline
;; Requires .el files from https://github.com/TheBB/spaceline
;; (use-package spaceline-config
;;   :ensure powerline
;;   :ensure s
;;   :load-path "spaceline"
;;   :config
;;   (setq powerline-default-separator "wave")
;;   (setq powerline-height 25)
;;   (spaceline-spacemacs-theme))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Command completion with vertico and consult ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package vertico
  :init
  (vertico-mode))
 
;; Configure directory extension.
(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))
 
(use-package consult)

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  ;; The :init section is always executed.
  :init
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-regexp orderless-flex))
  (completion-category-overrides '((file (styles basic partial-completion)))))

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup code completion with corfu ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto-delay 0.2))

(use-package cape
  :bind ("C-c p" . cape-prefix-map) ;; Alternative keys: M-p, M-+, ...
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
)
 
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/snippets"))
  (yas-global-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; git management with magit ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package magit)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTeX editting with AucTex ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package tex
  :ensure auctex
  :ensure adaptive-wrap
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq LaTeX-item-indent 0)
  (setq-default TeX-master nil)
  (setq-default adaptive-wrap-extra-indent 0)
  (add-hook 'LaTeX-mode-hook #'adaptive-wrap-prefix-mode)
  (add-hook 'LaTeX-mode-hook #'flyspell-mode)
  (add-hook 'LaTeX-mode-hook #'visual-line-mode))
 
 
;;;;;;;;;;;;;;;;;;;;;
;; Config org-mode ;;
;;;;;;;;;;;;;;;;;;;;;

(use-package olivetti
  :custom
  (olivetti-body-width 0.75)
  :config
  (add-hook 'org-mode-hook
	    (lambda ()
	      (variable-pitch-mode)
	      (olivetti-mode 1)
	      (flyspell-mode 1)
	      (visual-line-mode)
	      (display-line-numbers-mode -1)
	      ;; LaTeX formatting in Org Mode
	      (setq org-format-latex-options (plist-put org-format-latex-options :background "Transparent"))
	      (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))))
  (setq org-startup-indented t)
  (setq org-preview-latex-default-process 'dvisvgm))


;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Config env variables ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs Plus has a feature that injects $PATH variable
;; So this is not needed for $PATH, but still useful for other env vars
(use-package exec-path-from-shell)
(exec-path-from-shell-copy-env "LIBGS")

(use-package envrc
  :hook (after-init . envrc-global-mode))
 
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)
