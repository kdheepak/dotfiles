;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; brew install emacs --HEAD --use-git-head --cocoa --with-gnutls --with-rsvg --with-imagemagick
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
                          'python-mode
                          'elisp-slime-nav
                          'evil-visualstar
                          'key-chord
                          'helm
                          'neotree
                          'auctex
                          'matlab-mode
                          ;;; 'nxhtml
                          'pydoc-info
                          'scss-mode
                          ;;; 'popup
                          'nyan-mode
                          'helm-descbinds
                          'js2-mode
                          'yasnippet
                          'evil-tabs
                          'flyspell
                          'autopair
                          'minibuffer-complete-cycle
                          'projectile
                          'iedit
                          'evil-commentary
                          'evil-visual-mark-mode
                          'zenburn-theme
                          'auto-complete
                          'yaml-mode
                          'visual-regexp
                          ;;; 'typopunct
                          'textmate
                          'tango-2-theme
                          'solarized-theme
                          'smex
                          'smartparens
                          'redo+
                          'powerline-evil
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
                          'simpleclip
                          'multi-term
                          'dtrt-indent
                          'relative-line-numbers)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "55ed02951e7b458e4cd18837eefa1956884c9afd22bb514f697fd1d2d1abb3d3" "b06aaf5cefc4043ba018ca497a9414141341cb5a2152db84a9a80020d35644d1" "d9046dcd38624dbe0eb84605e77d165e24fdfca3a40c3b13f504728bab0bf99d" "52706f54fd3e769a0895d1786796450081b994378901d9c3fb032d3094788337" "c45539367c7526f69c6d8fa91060ab3b9f0b281762ad18a0ff696b9d70b7f945" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (request-deferred websocket ein elpy helm-fuzzy-find zenburn-theme yaml-mode visual-regexp textmate tango-2-theme solarized-theme smex smartparens simpleclip relative-line-numbers redo+ python-mode powerline-evil polymode pdf-tools pandoc-mode pallet org-ac neotree multiple-cursors multi-term monokai-theme mmm-mode minibuffer-complete-cycle maxframe markdown-mode+ magit light-soap-theme latex-pretty-symbols key-chord jedi inf-ruby iedit idle-highlight-mode icicles hl-line+ helm-projectile gruvbox-theme flycheck expand-region exec-path-from-shell evil-visual-mark-mode evil-tabs evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-matchit evil-mark-replace evil-leader evil-indent-textobject evil-exchange evil-escape evil-easymotion evil-args elisp-slime-nav dtrt-indent browse-kill-ring autopair auctex anti-zenburn-theme ag ace-jump-mode ac-ispell ac-etags ac-emmet))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

;;; Load theme
(load-theme 'light-soap t)

;;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

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
;;; (setq split-width-threshold nil)


;;; selection is not copied into clipboard
(defun x-select-text (text))
(setq x-select-enable-clipboard nil)
(setq x-select-enable-primary nil)
(setq mouse-drag-copy-region nil)

;;; Saves clipboard into "0 or  "+ register
(setq save-interprogram-paste-before-kill t)

;;; Saves clipboard in "+ register from external applications. Accessed by cmd V
(require 'simpleclip)
(simpleclip-mode 1)

(global-linum-mode t)

(require 'evil-leader)
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")

;;; (global-evil-tabs-mode t)
;;; (define-key evil-insert-state-map (kbd "C-0") (lambda() (interactive) (elscreen-goto 0)))
;;; (define-key evil-insert-state-map (kbd "C- ") (lambda() (interactive) (elscreen-goto 0)))
;;; (define-key evil-insert-state-map (kbd "C-1") (lambda() (interactive) (elscreen-goto 1)))
;;; (define-key evil-insert-state-map (kbd "C-2") (lambda() (interactive) (elscreen-goto 2)))
;;; (define-key evil-insert-state-map (kbd "C-3") (lambda() (interactive) (elscreen-goto 3)))
;;; (define-key evil-insert-state-map (kbd "C-4") (lambda() (interactive) (elscreen-goto 4)))
;;; (define-key evil-insert-state-map (kbd "C-5") (lambda() (interactive) (elscreen-goto 5)))
;;; (define-key evil-insert-state-map (kbd "C-6") (lambda() (interactive) (elscreen-goto 6)))
;;; (define-key evil-insert-state-map (kbd "C-7") (lambda() (interactive) (elscreen-goto 7)))
;;; (define-key evil-insert-state-map (kbd "C-8") (lambda() (interactive) (elscreen-goto 8)))
;;; (define-key evil-insert-state-map (kbd "C-9") (lambda() (interactive) (elscreen-goto 9)))

(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)


(setq scroll-margin 5
scroll-conservatively 9999
scroll-step 1)

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


;;; Scrolling

(define-key evil-normal-state-map (kbd "C-k") (lambda ()
                    (interactive)
                    (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
                        (interactive)
                        (evil-scroll-down nil)))


 
;;; Gets indent style from file
(dtrt-indent-mode 1)
 
; Auto-indent with the Return key
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


(toggle-frame-maximized)

(save-place-mode)
(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package

(add-hook 'find-file-hooks 'save-place-find-file-hook t)
(add-hook 'kill-emacs-hook 'save-place-kill-emacs-hook)
(add-hook 'kill-buffer-hook 'save-place-to-alist)

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

(evilnc-default-hotkeys)

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

;;; (add-hook 'prog-mode-hook 'relative-line-numbers-mode t)
(add-hook 'prog-mode-hook 'line-number-mode t)
(add-hook 'prog-mode-hook 'column-number-mode t)


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
  ;; "SPC" 'just-one-space
  "DEL" 'delete-trailing-whitespace
  "TAB" 'untabify
  "S-TAB" 'tabify
  ;; "\\" 'evil-ex-nohighlight
  "b" 'helm-mini
  "B" 'xah-next-user-buffer
  "e" 'helm-find-files
  "E" 'eval-last-sexp
  "i" 'whitespace-mode
  "k" 'evil-delete-buffer
  "n" 'make-frame-command
  "r" 'evil-read
  "R" 'rename-file-and-buffer
  "h" 'dkrishna/evil-edit-hsplit
  "v" 'dkrishna/evil-edit-vsplit
  "_" 'djoyner/evil-edit-hsplit
  "|" 'djoyner/evil-edit-vsplit
  "t" 'djoyner/evil-set-tab-width
  "x" 'execute-extended-command
  "," 'modi/switch-to-scratch-and-back
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

(defun djoyner/evil-edit-hsplit (file)
  (interactive "F:hsplit ")
  (let ((new-win (split-window (selected-window))))
    (find-file file))
  (balance-windows))

(defun djoyner/evil-edit-vsplit (file)
  (interactive "F:vsplit ")
  (let ((new-win (split-window (selected-window))))
    (find-file file))
  (balance-windows))

(defun dkrishna/evil-edit-hsplit ()
  (interactive)
  (split-window-vertically) (balance-windows))

(defun dkrishna/evil-edit-vsplit ()
  (interactive)
  (split-window-horizontally) (balance-windows))

(defun djoyner/evil-set-tab-width (value)
  (interactive "ntab-width: ")
  (set-variable 'tab-width value))

;;; ;; recenter after search
;;; (defadvice
;;;   isearch-forward
;;;   (after isearch-forward-recenter activate)
;;;   (recenter))
;;; (ad-activate 'isearch-forward)
;;;
;;; (defadvice
;;;   isearch-repeat-forward
;;;   (after isearch-repeat-forward-recenter activate)
;;;   (recenter))
;;; (ad-activate 'isearch-repeat-forward)
;;;
;;; (defadvice
;;;   isearch-repeat-backward
;;;   (after isearch-repeat-backward-recenter activate)
;;;   (recenter))
;;; (ad-activate 'isearch-repeat-backward)



;; c+ c- to increase/decrease number like Vim's C-a C-x
(define-key evil-normal-state-map (kbd "C-+") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C--") 'evil-numbers/dec-at-pt)


;;; (define-key evil-normal-state-map ",h" (lambda () (interactive) (split-window-vertically) (balance-windows)))
;;; (define-key evil-normal-state-map ",v" (lambda () (interactive) (split-window-horizontally) (balance-windows)))

;;; autocomplete
(ac-config-default)


(require 'minibuffer-complete-cycle)
(setq minibuffer-complete-cycle t)

(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

(setq tab-width 2
            indent-tabs-mode nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'autopair)

(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")


;;; (setq backup-directory-alist
      ;;; `((".*" . ,temporary-file-directory)))
;;; (setq auto-save-file-name-transforms
                ;;; `((".*" ,temporary-file-directory t)))

(require 'neotree)
 (global-set-key [f8] 'neotree-toggle)

(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;; Prevent quit command from exit Emacs
(defun my-nokill-current-switch-scratch-buffer ()
  :repeat nil
  (interactive)
    (condition-case nil
        (if (equal "*scratch*" (buffer-name))
          (progn
            (condition-case nil
            (delete-window)
                (error nil
               ))
            (my-server-exit-hook)
            (delete-frame)
            (message "On scratch")
            )
          (progn
            (kill-buffer (current-buffer))
            (message "Killed buffer")
            (condition-case nil
            (delete-window)
                (error nil
                       ))
            )
        )))

(defun my-save-nokill-current-switch-scratch-buffer ()
  :repeat nil
  (interactive) ;;;
    (condition-case nil
        (if (equal "*scratch*" (buffer-name))
          (progn
            (condition-case nil
            (delete-window)
                (error nil
               ))
            (message "On scratch")
            )
          (progn
            (save-buffer)
            (kill-buffer (current-buffer))
            (message "Saved and killed buffer")
            (condition-case nil
            (delete-window)
                (error nil
                       ))
            )
        )))

;;; custom save and quit commands

(evil-ex-define-cmd "q[uit]" 'my-nokill-current-switch-scratch-buffer)
(evil-ex-define-cmd "Q[uit]" 'my-nokill-current-switch-scratch-buffer)

; dont care shift key
(evil-ex-define-cmd "W" 'save-buffer)
(evil-ex-define-cmd "w" 'save-buffer)
(evil-ex-define-cmd "Wq" 'my-save-nokill-current-switch-scratch-buffer)
(evil-ex-define-cmd "WQ" 'my-save-nokill-current-switch-scratch-buffer)
(evil-ex-define-cmd "wq" 'my-save-nokill-current-switch-scratch-buffer)

;;; (evil-ex-define-cmd "e" 'dkrishna/evil-edit)
;;; (pdf-tools-install)
(define-key evil-ex-map "e" 'helm-find-files)
(define-key evil-ex-map "E" 'helm-find-files)

(defun modi/switch-to-scratch-and-back (arg)
  "Toggle between *scratch-MODE* buffer and the current buffer.
If a scratch buffer does not exist, create it with the major mode set to that
of the buffer from where this function is called.
    C-u COMMAND -> Open/switch to a scratch buffer in `org-mode'
C-u C-u COMMAND -> Open/switch to a scratch buffer in `emacs-elisp-mode'"
  (interactive "P")
  (if (and (null arg)
           (string-match-p "\\*scratch" (buffer-name)))
      (switch-to-buffer (other-buffer))
    (let (mode-str)
      (cl-case (car arg)
        (4  (setq mode-str "org-mode"))
        (16 (setq mode-str "emacs-lisp-mode"))
        (t  (setq mode-str (format "%s" major-mode))))
      (switch-to-buffer (get-buffer-create
                         (concat "*scratch-" mode-str "*")))        
      (funcall (intern mode-str))))) ; http://stackoverflow.com/a/7539787/1219634

(setq-default evil-symbol-word-search t)

;;; (defadvice evil-inner-word (around underscore-as-word activate)
  ;;; (let ((table (copy-syntax-table (syntax-table))))
    ;;; (modify-syntax-entry ?_ "w" table)
    ;;; (with-syntax-table table
      ;;; ad-do-it)))

;;;(defmacro define-and-bind-text-object (key start-regex end-regex)
  ;;;(let ((inner-name (make-symbol "inner-name"))
        ;;;(outer-name (make-symbol "outer-name")))
    ;;;`(progn
      ;;;(evil-define-text-object ,inner-name (count &optional beg end type)
        ;;;(evil-regexp-range count beg end type ,start-regex ,end-regex t))
      ;;;(evil-define-text-object ,outer-name (count &optional beg end type)
        ;;;(evil-regexp-range count beg end type ,start-regex ,end-regex nil))
      ;;;(define-key evil-inner-text-objects-map ,key (quote ,inner-name))
      ;;;(define-key evil-outer-text-objects-map ,key (quote ,outer-name)))))
;;;
;;;; between dollar signs:
;;;(define-and-bind-text-object "$" "\\$" "\\$")
;;;
;;;; between pipe characters:
;;;(define-and-bind-text-object "|" "|" "|")
;;;
;;;; between hypen signs:
;;;(define-and-bind-text-object "-" "\\-" "\\-")

(defun xah-next-user-buffer ()
  "Switch to the next user buffer.
 “user buffer” is a buffer whose name does not start with “*”.
If `xah-switch-buffer-ignore-dired' is true, also skip directory buffer.
2015-01-05 URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (or
           (string-equal "*" (substring (buffer-name) 0 1))
           (if (string-equal major-mode "dired-mode")
               xah-switch-buffer-ignore-dired
             nil
             ))
          (progn (next-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-previous-user-buffer ()
  "Switch to the previous user buffer.
 “user buffer” is a buffer whose name does not start with “*”.
If `xah-switch-buffer-ignore-dired' is true, also skip directory buffer.
2015-01-05 URL `http://ergoemacs.org/emacs/elisp_next_prev_user_buffer.html'"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (< i 20)
      (if (or
           (string-equal "*" (substring (buffer-name) 0 1))
           (if (string-equal major-mode "dired-mode")
               xah-switch-buffer-ignore-dired
             nil
             ))
          (progn (previous-buffer)
                 (setq i (1+ i)))
        (progn (setq i 100))))))

(defun xah-next-emacs-buffer ()
  "Switch to the next emacs buffer.
 (buffer name that starts with “*”)"
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (next-buffer))))

(defun xah-previous-emacs-buffer ()
  "Switch to the previous emacs buffer.
 (buffer name that starts with “*”)"
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (not (string-equal "*" (substring (buffer-name) 0 1))) (< i 20))
      (setq i (1+ i)) (previous-buffer))))

;;; (define-key evil-ex-map "b" 'helm-buffers-list)

;;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
;;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
;;; (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
;;; (require 'helm-fuzzy-find)


;; Use Emacs terminfo, not system terminfo
(setq system-uses-terminfo nil)

       ;; foreground color (yellow)


;;; (require 'evil-visualstar)
(global-evil-visualstar-mode)


(setq-default truncate-lines t)

(defun linum-format-func (line)
  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
     (propertize (format (format "%%%dd " w) line) 'face 'linum)))

(setq linum-format 'linum-format-func)
;; use customized linum-format: add a addition space after the line number


;; show the column number in the status bar
(column-number-mode t)


;;==============================================================================
;; Hack "*" to hightlight, but not jump to first match
(defun my-evil-prepare-word-search (forward symbol)
  "Prepare word search, but do not move yet."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     evil-symbol-word-search))
  (let ((string (car-safe regexp-search-ring))
        (move (if forward #'forward-char #'backward-char))
        (end (if forward #'eobp #'bobp)))
    (setq isearch-forward forward)
    (setq string (evil-find-thing forward (if symbol 'symbol 'word)))
    (cond
     ((null string)
      (error "No word under point"))
     (t
      (setq string
            (format (if symbol "\\_<%s\\_>" "\\<%s\\>")
                    (regexp-quote string)))))
    (evil-push-search-history string forward)
    (my-evil-search string forward t)))

(defun my-evil-search (string forward &optional regexp-p start)
  "Highlight STRING matches.
If FORWARD is nil, search backward, otherwise forward.
If REGEXP-P is non-nil, STRING is taken to be a regular expression.
START is the position to search from; if unspecified, it is
one more than the current position."
  (when (and (stringp string)
             (not (string= string "")))
    (let* ((orig (point))
           (start (or start
                      (if forward
                          (min (point-max) (1+ orig))
                        orig)))
           (isearch-regexp regexp-p)
           (isearch-forward forward)
           (case-fold-search
            (unless (and search-upper-case
                         (not (isearch-no-upper-case-p string nil)))
              case-fold-search)))
      ;; no text properties, thank you very much
      (set-text-properties 0 (length string) nil string)
      (setq isearch-string string)
      (isearch-update-ring string regexp-p)
      ;; handle opening and closing of invisible area
      (cond
       ((boundp 'isearch-filter-predicates)
        (dolist (pred isearch-filter-predicates)
          (funcall pred (match-beginning 0) (match-end 0))))
       ((boundp 'isearch-filter-predicate)
        (funcall isearch-filter-predicate (match-beginning 0) (match-end 0))))
      (evil-flash-search-pattern string t))))

(define-key evil-motion-state-map "*" 'my-evil-prepare-word-search)
(define-key evil-motion-state-map (kbd "*") 'my-evil-prepare-word-search)
;; end highlight hack
;;==============================================================================

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

(elpy-enable)

;; ;; Fixing a key binding bug in elpy
;; (define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; ;; Fixing another key binding bug in iedit mode
;; (define-key global-map (kbd "C-c o") 'iedit-mode)

;;   (require 'auto-complete)
;;   (require 'auto-complete-config)

;;   (setq ac-auto-show-menu t)
;;   (setq ac-auto-start t)
;;   (setq ac-comphist-file "~/.ac-comphist.dat")
;;   (setq ac-quick-help-delay 0.3)
;;   (setq ac-quick-help-height 30)
;;   (setq ac-show-menu-immediately-on-auto-complete t)

;;   (dolist (mode '(vimrc-mode html-mode stylus-mode))
;;     (add-to-list 'ac-modes mode))

;;   (ac-config-default)

;;   (after 'linum
;;     (ac-linum-workaround))

;;   (after 'yasnippet
;;     (add-hook 'yas-before-expand-snippet-hook (lambda () (auto-complete-mode -1)))
;;     (add-hook 'yas-after-exit-snippet-hook (lambda () (auto-complete-mode t)))
;;     (defadvice ac-expand (before advice-for-ac-expand activate)
;;       (when (yas-expand)
;;         (ac-stop))))

;;   (require 'ac-etags)
;;   (setq ac-etags-requires 1)
;;   (after 'etags
;;     (ac-etags-setup))

  (defun my-do-not-kill-scratch-buffer ()
  (if (member (buffer-name (current-buffer))
              '("*scratch*" "*Messages*" "*Require Times*"))
      (progn
        (bury-buffer)
        nil)
    t))
(add-hook 'kill-buffer-query-functions 'my-do-not-kill-scratch-buffer)



(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)



(setq sentence-end-double-space nil)
(setq delete-by-moving-to-trash t)
(setq mark-ring-max 64)
(setq global-mark-ring-max 128)
(setq create-lockfiles nil)
(setq echo-keystrokes 0.01)
(setq gc-cons-threshold 10000000)
(setq initial-major-mode 'emacs-lisp-mode)
(setq eval-expression-print-level nil)
(setq-default indent-tabs-mode nil)


(require 'evil-commentary)
(evil-commentary-mode t)


(setq helm-command-prefix-key "C-c h")
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)
(setq helm-M-x-fuzzy-match t)
(setq helm-apropos-fuzzy-match t)
(setq helm-recentf-fuzzy-match t)
(setq helm-locate-fuzzy-match t)
(setq helm-file-cache-fuzzy-match t)
(setq helm-semantic-fuzzy-match t)
(setq helm-imenu-fuzzy-match t)
(setq helm-lisp-fuzzy-completion t)
(setq helm-completion-in-region-fuzzy-match t)
(setq helm-mode-fuzzy-match t)

;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)

(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)
(require 'helm-locate)

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

(defun save-persistent-scratch ()
  "Write the contents of *scratch* to the file name
`persistent-scratch-file-name'."
  (with-current-buffer (get-buffer-create "*scratch*")
    (write-region (point-min) (point-max) "~/.emacs-persistent-scratch")))

(defun load-persistent-scratch ()
  "Load the contents of `persistent-scratch-file-name' into the
  scratch buffer, clearing its contents first."
  (if (file-exists-p "~/.emacs-persistent-scratch")
      (with-current-buffer (get-buffer "*scratch*")
        (delete-region (point-min) (point-max))
        (insert-file-contents "~/.emacs-persistent-scratch"))))

(push #'load-persistent-scratch after-init-hook)
(push #'save-persistent-scratch kill-emacs-hook)

(if (not (boundp 'save-persistent-scratch-timer))
    (setq save-persistent-scratch-timer
          (run-with-idle-timer 300 t 'save-persistent-scratch)))


(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-x b") 'helm-mini)

(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(setq helm-locate-fuzzy-match t)

;;; Powerline theme based on https://github.com/jcf/emacs.d


(require 'powerline)

(defface kd-powerline-emacs
    '((t (:background "#af74e6" :foreground "#080808" :inherit mode-line)))
    "Colour applied to Emacs mode indicator."
    :group 'powerline)

(defface kd-powerline-insert
    '((t (:background "#66d9ef" :foreground "#080808" :inherit mode-line)))
    "Colour applied to insert mode indicator."
    :group 'powerline)

(defface kd-powerline-motion
    '((t (:background "#465457" :foreground "#1b1d1e" :inherit mode-line)))
    "Colour applied to motion mode indicator."
    :group 'powerline)

(defface kd-powerline-normal
    '((t (:background "green" :foreground "#080808" :inherit mode-line)))
    ;;; '((t (:background "#e6db74" :foreground "#080808" :inherit mode-line)))
    "Colour applied to normal mode indicator."
    :group 'powerline)

(defface kd-powerline-visual
    '((t (:background "#fd971f" :foreground "#080808" :inherit mode-line)))
    "Colour applied to visual mode indicator."
    :group 'powerline)

(defun kd-propertized-evil-mode-tag ()
    (let* ((x (cond ((evil-emacs-state-p)  '(" EMACS  " kd-powerline-emacs))
                    ((evil-insert-state-p) '(" INSERT " kd-powerline-insert))
                    ((evil-motion-state-p) '(" MOTION " kd-powerline-motion))
                    ((evil-normal-state-p) '(" NORMAL " kd-powerline-normal))
                    ((evil-visual-state-p) '(" VISUAL " kd-powerline-visual))
                    (t                     '("  ^.^ V " kd-powerline-emacs))))
            (text (or (first x) ""))
            (face (second x)))

    (list
        (powerline-raw text face face)
        (powerline-arrow-left face nil))))

;; (defface powerline-active1 '((t (:foreground "#d0d0f0" :background "purple" :inherit mode-line)))
;;   "Powerline face 1."
;;   :group 'powerline)

;; (defface powerline-active2 '((t (:foreground "#63b132" :weight bold :background "black" :inherit mode-line)))
;;   "Powerline face 2."
;;   :group 'powerline)

;; (defface powerline-active0 '((t (:foreground "deep pink" :weight bold :background "black" :inherit mode-line)))
;;   "Powerline face 0."
;;   :group 'powerline)

;; (defface powerline-inactive0
;;   '((t (:background "black" :weight bold :inherit mode-line-inactive)))
;;   "Powerline face 0."
;;   :group 'powerline)


(defun kd-powerline-theme ()
    (interactive)
    (setq-default
    mode-line-format
    '("%e"
        (:eval
        (let* ((active (powerline-selected-window-active))
                (kd-mode-line (if active 'mode-line 'mode-line-inactive))
                (face1 (if active 'powerline-active1 'powerline-inactive1))
                (face2 (if active 'powerline-active2 'powerline-inactive2))
                (separator-left (intern (format "powerline-%s-%s"
                                                powerline-default-separator
                                                (car powerline-default-separator-dir))))
                (separator-right (intern (format "powerline-%s-%s"
                                                powerline-default-separator
                                                (cdr powerline-default-separator-dir))))

                (lhs (append
                    (kd-propertized-evil-mode-tag)
                    (list (powerline-raw "%*" nil 'l)
                            (powerline-buffer-size nil 'l)
                            (powerline-raw mode-line-mule-info nil 'l)
                            (powerline-buffer-id nil 'l)
                            (when (and (boundp 'which-func-mode) which-func-mode)
                            (powerline-raw which-func-format nil 'l))
                            (powerline-raw " ")
                            (funcall separator-left kd-mode-line face1)
                            (when (boundp 'erc-modified-channels-object)
                            (powerline-raw erc-modified-channels-object face1 'l))
                            (powerline-major-mode face1 'l)
                            (powerline-process face1)
                            (powerline-minor-modes face1 'l)
                            (powerline-narrow face1 'l)
                            (powerline-raw " " face1)
                            (funcall separator-left face1 face2)
                            (powerline-vc face2 'r))))
                (rhs (list (powerline-raw global-mode-string face2 'r)
                        (funcall separator-right face2 face1)
                        (powerline-raw "%4l" face1 'l)
                        (powerline-raw ":" face1 'l)
                        (powerline-raw "%3c" face1 'r)
                        (funcall separator-right face1 kd-mode-line)
                        (powerline-raw " ")
                        (powerline-raw "%6p" nil 'r)
                        (powerline-hud face2 face1))))
        (concat (powerline-render lhs)
                (powerline-fill face2 (powerline-width rhs))
                (powerline-render rhs)))))))


(kd-powerline-theme)


(setq mac-command-modifier 'super)
(global-set-key (kbd "s-<left>") 'move-beginning-of-line)
(global-set-key (kbd "s-<right>") 'move-end-of-line)
(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
(global-set-key (kbd "s-<down>") 'end-of-buffer)


(require 'magit)

;-------------------;
;;; Auto-Complete ;;;
;-------------------;

(setq ac-directory "~/.emacs.d/auto-complete")
(add-to-list 'load-path ac-directory)
(require 'auto-complete) 

(require 'auto-complete-config) 
(ac-config-default)
(global-auto-complete-mode 1)
(setq-default ac-sources '(ac-source-yasnippet
                           ac-source-abbrev
                           ac-source-dictionary
                           ac-source-words-in-same-mode-buffers))

; hack to fix ac-sources after pycomplete.el breaks it
(add-hook 'python-mode-hook
          '(lambda ()
             (setq ac-sources '(ac-source-pycomplete
                                ac-source-yasnippet
                                ac-source-abbrev
                                ac-source-dictionary
                                ac-source-words-in-same-mode-buffers))))

;; from http://truongtx.me/2013/01/06/config-yasnippet-and-autocomplete-on-emacs/
; set the trigger key so that it can work together with yasnippet on
; tab key, if the word exists in yasnippet, pressing tab will cause
; yasnippet to activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;; from http://blog.deadpansincerity.com/2011/05/setting-up-emacs-as-a-javascript-editing-environment-for-fun-and-profit/
; Start auto-completion after 2 characters of a word
(setq ac-auto-start 2)
; case sensitivity is important when finding matches
(setq ac-ignore-case nil)

;----------------------;
;;; Custom Functions ;;;
;----------------------;

; unfill a paragraph, i.e., make it so the text does not wrap in the
; paragraph where the cursor is
(defun unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

; unfill a region, i.e., make is so the text in that region does not
; wrap
(defun unfill-region ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-region (region-beginning) (region-end) nil)))

(defun system-is-mac ()
  (interactive)
  (string-equal system-type "darwin"))

(defun system-is-linux ()
  (interactive)
  (string-equal system-type "gnu/linux"))

(defun make-plugin-path (plugin)
  (expand-file-name
   (concat plugin-path plugin)))

(defun include-plugin (plugin)
  (add-to-list 'load-path (make-plugin-path plugin)))

(defun make-elget-path (plugin)
  (expand-file-name
   (concat elget-path plugin)))

(defun include-elget-plugin (plugin)
  (add-to-list 'load-path (make-elget-path plugin)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ein:cell-input-area ((t (:background "#042028"))))
 '(ein:cell-input-prompt ((t (:inherit header-line :background "#002b35" :foreground "#859900" :inverse-video nil :weight bold))))
 '(ein:cell-output-prompt ((t (:inherit header-line :background "#002b35" :foreground "#dc322f" :inverse-video nil :weight bold))))
 '(magit-item-highlight ((t (:inherit highlight :background "#042028"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 210))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 190))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 170))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 150))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :slant italic :weight bold))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :slant italic :weight normal))))
 '(markdown-math-face ((t (:inherit font-lock-string-face :foreground "#cb4b16" :slant italic))))
 '(powerline-active1 ((t (:foreground "white" :background "purple" :box nil))))
 '(powerline-active2 ((t (:foreground "black" :background "#FFFFFF" :box nil))))
 '(powerline-inactive1 ((t (:foreground "white" :background "purple" :box nil))))
 '(powerline-inactive2 ((t (:foreground "black" :background "#FFFFFF" :box nil))))
 '(py-variable-name-face ((t (:inherit default :foreground "#268bd2")))))

;------------------------;
;;; Python Programming ;;;
;------------------------;

;; -----------------------
;; python.el configuration
;; -----------------------

; from python.el
(require 'python)

(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args (if (system-is-mac)
				   "--matplotlib=osx --colors=Linux"
                                   (if (system-is-linux)
				       "--gui=wx --matplotlib=wx --colors=Linux"))
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")


;; -----------------------------
;; emacs IPython notebook config
;; -----------------------------

; use autocompletion, but don't start to autocomplete after a dot
(setq ein:complete-on-dot -1)
(setq ein:use-auto-complete 1)

; set python console args
(setq ein:console-args
      (if (system-is-mac)
	  '("--gui=osx" "--matplotlib=osx" "--colors=Linux")
	(if (system-is-linux)
	    '("--gui=wx" "--matplotlib=wx" "--colors=Linux"))))

; timeout settings
(setq ein:query-timeout 1000)

; IPython notebook
(require 'ein)

; shortcut function to load notebooklist
(defun load-ein () 
  (ein:notebooklist-load)
  (interactive)
  (ein:notebooklist-open))


;; ------------------
;; misc python config
;; ------------------

; pydoc info
(require 'pydoc-info)

;; ; jedi python completion
;; (include-elget-plugin "ctable")   ; required for epc
;; (include-elget-plugin "deferred") ; required for epc
;; (include-elget-plugin "epc")      ; required for jedi
;; (include-elget-plugin "jedi")
;; (require 'jedi)
;; (setq jedi:setup-keys t)
;; (autoload 'jedi:setup "jedi" nil t)
;; (add-hook 'python-mode-hook 'jedi:setup)

;; pyflakes flymake integration
;; http://stackoverflow.com/a/1257306/347942
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pycheckers" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))
(add-hook 'python-mode-hook
	  (lambda ()
	    (unless (eq buffer-file-name nil) (flymake-mode 1))))

; Set PYTHONPATH, because we don't load .bashrc
(defun set-python-path-from-shell-PYTHONPATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PYTHONPATH'")))
    (setenv "PYTHONPATH" path-from-shell)))

(if window-system (set-python-path-from-shell-PYTHONPATH))

(setq auto-mode-alist
      (append 
       (list '("\\.pyx" . python-mode)
             '("SConstruct" . python-mode))
       auto-mode-alist))

; keybindings
(eval-after-load 'python
  '(define-key python-mode-map (kbd "C-c !") 'python-shell-switch-to-shell))
(eval-after-load 'python
  '(define-key python-mode-map (kbd "C-c |") 'python-shell-send-region))

(defun recompile-quietly ()
  "Re-compile without changing the window configuration."
  (interactive)
  (save-window-excursion
    (recompile)))


(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook
  '(lambda() (set-fill-column 80)))


; from enberg on #emacs
(setq compilation-finish-function
  (lambda (buf str)
    (if (null (string-match ".*exited abnormally.*" str))
        ;;no errors, make the compilation window go away in a few seconds
        (progn
          (run-at-time
           "2 sec" nil 'delete-windows-on
           (get-buffer-create "*compilation*"))
          (message "No Compilation Errors!")))))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(defun my-server-visit-hook()
       (interactive)
       (shell-command
	  "osascript -e 'tell application \"Emacs\" to activate'"))

(add-hook 'server-visit-hook 'my-server-visit-hook)

(defun my-server-exit-hook()
  "Returns focus back to terminal"
       (interactive)
       (shell-command
        "osascript -e 'tell application \"Terminal\" to activate'"))

(add-hook 'delete-frame-functions 'my-server-exit-hook)
