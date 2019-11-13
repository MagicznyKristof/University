#lang racket

(define (a f) (lambda (y)
    (let ((x 3))
      (let ((y x))
        (f x y x)))))

(define b '((car (a . b)) (* 2)))

(define c (list (list 'car (cons 'a 'b)) (list '* 2)))
#|
(define (node v l r)
  (list 'node v l r))

(define (node? t)
  (and (list? t)
       (= (length t) 4)
       (eq? (first t) 'node)))

(define (node-val t)
  (second t))

(define (node-left t)
  (third t))

(define (node-right t)
  (fourth t))

(define leaf 'leaf)

(define (leaf? t)
  (eq? 'leaf t))

(define (tree? t)
  (or (leaf? t)
      (and (node? t)
           (tree? (node-left t))
           (tree? (node-right t)))))


(define (tree-min t)
  (if (leaf? t)
      false
      (let ((min-left (tree-min (node-left t)))
            (min-right (tree-min (node-right t)))
            (min-node (node-val t)))
        (cond [(and (false? min-left)
                    (false? min-right))
               min-node]
              [(false? min-left)
               (if (< min-right min-node)
                   min-right
                   min-node)]
              [(false? min-right)
               (if (< min-left min-node)
                   min-left
                   min-node)]
              [else
               (if (< min-right min-left)
                   (if (< min-right min-node)
                       min-right
                       min-node)
                   (if (< min-left min-node)
                       min-left
                       min-node))]))))
|#

(define (interleave xs ys)
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [else (append (list (car xs) (car ys))
                      (interleave (cdr xs) (cdr ys)))]))

                   
(define (partition pivot xs)
  (if (null? xs)
      (cons null null)
      (let ((res (partition pivot (cdr xs))))
        (if (< (car xs) pivot)
            (cons (cons (car xs) (car res))
                  (cdr res))
            (cons (car res)
                  (cons (car xs) (cdr res)))))))

(define (quicksort xs)
  (if (null? xs)
      xs
      (let* ((pivot (car xs))
            (parted (partition pivot (cdr xs))))
        (append (quicksort (car parted)) (list pivot) (quicksort (cdr parted))))))
          

;;(define (sublists xs)
;;  (if (null? xs)
;;      (list null)
;;      (concat-map (lambda (x) (list (car xs) (cons (car xs) x))) (sublists (cdr xs)))))

(define d '((+ 1 2 3) (cons) (cons a b)))

(define e (list (list '+ 1 2 3) (list 'cons) (list 'cons 'a 'b)))

(define (node l r)
  (list 'node l r))

(define (node? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (first t) 'node)))

(define (node-left t)
  (second t))

(define (node-right t)
  (third t))

(define (leaf v)
  (list 'leaf v))

(define (leaf? t)
  (and (list? t)
       (= (length t) 2)
       (eq? (first t) 'leaf)))

(define (leaf-val t)
  (second t))

(define (tree? t)
  (or (leaf? t)
      (and (node? t)
           (tree? (node-left t))
           (tree? (node-right t)))))

(define (tree-max t)
  (if (leaf? t)
      (leaf-val t)
      (let ((max-l (tree-max (node-left t)))
            (max-r (tree-max (node-right t))))
        (if (> max-l max-r)
            max-l
            max-r))))