;make one apply-sub function then use input 1 and input 2 to ensure that the lisp
;function works properly. the output should be the same as answer 1 and answer 2. 
;also remeber that also remember that for this function, ? stands for a variable 
;and it separates those that are variables and can be changed from those that are 
;not variables and are static. for example, ?x is a variable can be moved and changed,
;but P is not. so for (f ?x) it would be (f 10). this is the idea. the function should be 
;in a way in which it does not matter where the ?variables is located. it should be able to 
;be changed with its corresponding counterpart. for example: the same way (p ?x) would 
;be changed with (10 ?x) resultiong in (p 10). if the the input was changed to (p ?y), 
;then it would substitute with (20 ?y) resuting in (p 20). also you can use the isvar function 
;provided and tie it with the apply sub function in order to help you handle the ? aspect. 
;also remeber that it should be able to do the substitution with ? irregardless of where it is placed



;Try and change up the ?variables around to ensure that it is actually substitutiong and giving the correct answer.
;   (apply-sub expr sub)

;  input 1: (apply-sub '(p ?x (f ?y) bill) '((10 ?x) (20 ?y)))
; Answer 1: (p 10 (f 20) bill)

;  input 2: (apply-sub '(p ?x (f ?y) bill) '(((g ?z) ?x) (gary ?y)))
; Answer 2: (p (g ?z) (f gary) bill)

;--------- Answer ---------

(defun isvar (x)
  (cond
    ((null x) nil)
    ((consp x) nil)
    (t (equal "?" (substring (symbol-name x) 0 1)))))

;; () '((10 ?x))
;; (p ?x) '((20 ?x))
;; (p (f ?x) ?y) '((10 ?x) (20 ?y))

(defun reverse-symbol-table (symbol-table)
  (let ((new-table '()))
    (loop for s in symbol-table do
         (setq new-table (append new-table (list (reverse s))))
         )
    new-table))

;;(print (reverse-symbol-table '((1 ?x) (2 ?y))))
(defun apply-sub (exp symbol-table)
  (let ((reverse-symbol-table (reverse-symbol-table symbol-table)) (result '()))
    (loop for e in exp do
         (if (atom e)
           (if (assoc e reverse-symbol-table)
               (setq result (append result (list (car (reverse (assoc e reverse-symbol-table))))))
               (setq result (append result (list e))))
           (setq result (append result (list (apply-sub e symbol-table))))))
    result))


(print (apply-sub '(p ?x (f ?y) bill) '((10 ?x) (20 ?y))))
(print (apply-sub '(p ?x (f ?y) bill) '(((g ?z) ?x) (gary ?y))))
(print (apply-sub '(p ?v (f ?w) bill) '(((great ?z) ?v) (success ?w))))
(print (apply-sub '(p ?w(f ?v) bill) '(((great ?z) ?v) (success ?w))))

(print (apply-sub '((?x ?z) (?w ?y)) '((a ?x) (b ?v))))


;; In the input `(compose '(((g ?x ?y ?w) ?z)) '((a ?x) (b ?y) (c ?w) (d ?z)))`, the variable `?z` stayed the same in the output because it didn't have a direct substitution in the second substitution list.

;; Let's break it down step by step:

;; 1. The first substitution list `(((g ?x ?y ?w) ?z))` indicates that the variable `?z` should be replaced by the result of the expression `(g ?x ?y ?w)`.

;; 2. The second substitution list `((a ?x) (b ?y) (c ?w) (d ?z))` provides substitutions for `?x`, `?y`, `?w`, and `?z`. However, it doesn't provide a direct substitution for `?z`. Instead, it provides a substitution for `?x`, `?y`, and `?w`.

;; 3. When the `compose` function combines these two substitution lists, it correctly substitutes `?x`, `?y`, and `?w` based on the second substitution list, but it leaves `?z` unchanged because there is no direct substitution for `?z` in the second list.

;; As a result, `?z` remains the same in the final composed substitution list, which is `(((g a b c) ?z) (a ?x) (b ?y) (c ?w))`.

;; that is why (compose '(((g ?x ?y) ?z)) '((a ?x) (b ?y) (c ?w) (d ?z))) results in (((g a b) ?z) (a ?x) (b ?y) (c ?w))

;; but (compose '(((g ?x ?y ?w) ?z)) '((a ?x) (b ?y) (c ?w) (d ?z))) results in (((g a b c) ?z) (a ?x) (b ?y) (c ?w))


;  input 1: (apply-sub '(p ?x (f ?y) bill) '((10 ?x) (20 ?y)))
; Answer 1: (p 10 (f 20) bill)

;  input 2: (apply-sub '(p ?x (f ?y) bill) '(((g ?z) ?x) (gary ?y)))
; Answer 2: (p (g ?z) (f gary) bill)



;; ;; Test with provided inputs

;; (setq expr1 '(p ?x (f ?y) bill))
;; (setq sub1 '((10 ?x) (20 ?y)))
;; (setq result1 (apply-sub expr1 sub1))
;; (print result1)
;; ; Expected Output: (p 10 (f 20) bill)

;; (setq expr2 '(p ?x (f ?y) bill))
;; (setq sub2 '(((g ?z) ?x) (gary ?y)))
;; (setq result2 (apply-sub expr2 sub2))
;; (print result2)
; Expected Output: (p (g ?z) (f gary) bill)
