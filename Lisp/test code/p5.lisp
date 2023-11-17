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

(defun apply-sub-rest (sub var rest)
  (if (null sub)
      (cons var (apply-sub rest sub))
      (let* ((pair (car sub))
             (replacement (car pair))
             (replacement-var (cadr pair))
             (remaining-sub (cdr sub)))
        (if (equal var replacement-var)
            (cons replacement (apply-sub rest remaining-sub))
            (apply-sub-rest remaining-sub var rest)))))

(defun apply-sub (expr sub)
  (if (null expr)
      nil
      (let ((current (car expr))
            (rest (cdr expr)))
        (cond
          ((isvar current)
           (apply-sub-rest sub current rest))
          ((consp current)
           (cons (apply-sub current sub) (apply-sub rest sub)))
          (t
           (cons current (apply-sub rest sub)))))))


;; Test with provided inputs

(setq expr1 '(p ?x (f ?y) bill))
(setq sub1 '((10 ?x) (20 ?y)))
(setq result1 (apply-sub expr1 sub1))
(print result1)
; Expected Output: (p 10 (f 20) bill)

(setq expr2 '(p ?x (f ?y) bill))
(setq sub2 '(((g ?z) ?x) (gary ?y)))
(setq result2 (apply-sub expr2 sub2))
(print result2)
; Expected Output: (p (g ?z) (f gary) bill)