; Project 2:

; 1.) make one unity lisp function. it should be able to take test 1, test 2, test 3, test 4 and test 5. then
;     it should return answer 1, answer 2 , answer 3, answer 4 and answer 5. also you can use the written layout
;     to help you write the unity code. some of the tests and answers will use the apply-sub function to help test
;     the unity function.


;     Test 5: (unity '(p bill) '(p mary))
;     Answer 5: fail

;     Test 3: (unity '(p (f ?x) ?y (g ?y)) '(p (f ?x) ?z (g ?x)))
;     Answer 3: ((?x ?y) (?x ?z))
    
;      A.) written layout to help create unity lisp function:
     
;       if either expr is atom
;            if match, then return ()
;            if at least one is var, then return ((??? ?x))
;            otherwise return 'fail

;       Try to unify cars, fail if not possible
;       apply resulting substitution to both cdrs
;       try to unify cdrs, fail if not possible
;       Return composition of two results


;     B.) Test Cases. also use the apply-sub function to test the unity function

;      (unify expr1 expr2)

;     Test 1: (unify '(p ?x) '(p bill))
;   Answer 1: ((bill ?x))

;     Test 2: (apply-sub '(p ?x) '((bill ?x)))
;   Answer 2: (p bill)

    
;     Test 3: (unify '(p (f ?x) ?y (g ?y)) '(p (f ?x) ?z (g ?x)))
;   Answer 3: ((?x ?y) (?x ?z))

;     Test 4: (apply-sub '(p (f ?x) ?y (g ?y)) '((?x ?y) (?x ?z)))
;   Answer 4: (p (f ?x) ?x (g ?x))

 
;     Test 5: (unity '(p bill) '(p mary))
;   Answer 5: fail




 

;   2.) make one newvars lisp function. it should be able to take test 6, test 7, test 8, and test 9. then
;     it should return answer 6, answer 7 , answer 8, and answer 9.

      

;      (newvars clause)

(defun is-var (symbol)
  (and (symbolp symbol)
       (char= #\? (char (symbol-name symbol) 0))))


(defun newvars (exp &optional (var-list '()) (start 119))
  (if exp
      (let ((next-element (car exp)))
        (cond
          ((atom next-element)
           (if (and (is-var next-element) (not (member next-element var-list)))
               (progn
                 (setq var-list (cons (list (incf start) next-element) var-list))
               (newvars (cdr exp) var-list start)
               )
           ))
          (t (progn
               (newvars next-element var-list start)
               (newvars (cdr exp) var-list start)))))))


(defvar *start* 119)
(defun normalize (number)
  (read-from-string (format nil "?x~A" number)))

(defun convert-to-atomic-list (exp &optional (expanded-list nil))
  ;; (f ?x (p ?y (q ?z)) ?x) to
  ;; (f ?x p ?y q ?z ?x)
  (if exp
      (let ((first-element (car exp)))        
        (if (atom first-element)
            (progn
              ;;(format t "atomic case~%")
              (if (member first-element expanded-list)
                  expanded-list
                  (convert-to-atomic-list
                   (cdr exp )
                   (append expanded-list (list first-element)))))
            ;;(when (cdr first-element)
            (progn
              ;;(format t "recursive case~%")
              (setq inner-list (convert-to-atomic-list first-element expanded-list))
              (convert-to-atomic-list (cdr exp) inner-list)
              )))        
      expanded-list))
      
(defun newvars-atomic-list (atomic-exp)
  (let ((var-list '()))
    (loop for e in atomic-exp do
         (unless (member e var-list)
           (when (is-var e)
             (setq var-list
                   (append var-list
                           (list (list (normalize (incf *start*)) e))))
             )))
    var-list))

;;(print (newvars-atomic-list '(hello ?x zaeem ?y)))
(defun newvars (exp)
  (newvars-atomic-list (convert-to-atomic-list exp)))

;;   Test 6: (newvars '(p ?x (f ?y) bill))
;; Answer 6: ((?x120 ?x) (?x121 ?y)) 

;;   Test 7: (newvars '(p (f ?x) ?y (g ?y)))
;; Answer 7: ((?x122 ?x) (?x123 ?y))


;;  Test 8: (newvars '((likes mary ?x) <- (likes john ?x) (blue ?x)))
;; Answer 8: ((?x124 ?x))

;;   Test 9: (newvars '((sister ?x ?y) <- (female ?x) (sibling ?x ?y)))
;; Answer 9: ((?x125 ?x) (?x126 ?y))

(setq test6 '(p ?x (f ?y) bill))
(setq ans6 '((?x120 ?x) (?x121 ?y)))

(setq test7 '(p (f ?x) ?y (g ?y)))
(setq ans7 '((?x122 ?x) (?x123 ?y)))

(setq test8 '((likes mary ?x) <- (likes john ?x) (blue ?x)))
(setq ans8 '((?x124 ?x)))

(setq test9 '((sister ?x ?y) <- (female ?x) (sibling ?x ?y)))
(setq ans9 '((?x125 ?x) (?x126 ?y)))

(defun newvars-test ()  
  (if (equal ans6 (newvars test6))
      (format t "Test 6 passed ...~%")
      (format t "Test 6 failed ...~%"))
  
  (if (equal ans7 (newvars test7))
      (format t "Test 7 passed ...~%")
      (format t "Test 7 failed ...~%"))
  (if (equal ans8 (newvars test8))
      (format t "Test 7 passed ...~%")
      (format t "Test 7 failed ...~%"))
  (if (equal ans9 (newvars test9))
      (format t "Test 9 passed ...~%")
      (format t "Test 9 failed ...~%")))
(newvars-test)
