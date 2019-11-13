#lang racket

#|
Krzysztof Łyskawa
Pracownia 9
Współpracownicy: Krzysztof Lis, kod ze skosa
|#

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
  (cond [(true? e) true]
        [(false? e) false]
        [(var? e) (get-mem e m)]
        [(op? e)
         (apply
          (op->proc (op-op e))
          (map (lambda (x) (eval-arith x m))
               (op-args e)))]
        [(const? e) e]))

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



(define (old-eval e m)

  (define (eval-arith-with-state e m)
    (lambda (seed)
      (cond [(true? e) (res true seed)]
            [(false? e) (res false seed)]
            [(var? e) (res (get-mem e m) seed)]
            [(op? e)
             (let ((result ((apply
                             ((curry st-app) (op->proc (op-op e)))
                             (map (lambda (x) (eval-arith-with-state x m))
                                  (op-args e))) seed)))
               (if (not (eq? (op-op e) 'rand))
                   result
                   ((car result) (cdr result))))]
            [(const? e) (res e seed)])))

  (lambda (seed)
    (cond [(assign? e)
           (let ((eval-processed ((eval-arith-with-state (assign-expr e) m) seed)))
             (res (set-mem
                   (assign-var e)
                   (res-val eval-processed)
                   m)
                  (res-state eval-processed)))]
          [(if? e)
           (let ((eval-processed ((eval-arith-with-state (while-cond e) m) seed)))
             (if (res-val eval-processed)
                 ((old-eval (if-then e) m) (res-state eval-processed))
                 ((old-eval (if-else e) m) (res-state eval-processed))))]
          [(while? e)
           (let ((eval-processed ((eval-arith-with-state (while-cond e) m) seed)))
             (if (res-val eval-processed)
                 (let ((while-expr-processed
                        ((old-eval (while-expr e) m)
                         (res-state eval-processed))))
                   ((old-eval e (res-val while-expr-processed)) (res-state while-expr-processed)))
                 (res m (res-state eval-processed))))]
          [(block? e)
           (if (null? e)
               (res m seed)
               (let ((car-processed ((old-eval (car e) m) seed)))
                 ((old-eval (cdr e) (res-val car-processed)) (res-state car-processed))))])))
  
(define (eval e m seed)
  (res-val ((old-eval e m) seed)))

(define (run e)
  (eval e empty-mem initial-seed))

;;
 
(define fermat-test
  '( (composite := false)
     (if (or (= n 3)
             (= n 2))
         (composite := false)
         (while (and (> k 0)
                     (not composite))
                ( (a := (+ (rand (- n 3)) 2))
                  (m := (- n 2))
                  (b := a)
                  (while (> m 0)
                         ( (b := (* b a))
                           (while (>= b n)
                                  (b := (- b n))
                                  )
                           (m := (- m 1))
                           )
                         )      
                  (k := (- k 1))
                  (if (= b 1)
                      (composite := false)
                      (composite := true)
                  )
                  )
                )
         )
     )
)
            
  

(define (probably-prime? n k) ; check if a number n is prime using
                              ; k iterations of Fermat's primality
                              ; test
  (let ([memory (set-mem 'k k
                (set-mem 'n n empty-mem))])
    (not (get-mem
           'composite
           (eval fermat-test memory initial-seed)))))

(define (fun x y z)
    (x y z))

(define prime10
  '( (prime := 3)
     (sum := 2)
     (i := 1)
     (while (< i 10)
       ( (k := 3)
         (while (<= (* k k) prime)
                ( (m := prime)
                  (while (<= 0 m)
                         (if (= m 0)
                             ( (k := (+ prime 1))
                               (m := (- m 1)) )
                             (m := (- m k)) ))
                  (k := (+ k 2)) ))
         (if (= k (+ prime 3))
             (prime := (+ prime 2))
             ( (i := (+ i 1))
               (sum := (+ sum prime))
               (prime := (+ prime 2)) ))))))

(define (test-gen test-num range)
  (define (test test-num number)
    (probably-prime? number test-num))

  (define (help test-num range)
    (if (= range 1)
        null
        (cons (test test-num range) (test-gen test-num (- range 1)))))
  (reverse (help test-num range))
)

(define (test-summary range test-num)
  (display "Among the first ")
  (display range)
  (display " natural numbers, there is no less than ")
  (display (count (lambda (x) (eq? x #t)) (test-gen test-num range)))
  (display " primes."))