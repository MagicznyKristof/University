#lang racket

(require rackunit)

;; definicja wyrażeń

(struct variable     (x)        #:transparent)
(struct const        (val)      #:transparent)
(struct op           (symb l r) #:transparent)
(struct let-expr     (x e1 e2)  #:transparent)
(struct if-expr      (b t e)    #:transparent)
(struct cons-expr    (l r)      #:transparent)
(struct car-expr     (p)        #:transparent)
(struct cdr-expr     (p)        #:transparent)
(struct pair?-expr   (p)        #:transparent)
(struct null-expr    ()         #:transparent)
(struct null?-expr   (e)        #:transparent)
(struct symbol-expr  (v)        #:transparent)
(struct symbol?-expr (e)        #:transparent)
(struct lambda-expr  (xs b)     #:transparent)
(struct app-expr     (f es)     #:transparent)
(struct apply-expr   (f e)      #:transparent)

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
    [(cons-expr l r)    (andmap expr? (list l r))]
    [(car-expr p)       (expr? p)]
    [(cdr-expr p)       (expr? p)]
    [(pair?-expr p)     (expr? p)]
    [(null-expr)        true]
    [(null?-expr p)     (expr? p)]
    [(symbol-expr v)    (symbol? v)]
    [(symbol?-expr p)   (expr? p)]
    [(lambda-expr xs b) (and (list? xs)
                             (andmap symbol? xs)
                             (expr? b)
                             (not (check-duplicates xs)))]
    [(app-expr f es)    (and (expr? f)
                             (list? es)
                             (andmap expr? es))]
    [(apply-expr f e)   (and (expr? f)
                             (expr? e))]
    [_                  false]))

;; wartości zwracane przez interpreter

(struct val-symbol (s)   #:transparent)
(struct closure (xs b e))

(define (my-value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v)
           (my-value? (car v))
           (my-value? (cdr v)))
      ; null-a reprezentujemy symbolem (a nie racketowym
      ; nullem) bez wyraźnej przyczyny
      (and (symbol? v) (eq? v 'null))
      (and ((val-symbol? v) (symbol? (val-symbol-s v))))))

;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
;; dwuelementowych list

(define (lookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

;; kilka operatorów do wykorzystania w interpreterze

(define (op-to-proc x)
  (lookup x `(
              (+ ,+)
              (* ,*)
              (- ,-)
              (/ ,/)
              (> ,>)
              (>= ,>=)
              (< ,<)
              (<= ,<=)
              (= ,=)
              (eq? ,(lambda (x y) (eq? (val-symbol-s x)
                                       (val-symbol-s y))))
              )))

;; interfejs do obsługi środowisk

(define (env-empty) null)
(define env-lookup lookup)
(define (env-add x v env) (cons (list x v) env))
;; Mam nadzieję, że nie jest to sprzeczne z ideą zadania
(define (env-add-mul xs vs env) (if (xor (null? xs) (null? vs))
                                    (error "number of arguments in application doesn't match number of arguments in function")
                                    (if (and (null? xs) (null? vs))
                                        env
                                        (env-add-mul (cdr xs) (cdr vs) (env-add (car xs) (car vs) env)))))

(define (env? e)
  (and (list? e)
       (andmap (lambda (xs) (and (list? e)
                                 (= (length e) 2)
                                 (symbol? (first e)))))))

;; interpretacja wyrażeń

(define (eval e env)
  (match e
    [(const n) n]
    [(op s l r)
     ((op-to-proc s) (eval l env)
                     (eval r env))]
    [(let-expr x e1 e2)
     (let ((v1 (eval e1 env)))
       (eval e2 (env-add x v1 env)))]
    [(variable x) (env-lookup x env)]
    [(if-expr b t e) (if (eval b env)
                         (eval t env)
                         (eval e env))]
    [(cons-expr l r)
     (let ((vl (eval l env))
           (vr (eval r env)))
       (cons vl vr))]
    [(car-expr p)      (car (eval p env))]
    [(cdr-expr p)      (cdr (eval p env))]
    [(pair?-expr p)    (pair? (eval p env))]
    [(null-expr)       'null]
    [(null?-expr e)    (eq? (eval e env) 'null)]
    [(symbol-expr v)   (val-symbol v)]
    [(lambda-expr xs b) (closure xs b env)]
    [(app-expr f es)   (let ((vf (eval f env))
                             (ves (map (lambda (x) (eval x env)) es)))
                         (match vf
                           [(closure xs b c-env)
                            (eval b (env-add-mul xs ves c-env))]))]
    [(apply-expr f e)
     (define (lang-list->list list)
       (match list
         [(cons-expr l r) (cons l (lang-list->list r))]
         [(null-expr)     null]))
     (eval (app-expr f (lang-list->list e)) env)] 
                             

    ))

(define (run e)
  (eval e (env-empty)))


(define app-tests
  (test-suite
   "Testy app-expr"
   (check-equal? (run (app-expr (lambda-expr '(x) (op '+ (variable 'x) (const 1)))
                               (list (const 5)))) 6)
   (check-equal? (run (app-expr (lambda-expr '(x y) (cons-expr (op '+ (variable 'x) (const 1))
                                                               (cons-expr (op '+ (variable 'y) (const 2)) (null-expr))))
                               (list (const 5) (const 1)))) (cons 6 (cons 3 'null)))
   (check-equal? (run (let-expr 'lista (app-expr (lambda-expr '(x y z)
                                                            (cons-expr (op '+ (variable 'x) (const 1))
                                                                       (cons-expr (op '* (variable 'y) (const 2))
                                                                                  (cons-expr (op '/ (variable 'z) (const 5))
                                                                                             (null-expr)))))
                                               (list (const 5) (const 4) (const 15)))
                                (app-expr (lambda-expr '(x) (op '- (variable 'x) (const 4))) (list (car-expr (variable 'lista))))))
                 2)
                                                                                    


   ))

(define apply-tests
  (test-suite
   "Testy apply-expr"
   (check-equal? (run (apply-expr (lambda-expr '(x) (op '+ (variable 'x) (const 1)))
                               (cons-expr (const 5) (null-expr)))) 6)
   (check-equal? (run (apply-expr (lambda-expr '(x y) (cons-expr (op '+ (variable 'x) (const 1))
                                                               (cons-expr (op '+ (variable 'y) (const 2)) (null-expr))))
                                (cons-expr (const 5) (cons-expr (const 1) (null-expr))))) (cons 6 (cons 3 'null)))
   (check-equal? (run (let-expr 'lista (apply-expr (lambda-expr '(x y z)
                                                            (cons-expr (op '+ (variable 'x) (const 1))
                                                                       (cons-expr (op '* (variable 'y) (const 2))
                                                                                  (cons-expr (op '/ (variable 'z) (const 5))
                                                                                             (null-expr)))))
                                               (cons-expr (const 5)
                                                          (cons-expr (const 4)
                                                                     (cons-expr (const 15) (null-expr)))))
                                (apply-expr (lambda-expr '(x) (op '- (variable 'x) (const 4))) (cons-expr (car-expr (variable 'lista)) (null-expr)))))
                 2)
                                                                                    


   ))



(run-test app-tests)
(run-test apply-tests)


;; Nie jestem w stanie znaleźć w rackunicie opcji, która pozwalałaby na sprawdzenie,
;; czy program zwraca konkretny błąd, więc zakomentowałem testy, które powinny zwrócić błędy 
#|
(run (app-expr (lambda-expr '(x y) (cons-expr (op '+ (variable 'x) (const 1))
                                              (cons-expr (op '+ (variable 'y) (const 2)) (null-expr))))
               (list (const 5))))

(run (apply-expr (lambda-expr '(x y) (cons-expr (op '+ (variable 'x) (const 1))
                                                (cons-expr (op '+ (variable 'y) (const 2)) (null-expr))))
                 (cons-expr (const 5) (null-expr))))

|#
                               