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
 
  ;; Enforce horizontal split
  ;; (setq split-height-threshold nil)
  ;; (setq split-width-threshold 0)
 
  ;; Enable indentation+completion using the TAB key.
  (setq tab-always-indent 'complete)
  (setq read-extended-command-predicate #'command-completion-default-include-p)
 
  ;; Tweak backup settings
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
  (set-fringe-mode 10)
  (menu-bar-mode -1)
  (fringe-mode 12)
  (global-display-line-numbers-mode)
 
  ;; Auto-close brackets
  (electric-pair-mode)
 
  ;; Maximize frame on start-up
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
 
  ; Make macos title bar transparent
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  ;; Set font face
  (set-face-attribute 'default nil :font "PragmataPro Mono" :height 140)
 
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
  (add-to-list 'major-mode-remap-alist '(elisp-mode . elisp-ts-mode))
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode))
  (add-to-list 'major-mode-remap-alist '(bash-mode . bash-ts-mode))
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode))
  (setq treesit-font-lock-level 4))
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use $PATH from shell ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
 
;; (use-package exec-path-from-shell
;;   :config
;;   (when (memq window-system '(mac ns x))
;;     (exec-path-from-shell-initialize)))
 
;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize))
;; (when (daemonp)
;;   (exec-path-from-shell-initialize))
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use evil key bindings ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-respect-visual-line-mode t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
 
  ;; Set evil keybindings
  (evil-set-leader nil (kbd "SPC"))
  (evil-define-key 'normal 'global (kbd "<leader>s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>d") 'dired)
  (evil-define-key 'normal 'global (kbd "<leader>b") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>g") 'magit)
  (evil-define-key 'normal 'global (kbd "<leader>c") 'comment-region)
 
  (evil-define-key 'normal 'global (kbd "<leader>w") 'split-window-right)
  (evil-define-key 'normal 'global (kbd "<leader>x") 'delete-window)
  (evil-define-key 'normal 'global (kbd "<leader>h") 'windmove-left)
  (evil-define-key 'normal 'global (kbd "<leader>j") 'windmove-down)
  (evil-define-key 'normal 'global (kbd "<leader>k") 'windmove-up)
  (evil-define-key 'normal 'global (kbd "<leader>l") 'windmove-right))
 
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))
 
(use-package which-key)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load themes, icon packs and modeline theme ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package ef-themes
  :config
  (setq ef-themes-to-toggle '(ef-cyprus ef-elea-dark))
 
  ;; Default weight is `bold'
  (setq ef-themes-headings
	'((0 1.9)
	  (1 1.8)
	  (2 regular 1.7)
	  (3 regular 1.6)
	  (4 regular 1.5)
	  (5 1.4)
	  (6 1.3)
	  (7 1.2)
	  (t 1.1)))
  (setq ef-themes-mixed-fonts t)
 
  ;; Disable all other themes to avoid awkward blending:
  (mapc #'disable-theme custom-enabled-themes)
 
  ;; Load the theme of choice:
  (load-theme 'ef-cyprus :no-confirm))
 
(use-package nerd-icons
  :custom
  (nerd-icons-font-family "Symbols Nerd Font Mono")
  :config
  (setq nerd-icons-scale-factor 1.1))
 
(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 40))
 
 
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
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setup code completion with corfu ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto-delay 0.2))
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; git management with magit ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package magit)
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTeX editting with AucTex ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook #'flyspell-mode)
  (add-hook 'LaTeX-mode-hook #'visual-line-mode))
 
 
;;;;;;;;;;;;;;;;;;;;;
;; Config org-mode ;;
;;;;;;;;;;;;;;;;;;;;;
 
(defun org-buffer-face-mode-function ()
  (interactive)
  (setq buffer-face-mode-face '(:family "Iosevka Nerd Font" :height 130))
  (buffer-face-mode))
 
(use-package olivetti
  :config
  (add-hook 'org-mode-hook #'olivetti-mode)
  (add-hook 'org-mode-hook #'flyspell-mode)
  (add-hook 'org-mode-hook #'visual-line-mode)
  (add-hook 'org-mode-hook 'org-buffer-face-mode-function)
  :custom
  (olivetti-body-width 108)
  :config
  (setq org-startup-indented t))
 
 
;; Python specific packages: jupyter and its dependency zmq
;; (use-package zmq)
;; (use-package jupyter)
 
;; envrc: integrating direnv and pyenv
;; (use-package envrc)
;; (envrc-global-mode)
 
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)
