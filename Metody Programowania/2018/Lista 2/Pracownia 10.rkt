#lang racket

#|
Pracownia 2, Zadanie 10
Krzysztof Łyskawa
Współpracowinicy: Krzysztof Lis (pracownia z zeszłego roku)
|#

(define (f num den)
  (define (f-iter Ak-1 Ak-2 Bk-1 Bk-2 k)
    (let (
          [Ak (+ (* (den k) Ak-1) (* (num k) Ak-2))]
          [Bk (+ (* (den k) Bk-1) (* (num k) Bk-2))]
          )
      (let ([good-enough? (if (< (abs (- (/ Ak Bk) (/ Ak-1 Bk-1))) 0.00001) #t #f)])
        (if good-enough?
            (/ Ak Bk)
            (f-iter Ak Ak-1 Bk Bk-1 (+ k 1)))
      )
    )
  )
  (f-iter 0 1 1 0 1)
)

(f (lambda (i) 1.0) (lambda (i) 1.0)) ;złoty podział
(+ 3 (f (lambda (x) (expt (- (* x 2) 1) 2)) (lambda (x) 6.0))) ;pi
(/ 1.0 (+ 1.0 (f (lambda (x) (expt (* x 1) 2)) (lambda (x) (+ 1 (* x 2)))))) ;arctg(1)

#|
Dla precyzji 0.0000001 i większej dla testów innych niz złoty podział
funkcja się zapętla, gdyż Ak i Bk stają sie tak duże, że racket robi z nich
+inf.0 (u Krzyśka Lisa w tym momencie wypisuje nan.0 z racji dzielenia inf.0/inf.0

Podczas obliczania phi nie występuje ten problem nawet dla dużo wiekszej precyzji,
gdyż Ak i Bk nie rośnie tak szybko, a jedynie tak jak wzór fibonacciego.
|#
