#lang racket

(provide (all-defined-out))

;; definicja wyrażeń

(struct variable     (x)        #:transparent)
(struct const        (val)      #:transparent)
(struct op           (symb l r) #:transparent)
(struct let-expr     (x e1 e2)  #:transparent)
(struct letrec-expr  (x e1 e2)  #:transparent)
(struct if-expr      (b t e)    #:transparent)
(struct cons-expr    (l r)      #:transparent)
(struct car-expr     (p)        #:transparent)
(struct cdr-expr     (p)        #:transparent)
(struct pair?-expr   (p)        #:transparent)
(struct null-expr    ()         #:transparent)
(struct null?-expr   (e)        #:transparent)
(struct symbol-expr  (v)        #:transparent)
(struct symbol?-expr (e)        #:transparent)
(struct lambda-expr  (x b)      #:transparent)
(struct app-expr     (f e)      #:transparent)
(struct set!-expr    (x v)      #:transparent)
(struct let-lazy (x e1 e2)      #:transparent)

;; wartości zwracane przez interpreter

(struct val-symbol (s)   #:transparent)
(struct closure (x b e)) ; Racket nie jest transparentny w tym miejscu,
                         ; to my też nie będziemy
(struct blackhole ()) ; lepiej tzrymać się z daleka!

;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
;; dwuelementowych list

(define (lookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

(define (mlookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (mcar (mcar xs)) x)
     (match (mcar (mcdr (mcar xs)))
       [(blackhole) (error "Stuck in a black hole :(")]
       [x x])]
    [else (mlookup x (mcdr xs))]))

(define (mupdate! x v xs)
  (define (update! ys)
    (cond
      [(null? ys) (error x "unknown identifier :(")]
      [(eq? x (mcar (mcar ys)))
       (set-mcar! (mcdr (mcar ys)) v)]
      [else (update! (mcdr ys))]))
  (begin (update! xs) xs))

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
              (% ,modulo)
              (!= ,(lambda (x y) (not (= x y)))) 
              (&& ,(lambda (x y) (and x y)))
              (|| ,(lambda (x y) (or x y)))
              (eq? ,(lambda (x y) (eq? (val-symbol-s x)
                                       (val-symbol-s y))))
              )))

;; interfejs do obsługi środowisk

(define (env-empty) null)
(define env-lookup mlookup)
(define (env-add x v env)
  (mcons (mcons x (mcons v null)) env))
(define env-update! mupdate!)

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
    [(letrec-expr x e1 e2)
     (let* ((new-env (env-add x (blackhole) env))
            (v1 (eval e1 new-env)))
       (eval e2 (env-update! x v1 new-env)))]
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
    [(lambda-expr x b) (closure x b env)]
    [(app-expr f e)    (let ((vf (eval f env))
                             (ve (eval e env)))
                         (match vf
                           [(closure x b c-env)
                            (eval b (env-add x ve c-env))]
                           [_ (error "application: not a function :(")]))]
    ;; Zadanie 4
    [(let-lazy x e1 e2) (eval e2 (env-add x (closure 'cos e1 env) env))]
    [(variable x) (let ((env-x (env-lookup x env)))
                    (match env-x
                      [(closure _ e clos-env) (eval e clos-env)]
                      [_ env-x]))]
    [(set!-expr x e)
     (env-update! x (eval e env) env)]
    ))

(define (run e)
  (eval e (env-empty)))

;; przykład

(define fact-in-expr
  (letrec-expr 'fact (lambda-expr 'n
     (if-expr (op '= (const 0) (variable 'n))
              (const 1)
              (op '* (variable 'n)
                  (app-expr (variable 'fact)
                            (op '- (variable 'n)
                                   (const 1))))))
     (app-expr (variable 'fact)
               (const 5))))

#|
;; Zadanie 1

(let ((x 5)) (lambda (x) (let (y 5) (+ x y))))

(let-expr x (const 5) (lambda-expr 'x (let-expr 'y (const 5) (op '+ (variable 'x) (variable 'y)))))

;; Zadanie 3
(define envs-n '())
(define (env-empty-n) (begin (set! envs-n '()) '()))
(define (env-from-accos-list-n xs) (begin (set! env-ns (list xs)) xs))
(define (update-n2! x v env)
  (let ((new-env (update x v env)))
    (begin (set! envs-n (cons new-env envs-n)) new env)))
(define env-update-n update-n2!)
(define (env-addn x v env)
  (let ((new-env (cons (list x v) env)))
    (begin (set! envs-n (cons new-env envs-n)) new-env)))
(define (env-discard-n env)
  (let ((new-env (cdr env)))
    (begin (set! envs-n (cons new-env envs-n)) new-env))))

(define (debug prog env)
  (begin (interp prog env) (reverse envs-n)))

;; Zadanie 5

(define (tail? e)
  (define (aux name e)
    (match e
      [(const x) #t]
      [(op _ x y) (and (notcontains? name x)
                       (notcontains? name y))]
      [(cons-expr x y) (and (notcontains? name x)
                            (notcontains? name y))]
      [(lambda-expr x e1) (aux name e1)]
      [(if-expr b e1 e2) (and (notcontains? name b)
                              (aux name e1)
                              (aux name e2))]
      [(let-expr x e1 e2) (and (notcontains? name e1)
                               (aux name e2))]))
  (define (notcontains? name exp)
    (match exp
      [(app-exp e1 e2)
       (match e1
         [(variable x) (or (= x name) (notcontains? name e2))]
         [_ (and (notcontains? name e1)
                 (notcontains? name e2))])]))
    (match e
      [(letrec-expr  name e1 _) (aux2 e1)]
      [else #f]))
|#
      
