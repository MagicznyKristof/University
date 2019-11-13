#lang racket
#|
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b))) b a)
(cond [(= a 4) 6]
      [(= b 4) (+ 6 7 a)]
      [else 25])
(+ 2 (if (> b a) b a))
(* (cond [(> a b) a]
         [(< a b) b]
         [else -1])
(+ a 1))

;Zad 2
(/
 (+ 5 4
    (- 2
       (- 3
          (+ 6 (/ 4 5))
          )
       )
    )
 (* 3
    (- 6 2)
    (- 2 7)
 )
)

;Zad 4



;Zad 7   ->    (define (p) (p)) po wywolaniu (p) zawiesza sie bo wywolanie rekur.
|#
(define (power-close-to b n)
  (define (iter-up e)
    (if (<= (expt b (* e 2)) n)
        (iter-up (* e 2))
        (iter-down e (* e 2))
    )
  )
  (define (iter-down p e)
    (if (= e (+ p 1))
        e
        (if (> (expt b (quotient (+ p e) 2)) n)
            (iter-down p (quotient (+ p e) 2))
            (iter-down (quotient (+ p e) 2) e)
        )
    )
  )
 (iter-up 1)
)

#|
(define (a x y) (and x y))

(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y))
|#



(define (x) (lambda (x y z) (+ x y z)))

