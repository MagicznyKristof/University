#lang racket

#|
Lista 4, zadanie na pracownię
Współpracownicy: Krzysztof Lis, kod ze skosa (pracownia z zeszłego roku)
|#

(define (inc n)
  (+ n 1))

;;; ordered elements
(define (make-elem pri val)
  (cons pri val))

(define (elem-priority x)
  (car x))

(define (elem-val x)
  (cdr x))

;;; leftist heaps (after Okasaki)

;; data representation
(define leaf 'leaf)

(define (leaf? h) (eq? 'leaf h))

(define (hnode? h)
  (and (list? h)
       (= 5 (length h))
       (eq? (car h) 'hnode)
       (natural? (caddr h))))

(define (make-node elem heap-a heap-b)
  (if (< (rank heap-a) (rank heap-b))
         (list 'hnode elem (+ 1 (rank heap-a)) heap-b heap-a)
         (list 'hnode elem (+ 1 (rank heap-b)) heap-a heap-b)
  )
)

(define (node-elem h)
  (second h))

(define (node-left h)
  (fourth h))

(define (node-right h)
  (fifth h))

(define (hord? p h)
  (or (leaf? h)
      (<= p (elem-priority (node-elem h)))))

(define (heap? h)
  (or (leaf? h)
      (and (hnode? h)
           (heap? (node-left h))
           (heap? (node-right h))
           (<= (rank (node-right h))
               (rank (node-left h)))
           (= (rank h) (inc (rank (node-right h))))
           (hord? (elem-priority (node-elem h))
                  (node-left h))
           (hord? (elem-priority (node-elem h))
                  (node-right h)))))

(define (rank h)
  (if (leaf? h)
      0
      (third h)))

;; operations

(define empty-heap leaf)

(define (heap-empty? h)
  (leaf? h))

(define (heap-insert elt heap)
  (heap-merge heap (make-node elt leaf leaf)))

(define (heap-min heap)
  (node-elem heap))

(define (heap-pop heap)
  (heap-merge (node-left heap) (node-right heap)))

(define (heap-merge h1 h2)
  (cond
   [(leaf? h1) h2]
   [(leaf? h2) h1]
   ;; XXX: fill in the implementation
   [else (if (< (elem-priority (node-elem h1)) (elem-priority (node-elem h2)))
             (make-node (node-elem h1) (node-left h1) (heap-merge (node-right h1) h2))
             (make-node (node-elem h2) (node-left h2) (heap-merge (node-right h2) h1))
         )
   ]
  )
)


;;; heapsort. sorts a list of numbers.
(define (heapsort xs)
  (define (popAll h)
    (if (heap-empty? h)
        null
        (cons (elem-val (heap-min h)) (popAll (heap-pop h)))))
  (let ((h (foldl (lambda (x h)
                    (heap-insert (make-elem x x) h))
            empty-heap xs)))
    (popAll h)))

;;; check that a list is sorted (useful for longish lists)
(define (sorted? xs)
  (cond [(null? xs)              true]
        [(null? (cdr xs))        true]
        [(<= (car xs) (cadr xs)) (sorted? (cdr xs))]
        [else                    false]))

;;; generate a list of random numbers of a given length
(define (randlist len max)
  (define (aux len lst)
    (if (= len 0)
        lst
        (aux (- len 1) (cons (random max) lst))))
  (aux len null))


;;; Testy - zwracają tablicę #t i #f
;;; #t - jeżeli uzyskana lista jest poprawnie posortowana, #f - w p.p.
(define (tests n len max)
  (if (zero? n)
      null
      (cons (sorted? (heapsort (randlist len max)))
            (tests (- n 1) len max))
  )
)
  
(tests 50 1000 1000000) ;; Dla max = 0 nie działa


