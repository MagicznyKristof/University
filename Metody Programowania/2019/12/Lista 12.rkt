#lang racket

(require racket/contract)
(require quickcheck)


(define/contract foo number? 42)

(define/contract (dist x y)
  (-> number? number? number?)
  (abs (- x y)))

(define/contract (average x y)
  (-> number? number? number?)
  (/ (+ x y) 2))

(define/contract (square x)
  (-> number? number?)
  (* x x))

(define (sq/c y)
  (lambda (x) (= y (* x x)))) 

(define/contract (sqrt x)
  ;(-> positive? positive?)
  (->i [(argument (and/c real? positive?))]
       [result (argument) (and/c number?
                                 (sq/c argument))])
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

(define (fulfill/c p)
  (lambda (xs) (andmap p xs)))

(define/contract (filter f? xs)
  (parametric->/c [a] (->i ([p (-> a boolean?)]
                            [l (listof a)])
                           [result (p) (and/c (fulfill/c p) (listof a))]))
  (if (null? xs)
      xs
      (if (f? (car xs))
          (cons (car xs) (filter f? (cdr xs)))
          (filter f? (cdr xs)))))

(define-signature monoid^
   ((contracted
      [elem? (-> any/c boolean?)]
      [neutral elem?]
      [oper (-> elem? elem? elem?)])))

(define-unit monoid-add@
  (import)
  (export monoid^)

  (define (elem? e) (and (integer? e)
                         (not (negative? e))))

  (define neutral 0)

  (define oper +)

  (quickcheck
    (property ([m arbitrary-natural])
              (and (= (oper m neutral) m)
                   (= (oper neutral m) m))))
  (quickcheck
    (property ([x arbitrary-natural]
               [y arbitrary-natural]
               [z arbitrary-natural])
              (= (oper (oper x y) z)
                 (oper x (oper y z)))))
                   
  )

(define-unit monoid-list@
  (import)
  (export monoid^)

  (define elem? list?)
  (define neutral '())
  (define oper append)

  (quickcheck
   (property ([m (arbitrary-list arbitrary-symbol)])
              (and (equal? (oper m neutral) m)
                   (equal? (oper neutral m) m))))
  (quickcheck
    (property ([x (arbitrary-list arbitrary-symbol)]
               [y (arbitrary-list arbitrary-symbol)]
               [z (arbitrary-list arbitrary-symbol)])
              (equal? (oper (oper x y) z)
                 (oper x (oper y z)))))
  )

(define-values/invoke-unit/infer monoid-list@)

;; Zadanie 5

(define-signature integers-set^
  ((contracted
    [is-set? (-> any/c boolean?)]
    [in-set? (-> integer? is-set? boolean?)]
    [empty is-set?]
    [singleton (-> integer? is-set?)]
    [union (-> is-set? is-set? is-set?)]
    [intersection (-> is-set? is-set? is-set?)])))

(define-unit set-on-list@
  (import)
  (export integers-set^)

  (define (is-set? a)
    (define (aux sorted-set)
      ;(let ([sorted  (sort set <)])
      (cond [(null? sorted-set) #t]
            [(> 2 (length sorted-set)) #t]
            [else (and (not (= (car sorted-set) (cadr sorted-set)))
                       (aux (cdr sorted-set))) #f]))
    (and (list? a)
         (andmap integer? a)
         (aux (sort a <))))

  (define in-set? member)
  (define empty '())
  (define singleton list)
  (define (union a b)
    (if (null? a)
        b
        (if (member (car a) b)
            (union (cdr a) b)
            (cons (car a) (union (cdr a) b)))))
  
  (define (intersection a b)
    (if (null? a)
        b
        (if (member (car a) b)
            (cons (car a) (union (cdr a) b))
            (union (cdr a) b))))

  (quickcheck
   (property ([n arbitrary-integer]
              [m arbitrary-integer])
             (let ((a (singleton n)))
               (if (not (= m n))
                   (and (in-set? n a)
                        (not (in-set? m a)))
                   (in-set? m a)))))

  (define arbitrart-set

  (quickcheck
   (property ([xs (arbitrart-list arbitrary-integer)]
              [ys (arbitrart-list arbitrary-integer)])
             (let* ([a (foldl (lambda (x y) (union (singleton x) y)) empty xs)]
                    [b (foldl (lambda (x y) (union (singleton x) y)) empty ys)]
                    [c (union a b)])
               (andmap (lambda (i) (or (in-set? i a) (in-set? i b)))))))
  
  

