#lang racket

#|
Krzysztof Łyskawa
Pracownia 10
Współpracownicy: Krzysztof Lis, Oleś Kulczewicz, kod ze skosa
|#

(require "calc.rkt")

(define (def-name p)
  (car p))

(define (def-prods p)
  (cdr p))

(define (rule-name r)
  (car r))

(define (rule-body r)
  (cdr r))

(define (lookup-def g nt)
  (cond [(null? g) (error "unknown non-terminal" g)]
        [(eq? (def-name (car g)) nt) (def-prods (car g))]
        [else (lookup-def (cdr g) nt)]))

(define parse-error 'PARSEERROR)

(define (parse-error? r) (eq? r 'PARSEERROR))

(define (res v r)
  (cons v r))

(define (res-val r)
  (car r))

(define (res-input r)
  (cdr r))

;;

(define (token? e)
  (and (list? e)
       (> (length e) 0)
       (eq? (car e) 'token)))

(define (token-args e)
  (cdr e))

(define (nt? e)
  (symbol? e))

;;

(define (parse g e i)
  (cond [(token? e) (match-token (token-args e) i)]
        [(nt? e) (parse-nt g (lookup-def g e) i)]))

(define (parse-nt g ps i)
  (if (null? ps)
      parse-error
      (let ([r (parse-many g (rule-body (car ps)) i)])
        (if (parse-error? r)
            (parse-nt g (cdr ps) i)
            (res (cons (rule-name (car ps)) (res-val r))
                 (res-input r))))))

(define (parse-many g es i)
  (if (null? es)
      (res null i)
      (let ([r (parse g (car es) i)])
        (if (parse-error? r)
            parse-error
            (let ([rs (parse-many g (cdr es) (res-input r))])
              (if (parse-error? rs)
                  parse-error
                  (res (cons (res-val r) (res-val rs))
                       (res-input rs))))))))

(define (match-token xs i)
  (if (and (not (null? i))
           (member (car i) xs))
      (res (car i) (cdr i))
      parse-error))

;;

(define num-grammar
  '([digit {DIG (token #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)}]
    [numb {MANY digit numb}
          {SINGLE digit}]))

(define (node-name t)
  (car t))

(define (c->int c)
  (- (char->integer c) (char->integer #\0)))

(define (walk-tree-acc t acc)
  (cond [(eq? (node-name t) 'MANY)
         (walk-tree-acc
          (third t)
          (+ (* 10 acc) (c->int (second (second t)))))]
        [(eq? (node-name t) 'SINGLE)
         (+ (* 10 acc) (c->int (second (second t))))]))

(define (walk-tree t)
  (walk-tree-acc t 0))

;; converting a character to a symbol:
(define (char->symbol ch)
  (string->symbol (string ch)))

;;
;; zamienia łączność + i -
(define (add-tree-converter tree acc op)
  (if (eq? (node-name tree) 'ADD-SINGLE)
      (binop-cons
       (char->symbol op)
       acc
       (arith-walk-tree (second tree)))
      (let ([left   (arith-walk-tree (second tree))]
            [right  (fourth tree)]
            [new-op (third tree)])
        (add-tree-converter
         right
         (binop-cons (char->symbol op) acc left)
         new-op))))

;; zamienia łączność * i /
(define (mult-tree-converter tree acc op)
  (if (eq? (node-name tree) 'MULT-SINGLE)
      (binop-cons
       (char->symbol op)
       acc
       (arith-walk-tree (second tree)))
      (let ([left   (arith-walk-tree (second tree))]
            [right  (fourth tree)]
            [new-op (third tree)])
        (mult-tree-converter
         right
         (binop-cons (char->symbol op) acc left)
         new-op))))

(define arith-grammar
  (append num-grammar
     '([add-expr {ADD-MANY   mult-expr (token #\+ #\-) add-expr}
                 {ADD-SINGLE mult-expr}]
       [mult-expr {MULT-MANY base-expr (token #\* #\/) mult-expr}
                  {MULT-SINGLE base-expr}]
       [base-expr {BASE-NUM numb}
                  {PARENS (token #\() add-expr (token #\))}])))

(define (arith-walk-tree t)
  (cond [(eq? (node-name t) 'ADD-SINGLE)
         (arith-walk-tree (second t))]
        [(eq? (node-name t) 'MULT-SINGLE)
         (arith-walk-tree (second t))]
        [(eq? (node-name t) 'ADD-MANY)
         (add-tree-converter (fourth t) (arith-walk-tree (second t)) (third t))]
        [(eq? (node-name t) 'MULT-MANY)
         (mult-tree-converter (fourth t) (arith-walk-tree (second t)) (third t))]
        [(eq? (node-name t) 'BASE-NUM)
         (walk-tree (second t))]
        [(eq? (node-name t) 'PARENS)
         (arith-walk-tree (third t))]))

(define (calc s)
 (eval
  (arith-walk-tree
   (car
    (parse
       arith-grammar
       'add-expr
       (string->list s))))))


;; Generator racketowych wyrażeń arytmetycznych
(define (test-gen n max-depth)
  
  (define (test max-depth)
    (define (gen-number)
      (let ((sign (random 1)))
        (if (= sign 0)
            (+ 1 (random 10000))
            (- 0 (+ 1 (random 10000))))))

    (define (gen-binop op max-depth)
      (let ((t (test (- max-depth 1))))
        (if (= 0 (eval t))
            (list (list-ref '(+ - * +) op)
              (test (- max-depth 1))
              t)
            (list (list-ref '(+ - * /) op)
              (test (- max-depth 1))
              t))))
    
    (if (= max-depth 0)
        (gen-number)
        (let ((rand (random 5)))
          (if (= 4 rand)
              (gen-number)
              (gen-binop rand max-depth)))))
  
  (if (= n 0)
      null
      (let ((current-test (test max-depth)))
             (cons current-test
                   (test-gen (- n 1) max-depth)))))

;; Konwerter wyrażeń racketowych do infixowych

(define (racket->infix expr)
  (if (number? expr)
      (number->string expr)
      (let ([op    (first expr)]
            [left  (second expr)]
            [right (third expr)])
        (if (or (eq? op '+)
                (eq? op '-))
            (string-append
             (racket->infix left)
             (symbol->string op)
             (if (number? right)
                 (racket->infix right)
                 (if (or (eq? (first right) '+)
                         (eq? (first right) '-))
                     (string-append "(" (racket->infix right) ")")
                     (racket->infix right))))
            (string-append
             (if (number? left)
                 (racket->infix left)
                 (if (or (eq? (first left) '+)
                         (eq? (first left) '-))
                     (string-append "(" (racket->infix left) ")")
                     (racket->infix left)))
             (symbol->string op)
             (if (number? right)
                 (racket->infix right)
                 (string-append "(" (racket->infix right) ")")))))))

;; Porównuje, czy wynik wyrażenia racketowego jest równy
;; wynikowi wyrażenia infiksowego

(define (test-evaluator list)
  (if (null? list)
      null
      (cons (= (eval (car list)) (calc (racket->infix (car list)))) (test-evaluator (cdr list)))))

;; Wyświetla ile testów zakończyło się poprawnie a ile nie

(define (test-summary tests)
  (display "true: ")
  (display (count (compose false? false?) tests))
  (display "\nfalse: ")
  (display (count false? tests)))

(test-summary (test-evaluator (test-gen 1000 3)))