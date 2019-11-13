#lang racket

;; struktury z których budujemy drzewa binarne

(struct node (v l r) #:transparent)
(struct leaf () #:transparent)

;; predykat: czy dana wartość jest drzewem binarnym?

(define (tree? t)
  (match t
    [(leaf) true]
    ; wzorzec _ dopasowuje się do każdej wartości
    [(node _ l r) (and (tree? l) (tree? r))]
    ; inaczej niż w (cond ...), jeśli żaden wzorzec się nie dopasował, match kończy się błędem
    [_ false]))

;; przykładowe użycie dopasowania wzorca

(define (insert-bst v t)
  (match t
    [(leaf) (node v (leaf) (leaf))]
    [(node w l r)
     (if (< v w)
         (node w (insert-bst v l) r)
         (node w l (insert-bst v r)))]))

;; Zadanie 2

(define (paths t)
  (define (aux acc t)
    (match t
      [(leaf) (list (append acc (leaf '*)))]
      [(node v l r) (append (aux (append acc (list v)) l) (aux (append acc (list v) r)))]))
  (aux null t))

;; definicja wyrażeń arytmetycznych

(struct const (val) #:transparent)
(struct op (symb l r) #:transparent)

(define (expr? e)
  (match e
    [(const n) (number? n)]
    [(op s l r) (and (member s '(+ *))
                     (expr? l)
                     (expr? r))]
    [_ false]))

;; przykładowe wyrażenie

(define e1 (op '* (op '+ (const 2) (const 2))
                  (const 2)))

;; ewaluator wyrażeń arytmetycznych

(define (eval e)
  (match e
    [(const n) n]
    [(op '+ l r) (+ (eval l) (eval r))]
    [(op '* l r) (* (eval l) (eval r))]))

;; kompilator wyrażeń arytmetycznych do odwrotnej notacji polskiej
#|
(define (to-rpn e)
  (match e
    [(const n) (list n)]
    [(op s l r) (append (to-rpn l)
                        (to-rpn r)
                        (list s))]))

(define (count-ops t)
  (define (aux t)
    (match t
      [(const t) (cons 0 0)]
      [(op o l r) (let ((left (aux l))
                        (right (aux r)))
                    (if (eq? o '*)
                        (cons (+ (car left) (car right))
                              (+ (cdr left) (cdr right) 1))
                        (cons (+ (car left) (car right) 1)
                              (+ (cdr left) (cdr right)))
                    )
                   )]))
  (let ((result (aux t)))
    (if (< (car res) (cdr res))
        '*
        '+)))
|#
(define (rozklad n)
  (define (wyk n div acc)
    (if (= (modulo n div) 0)
        (wyk (/ n div) div (+ acc 1))
        acc))
  (define (is-div n p)
    (if (= n 1)
        null
        (if (= (modulo n p) 0)
            (let ((pow (wyk (/ n p) p 1)))
              (cons (cons p pow)
                    (is-div (/ n (expt p pow)) (+ p 1))))
            (is-div n (+ p 1)))))
  (is-div n 2))
                              
