#lang racket

#|
Pracownia 3
Krzysztof Łyskawa
|#

(define (reverse xs)
  (define (rev-acc list acc)
    (if (null? list)
        acc
        (rev-acc (cdr list) (cons (car list) acc))))
  (rev-acc xs null)
)

(define (merge xs ys)
  (define (merge-iter xs ys acc)
    (cond [(and (null? xs) (null? ys)) acc]
          [(null? xs) (merge-iter xs (cdr ys) (cons (car ys) acc))]
          [(null? ys) (merge-iter (cdr xs) ys (cons (car xs) acc))]
          [else (if (< (car xs) (car ys))
                    (merge-iter (cdr xs) ys (cons (car xs) acc))
                    (merge-iter xs (cdr ys) (cons (car ys) acc)))]))
  (reverse (merge-iter xs ys null)))


(define (split xs)
  (define (splitting xs acc to-split)
    (if (= to-split 0)
        (cons (reverse acc) (list xs))
        (splitting (cdr xs) (cons (car xs) acc) (- to-split 1))))
    (splitting xs null (quotient (length xs) 2)))

(define (merge-sort xs)
  (define (splitter xs)
    (if (= (length xs) 1)
        xs
        (let ((splitted (split xs)))
          (cons (splitter (first splitted)) (list (splitter (second splitted)))))))
  (define (merger xs)
    (cond [(and (list? xs) (= (length xs) 2))
           (merge (merger (first xs)) (merger (second xs)))]
          [else xs]))
  (if (null? xs)
      null
      (merger (splitter xs))))

(writeln '(merge testing))
(merge null null)
(merge null '(1 2 3))
(merge '(1 2 3) null)
(merge '(1 1 1 1 1) '(1 1 1 1))
(merge '(1) '(2))
(merge '(1 2 3) '(4 5 6))
(merge '(1 4 8 31) '(2 8 11 43))
(merge '(1 2 3) '(1 2 3))

; split nigdy nie powinien zostać wywołany dla listy długości
; krótszej niż 2, więc nie testuję takich przypadków
(newline)
(writeln '(split testing))
(split '(1 2 3 4 5 6))
(split '(1 1 1 1 1))
(split '(6 5 4 3 2 1))
(split '(8 1))

(newline)
(writeln '(merge-sort testing))
(merge-sort null)
(merge-sort '(1))
(merge-sort '(1 2))
(merge-sort '(2 1))
(merge-sort '(1 2 3))
(merge-sort '(3 2 1))
(merge-sort '(1 3 6 9 2 8 5 4 7))
(merge-sort '(1 1 1 1 1 1 1))
(merge-sort '(2 2 2 2 1 1 1))
(merge-sort '(1 2 1 2 1 2 1))
(merge-sort '(2 1 2 1 2 1 2))


