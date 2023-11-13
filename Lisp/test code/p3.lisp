Project 2:

1.) make one unity lisp function. it should be able to take test 1, test 2, test 3, test 4 and test 5. then
    it should return answer 1, answer 2 , answer 3, answer 4 and answer 5. also you can use the written layout
    to help you write the unity code. some of the tests and answers will use the apply-sub function to help test
    the unity function.

    
     A.) written layout to help create unity lisp function:
     
      if either expr is atom
           if match, then return ()
           if at least one is var, then return ((??? ?x))
           otherwise return 'fail

      Try to unify cars, fail if not possible
      apply resulting substitution to both cdrs
      try to unify cdrs, fail if not possible
      Return composition of two results


    B.) Test Cases. also use the apply-sub function to test the unity function

     (unify expr1 expr2)

    Test 1: (unify '(p ?x) '(p bill))
  Answer 1: ((bill ?x))

    Test 2: (apply-sub '(p ?x) '((bill ?x)))
  Answer 2: (p bill)

    
    Test 3: (unify '(p (f ?x) ?y (g ?y)) '(p (f ?x) ?z (g ?x)))
  Answer 3: ((?x ?y) (?x ?z))


    Test 4: (apply-sub '(p (f ?x) ?y (g ?y)) '((?x ?y) (?x ?z)))
  Answer 4: (p (f ?x) ?x (g ?x))

 
    Test 5: (unity '(p bill) '(p mary))
  Answer 5: fail




 

  2.) make one newvars lisp function. it should be able to take test 6, test 7, test 8, and test 9. then
    it should return answer 6, answer 7 , answer 8, and answer 9.



      

     (newvars clause)

    Test 6: (newvars '(p ?x (f ?y) bill))
  Answer 6: ((?x120 ?x) (?x121 ?y)) 

    Test 7: (newvars '(p (f ?x) ?y (g ?y)))
  Answer 7: ((?x122 ?x) (?x123 ?y))


    Test 8: (newvars '((likes mary ?x) <- (likes john ?x) (blue ?x)))
  Answer 8: ((?x124 ?x))

    Test 9: (newvars '((sister ?x ?y) <- (female ?x) (sibling ?x ?y)))
  Answer 9: ((?x125 ?x) (?x126 ?y))

   