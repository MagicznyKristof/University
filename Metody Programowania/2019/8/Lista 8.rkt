#lang racket
#|
(define (list->cycle xs)
  (define (cycle ...)
    )
  (define (list->mlist xs)
    (if (null? xs)
        null
        (mcons (car xs) (list->mlist (cdr xs)))))
  (if (null? xs)
      null
      (let ((mxs (list->mlist xs)))
        (begin (cycle mxs) mxs))))


(define (set-nth! n xs v)
  (if (= n 0)
      (set-mcar! xs v)
      (set-nth! (- x 1) (mcdr xs) v)))
               |#


(provide (all-defined-out))

;; definicja wyrażeń z let-wyrażeniami i if-wyrażeniami

(struct variable (x)         #:transparent)
(struct const    (val)       #:transparent)
(struct op       (symb l r)  #:transparent)
(struct let-expr (x e1 e2)   #:transparent)
(struct if-expr  (b t e)     #:transparent)

(define (expr? e)
  (match e
    [(variable s)       (symbol? s)]
    [(const n)          (or (number? n)
                            (boolean? n))]
    [(op s l r)         (and (member s '(+ *))
                             (expr? l)
                             (expr? r))]
    [(let-expr x e1 e2) (and (symbol? x)
                             (expr? e1)
                             (expr? e2))]
    [(if-expr b t e)    (andmap expr? (list b t e))]
    [_                  false]))

;; definicja instrukcji w języku WHILE

(struct skip      ()        #:transparent) ; skip
(struct comp      (s1 s2)   #:transparent) ; s1; s2
(struct assign    (x e)     #:transparent) ; x := e
(struct while     (b s)     #:transparent) ; while (b) s
(struct if-stm    (b t e)   #:transparent) ; if (b) t else e
(struct var-block (x e s)   #:transparent) ; var x := e in s
(struct -- (x)              #:transparent)
(struct ++ (x)              #:transparent)
(struct for (x e1 e2 s1 s2) #:transparent)

(define (stm? e)
  (match e
    [(skip) true]
    [(comp s1 s2)   (and (stm? s1) (stm? s2))]
    [(assign x e)   (and (symbol? x) (expr? e))]
    [(while b s)    (and (expr? b) (stm? s))]
    [(if-stm b t e) (and (expr? b) (stm? t) (stm? e))]
    [_ false]))
  
;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
;; dwuelementowych list

(define (lookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

;; aktualizacja środowiska dla danej zmiennej (koniecznie już
;; istniejącej w środowisku!)

(define (update x v xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x)
     (cons (list (caar xs) v) (cdr xs))]
    [else
     (cons (car xs) (update x v (cdr xs)))]))

;; kilka operatorów do wykorzystania w interpreterze

(define (op-to-proc x)
  (lookup x `((+ ,+)
              (* ,*)
              (- ,-)
              (/ ,/)
              (%, modulo)
              (> ,>)
              (>= ,>=)
              (< ,<)
              (<= ,<=)
              (= ,=)
              (!= ,(lambda (x y) (not (= x y)))) 
              (&& ,(lambda (x y) (and x y)))
              (|| ,(lambda (x y) (or x y)))
              )))

;; interfejs do obsługi środowisk

(define (env-empty) null)
(define env-lookup lookup)
(define (env-add x v env) (cons (list x v) env))
(define env-update update)
(define env-discard cdr)
(define (env-from-assoc-list xs) xs)

;; ewaluacja wyrażeń ze środowiskiem

(define (eval e env)
  (match e
    [(const n) n]
    [(op s l r) ((op-to-proc s) (eval l env)
                                (eval r env))]
    [(let-expr x e1 e2)
     (let ((v1 (eval e1 env)))
       (eval e2 (env-add x v1 env)))]
    [(variable x) (env-lookup x env)]
    [(if-expr b t e) (if (eval b env)
                         (eval t env)
                         (eval e env))]))

;; interpretacja programów w języku WHILE, gdzie środowisko m to stan
;; pamięci. Interpreter to procedura, która dostaje program i początkowy
;; stan pamięci, a której wynikiem jest końcowy stan pamięci. Pamięć to
;; aktualne środowisko zawierające wartości zmiennych

(define (interp p m)
  (match p
    [(skip) m]
    [(comp s1 s2) (interp s2 (interp s1 m))]
    [(assign x e)
     (env-update x (eval e m) m)]
    [(while b s)
     (if (eval b m)
         (interp p (interp s m))
         m)]
    [(var-block x e s)
     (env-discard
       (interp s (env-add x (eval e m) m)))]
    [(if-stm b t e) (if (eval b m)
                        (interp t m)
                        (interp e m))]
    [(-- x) (env-update x (- (eval x m) 1) m)]
    [(++ x) (env-update x (+ (eval x m) 1) m)]
    [(for x e1 e2 s1 s2) (interp (var-block x e1
                                 (while e2 (comp s2 s1))))]
     ))

;; silnia zmiennej i

(define fact-in-WHILE
  (var-block 'x (const 0)                                           ; var x := 0 in
     (comp (assign 'x (const 1))                                    ;   x := 1
     (comp (while (op '> (variable 'i) (const 0))                   ;   while (i > 0)
              (comp (assign 'x (op '* (variable 'x) (variable 'i))) ;     x := x * i
                    (assign 'i (op '- (variable 'i) (const 1)))))   ;     i := i - 1
           (assign 'i (variable 'x))))))                            ;   i := x

(define (factorial n)
  (env-lookup 'i (interp fact-in-WHILE
                         (env-from-assoc-list `((i ,n))))))

;; najmniejsza liczba pierwsza nie mniejsza niż i

(define find-prime-in-WHILE
 (var-block 'c (variable 'i)                                         ; var c := i in
 (var-block 'continue (const true)                                   ; var continue := true in
 (comp
  (while (variable 'continue)                                        ; while (continue)
   (var-block 'is-prime (const true)                                 ;   var is-prime := true in
   (var-block 'x (const 2)                                           ;   var x := 2 in
    (comp
     (while (op '&& (variable 'is-prime)                             ;   while (is-prime &&
                    (op '< (variable 'x) (variable 'c)))             ;            x < c)
        (comp (if-stm (op '= (op '% (variable 'c) (variable 'x))     ;     if (c % x =
                             (const 0))                              ;                 0)
                      (assign 'is-prime (const false))               ;       is-prime := false
                      (skip))                                        ;     else skip
              (assign 'x (op '+ (variable 'x) (const 1)))))          ;     x := x + 1 
     (if-stm (variable 'is-prime)                                    ;   if (is-prime)
             (assign 'continue (const false))                        ;     continue := false
             (comp (assign 'continue (const true))                   ;   else continue := true
                   (assign 'c (op '+ (variable 'c) (const 1))))))))) ;        c := c + 1
  (assign 'i (variable 'c))))))                                      ; i := c

(define (find-prime-using-WHILE n)
  (env-lookup 'i (interp find-prime-in-WHILE
                         (env-from-assoc-list `((i ,n) (is-prime ,true))))))          

;; porownajmy wydajnosc!

;; ten sam algorytm do wyszukiwania liczby pierwszej nie mniejszej niż n
;; zapisany funkcyjnie jest dosc brzydki, ale odpowiada temu zapisanemu w WHILE

(define (find-prime-native n)
  (define (is-prime c isp x)
    (if (and isp (< x c))
      (if (= (modulo c x) 0)
          (is-prime c false (+ x 1))
          (is-prime c isp   (+ x 1)))
      isp))
  (if (is-prime n true 2)
      n
      (find-prime-native (+ n 1))))

;; testujemy, żeby dowiedzieć się, jak dużo wydajności tracimy przez
;; uruchamianie programu w naszym interpreterze

(define (test)
  (begin
    (display "wait...\n")
    (flush-output (current-output-port))
    (test-performance)))

(define (test-performance)
  (let-values
      (((r1 cpu1 real1 gc1) (time-apply find-prime-using-WHILE (list 1111111)))
       ((r2 cpu2 real2 gc2) (time-apply find-prime-native      (list 1111111))))
    (begin
      (display "WHILE  time (cpu, real, gc): ")
      (display cpu1)  (display ", ")
      (display real1) (display ", ")
      (display gc1)   (display "\n")
      (display "native time (cpu, real, gc): ")
      (display cpu2)  (display ", ")
      (display real2) (display ", ")
      (display gc2)   (display "\n"))))

(define and-WHILE
  (var-block 'first (op '&& (const 1) (const 1)) (skip)))

(define fibb-WHILE
  (var-block 'first (const 0)
  (var-block 'second (const 1)
  (var-block 'next (const 0)
  (comp
   (while (op '> (variable 'n) (const 0))
          (comp
           (assign 'next (op '+
                             (variable 'first)
                             (variable 'second)))
           (comp (assign 'first (variable 'second))
                 (comp (assign 'second (variable 'next))
                       (assign 'n (op '+ (variable 'n) (const 1)))))))
   (assign 'n (variable 'next)))))))

(define fibb-FOR
  (var-block 'first (const 0)
  (var-block 'second (const 1)
  (var-block 'next (const 0)
  (comp
   (for 'i (const 0) (op '< (variable 'i) (variable 'n))
        (++ (variable 'i))
        (comp
         (assign 'next (op '+
                           (variable 'first)
                           (variable 'second)))
         (comp (assign 'first (variable 'second))
               (assign 'second (variable 'next)))))
   (assign 'n (variable 'next)))))))

(define (n-queens-in-WHILE n)
  (define (n-var-block rest n)
    (if (= n 0)
        (var-block 'done (const false) rest)
        (var-block (gen-symbol 'x n) (const 0) (n-var-block rest (- n 1)))))
  (define (amps k m)
    (if (= k (- m 1))
        (op '&& (op '!= (variable (gen-symbol 'y k))
                        (variable (gen-symbol 'y (- k 1))))
                (op '!= (abs (op '- (gen-symbol 'y k) (gen-symbol 'y (- k 1))))
                        (abs (op '- (const k) (op '- (const k) (const 1))))))
        (op '&& (op '&& (op '!= (variable (gen-symbol 'y k))
                                (variable (gen-symbol 'y (- k 1))))
                        (op '!= (abs (op '- (gen-symbol 'y k) (gen-symbol 'y (- k 1))))
                                (abs (op '- (const k) (op '- (const k) (const 1))))))
            (amps k (+ m 1)))))
                        
  (define (loops m)
    (if (= m 1)
        (for-stm (gen-symbol 'y m) (const 1) (op '&& (op '<=
                                                         (variable (gen-symbol 'y m))
                                                         (const n))
                                                 (not (variable 'done)))
                 (assign (gen-symbol 'y m) (op '+ (gen-symbol 'y m)
                                               (const 1)))
                 (if-stm (const true) (loops (+ m 1)) (skip)))
        (for-stm (gen-symbol 'y m) (const 1)
