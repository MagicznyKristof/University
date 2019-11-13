#lang racket

#|
Krzysztof Łyskawa
Pracownia 13
Współpracownicy: Krzysztof Lis, kod ze skosa
|#

(require racklog)

;; transpozycja tablicy zakodowanej jako lista list
(define (transpose xss)
  (cond [(null? xss) xss]
        ((null? (car xss)) (transpose (cdr xss)))
        [else (cons (map car xss)
                    (transpose (map cdr xss)))]))

;; procedura pomocnicza
;; tworzy listę n-elementową zawierającą wyniki n-krotnego
;; wywołania procedury f
(define (repeat-fn n f)
  (if (eq? 0 n) null
      (cons (f) (repeat-fn (- n 1) f))))

;; tworzy tablicę n na m elementów, zawierającą świeże
;; zmienne logiczne
(define (make-rect n m)
  (repeat-fn m (lambda () (repeat-fn n _))))

;; predykat binarny
;; (%row-ok xs ys) oznacza, że xs opisuje wiersz (lub kolumnę) ys
(define %row-ok
  (%rel (h t num nums out)
        [(null null) !]
        [(null (cons '* t)) ! %fail]
        [(null (cons '_ t)) ! (%row-ok null t)]
        [((cons num nums) null) ! %fail]
        [((cons num nums) (cons '* t))
         !
         (%num-ok num (cons '* t) out)
         (%row-ok nums out)]
        [((cons num nums) (cons '_ t)) ! (%row-ok (cons num nums) t)]
        ))

(define %num-ok
  (%rel (num h t t-out new-num)
        [(0 null null)]
        [(num null (_)) %fail]
        [(0 (cons '* t) (_)) %fail]
        [(0 (cons '_ t) t)]
        [(num (cons '_ t) (_)) %fail]
        [(num (cons '* t) t-out)
         (%is new-num (- num 1))
         (%num-ok new-num t t-out)]
        ))
;; sprawdza poprawność cwszystkich wierszy
(define %board-ok
  (%rel (r1 rs row rows)
        ;; (rows, board)
        [(null null)]
        [(null (cons (_) (_))) %fail]
        [((cons (_) (_)) null) %fail]
        [((cons r1 rs) (cons row rows))
         (%row-ok r1 row)
         (%board-ok rs rows)])) 


;; funkcja rozwiązująca zagadkę
(define (solve rows cols)
  (define board (make-rect (length cols) (length rows)))
  (define tboard (transpose board))
  
  ;; generuje wiersze dla tablicy
  (define %gen-rows
    (%rel (h t l board row rows)
          ;; (rows, l, board) 
          [(null (_) null)]
          [((cons h t) l board)
           (%gen-row l 0 h row)
           (%gen-rows t l rows) 
           (%is board (cons row rows))]
          ))
          
  
  ;; generuje wszystkie możliwe wiersze
  (define %gen-row
    (%rel (l nums iter row new-iter new-l)
          [(0 (_) (_) (_)) %fail]
          [(l iter nums row)
           (%gen-row-for-fixed-iter l iter nums row)]
          [(l iter nums row)
           (%is #t (> l 0))
           (%is #f (null? nums))
           (%is new-iter (+ iter 1))
           (%is new-l (- l 1))
           (%gen-row new-l new-iter nums row)])) 


  ;; generuje wiersz dla ustalonych odstępów między gwiazdkami
  (define %gen-row-for-fixed-iter
    (%rel (l h t iter row sub-row out_ out* new-l)
          ; lista argumentów to (len, iter, nums, output)
          [(0 (_) null null)] ;
          [(0 (_) (cons (_) (_)) (_)) %fail]
          [(l (_) null row)
           (%is #t (> l 0))
           (%gen-symb l '_ row)]
          [(l iter (cons h t) row)
           (%is #t (>= l (+ (apply + t) (length t) h)))
           (%gen-symb iter '_ out_)
           (%gen-symb h '* out*)
           (%is new-l (if (= (- l h) 0) 0 (- l h 1)))
           (%gen-row new-l 0 t sub-row)
           (%is row (append out_ out* (if (= (- l h) 0) null (list '_)) sub-row))]
          ))

  (define %gen-symb ;; generuje tablicę podanych symboli o danej długości
    (%rel (len symb out new-len)
          [(0 (_) null)]
          [(len symb (cons symb out))
           (%is #t (> len 0))
           (%is new-len (- len 1))
           (%gen-symb new-len symb out)]
          ))
  
  (define ret (%which (xss trans-xss) 
                      (%= xss board)
                      (%gen-rows rows (length cols) xss)
                      (%is trans-xss (transpose xss))
                      (%board-ok cols trans-xss)
                      ))

  
           
  (and ret (cdar ret))
  )




;; testy
(equal? (solve '((2) (1) (1)) '((1 1) (2)))
        '((* *)
          (_ *)
          (* _)))

(equal? (solve '((2) (2 1) (1 1) (2)) '((2) (2 1) (1 1) (2)))
        '((_ * * _)
          (* * _ *)
          (* _ _ *)
          (_ * * _)))
;; TODO: możesz dodać własne testy

(solve '((1 2) (2) (1) (1) (2) (2 4) (2 6) (8) (1 1) (2 2)) '((2) (3) (1) (2 1) (5) (4) (1 4 1) (1 5) (2 2) (2 1)))
