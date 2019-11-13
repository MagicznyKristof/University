#lang racket

(struct const    (val)      #:transparent)
(struct op       (symb l r) #:transparent)
(struct let-expr (x e1 e2)  #:transparent)
(struct variable (x)        #:transparent)

;; Zadanie 1

(define/contract (suffixes xs)
  (parametric->/c [a] (-> (listof a) (listof (listof a))))
  (if (null? xs)
      (list xs)
      (append (list xs) (suffixes (cdr xs)))))

;; Zadanie 2

(define/contract (sublists xs)
  (parametric->/c [a] (-> (listof a) (listof (listof a))))
  (if (null? xs)
      (list null)
      (append-map
       (lambda (ys) (list (cons (car xs) ys) ys))
       (sublists (cdr xs)))))

;; Zadanie 3

(define/contract (f x y)
  (parametric->/c [a b] (-> a b a))
  x)

(define/contract (g x y z)
  (parametric->/c [a b c] (-> (-> a b c) (-> a b) a c))
  (x z (y z)))

(define/contract (h x y)
  (parametric->/c [a b c] (-> (-> b c) (-> a b) (-> a c)))
  (lambda (z) (x (y z))))

(define/contract (i x)
  (parametric->/c [a] (-> (-> (-> a a) a) a))
  (x (lambda (y) (y))))

;; Zadanie 4

(define/contract (j a)
  (parametric->/c [a b] (-> a b))
  (j a))

;; Zadanie 5

(define/contract (foldl-map f a xs)
  (parametric->/c [a b c] (-> (-> a b (cons/c c b))
                            b (listof a) (cons/c (listof c) b)))
  (define (it a xs ys)
    (if (null? xs)
        (cons (reverse ys) a)
        (let [(p (f (car xs) a))]
          (it (cdr p)
              (cdr xs)
              (cons (car p) ys)))))
  (it a xs null))

;; Zadanie 6

(define expr/c
  (flat-rec-contract expr
                     (struct/c variable symbol?)
                     (struct/c const number?)
                     (struct/c op (lambda (x) (member x '(+ *))) expr expr)
                     (struct/c let-expr symbol? expr expr)))

(define/contract (expr? e)
  (match e
    [(variable s)       (symbol? s)]
    [(const n)          (number? n)]
    [(op s l r)         (and (member s '(+ *))
                             (expr/c l)
                             (expr/c r))]
    [(let-expr x e1 e2) (and (symbol? x)
                             (expr/c e1)
                             (expr/c e2))]
    [_                  false]))

(define/contract (subst x v e)
  (-> symbol? number? expr/c expr/c)
  (match e
    [(op s l r)   (op s (subst x v l)
                        (subst x v r))]
    [(const n)    (const n)]
    [(variable y) (if (eq? x y)
                      (const v)
                      (variable y))]
    [(let-expr y e1 e2)
     (if (eq? x y)
         (let-expr y
                   (subst x v e1)
                   e2)
         (let-expr y
                   (subst x v e1)
                   (subst x v e2)))]))

(define/contract (eval e)
  (-> expr/c number?)
  (match e
    [(const n)    n]
    [(op '+ l r)  (+ (eval l) (eval r))]
    [(op '* l r)  (* (eval l) (eval r))]
    [(let-expr x e1 e2)
     (eval (subst x (eval e1) e2))]
    [(variable n) (error n "cannot reference an identifier before its definition ;)")]))

(define p1
  (let-expr 'x (op '+ (const 2) (const 2))
     (op '+ (const 1000) (let-expr 'y (op '+ (const 5) (const 5))
                            (op '* (variable 'x) (variable 'y))))))
