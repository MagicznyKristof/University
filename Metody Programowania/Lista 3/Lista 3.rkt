#lang racket

;Zad 1
(define (make-rat num den)
  (cons num den))

(define (rat-num x)
  (car x))

(define (rat-den x)
  (cdr x))

(define (rat? x)
  (and (pair? x) (integer? (car x)) (integer? (cdr x))))

;Zad 4

(define (reverse-rec xs)
  #|
  (define (app l1 l2)
        (if (null? l1)
            l2
            (cons (car l1) (app (cdr l1) l2))));|#
  (if (null? xs)
      null
      (append (reverse-rec (cdr xs)) (list (car xs))))
)



(define (reverse-iter xs)
  (define (rev-acc list acc)
    (if (null? list)
        acc
        (rev-acc (cdr list) (cons (car list) acc))))
  (rev-acc xs null)
)

;; Zadanie 5
(define (insert xs n)
  (cond [(null? xs) (cons n null)]
        [(< n (car xs)) (cons n xs)]
        [else (cons (car xs) (insert (cdr xs) n))]
  )
)

(define (insert-sort xs)
  (define (insert-sort-acc xs acc)
    (if (null? xs) acc
        (insert-sort-acc (cdr xs) (insert acc (car xs)))))
  (insert-sort-acc xs null)
)

;; Zadanie 6

(define (insert-at xs elem n)
  (if (= n 1)
      (cons elem xs)
      (cons (car xs) (insert-at (cdr xs) elem (- n 1)))))

(define (permi xs)
  ;;; dla każdego elementu pierwszej listy tworzy każdą jej permutację z elem
  (define (perm l elem n)
    (if (= n 0)
        null
        (cons (insert-at l elem n) (perm l elem (- n 1)))
    )
  )
  ;;; dla każdej uzyskanej dotąd permutacji tworzy wszystkie jej permutacje z 'elem'
  (define (perm-all ll n elem)
    (if (< n 1)
        null
        (append (perm (car ll) elem (+ (length (car ll)) 1))
                (perm-all (cdr ll) (if (null? (cdr ll)) 0 n) elem)
        )
     )
   )
  ;;; główne wywołanie
  (if (null? xs)
      (cons null null)
      (perm-all (permi (cdr xs)) (length xs) (car xs))
  )
)
