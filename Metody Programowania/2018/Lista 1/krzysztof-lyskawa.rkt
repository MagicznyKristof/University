#lang racket
;; Wspolpracownicy: Krzysztof Lis, Filip Sieczkowski (modyfikacja kodu ze SKOSa) (pracownia z zeszlego roku)




(define (cube-root x)
  (define (improve approx)
    (/ (+ (* 2 approx) (/ x (* approx approx))) 3))
  (define (good-enough? approx)
    (< (abs (- x (* approx approx approx))) 0.0001))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))


(cube-root 0.0) ;0.0
(cube-root 1.0) ;1.0
(cube-root 3.0) ;1.44224957
(cube-root 8.0) ;2.0
(cube-root 12.34567) ;2.31120368
(cube-root 12.3456789) ;2.31120424
(cube-root 12.34567890123456789) ;2.31120424
(cube-root 21.0) ;2.75892417
(cube-root 27.0) ;3.0
(cube-root 1000000000000000000.0) ;1000000.0
(cube-root -0.125) ;-0.5
(cube-root -64.0) ;-4.0
(cube-root -88.0) ;4.44796018
