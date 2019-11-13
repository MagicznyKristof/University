#lang racket

(let
    ([x 3])
  (+ x 3))  ;y unbound

(let
    ([x 1]
     [y (+ 3 2)])   ;x unbound
  (+ x y))

(let
    ([x 1])
  (let
      ([y (+ x 2)])
    (* x y)))

((lambda
    (x y)
  (* x y 3)) 2 4) ;z unbound

((let
    ([x 1])
  (lambda
      (y z)
    (* x y z))) 42 4 )  ;dziala tez jak argumenty dasz w let'cie

(define (square x)
  (* x x))

(define (compose f g)
  (lambda (x) (f (g x)))
)

(define (repeated p n)
  (if (= n 1)
      p
      (compose p (repeated p (- n 1)))
      )
  )

(define (inc x) (+ x 1)) 

(define (product-rec term a next b)        ;duże pi
  (if (> a b)
      1
      (* (term a) (product-rec term (next a) next b) )
  )
)

(define (product-iter term a next b)
  (define (product-iter-acc term a next b acc)
    (if (> a b)
        acc
        (product-iter-acc term (next a) next b (* acc (term a)))
    )
  )
  (product-iter-acc term a next b 1)
)

(define (wallis-pi iter-number)
  (* 2.0 (product-iter (lambda (x) (* (/ (* x 2) (- (* 2 x) 1)) (/ (* x 2) (+ (* 2 x) 1)))) 1 inc iter-number))
)
#|
(define (pi iter-number)
  (product-rec ((if 
|#
(define (accumulate-rec combiner null-value term a next b)        ;duże pi
  (if (> a b)
      null-value
      (combiner (term a) (accumulate-rec combiner null-value term (next a) next b) )
  )
)
  
(define (accumulate-iter combiner null-value term a next b)
  (define (accumulate-iter-acc combiner null-value term a next b acc)
    (if (> a b)
        acc
        (accumulate-iter-acc combiner null-value term (next a) next b (combiner acc (term a)))
    )
  )
  (accumulate-iter-acc combiner null-value term a next b null-value)
)


(define (cont-frac-rec num den k)
  (define (pom x)
    (if (< k x)
      0
      (/ (num x) (+ (den x) (pom (+ x 1)))))
    )
  (pom 1)
)

(define (cont-frac-iter num den k)
  (define (cont-frac-acc k acc)
  (if (= k 0)
      acc
      (cont-frac-acc (- k 1) (/ (num k) (+ (den k) acc)))))
   (cont-frac-acc k 0)
)

(define (chain-pi iter-number)
  (+ 3 (cont-frac-rec (lambda (x) (square (- (* 2 x) 1))) (lambda (x) 6.0) iter-number))
)

(define (atan-cf x k)
  (/ x (+ 1.0 (cont-frac-iter (lambda (y) (square (* y x))) (lambda (y) (+ 1 (* y 2))) k)))
)






