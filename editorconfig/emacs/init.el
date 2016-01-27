(require 'cask "/usr/local/Cellar/cask/0.7.2/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

(add-to-list 'load-path "~/.emacs.d/elpa/dash-at-point-0.0.5/")
   (autoload 'dash-at-point "dash-at-point"
             "Search the word at point with Dash." t nil)
   (global-set-key "\C-cd" 'dash-at-point)
(setq load-path (cons  "/usr/local/lib/erlang/lib/tools-2.8.11/emacs"
		       load-path))
(setq erlang-root-dir "/usr/local/lib/erlang")
(setq exec-path (cons "/usr/local/lib/erlang/bin" exec-path))
(require 'erlang-start)
(menu-bar-mode -1)
(require 'color-theme)
(color-theme-initialize)
(color-theme-vivid-chalk)
(require 'alchemist)
(require 'package) 
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) 
(tool-bar-mode -1)
