;;  initialisation file.

;; Copyright (C) 2014  Dominic Charlesworth <dgc336@gmail.com>

;; Author: Dominic Charlesworth <dgc336@gmail.com>
;; Keywords: internal

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; When setting up from scratch, there are a couple of external
;; packages that you'll require, here is a list of things to install

;; npm install -g livedown
;; npm install -g n_
;; npm install -g pen
;; npm install -g nave
;; npm install -g speed-test
;; npm install -g eslint_d
;; npm install -g ramda-repl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq custom-file (expand-file-name "init/custom.el" user-emacs-directory))
(load-file (expand-file-name "init/custom.el" user-emacs-directory))

(require 'package)
(setq-default package-user-dir (expand-file-name "etc/packages" user-emacs-directory))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize nil)
(run-with-idle-timer 900 t 'package-refresh-contents)

(require 'benchmark-init)
(add-hook
 'benchmark-init/tree-mode-hook
 '(lambda ()
    (local-set-key "i" '(lambda () (interactive) (find-file user-init-file)))
    (local-set-key "s" '(lambda () (interactive) (switch-to-buffer "*scratch*")))
    (local-set-key "F" '(lambda () (interactive) (set-frame-size (selected-frame) 238 100)))
    (local-set-key "t" 'counsel-load-theme)
    (local-set-key "f" 'set-font)
    (local-set-key "a" 'org-agenda)
    (local-set-key "p" 'projectile-switch-project)
    (local-set-key "P" 'paradox-list-packages)))

(eval-when-compile (require 'use-package))

(use-package bind-key :ensure t)
(use-package try :ensure t :commands (try))

(use-package functions :load-path "init")

(use-package paradox
  :ensure t
  :commands (paradox-list-packages)
  :bind (:map paradox-menu-mode-map ("g" . paradox--refresh-remote-data)))

(use-package quickrun
  :ensure t
  :bind ("C-x RET RET" . quickrun))

(eval-after-load "treemacs"
  (use-package solaire-mode
   :ensure t
   :hook ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)))

(use-package no-littering :ensure t)
(use-package linum-off :ensure t)
(use-package nlinum :ensure t :after linum-off
  :config
  (advice-add 'nlinum-mode :around
              (lambda (orig-f &rest args)
                (unless (or (minibufferp)
                            (or
                             (eq major-mode 'treemacs-mode)
                             (memq major-mode linum-disabled-modes-list))
                            (string-match "*" (buffer-name)))
                  (apply orig-f args))))
  (setq nlinum-highlight-current-line t)
  (global-nlinum-mode))

(use-package origami :ensure t :disabled t
  :config (origami-mode)
  :bind ("s-=" . origami-toggle-node))

(use-package rainbow-delimiters :ensure t :defer 1
  :init (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
(use-package rainbow-mode :ensure t :defer 1
  :init (add-hook 'prog-mode-hook 'rainbow-mode))

(use-package highlight-defined :ensure t :after emacs-lisp-mode
  :init (add-hook 'emacs-lisp-mode-hook 'highlight-defined-mode))
(use-package highlight-quoted :ensure t :after emacs-lisp-mode
  :init (add-hook 'emacs-lisp-mode-hook 'highlight-quoted-mode))
(use-package highlight-parentheses :ensure t :after emacs-lisp-mode
  :init (add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)
  :config (setq hl-paren-colors '("#91ca55" "#f45d43" "#ee3f46" "#c0392b")))

(use-package auto-highlight-symbol :ensure t
  :config
  (setq ahs-idle-interval 0.5)
  (auto-highlight-symbol-mode 1))

(use-package multiple-cursors :ensure t
  :bind ("H-n" . mc/mark-next-like-this)
        ("<end>" . mc/mark-next-like-this)
        ("H-N" . mc/skip-to-next-like-this)
        ("<S-end>" . mc/skip-to-next-like-this)
        ("H-p" . mc/mark-previous-like-this)
        ("<f13>" . mc/mark-previous-like-this)
        ("H-P" . mc/skip-to-previous-like-this)
        ("<S-f13>" . mc/skip-to-previous-like-this)
        ("H-l" . mc/mark-all-symbols-like-this)
        ("H->" . mc/insert-numbers)
        ("M-<mouse-1>" . mc/add-cursor-on-click))

(use-package multi-line :ensure t
  :bind ("C-c [" . multi-line-single-line)
        ("C-c ]" . multi-line))

(use-package drag-stuff :ensure t
  :bind ("s-S-<up>" . drag-stuff-up)
        ("s-P" . drag-stuff-up)
        ("s-S-<down>" . drag-stuff-down)
        ("s-N" . drag-stuff-down))

(use-package expand-region :ensure t
  :bind ("M-q" . er/expand-region))

(use-package ibuf-ext :after ibuffer
  :config (add-to-list 'ibuffer-never-show-predicates "^\\*"))
(use-package ibuffer-vc :ensure t :after ibuffer
  :bind (:map ibuffer-mode-map ("G" . ibuffer-vc-set-filter-groups-by-vc-root)))
(use-package ibuffer-projectile :ensure t :after ibuffer
  :bind (:map ibuffer-mode-map ("P" . ibuffer-vc-set-filter-groups-by-vc-root)))

(use-package ibuffer :ensure t :defer t
  :bind (:map ibuffer-mode-map
         ("M-u" . ibuffer-unmark-all)))

(use-package eyebrowse :ensure t
  :config
  (eyebrowse-mode)
  (setq spaceline-all-the-icons-icon-set-eyebrowse-slot 'string
        eyebrowse-mode-line-left-delimiter ""
        eyebrowse-mode-line-style 'smart
        eyebrowse-mode-line-separator " | "
        eyebrowse-mode-line-right-delimiter "  👀")
  (eyebrowse-rename-window-config 1 "emacs"))

(use-package smart-forward :ensure t
  :bind ("s-." . forward-sexp)
        ("s-," . backward-sexp)
        ("C-." . smart-forward)
        ("C-," . smart-backward))

(use-package smart-newline :ensure t
  :bind ("RET" . smart-newline))

(use-package smartparens-config :after smartparens)
(use-package smartparens :ensure t :defer 1
  :config
  (show-smartparens-global-mode)
  (smartparens-global-mode)
  (sp-local-pair
   '(minibuffer-inactive-mode snippet-mode lisp-mode emacs-lisp-mode text-mode)
           "'" nil :actions nil)
  (sp-with-modes sp-lisp-modes (sp-local-pair "(" nil :bind "s-("))
  :bind ("C-)" . sp-slurp-hybrid-sexp)
        ("<s-backspace>" . sp-splice-sexp)
        ("s-f" . sp-slurp-hybrid-sexp)
        ("s-b" . sp-forward-barf-sexp))

(use-package popup :ensure t :defer t)
(use-package popwin :ensure t
  :config
  (popwin-mode 1)
  (setq popwin:close-popup-window-timer-interval 0.1)
  (setq popwin:close-popup-window-timer nil))

(use-package org :ensure t
  :defer t
  :mode ("\\.org"  . org-mode)
  :bind ("C-c c"   . org-capture)
        ("C-c a"   . org-agenda)
        ("C-c l"   . org-store-link)
        ("C-c e"   . org-export-dispatch)
        ("C-c C-l" . org-link)
        ("C-j"     . join-line)
  :init
  (setq diary-file "~/Dropbox/Documents/Org/diary"
        org-src-fontify-natively t
        org-agenda-files
        '("~/Dropbox/Documents/Org/meetings.org"
          "~/Dropbox/Documents/Org/tasks.org"
          "~/Dropbox/Documents/Org/birthdays.org")
        org-ellipsis "⤵"
        org-todo-keywords '((sequence "TODO" "IN PROGRESS" "DONE" "WAITING"))
        org-todo-keyword-faces
        '(("DONE"        . (:foreground "#0fbf5c" :weight bold :box (:line-width 1 :color "#3dc748") ))
          ("IN PROGRESS" . (:background "#f1c40f" :foreground "#2c3e50" :weight bold))
          ("WAITING"     . (:background "#e74c3c" :foreground "#2c3e50" :weight bold)))
        org-capture-templates
        `(("t" "Todo" entry (file+headline "~/Dropbox/Documents/Org/tasks.org" "Tasks") "* TODO %?\n %t")
          ("j" "Journal" entry (file+datetree "~/Dropbox/Documents/Org/journal.org") "** %^{Heading}  :LOG:\n%?")
          ("m" "Meeting" entry (file+headline "~/Dropbox/Documents/Org/meetings.org" "MEETINGS") "* %^{Title} %^g\n  SCHEDULED: %(cfw:capture-schedule-day)\n  %?\n"))
        org-agenda-todo-ignore-scheduled 'past
        org-scheduled-past-days 0
        org-deadline-warning-days 7
        org-agenda-tags-todo-honor-ignore-options t
        org-todo-keywords-for-agenda t
        org-agenda-skip-deadline-prewarning-if-schedule t
        org-agenda-skip-scheduled-if-done t
        org-agenda-custom-commands
        '(("n" "Agenda and all TODOs"
           ((agenda "" ((org-agenda-sorting-strategy '(time-up deadline-up))))
            (alltodo "" ((org-agenda-sorting-strategy '(todo-state-up tag-down priority-down effort-down))))
            (todo "" ((org-agenda-files '("~/Dropbox/Documents/org/tickets.org"))
                      (org-agenda-sorting-strategy '(todo-state-up))))))))

  :config
  ;; Export Backends
  (use-package ox-twbs :ensure t)
  (use-package org-wc :ensure t)
  (bind-keys :map org-mode-map
             ("C-c C-x l"   . org-toggle-link-display)
             ("M-=" . org-wc-display)
             ("C-;" . org-search-view)
             ("C-j" . join-line)
             ("s-f" . org-next-link)
             ("s-o" . org-open-at-point)
             ("s-b" . org-previous-link))
  (org-babel-do-load-languages 'org-babel-load-languages '((sh . t) (ruby . t) (dot . t) (perl . t)))
  (add-hook 'org-mode-hook 'auto-fill-mode)
  (add-hook 'org-mode-hook 'rainbow-mode)
  (add-hook 'org-mode-hook 'abbrev-mode)
  (add-hook 'org-mode-hook '(lambda () (flycheck-mode 0)))
  (add-hook 'org-finalize-agenda-hook '(lambda ()
                                         (org-color-tag "Birthdays:" "#27ae60")
                                         (org-color-tag "Holidays:" "#3498db")
                                         (org-color-tag "Reminders:" "#8e44ad"))))

(use-package doc-view :ensure t
  :mode ("\\.pdf" . doc-view-mode))

(use-package undo-tree :ensure t
  :config (global-undo-tree-mode)
  :bind ("C-c C-u" . undo-tree-visualize)
        ("s-z" . undo-tree-undo)
        ("s-Z" . undo-tree-redo)
        ("s-y" . undo-tree-redo)
        ("C-+" . undo-tree-redo))

(use-package github-browse-file :ensure t :commands (github-browse-file))
(use-package git-link :ensure t :commands (git-link git-link-homepage))
(use-package git-timemachine :ensure t :bind ("C-x v t" . git-timemachine))

(use-package git-gutter-fringe+ :ensure t :defer 3
  :if window-system
  :config
  (setq git-gutter-fr+-side 'right-fringe)
  (defun theme-git-gutter (&rest args) "Set the background colour of the git-gutter faces"
    (set-face-attribute 'git-gutter-fr+-added nil :foreground (face-foreground 'success) :background (face-foreground 'success))
    (set-face-attribute 'git-gutter-fr+-deleted nil :foreground (face-foreground 'error) :background (face-foreground 'error))
    (set-face-attribute 'git-gutter-fr+-modified nil :foreground (face-foreground 'warning) :background (face-foreground 'warning)))
  (theme-git-gutter)
  (advice-add 'load-theme :after 'theme-git-gutter)

  (global-git-gutter+-mode)

  :bind (:map git-gutter+-mode-map
              ("C-x v p" . git-gutter+-previous-hunk)
              ("C-x v s" . git-gutter+-show-hunk)
              ("C-x v n" . git-gutter+-next-hunk)))

(use-package image+ :ensure t :after 'image-mode
  :init (add-hook 'image-mode-hook '(lambda () (require 'image+)))
  :config (bind-keys :map image-mode-map
             ("0" . imagex-sticky-restore-original)
             ("+" . imagex-sticky-maximize)
             ("=" . imagex-sticky-zoom-in)
             ("-" . imagex-sticky-zoom-out)))

(use-package dired+
  :after dired
  :load-path "etc/elisp-packages/dired+"
  :config
  (setq insert-directory-program "gls")
  (add-hook 'dired-mode-hook '(lambda () (dired-hide-details-mode 0)))
  (add-hook 'dired-mode-hook '(lambda () (local-set-key (kbd "C-p") 'previous-line)))
  (add-hook 'dired-mode-hook
            (lambda ()
              (local-set-key (kbd "W") (lambda () (interactive) (wdired-change-to-wdired-mode)))
              (local-set-key (kbd "q") 'kill-all-dired-buffers))))

(use-package dired-filter :ensure t
  :after dired
  :init (setq dired-filter-group-saved-groups
              '(("default"
                 ("JavaScript" (extension "js" "json"))
                 ("MarkUp" (extension "md" "org"))
                 ("Archives" (extension "zip" "rar" "gz" "bz2" "tar"))
                 ("Images" (extension "png" "gif" "jpg")))))
  :config (bind-keys :map dired-mode-map
                     ("//" . dired-filter-group-mode)
                     ("C-o" . project-find-file)))

(use-package dired-quick-sort :ensure t
  :after dired
  :config (dired-quick-sort-setup))

(use-package windmove :ensure t
  :bind ("<M-s-right>" . windmove-right)
        ("<M-s-left>" . windmove-left)
        ("<M-s-up>" . windmove-up)
        ("<M-s-down>" . windmove-down))

(use-package yaml-mode :ensure t :mode ("\\.yml$" . yaml-mode))
(use-package dockerfile-mode :ensure t
  :mode ("^Dockerfile$" . dockerfile-mode)
  :config (bind-keys :map dockerfile-mode-map
                     ("C-x c" . dockerfile-build-buffer)
                     ("C-x C-c" . dockerfile-build-no-cache-buffer)))

(use-package docker-compose-mode :ensure t
  :mode ("^docker-compose.yml$" . docker-compose-mode))

(use-package nameless :ensure t
  :defer t
  :config (bind-keys :map nameless-mode-map ("C-c C-c" . nameless-insert-name)))

(use-package projectile :ensure t
  :commands (projectile-switch-project)
  :bind ("C-c p p" . projectile-switch-project)
  :config
  (recentf-mode)
  (projectile-mode)
  (setq projectile-completion-system 'ivy)
  (setq projectile-sort-order 'recently-active)
  (setq projectile-globally-ignored-directories
        (append projectile-globally-ignored-directories
                '("node_modules" "build" "tests" ".cache")))
  (setq projectile-globally-ignored-file-suffixes '(".min.js" ".tags" ".elc"))
  (setq projectile-tags-file-name ".tags")
  (setq projectile-tags-command "/usr/local/Cellar/ctags/5.8_1/bin/ctags -Re -f \"%s\" %s")
  :bind
  ("C-o" . projectile-find-file)
  ("C-c C-p" . projectile-ibuffer)
  ("C-c p o" . projectile-find-file-in-known-projects)
  ("C-c p a" . projectile-add-known-project)
  ("C-c p d" . projectile-find-dir)
  ("C-c p x x" . projectile-remove-known-project))

(use-package visual-regexp :ensure t
  :bind ("C-c r" . vr/replace)
        ("C-c q" . vr/query-replace)
        ("C-c m" . vr/mc-mark)
        ("s-r" . vr/query-replace)
        :config (setq vr/match-separator-string " 🌪️ "
                      vr/match-separator-use-custom-face t))

(use-package cycle-quotes :ensure t
  :bind ("H-C" . cycle-quotes)
        ("<S-delete>" . cycle-quotes))

(use-package embrace :ensure t
  :bind
  ("H-S-SPC"      . embrace-delete)
  ("H-c"          . embrace-change)
  ("<deletechar>" . embrace-change))

(use-package smex :ensure t :after counsel)
(use-package counsel :ensure t :after ivy
  :defer 5
  :config
  (setq counsel-find-file-at-point t)
  (defalias 'counsel-use-package 'counsel-load-library)
  (defun counsel-ag-project ()
      (interactive)
      (counsel-ag (thing-at-point 'symbol) (projectile-project-root)))

  (defun counsel-rg-type (&optional pfx)
    (interactive "P")
    (let* ((ext (file-name-extension (buffer-file-name)))
           (type-list (s-split "\n" (shell-command-to-string "rg --type-list")))
           (type (car (s-split ":" (car (--filter (s-contains? ext it) type-list))))))
      (counsel-rg
       (if pfx (thing-at-point 'symbol) "")
       (projectile-project-root)
       (format "--type %s" type))))

  :bind ("H-2"     . counsel-git-grep)
        ("C-S-o"   . counsel-git)
        ("C-x n"   . counsel-bookmark)
        ("C-c f"   . counsel-rg)
        ("C-c C-f" . counsel-rg-type)
        ("C-c v"   . counsel-git-grep)
        ("H->"     . counsel-imenu)
        ("C-'"     . counsel-imenu)
        ("M-x"     . counsel-M-x)
        ("C-x C-f" . counsel-find-file)
        ("C-h b"   . counsel-descbinds)
        ("C-h v"   . counsel-describe-variable)
        ("C-h F"   . counsel-describe-face)
        ("C-h f"   . counsel-describe-function)
        ("s-V"     . counsel-yank-pop)
        ("M-y"     . counsel-yank-pop))

(use-package imenu-list :ensure t
  :bind
  ("C-M-\\" . imenu-list-noselect)
  ("C-\\" . imenu-list))

(use-package imenu-anywhere :ensure t :after ivy
  :bind ("C-\"" . ivy-imenu-anywhere) )

(use-package bookmark :defer t
  :commands (bookmark-jump bookmark-all-names)
  :bind ("C-x r d" . bookmark-delete)
  :config (run-at-time "1 sec" 900 'bookmark-save))

(use-package fancy-narrow
  :ensure t
  :config
  (fancy-narrow-mode)
  (set-face-attribute 'fancy-narrow-blocked-face nil :foreground nil :inherit font-lock-comment-face)
  :bind ("C-x , ," . fancy-narrow-to-region)
        ("C-x , ." . fancy-widen))

(use-package flx :ensure t :after ivy)
(use-package ivy-hydra :ensure t :after ivy)
(use-package ivy :ensure t
  :config
  (ivy-mode)
  (defun swiper-thing-at-point ()
    (interactive)
    (if (region-active-p)
        (let ((text (buffer-substring (region-beginning) (region-end))))
          (deactivate-mark)
          (swiper text))
      (swiper)))

  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy))
        ivy-display-style 'plain
        ivy-height 9)
  :bind (("C-;"     . swiper-thing-at-point)
         ("C-:"     . swiper-all-thing-at-point)
         ("C-c C-r" . ivy-resume)
         ("C-x b"   . ivy-switch-buffer)
         ("C-x C-b" . ivy-switch-buffer-other-window)
         :map ivy-minibuffer-map
         ("s-k"     . delete-minibuffer-contents)
         ("C-S-j"   . ivy-immediate-done)))

(bind-keys :map minibuffer-local-map
           ("s-k" . delete-minibuffer-contents)
           ("<kp-decimal>" . completion-at-point)
           ("<backtab>" . completion-at-point))

(use-package isearch
  :commands swiper-from-isearch
  :bind (("H-s" . isearch-forward-symbol-at-point)
         ("C-s" . isearch-forward-regexp)
         ("C-r" . isearch-backward-regexp)
         :map isearch-mode-map
         ("C-;" . swiper-from-isearch)
         ("C-'" . avy-isearch)
         ("C-l" . counsel-git-grep-from-isearch)))

(use-package anzu :ensure t :defer 5
  :config (global-anzu-mode)
          (setq-default anzu-mode-line-update-function
                        'spaceline-all-the-icons-anzu-update-func))

(use-package avy-zap :ensure t :bind ("s-x" . avy-zap-up-to-char))
(use-package avy :ensure t
  :bind
  ("s-g" . avy-goto-line)
  ("s-p" . avy-goto-line-above)
  ("s-n" . avy-goto-line-below)
  ("s-J" . avy-goto-word-0)
  ("s-j" . avy-goto-word-1)
  ("s-l" . avy-goto-char-2)
  ("s-L" . avy-goto-char)
  :config
  (avy-setup-default))

(use-package wgrep-ag :ensure t :after ag
  :config (bind-keys :map ag-mode-map
                     ("W" . wgrep-change-to-wgrep-mode)
                     ("S" . wgrep-save-all-buffers)
                     ("F" . wgrep-finish-edit)))
(use-package ag
  :ensure t
  :commands (ag-regexp ag-project-regexp)
  :bind ("C-c g" . ag-project-regexp))

(use-package rg
  :ensure  t
  :bind ("M-s" . rg-dwim)
        ("M-S" . rg-project)
  :config
  (add-hook 'rg-mode-hook 'wgrep-ag-setup)
  (setq rg-show-columns t
        rg-show-header t)
  (bind-keys :map rg-mode-map
             ("W" . wgrep-change-to-wgrep-mode)))

(use-package comint
  :defer 5
  :init
  (add-hook
   'comint-mode-hook
   (lambda ()
     (local-set-key (kbd "C-r") 'comint-history-isearch-backward)
     (local-set-key (kbd "<up>") 'comint-previous-input)
     (local-set-key (kbd "<down>") 'comint-next-input))))

(use-package cpp :ensure t
  :mode ("\\.cpp" . c++-mode)
        ("\\.h" . c++-mode)
  :config
  (bind-keys :map c++-mode-map
             ("M-q" . er/expand-region)
             ("C-c C-p" . flycheck-previous-error)
             ("C-c C-n" . flycheck-next-error)))

(add-hook 'c++-mode-hook
          (lambda () (unless (file-exists-p "makefile")
                  (set (make-local-variable 'compile-command)
                       (let ((file (file-name-sans-extension buffer-file-name)))
                         (format "g++ %s -o %s" buffer-file-name file))))))

(use-package goto-addr :ensure t :after markdown-mode)
(use-package browse-url :ensure t
  :defer t
  :config (setq browse-url-browser-function 'browse-url-default-macosx-browser)
  :init (autoload 'browse-url-url-at-point "browse-url"))

(use-package link-hint :ensure t :after browse-url
  :bind ("H-o" . link-hint-open-link)
        ("H-k" . link-hint-open-multiple-links))

(use-package markdown-toc :ensure t
  :after markdown-mode
  :config (bind-keys :map markdown-mode-map
                     ("C-c C-t g" . markdown-toc-generate-toc)))

(use-package markdown-mode :ensure t
  :mode ("\\.md" . markdown-mode)
  :config
  (add-hook 'markdown-mode-hook 'auto-fill-mode)
  (add-hook 'markdown-mode-hook 'livedown-preview)
  (bind-keys* ("M-<left>" . backward-word)
              ("<M-S-left>" . backward-word)
              ("M-<right>" . forward-word)
              ("<M-S-right>" . forward-word)))

(use-package sudo-edit :ensure t
  :commands (sudo-edit))

(use-package scss-mode :ensure t :mode ("\\.scss" . scss-mode) :config (setq css-indent-offset 2))
(use-package css-mode :ensure t :mode ("\\.css$" . css-mode) :config (setq css-indent-offset 2))

(use-package eval-sexp-fu :ensure t :after emacs-lisp-mode
  :commands (eval-sexp-fu-flash-mode)
  :init (add-hook 'emacs-lisp-mode-hook (lambda () (require 'eval-sexp-fu)))
  :config (eval-sexp-fu-flash-mode))

(use-package lisp-mode
  :mode ("\\.el" . emacs-lisp-mode)
  :init
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
  (add-hook 'emacs-lisp-mode-hook
            '(lambda () (setq-local
                    ac-sources
                    '(ac-source-functions
                      ac-source-variables
                      ac-source-yasnippet
                      ac-source-symbols
                      ac-source-words-in-same-mode-buffers))))
  :config
  (bind-keys :map emacs-lisp-mode-map
             ("C-c n" . nameless-mode)
             ("C-c C-l" . elisp-debug)
             ("M-." . jump-to-find-function)))

(global-set-key (kbd "M-,") 'pop-tag-mark)

(use-package key-combo :ensure t
  :config
  (key-combo-mode 1)
  (key-combo-load-default))

(add-hook 'after-init-hook 'yas-global-mode)
(use-package yasnippet :ensure t
  :config (add-hook 'ruby-mode-hook (lambda () (yas-minor-mode -1)))
  :commands (yas-global-mode yas-minor-mode))

(use-package all-the-icons
  :if window-system
  :load-path "etc/elisp-packages/all-the-icons")

(setq neo-theme (if window-system 'icons 'arrow))
(use-package neotree :ensure t :disabled t
  :config
  (setq neo-show-updir-line nil
        neo-window-width 35
        neo-window-fixed-size nil
        neo-show-hidden-files t
        neo-vc-integration '(face))
  (add-hook 'neotree-mode-hook (lambda () (setq-local line-spacing 5)))
  (add-hook 'neotree-mode-hook (lambda () (setq-local tab-width 1)))

  (defun neotree-projectile ()
    (interactive)
    (let ((cw (get-buffer-window (current-buffer))))
      (neotree-find (or (ignore-errors (projectile-project-root))
                        (and (buffer-file-name) (file-name-nondirectory (buffer-file-name)))
                        (getenv "HOME")))))

  (defun neotree-projectile-find ()
    (interactive)
    (let ((cw (get-buffer-window (current-buffer))))
      (neotree-find)
      (select-window cw)))

  :bind ("H-1" . neotree-projectile)
  ("<f1> <f1>" . neotree-projectile)
  ("H-§" . neotree-projectile-find))

(use-package treemacs-projectile :ensure t
  :commands (treemacs-projectile))
(use-package treemacs
  :ensure t
  :commands (treemacs treemacs-toggle)
  :config
  (setq treemacs-change-root-without-asking t
        treemacs-follow-after-init t
        treemacs-no-png-images t
        treemacs-project-follow-cleanup t
        treemacs-recenter-after-file-follow t
        treemacs-git-integration t
        treemacs-width 40)
  (setq treemacs-icon-open-text (propertize "📂 " 'face 'treemacs-directory-face)
        treemacs-icon-closed-text (propertize "📁 " 'face 'treemacs-directory-face)
        treemacs-icon-tag-leaf-text (propertize "● " 'face 'treemacs-term-node-face)
        treemacs-icon-tag-node-open-text (propertize "💿 " 'face 'treemacs-tags-face)
        treemacs-icon-tag-node-closed-text (propertize "📀 " 'face 'treemacs-tags-face)
        treemacs-icon-text (propertize "📄 " 'face 'treemacs-file-face))

  (define-key treemacs-mode-map [mouse-1] #'treemacs-doubleclick-action)
  (treemacs-tag-follow-mode)
  (treemacs-git-mode 'simple)
  :bind ("<f1> <f1>" . treemacs-select-window)
        ("<s-kp-decimal>" . treemacs-select-window)
        ("<s-S-kp-decimal>" . treemacs-find-file)
        ("<S-f1> <S-f1>" . treemacs-find-file))

(use-package compile :ensure t :defer t
  :config
  (add-to-list 'compilation-error-regexp-alist '("at .*?\\(/.*?\\):\\(.*?\\):\\(.*?\\)$" 1 2 3))
  :bind ("C-x C-c" . compile))

(use-package ansi-color :ensure t
  :after (ansi-term compile)
  :config
  (defun colorize-compilation-buffer ()
    (toggle-read-only)
    (ansi-color-apply-on-region compilation-filter-start (point))
    (toggle-read-only))
  (add-hook 'compilation-filter-hook 'colorize-compilation-buffer))

(use-package shell-pop :ensure t
  :bind ("C-`" . shell-pop)
  :config
  (add-hook 'term-mode-hook '(lambda () (yas-minor-mode -1)))
  (setq shell-pop-autocd-to-working-dir nil
        shell-pop-shell-type '("term" "*terminal*" (lambda () (ansi-term "/bin/bash" "*ansi-terminal*")))
        shell-pop-window-position "bottom"
        shell-pop-window-size 20))

(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator "/")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))

(use-package pug-mode :ensure t :mode ("\\.pug$" . pug-mode))

;; Custom Auto Complete Sources
(use-package company :ensure t :defer 1
  :config
  (global-company-mode)
  (defvar company-mode/enable-yas t "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))


  (setq company-show-numbers t)
  (setq company-backends (--map (company-mode/backend-with-yas it) company-backends))

  :bind (("<kp-decimal>" . company-complete)
         ("<backtab>" . company-complete)
         ("<S-kp-decimal>" . company-yasnippet)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)))

(use-package company-quickhelp :ensure t
  :after company
  :config (company-quickhelp-mode 1)
  (setq pos-tip-background-color (face-background 'company-tooltip))
  (setq pos-tip-foreground-color (face-foreground 'company-tooltip)))


(use-package company-jsimport :load-path "init/company-jsimport.el"
  :after company
  :config (add-to-list 'company-backends (company-mode/backend-with-yas 'company-jsimport-backend)))

(use-package company-emoji :ensure t
  :after company
  :config (add-to-list 'company-backends (company-mode/backend-with-yas 'company-emoji)))

(use-package company-tern :ensure t
  :after company
  :config (add-to-list 'company-backends 'company-tern))

(use-package ac-emoji :ensure t :disabled t :after auto-complete
  :config
  (add-hook 'markdown-mode-hook 'ac-emoji-setup)
  (add-hook 'git-commit-mode-hook 'ac-emoji-setup)
  (add-hook 'git-commit-mode-hook 'auto-complete-mode))

(use-package auto-complete-config :after auto-complete)
(use-package auto-complete :ensure t :disabled t
  :config
  (ac-config-default)
  (setq ac-delay 0.2)
  (set-default 'ac-sources
               '(ac-source-yasnippet
                 ac-source-words-in-same-mode-buffers))
  (global-auto-complete-mode t)

  :bind (("<M-tab>" . auto-complete)
         ("<kp-decimal>" . auto-complete)
         :map ac-completing-map
         ("\e" . ac-stop)
         :map ac-complete-mode-map
         ([tab] . ac-expand-common)
         ([return] . ac-complete)
         ("C-j" . ac-complete)
         ("C-s" . ac-isearch)
         ("C-n" . ac-next)
         ("C-p" . ac-previous)))

(add-hook 'LaTeX-mode-hook '(lambda () (local-set-key (kbd "C-x c") 'xelatex-make)))
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

(use-package magit :ensure t
  :mode ("\/COMMIT_EDITMSG$" . text-mode)
  :bind (("H-6" . magit-status)
         ("<f6>" . magit-status)
         :map magit-mode-map
         ("o" . magit-open-file-other-window)
         ("C-c ." . magit-whitespace-cleanup)
         ("C-c C-." . magit-whitespace-cleanup)
         ("C-c e" . magit-vc-ediff)))

(use-package restart-emacs :ensure t :bind ("s-q" . restart-emacs))

(use-package powerline
  :if window-system
  :config (setq-default powerline-default-separator 'nil))

(use-package elixir-mode :ensure t
  :mode "\\.exs?"
  :config
  (require 'smartparens-elixir)
  (add-hook 'elixir-mode-hook 'smartparens-mode)
  (add-hook 'elixir-mode-hook
            (lambda () (add-hook 'before-save-hook 'elixir-format nil t))))

(use-package alchemist :ensure t
  :after elixir-mode
  :config (setq alchemist-key-command-prefix (kbd "C-c ."))
  (defun alchemist-eval-thing-at-point ()
    (interactive)
    (if (region-active-p) (call-interactively 'alchemist-eval-region) (alchemist-eval-current-line)))
  :bind (:map elixir-mode-map
              ("<s-return>" . alchemist-eval-thing-at-point)
              ("<s-S-return>" . alchemist-eval-buffer)))

(use-package atom-tabs :load-path "etc/elisp-packages/atom-tabs"
  :config (global-atom-tabs-mode)
  :bind (:map atom-tabs-mode-map
              ("<s-S-right>" . atom-tabs-forward-tab)
              ("<s-S-left>" . atom-tabs-backward-tab)
              ("s-w" . kill-current-buffer)
              ("s-!" . atom-tabs-select-tab-1)
              ("s-@" . atom-tabs-select-tab-2)
              ("s-£" . atom-tabs-select-tab-3)
              ("s-$" . atom-tabs-select-tab-4)
              ("s-%" . atom-tabs-select-tab-5)))

(use-package spaceline :after powerline :ensure t
  :config (setq spaceline-responsive nil))

(use-package spaceline-all-the-icons
  :load-path "etc/elisp-packages/spaceline-all-the-icons"
  :after spaceline
  :config
  (setq spaceline-all-the-icons-icon-set-bookmark 'heart
        spaceline-all-the-icons-icon-set-modified 'toggle
        spaceline-all-the-icons-icon-set-dedicated 'pin
        spaceline-all-the-icons-separator-type 'none
        spaceline-all-the-icons-icon-set-flycheck-slim 'dots
        spaceline-all-the-icons-flycheck-alternate t
        spaceline-all-the-icons-icon-set-window-numbering 'circle
        spaceline-all-the-icons-highlight-file-name t
        spaceline-all-the-icons-hide-long-buffer-path t
        spaceline-all-the-icons-separator-type 'none)
  (spaceline-toggle-all-the-icons-bookmark-off)
  (spaceline-toggle-all-the-icons-dedicated-off)
  (spaceline-toggle-all-the-icons-fullscreen-off)
  (spaceline-toggle-all-the-icons-buffer-position-on)
  (spaceline-toggle-all-the-icons-package-updates-off)
  (spaceline-all-the-icons--setup-paradox)
  (spaceline-all-the-icons--setup-neotree)
  (spaceline-all-the-icons-theme))

(use-package winum :ensure t :defer 1
  :init
  (dotimes (n 10)
    (global-set-key (kbd (format "s-%s" n)) (intern (format "winum-select-window-%s" n))))
  :config
  (winum-mode)
  (winum--clear-mode-line))

(use-package resize-window :ensure t :bind ("C-x =" . resize-window))

;; change vc-diff to use vc-ediff
(setq ediff-split-window-function (quote split-window-horizontally))
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(add-hook 'ediff-before-setup-hook 'my-ediff-bsh)
(add-hook 'ediff-after-setup-windows-hook 'my-ediff-ash 'append)
(add-hook 'ediff-quit-hook 'my-ediff-qh)
(add-hook 'ediff-startup-hook 'ediff-swap-buffers)

;; !!! - Comment up to this location for updating

;; Startup variables
(setq shift-select-mode t)                  ; Allow for shift selection mode
(setq inhibit-splash-screen t)              ; disable splash screen
(setq make-backup-files nil)                ; don't make backup files
(setq create-lockfiles nil)                 ; don't make lock files
(setq auto-save-default nil)                ; don't autosave
(setq truncate-partial-width-windows t)     ; Turn truncation off on split windows

;; Disable audible and visible bell in favor of flashing the mode line instead
(setq visible-bell nil)
(setq ring-bell-function nil)


;; Set Path
(setenv "PATH" (concat "/usr/texbin:/usr/local/bin:" (getenv "PATH")))
(setq exec-path '("/usr/local/bin" "/usr/bin" "/bin"))

;; Set Mac modifiers keys
(setq mac-function-modifier 'hyper)
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

(delete-selection-mode 1)                   ; Allows for deletion when typing over highlighted text
(fset 'yes-or-no-p 'y-or-n-p)               ; Use y or n instead of yes or no

(blink-cursor-mode 0)
(setq-default cursor-type '(bar . 1))             ; Change cursor to bar
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq frame-title-format nil)
(setq icon-title-format nil)

;; Get rid of stupid menu bar and Tool Bar..
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode 1)

;; Global Mode Stuff
;; (add-hook 'js2-mode-hook 'js2/load-prettify-symbols-alist)
;; (add-hook 'js2-mode-hook 'prettify-symbols-mode)
;; (global-prettify-symbols-mode)
(use-package prettify-symbols-mode
  :bind ("C-c <C-return>" . prettify-symbols-mode)
  :config
  (setq prettify-symbols-unprettify-at-point t))

(when (fboundp 'mac-auto-operator-composition-mode)
  (mac-auto-operator-composition-mode))

(use-package mode-web :load-path "init" :defer 1)
(use-package mode-javascript :load-path "init" :defer 1)
(use-package mode-linting :load-path "init" :defer 1)
(use-package mode-clojure :load-path "init" :defer 1)

;; Custom major modes
(add-to-list 'auto-mode-alist '("\\.te?xt$" . text-mode))

;; Auto correcting abbreve mode
(define-abbrev-table 'global-abbrev-table
  '(
    ("reuslt" "result" nil 0)
    ("reulst" "result" nil 0)
    ("remidner" "reminder" nil 0)
    ("suggestsions" "suggestions" nil 0)
    ("lenfgth" "length" nil 0)
    ("lengfth" "length" nil 0)
    ("hten" "then" nil 0)
    ("Promsie" "Promise" nil 0)
    ("requier" "require" nil 0)
    ("entires" "entries" nil 0)
    ("entiers" "entries" nil 0)
    ("emtires" "entries" nil 0)
    ("stirng" "string" nil 0)
    ("fitler" "filter" nil 0)
    ("reuqire" "require" nil 0)
    ("reuiqre" "require" nil 0)
    ))
(add-hook 'prog-mode-hook 'abbrev-mode)

;;------------------
;; Themes
;;------------------
(use-package keys :load-path "init")
(load-file (expand-file-name "init/advice.elc" user-emacs-directory))

;; Themed with Spaceline
(use-package atom-one-dark-theme :ensure t :defer t :disabled t)
(use-package dracula-theme :ensure t :defer t :disabled t)
(use-package darktooth-theme :ensure t :defer t :disabled t)
(use-package nord-theme :ensure t :defer t :disabled t)
(use-package doom-themes :ensure :defer t :disabled t
  :config
  (setq
   doom-one-light-brighter-modeline t
   doom-spacegrey-brighter-modeline t)
  (doom-themes-neotree-config)
  (doom-themes-org-config)
  (doom-themes-visual-bell-config))

(use-package tao-theme :ensure t :defer t :disabled t)
(use-package twilight-bright-theme :ensure t :defer t :disabled t)
(use-package creamsody-theme :ensure t :defer t :disabled t
  :config
  (custom-theme-set-faces 'creamsody
   '(term-color-black ((t :foreground "#232533")))
   '(term-color-blue ((t :foreground "#61AFEF")))
   '(term-color-cyan ((t :foreground "#86edec")))
   '(term-color-green ((t (:foreground "#38fab4"))))
   '(term-color-magenta ((t :foreground "#9c71a5")))
   '(term-color-red ((t :foreground "#f59ea3")))
   '(term-color-white ((t :foreground "#e5e5e5")))
   '(term-color-yellow ((t (:foreground "#f2ef9c"))))))

(use-package aquafresh-theme :load-path "init/aquafresh-theme.el"
  :config
  (setq spaceline-all-the-icons-separator-type 'none)
  (setq powerline-text-scale-factor 1.1))

(setq sql-connection-alist
      '((profile-production
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "crm-profile-production.cv7dcdtnxmsa.eu-west-1.rds.amazonaws.com")
         (sql-user "crm")

         (sql-database "crm_profile_production"))
        (profile-staging
         (sql-product 'postgres)
         (sql-port 5432)
         (sql-server "crm-profile-staging.cv7dcdtnxmsa.eu-west-1.rds.amazonaws.com")
         (sql-database "crm_profile_staging"))))


(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(remove-hook 'first-change-hook 'ns-unselect-line)

(when window-system
  (remove-mode-line-box)
  (load-theme 'aquafresh-morning)
  (spaceline-update-faces))

(benchmark-init/show-durations-tree)
;; Local Variables:
;; indent-tabs-mode: nil
;; eval: (flycheck-mode 0)
;; End:

(provide 'init)
;;; init.el ends here
