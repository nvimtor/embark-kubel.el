;;; embark-kubel.el --- Integration between Embark and kubel.el -*- lexical-binding: t -*-

;; Copyright (C) 2025 Vitor Leal

;; Author: Vitor Leal <hello@vitorl.com>
;; URL: https://github.com/nvimtor/embark-kubel.el
;; Version: 0.1.0
;; Package-Requires: ((emacs) (embark) (kubel))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This package integrates Embark with kubel.el. It provides a target
;; finder for Kubernetes resources listed in a `kubel-mode` buffer, allowing
;; you to use Embark to act on them directly.
;;
;; To use, enable `embark-kubel-mode` in `kubel-mode` buffers, for example:
;; (add-hook 'kubel-mode-hook #'embark-kubel-mode)

;;; Code:

(require 'embark)
(require 'kubel)

(defconst embark-kubel--resource-actions
  '(kubel-get-resource-details
    kubel-copy-popup
    kubel-delete-popup
    kubel-exec-popup
    kubel-log-popup
    kubel-port-forward-pod
    kubel-quick-edit
    kubel-rollout-history
    kubel-scale-replicas
    kubel-jab-deployment)
  "A list of kubel commands that act on a single resource.")

;; NOTE Embark target
(defun embark-kubel--embark-target-resource-at-point ()
  "Create a `kubel-resource` target in a `kubel` buffer for resources.
The target's value is the resource name at the current line."
    (when-let (((derived-mode-p 'kubel-mode))
               (resource-name (tabulated-list-get-id)))
      `(kubel-resource
        ,resource-name
        ,(line-beginning-position) . ,(line-end-position))))

;; NOTE keymap
(defvar-keymap embark-kubel-resource-map
  :doc "Keymap for Embark kubel resource targets."
  :parent embark-general-map)

(defun embark-kubel--populate-resource-map ()
  "Populate `embark-kubel-resource-map' with relevant bindings.
This function dynamically finds the keybindings for commands in
`embark-kubel--resource-actions' from the current `kubel-mode-map'
and adds them to the Embark keymap."
  (setq embark-kubel-resource-map (make-sparse-keymap))
  (set-keymap-parent embark-kubel-resource-map embark-general-map)

  (dolist (command embark-kubel--resource-actions)
    (when-let ((key-sequence (car (where-is-internal command kubel-mode-map))))
      (define-key embark-kubel-resource-map key-sequence command))))

;; NOTE minor mode
(define-minor-mode embark-kubel-mode
  "Minor mode for Embark integration with kubel.el."
  :init-value nil
  :lighter " Embark-Kubel"
  :global nil
  (if embark-kubel-mode
      (progn
        (embark-kubel--populate-resource-map)
        (add-to-list 'embark-target-finders #'embark-kubel--embark-target-resource-at-point)
        (add-to-list 'embark-keymap-alist '(kubel-resource . embark-kubel-resource-map)))
    (progn
      (setq embark-target-finders (delete #'embark-kubel--embark-target-resource-at-point embark-target-finders)))))

(provide 'embark-kubel)

;;; embark-kubel.el ends here
