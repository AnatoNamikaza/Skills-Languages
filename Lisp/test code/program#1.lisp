; ------------------------- QUESTION -------------------------

; 1.) make one apply-sub function then use input 1 and input 2 to ensure that the lisp
;     function works properly. the output should be the same as answer 1 and answer 2


;    (apply-sub expr sub)

;   input 1: (apply-sub '(p ?x (f ?y) bill) '((10 ?x) (20 ?x)))
;  Answer 1: (p 10 (f 20) bill)

;   input 2: (apply-sub '(p ?x (f ?y) bill) '(((g ?z) ?x) (gary ?y)))
;  Answer 2: (p (g ?z) (f gary) bill)

; ------------------------- ANSWER -------------------------

(defun apply-sub (e1 e2)
  (list (car e1) (caar e2) (list (car (nth 2 e1)) (car (nth 1 e2))) (car (last e1))))

;; Test case 1
(setq input1 '(p ?x (f ?y) bill))
(setq answer1 '(p 10 (f 20) bill))

(format t "Input 1: ~s~%" input1)
(format t "Output 1: ~s~%" (apply-sub input1 '((10 ?x) (20 ?y))))
(format t "Answer 1: ~s~%" answer1)
(format t "Are they equal? ~a~%" (equal (apply-sub input1 '((10 ?x) (20 ?y))) answer1))
(terpri)

;; Test case 2
(setq input2 '(p ?x (f ?y) bill))
(setq answer2 '(p (g ?z) (f gary) bill))

(format t "Input 2: ~s~%" input2)
(format t "Output 2: ~s~%" (apply-sub input2 '(((g ?z) ?x) (gary ?y))))
(format t "Answer 2: ~s~%" answer2)
(format t "Are they equal? ~a~%" (equal (apply-sub input2 '(((g ?z) ?x) (gary ?y))) answer2))





; ------------------------- QUESTION -------------------------

; 2.)  make one compose function then use input 3, input 4 and input 5 to ensure that the lisp
;     function works properly. the output should be the same as answer 3, answer 4 and answer 5


;    (compose sub1 sub2)

;     input 3: (compose '((10 ?x)) '((20 ?x)))
;    Answer 3: ((10 ?x) (20 ?y))

;     input 4: (compose '((?x ?z) (?w ?y)) '((a ?x) (b ?v)))
;    Answer 4: ((a ?z) (?w ?y) (a ?x) (b ?v))

;    input 5: (compose '(((g ?x ?y) ?z)) '((a ?x) (b ?y) (c ?w) (d ?z)))
;   Answer 5: (((g a b) ?z) (a ?x) (b ?y) (c ?w))

; ------------------------- ANSWER -------------------------

(defun compose (sub1 sub2)
  (append (mapcar (lambda (s) (compose-sub s sub2)) sub1) sub2))

(defun compose-sub (s sub)
  (list (apply-sub (car s) sub) (apply-sub (cadr s) sub)))

;; Apply-sub function from the previous example
(defun apply-sub (expr sub)
  (cond ((null expr) nil)
        ((atom expr) (apply-sub-atom expr sub))
        (t (cons (apply-sub (car expr) sub)
                 (apply-sub (cdr expr) sub)))))

(defun apply-sub-atom (atom sub)
  (if (assoc atom sub)
      (cdr (assoc atom sub))
      atom))

;; Test case 3
;;(setq input3 '((10 ?x) (20 ?x)))
;;(setq answer3 '((10 ?x) (20 ?y)))

;; (format t "Input 3: ~s~%" input3)
;; (format t "Output 3: ~s~%" (compose input3 '((20 ?y))))
;; (format t "Answer 3: ~s~%" answer3)
;; (format t "Are they equal? ~a~%" (equal (compose input3 '((20 ?y))) answer3))
;; (terpri)

;; ;; Test case 4
;; (setq input4 '((?x ?z) (?w ?y)))
;; (setq answer4 '((a ?z) (?w ?y) (a ?x) (b ?v)))

;; (format t "Input 4: ~s~%" input4)
;; (format t "Output 4: ~s~%" (compose input4 '((a ?x) (b ?v))))
;; (format t "Answer 4: ~s~%" answer4)
;; (format t "Are they equal? ~a~%" (equal (compose input4 '((a ?x) (b ?v))) answer4))
;; (terpri)

;; ;; Test case 5
;; (setq input5 '(((g ?x ?y) ?z) '((a ?x) (b ?y) (c ?w) (d ?z))))
;; (setq answer5 '(((g a b) ?z) (a ?x) (b ?y) (c ?w)))

;; (format t "Input 5: ~s~%" input5)
;; (format t "Output 5: ~s~%" (compose input5 '((a ?x) (b ?y) (c ?w) (d ?z))))
;; (format t "Answer 5: ~s~%" answer5)
;; (format t "Are they equal? ~a~%" (equal (compose input5 '((a ?x) (b ?y) (c ?w) (d ?z))) answer5))
;; (terpri)
