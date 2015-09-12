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

(eval-and-compile
  (defconst smart-mark-mark-functions
    '(mark-page mark-paragraph mark-whole-buffer mark-sexp mark-defun mark-word)
    "Functions with marking behavior."))

(defmacro smart-mark-advise-all ()
  "Advise all `smart-mark-mark-functions' so that point is initially saved."
  `(progn
     ,@(mapcar (lambda (f)
                 `(defadvice ,f (before smart-mark-set-restore-before-mark activate)
                    "Save point to `smart-mark-point-before-mark' before this function runs."
                    (setq smart-mark-point-before-mark (point))))
               smart-mark-mark-functions)))

(smart-mark-advise-all)

(defadvice keyboard-quit (before smart-mark-restore-cursor-cg-mark activate)
  (when (memq last-command smart-mark-mark-functions)
    (smart-mark-restore-cursor)))

(defun smart-mark-restore-cursor ()
  "Restore cursor position saved just before mark."
  (when smart-mark-point-before-mark
    (goto-char smart-mark-point-before-mark)
    (setq smart-mark-point-before-mark nil)))

(provide 'smart-mark)
;;; smart-mark.el ends here
