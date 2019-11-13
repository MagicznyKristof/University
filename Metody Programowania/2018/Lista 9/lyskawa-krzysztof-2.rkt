#lang racket

;; pomocnicza funkcja dla list tagowanych o określonej długości

(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))

;;
;; WHILE
;;

; memory

(define empty-mem
  null)

(define (set-mem x v m)
  (cond [(null? m)
         (list (cons x v))]
        [(eq? x (caar m))
         (cons (cons x v) (cdr m))]
        [else
         (cons (car m) (set-mem x v (cdr m)))]))

(define (get-mem x m)
  (cond [(null? m) 0]
        [(eq? x (caar m)) (cdar m)]
        [else (get-mem x (cdr m))]))

; arith and bool expressions: syntax and semantics

(define (const? t)
  (number? t))

(define (true? t)
  (eq? t 'true))

(define (false? t)
  (eq? t 'false))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= not and or mod rand))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]
        [(eq? op '=) =]
        [(eq? op '>) >]
        [(eq? op '>=) >=]
        [(eq? op '<)  <]
        [(eq? op '<=) <=]
        [(eq? op 'not) not]
        [(eq? op 'and) (lambda x (andmap identity x))]
        [(eq? op 'or) (lambda x (ormap identity x))]
        [(eq? op 'mod) modulo]
        [(eq? op 'rand) (lambda (max) (lambda (seed) ((rand max) seed)))]))


(define (var? t)
  (symbol? t))

(define (eval-arith e m)

  ;; wylicza wyrażenie zmieniając stan
  (define eval-op
    (lambda (seed)
      (let* ((op-op-e (op-op e))
             (applied (apply
                  (op->proc op-op-e)
                  (map (lambda (x) ((eval-arith x m) seed))
                       (op-args e)))))
        (if (eq? op-op-e 'rand)
            (applied seed)
            (res applied seed)))))

            
  (lambda (seed)
    (cond [(true? e)    (res true seed)]
          [(false? e)   (res false seed)]
          [(var? e)     (res (get-mem e m) seed)]
          [(op? e)      (eval-op seed)]
          [(const? e)   (res e seed)])))

;; syntax of commands

(define (assign? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (second t) ':=)))

(define (assign-var e)
  (first e))

(define (assign-expr e)
  (third e))

(define (if? t)
  (tagged-tuple? 'if 4 t))

(define (if-cond e)
  (second e))

(define (if-then e)
  (third e))

(define (if-else e)
  (fourth e))

(define (while? t)
  (tagged-tuple? 'while 3 t))

(define (while-cond t)
  (second t))

(define (while-expr t)
  (third t))

(define (block? t)
  (list? t))

;; st-app


(define (st-app f . xs)
  (define (st-iter acc i xs)
    (if (null? xs)
        (cons (reverse acc) i)
        (let ((rx ((car xs) i)))
          (st-iter (cons (res-val rx) acc) (res-state rx) (cdr xs)))))
  (lambda (i)
    (let ((result (st-iter null i xs)))
      (res (apply f (car result)) (cdr result))))) 

;; state

(define (res v s)
  (cons v s))

(define (res-val r)
  (car r))

(define (res-state r)
  (cdr r))

;; psedo-random generator

(define initial-seed
  123456789)

(define (rand max)
  (lambda (i)
    (let ([v (modulo (+ (* 1103515245 i) 12345) (expt 2 32))])
      (res (modulo v max) v))))

;; WHILE interpreter
#|
(define (old-eval e m)
  (cond [(assign? e)
         (set-mem
          (assign-var e)
          (eval-arith (assign-expr e) m)
          m)]
        [(if? e)
         (if (eval-arith (if-cond e) m)
             (old-eval (if-then e) m)
             (old-eval (if-else e) m))]
        [(while? e)
         (if (eval-arith (while-cond e) m)
             (old-eval e (old-eval (while-expr e) m))
             m)]
        [(block? e)
         (if (null? e)
             m
             (old-eval (cdr e) (old-eval (car e) m)))]))
;|#

(define (eval e m seed)
  (define (help e m)
    (lambda (seed)
      (cond [(assign? e)
             (set-mem
              (assign-var e)
              ((eval-arith (assign-expr e) m) seed)
              m)]
            [(if? e)
             (if ((eval-arith (if-cond e) m) seed)
                 ((help (if-then e) m) seed)
                 ((help (if-else e) m) seed))]
            [(while? e)
             (if ((eval-arith (while-cond e) m) seed)
                 ((help e ((help (while-expr e) m) seed)) seed)
                 m)]
            [(block? e)
             (if (null? e)
               m
               ((help (cdr e) ((help (car e) m) seed)) seed))])))
    
  ((help e m) seed))

(define (run e)
  (eval e empty-mem initial-seed))

;;

(define fermat-test
  '{} ;; TODO : ZAD A: Zdefiniuj reprezentację programu w jęzku
      ;;        WHILE, który wykonuje test Fermata, zgodnie z
      ;;        treścią zadania. Program powinien zakładać, że
      ;;        uruchamiany jest w pamięci, w której zmiennej
      ;;        n przypisana jest liczba, którą testujemy, a
      ;;        zmiennej k przypisana jest liczba iteracji do
      ;;        wykonania. Wynik powinien być zapisany w
      ;;        zmiennej comopsite. Wartość true oznacza, że
      ;;        liczba jest złożona, a wartość false, że jest
      ;;        ona prawdopodobnie pierwsza.
  )

(define (probably-prime? n k) ; check if a number n is prime using
                              ; k iterations of Fermat's primality
                              ; test
  (let ([memory (set-mem 'k k
                (set-mem 'n n empty-mem))])
    (not (get-mem
           'composite
           (eval fermat-test memory initial-seed)))))


(define test
  '((x := 1000)
    (i := (rand x))
    (j := (rand i))
    (k := (rand j))
    ))