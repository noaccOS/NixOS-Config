;; This fixed garbage collection, makes emacs start up faster
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

;; -----
;; straight.el bootstrap
;; -----
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; integration with use-package
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
;; -----
;; end bootstrap
;; -----

;; allow to use ~package-list-packages~ to browse melpa packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(use-package org
  :mode (("\\.org$" . org-mode))
  :bind
    ("C-c l" . org-store-link)
    ("C-c a" . org-agenda))

(when (file-readable-p "~/.emacs.d/README.org")
  (org-babel-load-file (expand-file-name "~/.emacs.d/README.org")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0d2882cc7dbb37de573f14fdf53472bcfb4ec76e3d2f20c9a93a7b2fe1677bf5" default))
 '(org-agenda-files nil)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
