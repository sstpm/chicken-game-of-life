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

(define (main)
  ;; Main function. Calls everything else.
  (define width 150)
  (define height 50)
  (define state (random-state width height))
  (render state))

(main)
