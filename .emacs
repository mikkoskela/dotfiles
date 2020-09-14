;;todo
;; workspaces
;; line numbers
;; web modes
;; go
;; ligatures
;; hydras and general
;; better terminal handling
;; projectile
;; dired-x
;; zap
;; lsp

;;
;; Packages
;;

(require 'package)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;;
;; Fix path
;;
(use-package exec-path-from-shell
  :ensure t
  :defer nil
  :config
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize))


;;
;; Configure Emacs
;;
(use-package emacs
  :init
  ;; Hide GUI elements
  (menu-bar-mode t)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  :config
  ;; Visual settings
  (tooltip-mode -1)
  (setq tooltip-use-echo-area t)
  (setq visible-bell t)
  (setq ring-bell-function 'ignore)
  (blink-cursor-mode -1)
  (show-paren-mode t)
  (setq show-paren-delay 0.0)
  (global-hl-line-mode t)
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq frame-title-format
        '("" invocation-name " Emacs - " (:eval (if (buffer-file-name)
                                                    (abbreviate-file-name (buffer-file-name))
                                                  "%b"))))


  ;;
  (setq confirm-nonexistent-file-or-buffer nil)

  ;; Backups and autosave
  (defvar custom-backup-dir (concat temporary-file-directory "emacs" "/"))
  (if (not (file-exists-p custom-backup-dir))
      (make-directory custom-backup-dir t))
  (setq backup-directory-alist
        `((".*" . ,custom-backup-dir)))
  (setq auto-save-file-name-transforms
        `((".*" ,custom-backup-dir t)))

  ;; Exit settings
  (setq confirm-kill-processes nil)
  (setq confirm-kill-emacs nil) ;;'y-or-n-p

  ;; Startup settings
  (setq inhibit-splash-screen t)
  (setq initial-scratch-message nil)
  (setq inhibit-startup-message t)
  (setq initial-major-mode 'org-mode)

  ;; Selections and clippings
  (setq shift-enable-select-mode t)
  (setq save-interprogram-paste-before-kill t)
  (setq x-select-enable-clipboard t)
  (transient-mark-mode t)
  (delete-selection-mode t)
  (setq mouse-yank-at-point t)

  ;; Scrolling behavior
  (setq scroll-preserve-screen-position t)
  (setq scroll-conservatively 1)
  (setq scroll-margin 0)
  (setq scroll-preserve-screen-position 1)
  (setq auto-window-vscroll nil)
  (set-window-scroll-bars (minibuffer-window) nil nil)

  ;; Indentations and text apparence
  (setq-default sentence-end-double-space nil)
  (setq-default tab-width 4)
  (setq-default tab-always-indent 'complete)
  (setq-default indent-tabs-mode nil)
  (setq require-final-newline t)

  ;; Runtime settings
  (setq gc-cons-threshold 20000000)
  (column-number-mode t)
  (setq delete-by-moving-to-trash t)
  (setq-default dired-listing-switches "-alh --group-directories-first")
  (global-font-lock-mode t)
  (setq default-directory (expand-file-name "~/"))
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (global-font-lock-mode t)
  (setq echo-keystrokes 0.2)

  ;; Editing
  (save-place-mode t)
  (global-auto-revert-mode t)
  (setq set-mark-command-repeat-pop t)

  ;; Encodings
  (setq bidi-paragraph-direction 'left-to-right)
  (prefer-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (global-prettify-symbols-mode t)

  ;; Custom functions

  ;; Stolen from https://www.masteringemacs.org/article/fixing-mark-commands-transient-mark-mode
  (defun cust/push-mark-no-activate ()
    "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
    (interactive)
    (push-mark (point) t nil)
    (message "Pushed mark to ring"))
  (defun cust/jump-to-mark ()
    "Jumps to the local mark, respecting the `mark-ring' order.
  This is the same as using \\[set-mark-command] with the prefix argument."
    (interactive)
    (set-mark-command 1))

  ;; Stolen from https://github.com/hrs/sensible-defaults.el
  (defun cust/comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region"
    (interactive)
    (let (beg end)
      (if (region-active-p)
          (setq beg (region-beginning) end (region-end))
        (setq beg (line-beginning-position) end (line-end-position)))
      (comment-or-uncomment-region beg end)))


  ;; Stolen from https://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line/
  (defun cust/smarter-move-beginning-of-line (arg)
    "Toggle between beginning of the line and beginning of the text"
    (interactive "^p")
    (setq arg (or arg 1))

    (when (/= arg 1)
      (let ((line-move-visual nil))
        (forward-line (1- arg))))
    (let ((orig-point (point)))
      (back-to-indentation)
      (when (= orig-point (point))
        (move-beginning-of-line 1))))

  ;; actually this is not needed https://www.emacswiki.org/emacs/SwitchingBuffers
  ;; Stolen from https://emacsredux.com/blog/2013/04/28/switch-to-previous-buffer/
  (defun cust/switch-to-previous-buffer ()
    "Switch to previous buffer"
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer) 1)))
  ;; how to set this up with bind?
  (global-set-key [remap move-beginning-of-line]
                  'cust/smarter-move-beginning-of-line)
  :bind
  (("M-;" . cust/comment-or-uncomment-region-or-line)
   ("C-c b" . #'cust/switch-to-previous-buffer)
   ("C-c j m" . 'cust/push-mark-no-activate)
   ("C-c j b" . 'cust/jump-to-mark)))

(use-package subword
  :config (global-subword-mode 1))

(use-package recentf
  :init
  (setq recentf-max-saved-items 50)
  (setq recentf-max-menu-items 15)
  (setq recentf-auto-cleanup 'never)
  (setq recentf-show-file-shortcuts-flag nil)
  :config
  (recentf-mode t))

(use-package savehist
  :config
  (setq savehist-file "~/.emacs.d/savehist")
  (setq history-length 30000)
  (setq history-delete-duplicates nil)
  (setq savehist-additional-variables '(search-ring
                                        regexp-search-ring))
  (setq savehist-save-minibuffer-history t)
  (savehist-mode 1))

(use-package time
  :init
  (setq display-time-day-and-date t)
  (setq display-time-default-load-average nil)
  (setq display-time-format "%H:%M ")
  :config
  (display-time-mode t))

(use-package calendar
  :hook (calendar-today-visible . calendar-mark-today))

;; Why does this not work?
(use-package server
  :hook (after-init-hook . server-start))

(use-package minibuffer
  :bind
  (("s-f" . find-file)
   ("s-F" . find-file-other-window)
   ("s-d" . dired)
   ("s-D" . dired-other-window)
   ("s-b" . switch-to-buffer)
   ("s-B" . switch-to-buffer-other-window))
  :config
  (setq enable-recursive-minibuffers t)
  (setq completion-styles '(basic partial-completion))
  (setq completion-category-defaults nil)
  (setq completion-cycle-threshold 3)
  (setq completion-flex-nospace nil)
  (setq completion-ignore-case t)
  (setq read-buffer-completion-ignore-case t)
  (setq read-file-name-completion-ignore-case t)
  (setq completions-format 'vertical)
  (minibuffer-depth-indicate-mode 1))

(use-package imenu
  :config
  (setq imenu-use-markers t)
  (setq imenu-auto-rescan t)
  (setq imenu-auto-rescan-maxout 600000)
  (setq imenu-max-item-length 100)
  (setq imenu-max-items 200)
  (setq imenu-use-popup-menu nil)
  (setq imenu-eager-completion-buffer nil)
  (setq imenu-space-replacement " ")
  (setq imenu-level-separator "/"))

;; Enable if needed
;; (use-package imenu-anywhere
;;   :ensure t
;;   :defer t
;;   :diminish t)

(use-package imenu-list
  :ensure t
  :after (imenu)
  :bind
  (("C-S-c m" . #'imenu-list-smart-toggle)))

(use-package isearch
  :diminish
  :config
  (setq search-highlight t))

(use-package ibuffer
  :config
  ;; stolen from https://cestlaz.github.io/posts/using-emacs-34-ibuffer-emmet/
  (setq ibuffer-expert t)
  (setq ibuffer-display-summary nil)
  (setq ibuffer-use-other-window nil)
  (setq ibuffer-use-header-line t)
  (setq ibuffer-saved-filter-groups
        (quote (("default"
                 ("dired" (mode . dired-mode))
                 ("org" (name . "^.*org$"))
                 ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
                 ("emacs" (or
                           (name . "^\\*scratch\\*$")
                           (name . "^\\*Messages\\*$")))
                 ))))
  (setq ibuffer-show-empty-filter-groups nil)
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-auto-mode 1)
              (ibuffer-switch-to-saved-filter-groups "default")))
  :bind (("C-x C-b" . 'ibuffer)))

(use-package window
  :init
  (defun cust/split-window-below-and-switch ()
    "Split window horizontally and switch automatically"
    (interactive)
    (split-window-below)
    (balance-windows)
    (other-window 1))
  (defun cust/split-window-right-and-switch ()
    "Split window vertically and switch automatically"
    (interactive)
    (split-window-right)
    (balance-windows)
    (other-window 1))
  :bind
  (("s-n" . next-buffer)
   ("s-p" . previous-buffer)
   ("s-o" . other-window)
   ("s-2" . 'cust/split-window-below-and-switch)
   ("s-3" . 'cust/split-window-right-and-switch)
   ("s-0" . delete-window)
   ("s-1" . delete-other-windows)
   ("s-5" . delete-frame)))

(use-package mouse
  :config
  (setq mouse-wheel-scroll-amount
        '(1
          ((shift) . 5)
          ((meta) . 0.5)
          ((control) . text-scale)))
  (setq mouse-drag-copy-region nil)
  (setq mouse-wheel-progressive-speed t)
  (setq mouse-wheel-follow-mouse t)
  :hook (after-init-hook . mouse-wheel-mode))

(use-package winner
  :ensure t
  :bind
  (("<s-right>" . winner-redo)
   ("<s-left>" . winner-undo))
  :config
  (winner-mode +1))

(use-package windmove
  :bind
  (("C-s-k" . windmove-up)
   ("C-s-l" . windmove-right)
   ("C-s-j" . windmove-down)
   ("C-s-h" . windmove-left)))

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-zoom (global-map "C-c h z")
    "zoom"
    ("g" text-scale-increase "in")
    ("l" text-scale-decrease "out"))
  (defhydra hydra-winner (global-map "C-c h w")
    "windows"
    ("k" windmove-up)
    ("l" windmove-right)
    ("j" windmove-down)
    ("h" windmove-left)
    ("u" winner-undo)
    ("r" winner-redo)))

(use-package general
  :ensure t
  :diminish t)

(use-package magit
  :ensure t
  :bind
  (("C-c g" . magit-status)
   ("<f9>" . magit-status))
  :config
  (setq git-commit-summary-max-length 80))

(use-package multiple-cursors
  :ensure t
  :defer t
  :diminish t
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode))


;; TODO configure
(use-package yasnippet
  :ensure t
  :defer t
  :diminish t
  :config
  (add-hook 'prog-mode-hook #'yas-minor-mode))


;; https://github.com/tlh/workgroups.el might we worth a try too
(use-package perspective
  :ensure t
  :diminish t
  :config
  (persp-mode))

;;
;; Org mode
;;

(use-package org
  :ensure t
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c a" . 'org-agenda))
  :config
  (setq org-ellipsis "⤵")
  (setq org-hide-emphasis-markers t)
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (setq org-return-follows-link t)
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)
  (setq org-adapt-indentation nil)
  (setq org-todo-keywords '((sequence "TODO(t)" "ONGOING(o)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-log-done 'time)
  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)
  (setq org-directory "~/Documents/notes")
  (setq org-agenda-files (apply 'append
                                (mapcar
                                 (lambda (directory)
                                   (directory-files-recursively
                                    directory org-agenda-file-regexp))
                                 '("~/Documents/notes"))))
  (add-hook 'org-mode-hook 'visual-line-mode)
  (setq org-tag-alist
        '(("test"))))

(use-package org-capture
  :after (org)
  :bind ("C-c c" . org-capture)
  :config
  (setq org-capture-templates
        '(("t" "Basic TODO task" entry
           (file+headline "inbox.org" "Task list")
           "* %^{Title}\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n\n%i%l"))))

(use-package org-agenda
  :after (org)
  :config
  (setq org-agenda-span 14)
  (setq org-agenda-start-on-weekday 1)
  (setq org-agenda-window-setup 'current-window))

(use-package org-src
  :after (org)
  :diminish t
  :defer t
  :config
  (setq org-src-window-setup 'current-window))

(use-package org-bullets
  :ensure t
  :defer t
  :after (org)
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))

;;
;; Markup language
;;

(use-package yaml-mode
  :ensure t
  :defer t
  :mode
  (("\\.yml$" . yaml-mode)
   ("\\.yaml$" . yaml-mode))
  :config
  (add-hook 'yaml-mode-hook 'whitespace-mode)
  (add-hook 'yaml-mode-hook 'subword-mode))

(use-package json-mode
  :ensure t
  :defer t
  :mode
  (("\\.json$" . json-mode)))

(use-package markdown-mode
  :ensure t
  :defer t
  :mode (("\\.md$" . markdown-mode)
         ("\\.markdown$" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

;;
;; Extra features
;;
(use-package neotree
  :ensure t
  :diminish t
  :bind
  ("<f8>" . 'neotree-toggle))

;; (use-package shell-pop
;;   :ensure t
;;   :diminish t
;;   :defer t
;;   :bind (("C-c t" . shell-pop))
;;   :config
;;   (setq shell-pop-shell-type
;;         (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
;;   (setq shell-pop-term-shell "/bin/zsh")
;;   (setq shell-pop-default-directory "~/")
;;   (setq shell-pop-window-position "bottom")
;;   (setq shell-pop-autocd-to-working-dir t)
;;   (setq shell-pop-full-span t)
;;   (setq shell-pop-window-size 30)
;;   (setq shell-pop-restore-window-configuration t)
;;   (setq shell-pop-cleanup-buffer-at-process-exit t))

(use-package diff-hl
  :ensure t
  :diminish t
  :config
  (global-diff-hl-mode)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package easy-kill
  :ensure t
  :diminish t
  :config
  (global-set-key [remap kill-ring-save] #'easy-kill)
  (global-set-key [remap mark-sexp] #'easy-mark))

(use-package browse-kill-ring
  :ensure t
  :diminish t
  :defer t
  :bind
  (("M-y" . browse-kill-ring))
  :config
  (setq browse-kill-ring-highlight-current-entry t)
  (setq browse-kill-ring-highlight-inserted-item t)
  (setq browse-kill-ring-show-preview t))

(use-package undo-tree
  :ensure t
  :defer t
  :diminish t
  :config
  (setq undo-tree-show-minibuffer-help t)
  (global-undo-tree-mode 1))

(use-package change-inner
  :ensure t
  :defer t
  :diminish t
  :bind
  (("M-i" . 'change-inner)
   ("M-o" . 'change-outer)))

(use-package restclient
  :ensure t
  :defer t)

(use-package company-restclient
  :ensure t
  :defer t
  :after (restclient)
  :config
  (add-to-list 'company-backend 'company-restclient))

(use-package expand-region
  :ensure t
  :diminish t
  :bind
  ("C-=" . 'er/expand-region))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.25)
  (which-key-mode))

; Enable this manually if needed. Might slow things down otherwise.
(use-package rainbow-delimiters
  :ensure t
  :disabled t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'text-mode-hook #'rainbow-delimiter-mode))

(use-package ivy
  :ensure t
  :diminish t
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 13)
  (setq ivy-wrap t)
  (setq ivy-display-style 'fancy)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-virtual-abbreviate 'full)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  :config
  (ivy-mode +1))

(use-package counsel
  :ensure t
  :diminish
  :bind
  (("M-x" . 'counsel-M-x)
   ("C-s" . 'swiper)
   ("C-S-s" . 'counsel-projectile-rg)
   ("C-x C-f" . 'counsel-find-file)
   ;("C-x C-r" . 'ivy-resume)
   ("C-c m" . counsel-imenu)
   ("C-x C-r" . counsel-recentf)
  )
  :config
  (use-package smex
    :ensure t))

(use-package display-line-numbers
  :config
  (setq display-line-numbers-type t)
  (display-line-numbers-mode t))

(use-package hl-line)

(use-package diminish
  :ensure t
  :after use-package)

(use-package electric
  :config
  (setq electric-pair-preserve-balance t)
  (setq electric-pair-skip-self 'electic-pair-default-skip-self)
  (setq electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)
  (setq electric-pair-skip-whitespace nil)
  (setq electric-pair-skip-whitespace-chars
        '(9
          10
          32))
  (electric-indent-mode 1)
  (electric-pair-mode 1))


(use-package origami
  :ensure t
  :diminish t
  :defer t
  :commands (origami-toggle-node))

(use-package avy
  :ensure t
  :bind
  (("C-." . avy-goto-char)
   ("C-c j 1" . avy-goto-char)
   ("C-c j 2" . avy-goto-char-2)
   ("C-c j 3" . avy-goto-char-timer)
   ("C-c j l" . avy-goto-line))
  :config
  (avy-setup-default))

;(use-package goto-chg
;  :ensure t
;  :config
;  (global-set-key (kbd "C-c b ,") 'goto-last-change)
;  (global-set-key (kbd "C-c b .") 'goto-last-change-reverse))

(use-package company
  :ensure t
  :init
  (setq company-show-numbers t)
  (setq company-idle-delay 0.3)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-limit 10)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t)
  :config
  (global-company-mode 1))

(use-package ace-window
  :ensure t
  :diminish
  :bind
  (("C-c o" . 'ace-window)))

(use-package dumb-jump
  :ensure t
  :defer t
  :diminish t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  (setq dumb-jump-selector 'ivy)
  :bind
  (("C-c j j" . xref-find-definitions)
   ("C-c j p" . xref-pop-marker-stack)))

(use-package projectile
  :ensure t
  :diminish t
  :defer t
  :config
  (projectile-global-mode)
  (setq projectile-compeletion-system 'ivy)
  (setq projectile-switch-project-action 'projectile-dired)
  (setq projectile-project-search-path '("~/dev/"))
  :bind-keymap
  (("C-c p" . projectile-command-map)))

(use-package dired-hide-dotfiles
  :ensure t
  :diminish t
  :defer t
  :config
  (dired-hide-dotfiles-mode)
  :bind (:map dired-mode-map
              ("." . #'dired-hide-dotfiles-mode)))

(use-package hippie-exp
  :config
  (setq hippie-expand-try-functions-list
        '(try-complete-file-name-partially
          try-complete-file-name
          try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill))
  :bind
  (("M-/" . 'hippie-expand)))

(use-package projectile-ripgrep
  :ensure t
  :diminish t
  :defer t)

;; (use-package deadgrep
;;   :ensure t
;;   :diminish t
;;   :defer t
;;   :bind
;;   (("<f5>" . #'deadgrep)))

;; Stolen from https://protesilaos.com/dotemacs
(use-package rg
  :ensure t
  :config
  (setq rg-group-result t)
  (setq rg-hide-command t)
  (setq rg-show-columns nil)
  (setq rg-show-header t)
  (setq rg-custom-type-aliases nil)
  (setq rg-default-alias-fallback "all")
  (rg-define-search prot/rg-vc-or-dir
                    "RipGrep in project root or present directory."
                    :query ask
                    :format regexp
                    :files "everything"
                    :dir (or (vc-root-dir)              ; search root project dir
                             default-directory)         ; or from the current dir
                    :confirm prefix
                    :flags ("--hidden -g !.git"))

  (rg-define-search prot/rg-ref-in-dir
                    "RipGrep for thing at point in present directory."
                    :query point
                    :format regexp
                    :files "everything"
                    :dir default-directory
                    :confirm prefix
                    :flags ("--hidden -g !.git"))

  (defun prot/rg-save-search-as-name ()
    "Save `rg' buffer, naming it after the current search query.

This function is meant to be mapped to a key in `rg-mode-map'."
    (interactive)
    (let ((pattern (car rg-pattern-history)))
      (rg-save-search-as-name (concat "«" pattern "»"))))

  :bind (("M-s g" . prot/rg-vc-or-dir)
         ("M-s r" . prot/rg-ref-in-dir)
         :map rg-mode-map
         ("s" . prot/rg-save-search-as-name)
         ("C-n" . next-line)
         ("C-p" . previous-line)
         ("M-n" . rg-next-file)
         ("M-p" . rg-prev-file)))

(use-package counsel-projectile
  :ensure t
  :diminish t
  :after (projectile))

(use-package all-the-icons
  :ensure t
  :defer t
  :init
  (add-hook 'after-init-hook (lambda () (require 'all-the-icons)))
  :config
  (setq all-the-icons-scale-factor 1.0))

(use-package all-the-icons-dired
  :ensure t
  :defer t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  (setq uniquify-strip-common-suffix t)
  (setq uniquify-after-kill-buffer-p t))

(use-package crux
  :ensure t
  :diminish t
  :bind
  (("C-k" . #'crux-smart-kill-line)
   ("C-c t" . #'crux-visit-term-buffer)
   ("C-c C-d" . #'crux-duplicate-current-line-or-region)
   ("C-x 4 t" . #'crux-transpose-windows)
   ("C-<return>" . #'crux-smart-open-line)
   ("C-S-<return>" . #'crux-smart-open-line-above)))

;;
;; DevOps related modes
;;

(use-package sh-script
  :mode (("\\.sh\\'" . sh-mode)
         ("\\.zsh\\'" . sh-mode)))

(use-package terraform-mode
  :ensure t)

(use-package company-terraform
  :ensure t)

(use-package docker
  :ensure t
  :defer t
  :diminish t
  :bind
  (("C-c d" . docker)))

(use-package dockerfile-mode
  :ensure t
  :diminish t
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package make-mode
  :mode (("Makefile" . makefile-gmake-mode)))

;;
;; Groovy
;;

(use-package groovy-mode
  :ensure t
  :defer t)

;;
;; Python
;;
(use-package python
  :mode (("\\.py\\'" . python-mode)))

(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  :config
  (setq elpy-rpc-python-command "/usr/bin/python3") ;this is now set as a link so "python" should be enough
  ;(setq elpy-rpc-timeout 2)
  ;(setq elpy-rpc-backend "jedi")
  (setq python-shell-interpreter "jupyter")
  (setq python-shell-interpreter-args "console --simple-prompt")
  (setq python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter"))

;; This is not needed when using Company
;(use-package jedi
;  :ensure t
;  :defer t
;  :config
;  (setq jedi:environment-virtualenv (list "python -m venv")))

(use-package company-jedi
  :ensure t
  :defer t
  :init
  (setq-default jedi:complete-on-dot t)
  (setq-default jedi:get-in-function-call-delay 0.2)
  :config
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook (add-to-list 'company-backends 'company-jedi)))

;;
;; Clojure
;;

(use-package clojure-mode
  :ensure t
  :defer t)

;;
;; Golang
;;

(use-package go-mode
  :ensure t
  :defer t)

(use-package company-go
  :disabled t
  :ensure t
  :diminish t
  :after (go-mode)
  :config
  (add-hook 'go-mode-hook (add-to-list 'company-backends 'company-go)))

(use-package go-errcheck
  :ensure t
  :after (go-mode))

;;
;; Web dev
;;
(use-package css-mode)

(use-package web-mode
  :ensure t)

;;
;; Themes and other visuals
;;

;; (use-package dracula-theme
;;   :ensure t
;;   :config
;;   (load-theme 'dracula t))

(use-package modus-operandi-theme
  :ensure t
  :config
  (defun modus-themes-toggle ()
    "Toggle between modus themes"
    (interactive)
    (if (eq (car custom-enabled-themes) 'modus-operandi)
        (progn
          (disable-theme 'modus-operandi)
          (load-theme 'modus-vivendi t))
      (disable-theme 'modus-vivendi)
      (load-theme 'modus-operandi t)))
  (setq modus-operandi-theme-bold-constructs t)
  (setq modus-operandi-theme-slanted-constructs t)
  (setq modus-operandi-theme-faint-syntax t)
  (setq modus-operandi-theme-prompts nil)
  (setq modus-operandi-theme-links 'faint)
  (setq modus-operandi-theme-mode-line nil)
  (setq modus-operandi-theme-completions 'opinionated)
  (setq modus-operandi-theme-fringes 'subtle)
  (setq modus-operandi-theme-intense-hl-line t)
  (setq modus-operandi-theme-intense-paren-match t)
  (setq modus-operandi-theme-org-blocks 'greyscale)
  (load-theme 'modus-operandi t))

(use-package modus-vivendi-theme
  :ensure t
  :defer t
  :config
  (setq modus-vivendi-theme-bold-constructs t)
  (setq modus-vivendi-theme-slanted-constructs t)
  (setq modus-vivendi-theme-faint-syntax nil)
  (setq modus-vivendi-theme-prompts 'intense)
  (setq modus-vivendi-theme-links 'faint)
  (setq modus-vivendi-theme-mode-line nil)
  (setq modus-vivendi-theme-completions 'opinionated)
  (setq modus-vivendi-theme-fringes 'subtle)
  (setq modus-vivendi-theme-intense-hl-line t)
  (setq modus-vivendi-theme-intense-paren-match t)
  (setq modus-vivendi-theme-org-blocks 'greyscale))

;(use-package cyberpunk-theme
; : :ensure t
;  :config
;  (load-theme 'cyberpunk t))

;; TODO configure
(use-package doom-modeline
  :disabled t
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-indent-info t))

(use-package volatile-highlights
  :ensure t
  :diminish t
  :config
  (volatile-highlights-mode +1))

(use-package beacon
  :ensure t
  :diminish
  :config
  (beacon-mode +1))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline success warning error])
 '(ansi-color-names-vector
   ["#000000" "#a60000" "#005e00" "#813e00" "#0030a6" "#721045" "#00538b" "#ffffff"])
 '(awesome-tray-mode-line-active-color "#0030a6")
 '(awesome-tray-mode-line-inactive-color "#e0e0e0")
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(display-time-mode t)
 '(dumb-jump-mode t)
 '(flymake-error-bitmap
   (quote
    (flymake-double-exclamation-mark modus-theme-fringe-red)))
 '(flymake-note-bitmap (quote (exclamation-mark modus-theme-fringe-cyan)))
 '(flymake-warning-bitmap (quote (exclamation-mark modus-theme-fringe-yellow)))
 '(global-company-mode t)
 '(global-undo-tree-mode t)
 '(highlight-tail-colors (quote (("#aecf90" . 0) ("#c0efff" . 20))))
 '(hl-todo-keyword-faces
   (quote
    (("HOLD" . "#70480f")
     ("TODO" . "#721045")
     ("NEXT" . "#5317ac")
     ("THEM" . "#8f0075")
     ("PROG" . "#00538b")
     ("OKAY" . "#30517f")
     ("DONT" . "#315b00")
     ("FAIL" . "#a60000")
     ("BUG" . "#a60000")
     ("DONE" . "#005e00")
     ("NOTE" . "#863927")
     ("KLUDGE" . "#813e00")
     ("HACK" . "#813e00")
     ("TEMP" . "#5f0000")
     ("FIXME" . "#a0132f")
     ("XXX+" . "#972500")
     ("REVIEW" . "#005a5f")
     ("DEPRECATED" . "#201f55"))))
 '(ibuffer-deletion-face (quote modus-theme-mark-del))
 '(ibuffer-filter-group-name-face (quote modus-theme-mark-symbol))
 '(ibuffer-marked-face (quote modus-theme-mark-sel))
 '(ibuffer-title-face (quote modus-theme-header))
 '(package-selected-packages
   (quote
    (perspective modus-vivendi-theme fira-code-mode flycheck groovy-mode clojure-mode dired-x rg hippie-expand change-inner browse-kill-ring crux shell-pop beacon general volatile-highlights deadgrep projectile-ripgrep web-mode company-jedi doom-modeline modus-operandi-theme counsel-projectile org-src company-restclient restclient docker ox-md diff-hl ace-window origami dockerfile-mode multiple-cursors goto-chg imenu-anywhere smex expand-region easy-kill neotree hydra imenu-list org-superstar org-plus-contrib rainbow-delimiters dired-hide-dotfiles which-key diminish all-the-icons-dired all-the-icons dumb-jump company-terraform terraform-mode projectile dumb-jump company-mode avy markdown-mode moody yaml-mode counsel ivy org magit use-package)))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#a60000")
     (40 . "#721045")
     (60 . "#8f0075")
     (80 . "#972500")
     (100 . "#813e00")
     (120 . "#70480f")
     (140 . "#5d3026")
     (160 . "#184034")
     (180 . "#005e00")
     (200 . "#315b00")
     (220 . "#005a5f")
     (240 . "#30517f")
     (260 . "#00538b")
     (280 . "#093060")
     (300 . "#0030a6")
     (320 . "#223fbf")
     (340 . "#0000bb")
     (360 . "#5317ac"))))
 '(vc-annotate-very-old-color nil)
 '(xterm-color-names
   ["#000000" "#a60000" "#005e00" "#813e00" "#0030a6" "#721045" "#00538b" "#f0f0f0"])
 '(xterm-color-names-bright
   ["#505050" "#972500" "#315b00" "#70480f" "#223fbf" "#8f0075" "#30517f" "#ffffff"]))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "FiraCode Nerd Font Mono" :foundry "CTDB" :slant normal :weight normal :height 122 :width normal)))))
