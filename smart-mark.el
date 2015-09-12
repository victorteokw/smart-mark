;;; smart-mark.el --- Restore point after C-g when mark

;; Copyright (C) 2015 Zhang Kai Yu

;; Author: Kai Yu <yeannylam@gmail.com>
;; Keywords: mark, restore

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; (require 'smart-mark)

;;; Code:

(defvar smart-mark-point-before-mark nil
  "Cursor position before mark.")

(defvar smart-mark-mark-functions
  '(mark-page mark-paragraph mark-whole-buffer mark-sexp mark-defun mark-word)
  "Functions with marking behavior.")

(defun smart-mark-set-advices ()
  (defadvice mark-page (before smart-mark-set-restore-before-mark activate)
    (setq smart-mark-point-before-mark (point)))
  (defadvice mark-paragraph (before smart-mark-set-restore-before-mark activate)
    (setq smart-mark-point-before-mark (point)))
  (defadvice mark-whole-buffer (before smart-mark-set-restore-before-mark activate)
    (setq smart-mark-point-before-mark (point)))
  (defadvice mark-sexp (before smart-mark-set-restore-before-mark activate)
    (setq smart-mark-point-before-mark (point)))
  (defadvice mark-defun (before smart-mark-set-restore-before-mark activate)
    (setq smart-mark-point-before-mark (point)))
  (defadvice mark-word (before smart-mark-set-restore-before-mark activate)
    (setq smart-mark-point-before-mark (point)))
  (defadvice keyboard-quit (before smart-mark-restore-cursor-cg-mark activate)
    (when (memq last-command smart-mark-mark-functions)
      (smart-mark-restore-cursor))))

(defun smart-mark-remove-advices ()
  (advice-remove 'mark-page #'smart-mark-set-restore-before-mark)
  (advice-remove 'mark-paragraph #'smart-mark-set-restore-before-mark)
  (advice-remove 'mark-whole-buffer #'smart-mark-set-restore-before-mark)
  (advice-remove 'mark-sexp #'smart-mark-set-restore-before-mark)
  (advice-remove 'mark-defun #'smart-mark-set-restore-before-mark)
  (advice-remove 'mark-word #'smart-mark-set-restore-before-mark)
  (advice-remove 'keyboard-quit #'smart-mark-restore-cursor-cg-mark))

(defun smart-mark-restore-cursor ()
  "Restore cursor position saved just before mark."
  (when smart-mark-point-before-mark
    (goto-char smart-mark-point-before-mark)
    (setq smart-mark-point-before-mark nil)))

;;;###autoload
(define-minor-mode smart-mark-mode
  "Mode for easy expand line when expand line is activated."
  :global t
  (if smart-mark-mode
      (smart-mark-set-advices)
    (smart-mark-remove-advices)))

(provide 'smart-mark)
;;; smart-mark.el ends here
