
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(require 'evil)
(evil-mode t)

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; Assuming you wish to install "iedit" and "magit"
(ensure-package-installed 'iedit
                          'evil-mark-replace
                          'magit
                          'evil-exchange
                          'evil-args
                          'evil
                          'projectile
                          'helm
                          'evil-tabs
                          'projectile
                          'iedit
                          'evil-visual-mark-mode
                          'zenburn-theme
                          'yaml-mode
                          'visual-regexp
                          ;;; 'typopunct
                          'textmate
                          'tango-2-theme
                          'solarized-theme
                          'smex
                          'smartparens
                          'redo+
                          'powerline
                          'polymode
                          'pandoc-mode
                          'evil-surround
                          'pallet
                          'org-ac
                          'multiple-cursors
                          'monokai-theme
                          'maxframe
                          'markdown-mode
                          'magit
                          'latex-pretty-symbols
                          'jedi
                          ;;; 'ipython
                          'inf-ruby
                          'idle-highlight-mode
                          'hl-line+
                          'expand-region
                          'exec-path-from-shell
                          'evil-numbers
                          'evil-nerd-commenter
                          'evil-matchit
                          'evil-leader
                          'evil-indent-textobject
                          'evil-escape
                          'evil-easymotion
                          'browse-kill-ring
                          'anti-zenburn-theme
                          'ag
                          'ace-jump-mode
                          'ac-ispell
                          'gruvbox-theme
                          'ac-etags
                          'ac-emmet
                          'flycheck
                          'helm-projectile
                          'multi-term
                          'dtrt-indent
                          'relative-line-numbers)

;; Essential settings.
(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(show-paren-mode 1)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode nil)
(setq-default left-fringe-width nil)
(setq-default indent-tabs-mode nil)
(eval-after-load "vc" '(setq vc-handled-backends nil))
(setq vc-follow-symlinks t)
(setq large-file-warning-threshold nil)
(setq split-width-threshold nil)

(global-linum-mode t)

(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

(global-evil-tabs-mode t)
(define-key evil-insert-state-map (kbd "C-0") (lambda() (interactive) (elscreen-goto 0)))
(define-key evil-insert-state-map (kbd "C- ") (lambda() (interactive) (elscreen-goto 0)))
(define-key evil-insert-state-map (kbd "C-1") (lambda() (interactive) (elscreen-goto 1)))
(define-key evil-insert-state-map (kbd "C-2") (lambda() (interactive) (elscreen-goto 2)))
(define-key evil-insert-state-map (kbd "C-3") (lambda() (interactive) (elscreen-goto 3)))
(define-key evil-insert-state-map (kbd "C-4") (lambda() (interactive) (elscreen-goto 4)))
(define-key evil-insert-state-map (kbd "C-5") (lambda() (interactive) (elscreen-goto 5)))
(define-key evil-insert-state-map (kbd "C-6") (lambda() (interactive) (elscreen-goto 6)))
(define-key evil-insert-state-map (kbd "C-7") (lambda() (interactive) (elscreen-goto 7)))
(define-key evil-insert-state-map (kbd "C-8") (lambda() (interactive) (elscreen-goto 8)))
(define-key evil-insert-state-map (kbd "C-9") (lambda() (interactive) (elscreen-goto 9)))

(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)

(setq scroll-margin 5
scroll-conservatively 9999
scroll-step 1)

(require 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

 ;; start maximized


(define-key evil-normal-state-map (kbd "C-k") (lambda ()
                    (interactive)
                    (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
                        (interactive)
                        (evil-scroll-down nil)))

;;; Gets indent style from file
(dtrt-indent-mode 1)

(define-key global-map (kbd "RET") 'newline-and-indent)

(show-paren-mode t)

(setq evil-move-cursor-back nil)

(evil-leader/set-key "V" 'exchange-point-and-mark)

(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

(defmacro after (feature &rest body)
  "After FEATURE is loaded, evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,feature
     '(progn ,@body)))


(visual-line-mode 1)


;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(after 'flycheck
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq flycheck-checkers (delq 'emacs-lisp-checkdoc flycheck-checkers))
  (setq flycheck-checkers (delq 'html-tidy flycheck-checkers))
  (setq flycheck-standard-error-navigation nil))

(global-flycheck-mode t)

;; flycheck errors on a tooltip (doesnt work on console)
;; (when (display-graphic-p (selected-frame))
;;   (eval-after-load 'flycheck
;;     '(custom-set-variables
;;       '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)
(require 'helm-locate)
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)

(after 'projectile
  (require 'helm-projectile))
(global-set-key (kbd "M-x") 'helm-M-x)

(defun helm-my-buffers ()
  (interactive)
  (let ((helm-ff-transformer-show-only-basename nil))
  (helm-other-buffer '(helm-c-source-buffers-list
                       helm-c-source-elscreen
                       helm-c-source-projectile-files-list
                       helm-c-source-ctags
                       helm-c-source-recentf
                       helm-c-source-locate)
                     "*helm-my-buffers*")))

(toggle-frame-maximized)

(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

(setq evil-move-cursor-back nil)

(define-key evil-normal-state-map (kbd "C-k") (lambda ()
                    (interactive)
                    (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
                        (interactive)
                        (evil-scroll-down nil)))

(add-hook 'after-init-hook #'global-flycheck-mode)


(setq scroll-margin 5
scroll-conservatively 1
scroll-step 1)

(unless window-system
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] '(lambda ()
                               (interactive)
                               (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                               (interactive)
                               (scroll-up 1))))

(setq x-select-enable-clipboard nil)

(evilnc-default-hotkeys)

(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

(setq ns-pop-up-frames nil)

(defadvice handle-delete-frame (around my-handle-delete-frame-advice activate)
  "Hide Emacs instead of closing the last frame"
  (let ((frame   (posn-window (event-start event)))
        (numfrs  (length (frame-list))))
    (if (> numfrs 1)
      ad-do-it
      (do-applescript "tell application \"System Events\" to tell process \"Emacs\" to set visible to false"))))

(when (require 'multi-term nil t)
  (global-set-key (kbd "<f5>") 'multi-term)
  (global-set-key (kbd "<C-next>") 'multi-term-next)
  (global-set-key (kbd "<C-prior>") 'multi-term-prev)
  (setq multi-term-buffer-name "term"
        multi-term-program "/bin/zsh"))


(server-start)

(load-theme 'solarized t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; (setq visible-bell 'top-bottom)


 (defun my-terminal-visible-bell ()
   "A friendlier visual bell effect."
   (invert-face 'mode-line)
   (run-with-timer 0.1 nil 'invert-face 'mode-line))

 (setq visible-bell nil
       ring-bell-function 'my-terminal-visible-bell)

(defun my-configure-visible-bell ()
   "Use a nicer visual bell in terminals."
     (setq visible-bell nil
           ring-bell-function 'my-terminal-visible-bell))

 (defun my-frame-config (frame)
   "Custom behaviours for new frames."
   (with-selected-frame frame
     (my-configure-visible-bell)))
 ;; Run now, for non-daemon Emacs...
 (my-frame-config (selected-frame))
 ;; ...and later, for new frames / emacsclient
 (add-hook 'after-make-frame-functions 'my-frame-config)
 ;; ...and whenever a frame gains input focus.
 (add-hook 'focus-in-hook 'my-configure-visible-bell)

 (defun flycheck-python-setup ()
  (flycheck-mode))
(add-hook 'python-mode-hook #'flycheck-python-setup)

(add-hook 'prog-mode-hook 'relative-line-numbers-mode t)
(add-hook 'prog-mode-hook 'line-number-mode t)
(add-hook 'prog-mode-hook 'column-number-mode t)

(require 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;;; Next visual line
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

(add-hook 'term-mode-hook
          (lambda ()
            (setq term-buffer-maximum-size 10000)))


(add-hook 'term-mode-hook
          (lambda ()
            (add-to-list 'term-bind-key-alist '("M-[" . multi-term-prev))
            (add-to-list 'term-bind-key-alist '("M-]" . multi-term-next))))

(add-hook 'term-mode-hook
          (lambda ()
            (define-key term-raw-map (kbd "C-y") 'term-paste)))


(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'evil-numbers)
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)

(evilnc-default-hotkeys)

;; Vim key bindings
(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
  "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "\\" 'evilnc-comment-operator ; if you prefer backslash key
)

(require 'evil-mark-replace)

(require 'evil-matchit)
(global-evil-matchit-mode 1)

(require 'evil-exchange)
;; change default key bindings (if you want) HERE
;; (setq evil-exchange-key (kbd "zx"))
(evil-exchange-install)

;; change default key bindings (if you want) HERE
;; (setq evil-extra-operator-eval-key (kbd "ge"))
;; (require 'evil-extra-operator)
;; (global-evil-extra-operator-mode 1)

;; locate and load the package
(add-to-list 'load-path "path/to/evil-args")
(require 'evil-args)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)

; Overload shifts so that they don't lose the selection
(define-key evil-visual-state-map (kbd ">") 'djoyner/evil-shift-right-visual)
(define-key evil-visual-state-map (kbd "<") 'djoyner/evil-shift-left-visual)
(define-key evil-visual-state-map [tab] 'djoyner/evil-shift-right-visual)
(define-key evil-visual-state-map [S-tab] 'djoyner/evil-shift-left-visual)

(defun djoyner/evil-shift-left-visual ()
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun djoyner/evil-shift-right-visual ()
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))



; Easy window navigation
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)


; Y behaves as you'd expect
(define-key evil-normal-state-map "Y" 'djoyner/copy-to-end-of-line)


; Move RET and SPC kley bindings from the motion state map to the normal state map
; so that when modes define them, RET and SPC bindings are available directly
;(move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
;(move-key evil-motion-state-map evil-normal-state-map " ")

;; Visual state mappings

; DEL deletes selection
(define-key evil-visual-state-map (kbd "DEL") 'evil-delete)


;; Leaders
(evil-leader/set-key
  "SPC" 'just-one-space
  "DEL" 'delete-trailing-whitespace
  "TAB" 'untabify
  "S-TAB" 'tabify
  "\\" 'evil-ex-nohighlight
  "b" 'iswitchb-buffer
  "B" 'list-buffers
  "e" 'djoyner/evil-edit
  "E" 'eval-last-sexp
  "i" 'whitespace-mode
  "k" 'evil-delete-buffer
  "n" 'make-frame-command
  "P" 'djoyner/evil-paste-clipboard-before
  "p" 'djoyner/evil-paste-clipboard-after
  "r" 'evil-read
  "R" 'rename-file-and-buffer
  "s" 'djoyner/evil-edit-split
  "t" 'djoyner/evil-set-tab-width
  "v" 'djoyner/evil-edit-vsplit
  "x" 'execute-extended-command
  "y" "\"*y")



;; Other mode mappings

; Override j/k mappings for ibuffer mode
(eval-after-load 'ibuffer
    '(progn
       ;; use the standard ibuffer bindings as a base
       (message "Setting up ibuffer mappings")
       (set-keymap-parent
        (evil-get-auxiliary-keymap ibuffer-mode-map 'normal t)
        (assq-delete-all 'menu-bar (copy-keymap ibuffer-mode-map)))
       (evil-define-key 'normal ibuffer-mode-map "j" 'ibuffer-forward-line)
       (evil-define-key 'normal ibuffer-mode-map "k" 'ibuffer-backward-line)
       (evil-define-key 'normal ibuffer-mode-map "J" 'ibuffer-jump-to-buffer) ; "j"
       ))


;; Functions
(defun djoyner/evil-paste-clipboard-before ()
(interactive)
(evil-paste-before 1 ?*))

(defun djoyner/evil-paste-clipboard-after ()
  (interactive)
  (evil-paste-after 1 ?*))

(defun djoyner/evil-shift-left-visual ()
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun djoyner/evil-shift-right-visual ()
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(defun djoyner/evil-edit (file)
  (interactive "F:edit ")
  (find-file file))

(defun djoyner/evil-edit-split (file)
  (interactive "F:split ")
  (let ((new-win (split-window (selected-window))))
    (find-file file)))

(defun djoyner/evil-edit-vsplit (file)
  (interactive "F:vsplit ")
  (let ((new-win (split-window (selected-window) nil t)))
    (find-file file)))

(defun djoyner/evil-set-tab-width (value)
  (interactive "ntab-width: ")
  (set-variable 'tab-width value))

(define-key evil-normal-state-map "vv" 'split-window-horizontally)
(define-key evil-normal-state-map "ss" 'split-window-vertically)
