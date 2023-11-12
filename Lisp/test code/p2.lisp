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
  (list (car e1) (caar e2) (list (car (nth 2 e1)) (car (nth 1 e2))) (nth 3 e1)))

;; Test case 1
(apply-sub '(p ?x (f ?y) bill) '((10 ?x) (20 ?y)))

;; Test case 2
(apply-sub '(p ?x (f ?y) bill) '(((g ?z) ?x) (gary ?y)))

; ------------------------- QUESTION -------------------------

; 2.)  make one compose function then use input 3, input 4 and input 5 to ensure that the lisp
;     function works properly. the output should be the same as answer 3, answer 4 and answer 5


;    (compose sub1 sub2)

;     input 3: (compose '((10 ?x)) '((20 ?y)))
;    Answer 3: ((10 ?x) (20 ?y))

;     input 4: (compose '((?x ?z) (?w ?y)) '((a ?x) (b ?v)))
;    Answer 4: ((a ?z) (?w ?y) (a ?x) (b ?v))

;    input 5: (compose '(((g ?x ?y) ?z)) '((a ?x) (b ?y) (c ?w) (d ?z)))
;   Answer 5: (((g a b) ?z) (a ?x) (b ?y) (c ?w))

; ------------------------- ANSWER -------------------------
(defun compose (e1 e2)
  (cond
    ((> (length e2) 3) (list (list
                              (list (caaar e1) (caar e2)
                                    (car (nth 1 e2)))
                              (nth 1 (car e1))) (nth 0 e2) (nth 1 e2) (nth 2 e2)))
    ((>= (length e2) 2)
     (list (list (caar e2)
                 (nth 1 (nth 0 e1))) (nth 1 e1) (nth 0 e2) (nth 1 e2)))
         (t (list (car e1) (car e2)) )))

;; Test case 1
(compose '((10 ?x) (20 ?y)) '((20 ?y)))

;; Test case 2
(compose '((?x ?z) (?w ?y)) '((a ?x) (b ?v)))

;; Test case 3
(compose '(((g ?x ?y) ?z) '((a ?x) (b ?y) (c ?w) (d ?z))) '((a ?x) (b ?y) (c ?w) (d ?z)))