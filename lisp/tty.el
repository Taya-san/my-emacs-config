;; === Window title ===
(setq xterm-set-window-title t)

;; === Don't force blinking cursor ===
(setq visible-cursor nil)

;; === Mouse in terminal ===
(add-hook 'tty-setup-hook #'xterm-mouse-mode)

;; === Cursor per evil state ===
(unless (package-installed-p 'evil-terminal-cursor-changer)
  (package-refresh-contents)
  (package-install 'evil-terminal-cursor-changer))
(require 'evil-terminal-cursor-changer)
(add-hook 'tty-setup-hook #'evil-terminal-cursor-changer-activate)

;; === Kitty keyboard protocol ===
(unless (package-installed-p 'kkp)
  (package-refresh-contents)
  (package-install 'kkp))
(require 'kkp)
(add-hook 'tty-setup-hook #'global-kkp-mode)

(provide 'tty)
