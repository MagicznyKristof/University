#lang racket

(define (var? t)
  (symbol? t))

(define (neg? t)
  (and (list? t)
       (= 2 (length t))
       (eq? 'neg (car t))))

(define (conj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'conj (car t))))

(define (disj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'disj (car t))))

;;; Zadanie 1

(define (neg f)
  (list 'neg f))

(define (conj f1 f2)
  (list 'conj f1 f2))

(define (disj f1 f2)
  (list 'disj f1 f2))

(define (neg-subf f)
  (cadr f))

(define (conj-left f)
  (cadr f))

(define (conj-right f)
  (caddr f))

(define (disj-left f)
  (cadr f))

(define (disj-right f)
  (caddr f))

(define (prop? f)
  (or (var? f)
      (and (neg? f)
           (prop? (neg-subf f)))
      (and (disj? f)
           (prop? (disj-left f))
           (prop? (disj-right f)))
      (and (conj? f)
           (prop? (conj-left f))
           (prop? (conj-right f)))))

;;; Zadanie 2

(define (free-vars f)
  (cond [(var? f) (list f)]
        [(neg? f) (free-vars (neg-subf f))]
        [(disj? f) (append (free-vars (disj-left f))
                           (free-vars (disj-right f)))]
        [(conj? f) (append (free-vars (conj-left f))
                           (free-vars (conj-right f)))]
  )
)

(define g (conj 'x 'y))
(define f (neg g))
(define h (conj f g))
(define i (disj g 'z))
(define j (disj 'x 'y))
(define k (neg (conj h j)))

;;; Zadanie 3

(define (gen-vals xs)
  (if (null? xs)
      (list null)
      (let* ((vss (gen-vals (cdr xs)))
             (x (car xs))
             (vst (map (lambda (vs) (cons (list x true) vs)) vss))
             (vsf (map (lambda (vs) (cons (list x false) vs)) vss)))
        (append vst vsf)
      )
  )
)

  

(define (eval-formula f vals)
  (define (return-val var values)
    (cond [(null? values) (error "Zmienna niezdefiniowana")]
          [(eq? (caar values) var) (cadar values)]
          [else (return-val var (cdr values))]
    )
  )
  (cond [(var? f) (return-val f vals)]
        [(neg? f) (not (eval-formula (neg-subf f) vals))]
        [(conj? f) (and (eval-formula (conj-left f) vals)
                        (eval-formula (conj-right f) vals))]
        [(disj? f) (or (eval-formula (disj-left f) vals)
                       (eval-formula (disj-right f) vals))]
  )
)

(define (falsifiable-eval? f)
  (define (current-val vals-list)
    (if (null? vals-list)
        false
        (if (eval-formula f (car vals-list))
            (current-val (cdr vals-list))
            (car vals-list)
        )
    )
  )      
  (current-val (gen-vals (free-vars f)))
)

;;; Zadanie 4

(define (nnf? f)
  (cond [(var? f) #t]
        [(neg? f) (var? (neg-subf f))]
        [(conj? f) (and (nnf? (conj-left f)) (nnf? (conj-right f)))]
        [(disj? f) (and (nnf? (disj-left f)) (nnf? (disj-right f)))]
  )
)

;;; Zadanie 5

(define (convert-to-nnf f)
  (define (convert-neg g)
    (cond [(var? g) (neg g)]
          [(neg? g) (convert-to-nnf (neg-subf g))]
          [(conj? g) (disj (convert-neg (conj-left g))
                           (convert-neg (conj-right g)))]
          [(disj? g) (conj (convert-neg (disj-left g))
                           (convert-neg (disj-right g)))]
    )
  )
  (cond [(var? f) f]
        [(neg? f) (convert-neg (neg-subf f))]
        [(conj? f) (conj (convert-to-nnf (conj-left f))
                         (convert-to-nnf (conj-right f)))]
        [(disj? f) (disj (convert-to-nnf (disj-left f))
                         (convert-to-nnf (disj-right f)))]
  )
)

;;; Zadanie 6

;(define (disj-cnf f)

#|
(define (disj-cnf? f)
  (cond [(conj? f) #f]
        [(var? f) #t]
        [(neg? f) (var? (neg-subf f))]
        [(disj? f) (and (disj-cnf? (disj-right f))
                        (disj-cnf? (disj-left f)))]
  )
)

(define (conj-cnf? f)
  (cond [(var? f) #t]
        [(neg? f) (var? (neg-subf f))]
        [(disj? f) (disj-cnf? f)]
        [(conj? f) (and (conj-cnf? (conj-right f))
                        (conj-cnf? (conj-left f)))]
  )
)
  
(define (cnf? f)
  (cond [(var? f) #t]
        [(neg? f) (var? (neg-subf f))]
        [(disj? f) (disj-cnf? f)]
        [(conj? f) (conj-cnf? f)]
  )
)
;|#

(define (lit? f)
  (or (var? f)
      (and (neg? f) (var? (neg-subf f)))))

(define (cnf? f)
  (define (clause? f)
    (or (null? f)
        (and (lit? (car f))
             (clause? (cdr f))))
  )
  (define (list-of-clauses? f)
    (or (null? f)
        (and (clause? (car f))
             (list-of-clauses? (cdr f))))
  )
  (and (list? f)
       (list-of-clauses? f))
)

(define (convert-to-cnf f)
  (define (merge l1 l2 i j acc)
    (if (zero? i)
        acc
        (merge (cdr l1) l2 (- i 1) j (merge-for-elem (car l1) l2 j acc))))
  (define (merge-for-elem elem list length acc)
    (if (zero? length)
        acc
        (merge-for-elem elem (cdr list) (- length 1) (cons (append elem (car list)) acc))
    )
  )      
  (cond [(lit? f) (list (list f))]
        [(conj? f) (append (convert-to-cnf (conj-left f))
                           (convert-to-cnf (conj-right f)))]
        [(disj? f) (let ((L1 (convert-to-cnf (disj-left f)))
                         (L2 (convert-to-cnf (disj-right f))))
                     (merge L1 L2 (length L1) (length L2) null))]
  )
)


(define x (convert-to-nnf k))

(