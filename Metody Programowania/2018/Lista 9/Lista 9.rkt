#lang racket

;; Idiom stanowy

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

(define (node l r)
  (list 'node l r))

(define (node? n)
  (tagged-tuple? 'node 3 n))

(define (node-left n)
  (second n))

(define (node-right n)
  (third n))

(define (leaf? n)
  (or (symbol? n)
      (number? n)
      (null? n)))

;;

(define (res v s)
  (cons v s))

(define (res-val r)
  (car r))

(define (res-state r)
  (cdr r))

;;

(define (rename t)
  (define (rename-st t i)
    (cond [(leaf? t) (res i (+ i 1))]
          [(node? t)
           (let* ([rl (rename-st (node-left t) i)]
                  [rr (rename-st (node-right t) (res-state rl))])
             (res (node (res-val rl) (res-val rr))
                  (res-state rr)))]))
  (res-val (rename-st t 0)))

;;
;;Zadanie 1
(define (st-app f . xs)
  (define (st-iter acc i xs)
    (if (null? xs)
        (cons (reverse acc) i)
        (let ((rx ((car xs) i)))
          (st-iter (cons (res-val rx) acc) (res-state rx) (cdr xs)))))
  
  (lambda (i)
    (let ((result (st-iter null i xs)))
      (res (apply f (car result)) (cdr result))))) 
    
;(define (st-app f x y)
;  (lambda (i)
;    (let* ([rx (x i)]
;           [ry (y (res-state rx))])
;      (res (f (res-val rx) (res-val ry))
;           (res-state ry)))))

(define get-st
  (lambda (i)
    (res i i)))

(define (modify-st f)
  (lambda (i)
    (res null (f i))))

;;

(define (inc n)
  (+ n 1))



(define (rename2 t)
  (define (rename-st t) ;; zwraca parę (res val state)
    (cond [(leaf? t)
           (st-app (lambda (x y) x)   ;; wykonuje operacje na argumentach. Operuje na res-val
                   get-st             ;; zwraca (res i i)
                   (modify-st inc))]  ;; zwraca (res null (f i)). Operuje na res-state
          [(node? t)
           (st-app node
                   (rename-st (node-left  t)) 
                   (rename-st (node-right t)))]))
  (res-val ((rename-st t) 0)))

;;obsługa pętli WHILE

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

; arith and bools

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <=))))

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
        [(eq? op '<=) <=]))

#|

(define (inc-op? t)
  (and (list? t)
       (not (null? t))
       (member (cdr t) '(++ --))))

(define (inc-op-op e)
  (second e))

(define (inc-op-arg e)
  (first e))

(define (inc-op-proc e)
  (cond [(eq? (inc-op-op e) '++) (+ (inc-op-arg e) 1)]
        [(eq? (inc-op-op e) '--) (- (inc-op-arg e) 1)]))

|#

(define (var? t)
  (symbol? t))

(define (eval-arith e m)
  (cond [(var? e) (get-mem e m)]
        [(op? e)
         (apply
          (op->proc (op-op e))
          (map (lambda (x) (eval-arith x m))
               (op-args e)))]
       ; [(inc-op? e)
        ; (inc-op-proc e)]
        [(const? e) e]))

;;

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

;;

(define (eval e m)
  (cond [(assign? e)
         (set-mem
          (assign-var e)
          (eval-arith (assign-expr e) m)
          m)]
        [(if? e)
         (if (eval-arith (if-cond e) m)
             (eval (if-then e) m)
             (eval (if-else e) m))]
        [(while? e)
         (if (eval-arith (while-cond e) m)
             (eval e (eval (while-expr e) m))
             m)]
        [(block? e)
         (if (null? e)
             m
             (eval (cdr e) (eval (car e) m)))]))

(define (run e)
  (eval e empty-mem))

;;

(define fact10
  '( (i := 10)
     (r := 1)
     (while (> i 0)
       ( (r := (* i r))
         (i := (- i 1)) ))))

(define (computeFact10)
  (run fact10))

;; Generator liczb pseudolosowych

(define (rand max)
  (lambda (i)
    (let ([v (modulo (+ (* 1103515245 i) 12345) (expt 2 32))])
      (res (modulo v max) v)))) ;; zwraca rand i new-seed


;; Zadanie 2


;(define (st-app f . xs)
;  (define (st-iter acc i xs)
;    (if (null? xs)
;        (cons (reverse acc) i)
;        (let ((rx ((car xs) i)))
;          (st-iter (cons (res-val rx) acc) (res-state rx) (cdr xs)))))
;  
;  (lambda (i)
;    (let ((result (st-iter null i xs)))
;      (res (apply f (car result)) (cdr result))))) 

(define (rename3 t)
  (define (rename-st t)
    (cond [(leaf? t)
           (st-app (lambda (x) x)
                  (rand (random 10000)))]
          [(node? t)
           (st-app node
                   (rename-st (node-left  t))
                   (rename-st (node-right t)))]))
  (res-val ((rename-st t) (random 10000))))

(define (get-and-modify f)
  (lambda (i) (cons i (f i))))

(define fib
  (lambda (i) (cons (cdr i) (+ (car i) (cdr i)))))

(define inc2
  (lambda (i) (cons (+ (car i) 1) (+ (cdr i) 1))))
           

(define (rename4 t)
  (define (rename-st t) ;; zwraca parę (res val state)
    (cond [(leaf? t)
           (st-app (lambda (x y z) x)
                   get-st             
                   get-st
                   (modify-st fib))]  
          [(node? t)
           (st-app node
                   (rename-st (node-left  t)) 
                   (rename-st (node-right t)))]))
  (res-val ((rename-st t) (cons 0 1))))

;; Zadanie 3

(define fib10
  '( (i := 1)
     (fib-n-2 := 0)
     (fib-n-1 := 0)
     (fib-n := 1)
     (while (< i 10)
       ( (fib-n-2 := fib-n-1)
         (fib-n-1 := fib-n)
         (fib-n := (+ fib-n fib-n-2))
         (i := (+ i 1)) ))))

(define (fib-counter)
  (run fib10))


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

(define (prime-sum)
  (run prime10))

;; Zadanie 4 (źle xD)

(define (get-values prog)
    (map car (run prog)))

