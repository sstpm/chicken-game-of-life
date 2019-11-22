;; Various unit tests for life.scm
(load "life.scm")

(define (test-get-neighbours)
  ;; The get-neighbour function takes a cell and returns a list of it's neighbours, wrapping
  ;; around the edges of the board. The following tests ensure that it wraps around correctly.
  (define (test-3x3-state)
    (define (test-center-cell)
      ;; In a 3x3 board, if we get the neighbours of the central cell, we just get a copy of the state.
      (define state-one-living-cell '((0 0 0)
                                      (0 1 0)
                                      (0 0 0)))
      (define expt-neighbours-of-center-cell state-one-living-cell)
      (define result (get-neighbours state-one-living-cell 1 1))
      (if (equal? result expt-neighbours-of-center-cell)
          (print "Passed test-center-cell")
          (print "Failed test-center-cell -- Expected: "
                 expt-neighbours-of-center-cell
                 "\n but recieved: "
                 result)))

    (define (test-top-left-cell)
      (define state '((1 0 1)
                      (0 0 1)
                      (1 1 0)))
      (define expt-neighbours-of-top-left-cell '((0 1 1)
                                                 (1 1 0)
                                                 (1 0 0)))
      (define result (get-neighbours state 0 0))
      (if (equal? result expt-neighbours-of-top-left-cell)
          (print "Passed test-top-left-cell")
          (print "Failed test-top-left-cell -- Expected: "
          expt-neighbours-of-top-left-cell
          "\n but recieved: "
          result)))

    (define (test-bottom-row)
      (define state '((1 0 1)
                      (0 0 1)
                      (1 1 0)))
      (define (test-bottom-left-cell)
        (define expt-result '((1 0 0)
                              (0 1 1)
                              (1 1 0)))
        (define result (get-neighbours state 2 0))
        (if (equal? result expt-result)
            (print "Passed test-bottom-left-cell")
            (print "Failed test-bottom-left-cell -- Expected:\n"
                   expt-result
                   "\n but recieved \n"
                   result)))
      (define (test-bottom-mid-cell)
        (define expt-result '((0 0 1)
                              (1 1 0)
                              (1 0 1)))
        (define result (get-neighbours state 2 1))
        (if (equal? result expt-result)
            (print "Passed test-bottom-mid-cell")
            (print "Failed test-bottom-mid-cell -- Expected:\n"
                   expt-result
                   "\n but recieved: \n"
                   result)))
      (define (test-bottom-right-cell)
        (define expt-result '((0 1 0)
                              (1 0 1)
                              (0 1 1)))
        (define result (get-neighbours state 2 2))
        (if (equal? result expt-result)
            (print "Passed test-bottom-right-cell")
            (print "Failed test-bottom-right-cell -- Expected:\n"
                   expt-result
                   "\n but recieved: \n"
                   result)))
      (test-bottom-left-cell)
      (test-bottom-mid-cell)
      (test-bottom-right-cell))
    (test-center-cell)
    (test-top-left-cell)
    (test-bottom-row))
  (test-3x3-state))

(define (test-next-state)
  ;; A cell with no living neighbhours should stay dead.
  (define (no-living-neighbours)
    (define state '((0 0 0)
                    (0 0 0)
                    (0 0 0)))
    (define expt-result '((0 0 0)
                          (0 0 0)
                          (0 0 0)))
    (define result (next-state state))
    (if (equal? expt-result result)
        (print "Test no-living-neighbours passed")
        (print "Failed no-living-neighbhours -- Expected: \n"
               expt-result
               "\n but recieved \n"
               result)))
  (define (dead-3-neighbours)
    ;; A dead cell with exactly three living neighbours should become alive.
    (define state '((0 0 0 0 0)
                    (0 1 1 0 0)
                    (0 0 1 0 0)
                    (0 0 0 0 0)))
    (define expt-result '((0 0 0 0 0)
                          (0 1 1 0 0)
                          (0 1 1 0 0)
                          (0 0 0 0 0)))
    (define result (next-state state))
    (if (equal? expt-result result)
        (print "Test dead-3-neighbours passed")
        (print "Failed dead-3-neighbours -- Expected: \n"
               expt-result
               "\n but recieved: \n"
               result)))
  (no-living-neighbours)
  (dead-3-neighbours))
;; Run the tests
(test-get-neighbours)
(print "\nTesting next-state...")
(test-next-state)
