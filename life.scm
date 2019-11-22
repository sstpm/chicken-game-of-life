;; Life.scm -- Conway's game of life in Chicken Scheme.
(import (chicken format)
        (chicken random)
        srfi-1
        srfi-42)

(define (initialize-cell)
  ;; Return either a board state of either 0 or 1, depending if a random value is above or below a
  ;; certain threshold.
  (define threshold 0.9)
  (define number (pseudo-random-real))
  (if (> number threshold)
      1   ; alive
      0)) ; dead

(define (get-cell state x y)
  ;; Given the state and the x and y coordinates of a cell, return the value of a given cell.
  (list-ref (list-ref state y) x))

(define (alive? cell)
  ;; Given a cell, return #t if alive (1) or #f if dead (0)
  (= cell 1))

(define (random-state width height)
  ;; SRFI-42 supplies list-ec, which allows for list generation in the form of
  ;; (list-ec (: var num) (f)) where f can optionally do somethig with var, but var is not passed to
  ;; f, unlike map or for-each. This means we can use a function f that takes no arguments.
  (list-ec (: n height) (list-ec (: i width) (initialize-cell))))

(define (get-neighbours state cell-x cell-y)
  (map (lambda (x)
         (map (lambda (y)
                (define wrapped-x (modulo (+ cell-x x) (length (list-ref state 0))))
                (define wrapped-y (modulo (+ cell-y y) (length state)))
                (get-cell state wrapped-x wrapped-y))
              (iota 3 -1 1)))
       (iota 3 -1 1)))

(define (next-state prev-state)
  ;; Given the previous state of the program, calculate the next state of each cell.
  ;; Follows the rules:
  ;; 1. A cell with 0 or 1 live neighbours dies, by underpopulation
  ;; 2. A cell with 2 or 3 live neighbours continues to live, as its neighbourhood is just right
  ;; 3. A cell with more than 3 live neighbours dies, by overpopulation
  ;; 4. A cell with exactly 3 live neighbours becomes alive, by reproduction.
  (define new-state
    (map (lambda (y)
         (map (lambda (x)
                ;; Get the number of living cells in a neighbourhood. If the current cell is alive,
                ;; subtract one from the list of living cells in the neighbourhood, which will give
                ;; us the proper number of living neighbours.
                (define cell (get-cell prev-state x y))
                (define num-living-cells (count alive? (flatten (get-neighbours prev-state x y))))
                (define num-living-neibours (if (alive? cell)
                                                (sub1 num-living-cells)
                                                num-living-cells))

                (cond ((and (alive? cell) (< num-living-neibours 1))       0) ; underpopulation
                      ((and (alive? cell) (or (= 2 num-living-neibours)
                                              (= 3 num-living-neibours)))  1) ; just right
                      ((and (alive? cell) (> num-living-neibours 3))       0) ; overpopulation
                      ((and (not (alive? cell)) (= num-living-neibours 3)) 1) ; reproduction
                      (else 0))) ; anything else is dead
              (iota (length (list-ref prev-state 0)))))
         (iota (length prev-state))))
  new-state)

(define (render state)
  ;; TODO: Clean this mess up.
  ;; Walk down a state, pretty-printing the status of each cell on each row of the state. EG:
  ;; -----------
  ;; |# ### #  |
  ;; | #  #  ##|
  ;; |   #  ## |
  ;; -----------
  ;; for a board of width 9 and height 3, where # represents a living cell.
  (define horizontal-border-len (+ 2 (length (list-ref state 0))))

  (define (print-horizontal-border)
    (define horizontal-border-char "-")
    (do-ec (: i horizontal-border-len) (printf horizontal-border-char))
    (newline))

  (print-horizontal-border)

  (define (print-row row row-index)
    (define vertical-border-char "|")
    (printf vertical-border-char)
    (do-ec (: i (length row)) (if (alive? (get-cell state i row-index))
                                  (printf "#")
                                  (printf " ")))
    (printf vertical-border-char)
    (newline))
  (map (lambda (y) (print-row (list-ref state y) y)) (iota (length state)))
  (print-horizontal-border))

(define (render-loop state)
  (let loop ((state state))
    (render state)
    (define new-state (next-state state))
    (loop new-state)))

(define (main)
  ;; Main function. Calls everything else.
  (define width 150)
  (define height 50)
  (define state (random-state width height))
  (render-loop state))

(main)
