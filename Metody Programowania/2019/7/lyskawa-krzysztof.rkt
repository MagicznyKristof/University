#lang racket

(require rackunit)

;; definicja wyrażeń arytmetycznych z jedną zmienną

(struct const (val) #:transparent)
(struct op (symb l r) #:transparent)
(struct variable () #:transparent)
(struct der (d f) #:transparent)

(define (expr? e)
  (match e
    [(variable) true]
    [(const n)  (number? n)]
    [(op s l r) (and (member s '(+ *))
                     (expr? l)
                     (expr? r))]
    [(der d f) (and (equal? d '∂)
                           (expr? f))]
    [_          false]))

;; ewaluator

(define (eval e x)
  ;; pochodna funkcji
  (define (∂ f)
    (match f
      [(const n)   (const 0)]
      [(variable)  (const 1)]
      [(op '+ f g) (op '+ (∂ f) (∂ g))]
      [(op '* f g) (op '+ (op '* (∂ f) g)
                       (op '* f (∂ g)))]
      [(der '∂ f) (∂ (∂ f))]))
  
  (match e
    [(variable) x]
    [(const n) n]
    [(op '+ l r) (+ (eval l x) (eval r x))]
    [(op '* l r) (* (eval l x) (eval r x))]
    [(der '∂ f) (eval (∂ f) x)]))

;; Testy

(define abstr-synt-tests
  (test-suite
   "Testy składni abstrakcyjnej"
   (check-equal? (expr? (variable)) true
                 "Test konstruktora zmiennej - Niepoprawna reprezentacja dla samej zmiennej")

   (check-equal? (expr? (const 0)) true
                 "Test konstruktora stałej - Niepoprawna reprezentacja dla stałej 0")

   (check-equal? (expr? (op '* (variable) (variable))) true
                 "Test mnożenia - Niepoprawna reprezentacja dla x*x")

   (check-equal? (expr? (op '+ (const 1) (const 6))) true
                 "Test dodawania - Niepoprawna reprezentacja dla 1+6")

   (check-equal? (expr? (der '∂ (variable))) true
                 "Test pochodnej - Niepoprawna reprezentacja dla x'")

   (check-equal? (expr? (der '∂ (op '* (const 7) (variable)))) true
                 "Test zagnieżdżenia mnożenia - Niepoprawna reprezentacja dla (7x)'")

   (check-equal? (expr? (op '* (op '+ (const 7) (variable)) (const 6))) true
                 "Test zagnieżdżenia dodawania - Niepoprawna reprezentacja dla (7+x)*6")

   (check-equal? (expr? (op '* (der '∂ (variable)) (const 7))) true
                 "Test zagnieżdżenia pochodnej - Niepoprawna reprezentacja dla x'*7")

   (check-equal? (expr? (op '+ (op '* (const 2) (variable))
                             (der '∂ (op '+
                                         (op '* (variable)
                                             (variable))
                                         (variable))))) true
                  "Niepoprawna reprezentacja dla bardziej skomplikowanego wyrażenia")

   (check-not-equal? (expr? (op '+ (op '* 2 (variable))
                             (der '∂ (op '+
                                         (op '* (variable)
                                             (variable))
                                         (variable))))) true
                  "Poprawna reprezentacja niepoprawnego wyrażenia")
   ))

(define evaluator-tests
  (test-suite
   "Testy ewaluatora"
   (check-equal? (eval (const 0) 0) 0
                 "Ewaluacja stałej - Niepoprawna ewaluacja stałej 0")

   (check-equal? (eval (variable) 10) 10
                 "Ewaluacja zmiennej - Niepoprawna ewaluacja x=10")

   (check-equal? (eval (op '* (variable) (variable)) 3) 9
                 "Ewaluacja mnożenia - Niepoprawna ewaluacja x*x dla x=3")

   (check-equal? (eval (op '+ (const 2) (variable)) 5) 7
                 "Ewaluacja dodawania - Niepoprawna ewaluacja 2 + x")

   (check-equal? (eval (der '∂ (variable)) 5) 1
                 "Ewaluacja pochodnej - Niepoprawna ewaluacja x'")

   (check-equal? (eval (op '+ (op '* (variable) (variable)) (variable)) 3) 12
                 "Ewaluacja mnożenia zagnieżdżonego w dodawaniu - Niepoprawna ewaluacja x+x*x dla x=3")

   (check-equal? (eval (op '* (op '+ (const 5) (variable)) (const 3)) 3) 24
                 "Ewaluacja dodawania zagnieżdżonego w mnożeniu - Niepoprawna ewaluacja (5+x)*3 dla x=3")

   (check-equal? (eval (der '∂ (op '+
                                   (op '* (variable) (variable))
                                   (variable))) 5) 11
                 "Ewaluacja wyrażenia zagnieżdżonego w pochodnej - Niepoprawna ewaluacja (x+x*x)' dla x=5")

   (check-equal? (eval (op '+
                           (op '* (const 2) (variable))
                           (der '∂ (variable))) 10) 21
                 "Ewaluacja pochodnej zagnieżdżonej w wyrażeniu - Niepoprawna ewaluacja 2x+x' dla x=10")
   (check-equal? (eval (der '∂ (der '∂ (op '+ (op '* (variable) (variable))
                 (variable)))) 123456789) 2
                 "Ewaluacja pochodnej zagnieżdżonej w pochodnej - Niepoprawna ewaluacja (x+x*x)''")

   (check-equal? (eval (op '+
                           (op '* (const 2) (variable))
                           (der '∂ (op '+
                                       (op '* (variable) (variable))
                                       (variable)))) 3) 13
                 "Ewaluacja skomplikowanego wyrażenia z polecenia - Niepoprawna ewaluacja 2x+(x*x+x)' dla x=3")

   (check-equal? (eval (der '∂ (op '+
                                   (op '* (const 2) (variable))
                                   (der '∂ (op '+
                                               (op '* (variable) (variable))
                                               (variable))))) 7) 4
                 "Ewaluacja pochodnej zagnieżdżonej w długiej pochodnej - Niepoprawna ewaluacja (2x+(x*x+x)')' dla x=7") 
   ))

(run-test abstr-synt-tests)
(run-test evaluator-tests)