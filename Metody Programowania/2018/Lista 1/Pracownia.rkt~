#lang racket
;; Wspolpracownicy: Krzysztof Lis, Filip Sieczkowski (modyfikacja kodu ze SKOSa)




(define (cube-root x)
  (define (improve approx)
    (/ (+ (* 2 approx) (/ x (* approx approx))) 3))
  (define (good-enough? approx)
    (< (abs (- x (* approx approx approx))) 0.0000000000000000000001))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))