#lang racket

(require racket/contract)

;; Zadanie 1

(define/contract (suffixes xs)
  (let ([a (new-∀/c 'a)])
    (-> (listof a) (listof (listof a))))
  (define (help xs acc)
    (if (null? xs)
        acc
        (help (cdr xs) (cons xs acc))))
  (help xs null))

;; Zadanie 2

;; ->i odracza ewaluację kontraktu do wywołania lub zwrócenia funkcji

(define/contract (dist x y)
  (-> number? number? number?)
  (abs (- x y)))

(define/contract (average x y)
  (-> number? number? number?)
  (/ (+ x y) 2))

(define/contract (square x)
  (-> number? number?)
  (* x x))

(define/contract (sqrt x)
  (->i ([p positive?]) () [result positive?]
  #:post (result p)
  (and (positive? result)
       (positive? p)))
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))
