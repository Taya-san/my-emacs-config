;; the window/frame settingsssssss
(add-to-list 'default-frame-alist '(undecorated . t)) 
(setq-default left-fringe-width 16)
(setq-default right-fringe-width 16)

;; loadingggg
(add-to-list 'load-path "~/.config/emacs/lisp")
(setq custom-file "~/.config/emacs/custom.el")

(load custom-file)
(load "~/.config/emacs/packages")
(require 'tramp)
(require 'tty)
(require 'zoxide)

;; im not evilllll
(evil-mode 1)

;; commenting in evillll
(evil-commentary-mode 1)

;; themeeeee
(load-theme 'doom-ayu-dark t)

;; keymapssss/keybindingssssss
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-x b") #'consult-buffer)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c z") #'zoxide-travel-with-query)

(with-eval-after-load 'dirvish
  (evil-define-key 'normal dirvish-mode-map
    (kbd "l") #'dired-find-file
    (kbd "h") #'dired-up-directory))

;; so it use normal evil mode in ibuffer
(add-hook 'ibuffer-mode-hook #'ibuffer-auto-mode)
(evil-set-initial-state 'ibuffer-mode 'normal)

;; emacs general configssss
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(tab-bar-mode 0)

;;el condor pasa
(setq elcord-client-id "1532396100076568696")
(setq elcord-quiet t)
(setq elcord-icon-base '"https://raw.githubusercontent.com/Taya-san/my-emacs-config/main/icons/")
(setq elcord-editor-icon '"logo_emacs_1")
(with-eval-after-load 'elcord
  (setq elcord--editor-name "jujur gk tw mw isi apa jd bayangin aja isinya"))

(elcord-mode 1)

;; magitttttt
(evil-set-initial-state 'magit-status-mode 'normal)
(evil-set-initial-state 'magit-diff-mode 'normal)
(evil-set-initial-state 'magit-log-mode 'normal)

;; im which keyyyy
(which-key-mode 1)

;; line numberingssssss
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; dashboarddddd
(setq dashboard-items nil)
(setq dashboard-footer-messages nil)

(setq dashboard-startup-banner "/home/taya/Pictures/comm_1/ascii_4 (55).txt")
(setq dashboard-footer-icon "")

(setq dashboard-banner-logo-title "ini hanya text editor biasa")

(defun my-dashboard-boot-footer ()
  "boot time only."
  (dashboard-insert-center
   (propertize (format "IT STARTED IN %s" (emacs-init-time))
               'face 'dashboard-footer-face))
  (insert "\n"))

(setq dashboard-startupify-list
      '(dashboard-insert-banner
        dashboard-insert-newline
        dashboard-insert-banner-title
        dashboard-insert-newline
        my-dashboard-boot-footer))

(dashboard-setup-startup-hook)

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (let ((buf (get-buffer "*dashboard*")))
              (when buf
                (switch-to-buffer buf)
                (dashboard-open)))))

;; dired or dirvish stuff
(dirvish-override-dired-mode)
(setq dirvish-attributes
      '(file-modes          ;; permissions like -rw-r--r--
        file-time           ;; modification date
        file-size           ;; file size
        vc-state            ;; git status (fringe)
	collapse))
(diredfl-global-mode 1)

(setq dired-kill-when-opening-new-dired-buffer t)

;; TRAMP card
(setq tramp-default-method "scp")

;; undo redo
(evil-set-undo-system 'undo-redo)

;; xclipppp
(xclip-mode 1)

;; verticooooo
(vertico-mode 1)

;;org-mode
(add-hook 'org-mode-hook 'evil-org-mode)
(evil-org-set-key-theme '(navigation insert textobjects additional calendar))
(evil-org-agenda-set-keys)
(with-eval-after-load 'org (global-org-modern-mode))
(setq org-log-done 'time)
(setq org-log-done 'note)
(setq org-startup-folded 'content)

;; orderlesssss
(setq completion-styles '(orderless))

;; DTRRT FOR INDENTATIOOOOOOOON
(setq dtrt-indent-global-mode t)

;; fontssssss
(set-fontset-font t 'unicode (font-spec :family "JetBrainsMono Nerd Font") nil 'prepend)

(set-face-attribute 'default nil
		    :font "JetBrainsMono Nerd Font"
		    :height 130
		    :weight 'bold)

;; backupssssssssss
(add-to-list 'auto-save-file-name-transforms
             `(".*" "~/.config/emacs/backups/" t)
             t)

(setq backup-directory-alist `(("." . "~/.config/emacs/backups/")))

;; electris pairrrrrrrr (its the bracket thingy)
(electric-pair-mode 1)

;; idle
(require 'idle)

;; terminal
(setq ansi-color-names-vector
      ["black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"])
;; Color 15 = bright white → make it visible:
(custom-set-faces
 '(term-color-white ((t (:foreground "#FFFFFF"))))
 '(term-color-bright-white ((t (:foreground "#FFFFFF")))))

;; code-cellsssssss
(add-hook 'python-ts-mode-hook #'code-cells-mode-maybe)

(with-eval-after-load 'code-cells
  (let ((map code-cells-mode-map))
    (keymap-set map "M-p" 'code-cells-backward-cell)
    (keymap-set map "M-n" 'code-cells-forward-cell)
    (keymap-set map "C-c C-c" 'code-cells-eval)))

;; pythonnnnnnnnn
(setq python-shell-dedicated-buffer 'project)
(setq comint-terminfo-terminal "xterm-256color")

;; lsp and treesitters
(add-to-list 'auto-mode-alist '("\\.typ$" . typst-ts-mode))
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-ts-mode))

(add-hook 'emacs-lisp-mode-hook #'highlight-defined-mode)
(add-hook 'emacs-lisp-mode-hook #'highlight-quoted-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)

(setq eglot-server-programs
      (append
       '((html-ts-mode . ("vscode-html-languageserver" "--stdio"))
         (toml-ts-mode . ("taplo" "lsp" "stdio"))
         (typst-ts-mode . ("tinymist")))
       eglot-server-programs))

(add-hook 'python-ts-mode-hook #'eglot-ensure)
(add-hook 'js-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)
(add-hook 'css-ts-mode-hook #'eglot-ensure)
(add-hook 'html-ts-mode-hook #'eglot-ensure)
(add-hook 'rust-ts-mode-hook #'eglot-ensure)
(add-hook 'go-ts-mode-hook #'eglot-ensure)
(add-hook 'typst-ts-mode-hook #'eglot-ensure)
(add-hook 'yaml-ts-mode-hook #'eglot-ensure)
(add-hook 'json-ts-mode-hook #'eglot-ensure)

(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        (js-mode . js-ts-mode)
        (typescript-mode . tsx-ts-mode)
        (css-mode . css-ts-mode)
        (html-mode . html-ts-mode)
        (json-mode . json-ts-mode)
        (yaml-mode . yaml-ts-mode)
        (toml-mode . toml-ts-mode)
        (rust-mode . rust-ts-mode)
        (go-mode . go-ts-mode)))
