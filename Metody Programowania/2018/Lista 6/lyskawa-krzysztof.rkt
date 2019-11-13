#lang racket

#|
Pracownia 6
Krzysztof Łyskawa
Współpraca: Krzysztof Lis, kod ze skosa
|#

(define (const? t)
  (number? t))

(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(+ - * /))))

(define (binop-op e)
  (car e))

(define (binop-left e)
  (cadr e))

(define (binop-right e)
  (caddr e))

(define (binop-cons op l r)
  (list op l r))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

(define (let-def? t)
  (and (list? t)
       (= (length t) 2)
       (symbol? (car t))))

(define (let-def-var e)
  (car e))

(define (let-def-expr e)
  (cadr e))

(define (let-def-cons x e)
  (list x e))

(define (let? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

(define (hole? t)
  (eq? t 'hole))

(define (arith/let/holes? t)
  (or (hole? t)
      (const? t)
      (and (binop? t)
           (arith/let/holes? (binop-left  t))
           (arith/let/holes? (binop-right t)))
      (and (let? t)
           (arith/let/holes? (let-expr t))
           (arith/let/holes? (let-def-expr (let-def t))))
      (var? t)))

(define (num-of-holes t)
  (cond [(hole? t) 1]
        [(const? t) 0]
        [(binop? t)
         (+ (num-of-holes (binop-left  t))
            (num-of-holes (binop-right t)))]
        [(let? t)
         (+ (num-of-holes (let-expr t))
            (num-of-holes (let-def-expr (let-def t))))]
        [(var? t) 0]))

(define (arith/let/hole-expr? t)
  (and (arith/let/holes? t)
       (= (num-of-holes t) 1)))

(define (hole-context e)
  (define (extend-dict list var)
    (if (false? (member var list))
        (cons var list)
        list))
  (define (hole-context-acc expr dict)
    (cond [(hole? expr) dict]
          [(const? expr) false]
          [(binop? expr) 
           (let ((left-binop (hole-context-acc (binop-left expr) dict)))
             (if (false? left-binop)
                 (hole-context-acc (binop-right expr) dict)
                 left-binop))]
          [(let? expr) (let ((let-def-context (hole-context-acc (let-def-expr (let-def expr)) dict)))
                         (if (false? let-def-context)
                             (hole-context-acc (let-expr expr) (extend-dict dict (let-def-var (let-def expr))))
                             let-def-context))]
          [(var? expr) false]))
  (hole-context-acc e null)
)

(define (test) ;; w liscie zwracanej przez test kolejnosc argumentów jest taka sama,
               ;; jak w podanej liście testów, a odwrotna niż w liście rezultatów 
  
  (define (test-list list acc)
    (if (null? list)
        acc
        (test-list (cdr list) (cons (hole-context (car list)) acc))))

  (define (check-single-context test result)
    (equal? (sort test symbol<?) (sort result symbol<?))) 
  
  (define (check-contexts list-of-tests list-of-results acc)
    (if (null? list-of-tests)
        acc
        (check-contexts (cdr list-of-tests) (cdr list-of-results) (cons (check-single-context (car list-of-tests) (car list-of-results)) acc))
    )
  )
  
  (let ((test-results (test-list '(
                                  (+ 3 hole)
                                  (let (x 3) (let (y 7) (+ x hole)))
                                  (let (x 3) (let (y hole) (+ x 3)))
                                  (let (x hole) (let (y 7) (+ x 3)))
                                  (let (piesek 1) (let (kotek 7) (let (piesek 9) (let (chomik 5) hole))))
                                  (+ ( let ( x 4) 5) hole )
                                  (+ e hole)
                                  (let (f 61) (* (let (d 22) s) (/ hole 87)))
                                  (* f (let (w hole) x))
                                  (let (w (* o 19)) (let (v 69) hole))
                                  (let (s hole) j)
                                  (let (n (+ (let (g 46) (let (d hole) y)) (let (z 78) (let (u p) 1)))) r)
                                  (let (m (+ 3 4)) hole)
                             ) null)) ;; wszystkie testy poza ostatnim są poprawne
        (expected-results '((falsz) (g) () (v w) () (f) () () (chomik piesek kotek) () (x) (y x) ()))
       )
    (check-contexts test-results expected-results null)
    
  )
        
)

(test)

