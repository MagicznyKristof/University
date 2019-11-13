#lang racket
;; foldr gdzie concat (append) jest funkcją
#|(define (concatMap f xs)
  (if (null? xs)
      null
      (append (f (car xs)) (concatMap f (cdr xs)))))

;; zwraca podzbiór liczb naturalnych (s, ..., e)
(define (from-to s e)
  (if (= s e)
      (list s)
      (cons s (from-to (+ s 1) e))))

(define (queens board-size)
  ;; Return the representation of a board with 0 queens inserted
  (define (empty-board)
    null
    )
        
  ;; Return the representation of a board with a new queen at
  ;; (row, col) added to the partial representation `rest'
  (define (adjoin-position row col rest)
    );;(adjoin row6 3 tab) -> (cons rest 3)
  ;; Return true if the queen in k-th column does not attack any of
  ;; the others
  (define (safe? k positions)
    
    )
  ;; Return a list of all possible solutions for k first columns
  (define (queen-cols k)
    (if (= k 0)
        (list (empty-board))
        (filter
         (lambda (positions) (safe? k positions))
         (concatMap
          (lambda (rest-of-queens)
            (map (lambda (new-row) ;; bierze wiersz i w następnej kolumnie dodaje następnego hetmana
                   ;; map - zwraca dla każdego wiersza ?wszystkie? możliwe ustawienia hetmanów
                   (adjoin-position new-row k rest-of-queens))
                 (from-to 1 board-size)))
          (queen-cols (- k 1)))))) ;; zwraca wszystkie ustawienia dla k-1 kolumn
  (queen-cols board-size))
|#
;; Zadanie 3


;;; drzewa binarne

(define (leaf? x)
  (eq? x 'leaf))

(define leaf 'leaf)
;#|
(define (node? x)
  (and (list? x)
       (= (length x) 4)
       (eq? (car x) 'node)))

(define (node-val x)
  (cadr x))

(define (node-left x)
  (caddr x))

(define (node-right x)
  (cadddr x))

(define (make-node v l r)
  (list 'node v l r))

(define (tree? t)
  (or (leaf? t)
      (and (node? t)
           (tree? (node-left t))
           (tree? (node-right t)))))

;;; wyszukiwanie i wstawianie w drzewach przeszukiwań binarnych

(define (bst-find x t)
  (cond [(leaf? t)          false]
        [(= x (node-val t)) true]
        [(< x (node-val t)) (bst-find x (node-left t))]
        [(> x (node-val t)) (bst-find x (node-right t))]))

(define (bst-insert x t)
  (cond [(leaf? t)
         (make-node x leaf leaf)]
        [(< x (node-val t))
         (make-node (node-val t)
                    (bst-insert x (node-left t))
                    (node-right t))]
        [else
         (make-node (node-val t)
                    (node-left t)
                    (bst-insert x (node-right t)))]))

;;; kodowanie Huffmana

(define (concat-map f cs)
  (apply append (map f cs)))

;; pairs with priority

(define (ord key priority)
  (cons key priority))

(define (ord? val)
  (and (pair? val)
       (integer? (cdr val))))

(define (ord-priority val)
  (cdr val))

(define (ord-key val)
  (car val))

;; priority queues, aka heaps
;; trivial implementation using ordered lists

(define empty-heap null)

(define (heap-empty? h)
  (null? h))

(define (heap-insert elt h)
  (if [or (null? h)
          (< (ord-priority elt)
             (ord-priority (car h)))]
      (cons elt h)
      (cons (car h) (heap-insert elt (cdr h)))))

(define (heap-min h)
  (car h))

(define (heap-pop h)
  (cdr h))

;; reprezentacja drzewa kodowego

(define (htleaf c)
  (list 'htleaf c))

(define (htleaf-sym t)
  (cadr t))

(define (htleaf? t)
  (and (list? t)
       (= (length t) 2)
       (eq? (car t) 'htleaf)))

(define (htnode t1 t2)
  (list 'htnode t1 t2))

(define (htnode-left t)
  (cadr t))

(define (htnode-right t)
  (caddr t))

(define (htnode? t)
  (and (list? t)
       (= 3 (length t))
       (eq? (car t) 'htnode)))


(define plist '((a . 10) (b . 1) (c . 6) (d . 5) (e . 3) (f . 6)))

;;; lista par jako słownik

(define empty-dict null)

(define (dict-insert k v d)
  (cons (cons k v) d))

(define (dict-find k d)
  (cond [(null? d) false]
        [(eq? (caar d) k) (car d)]
        [else (dict-find k (cdr d))]))


;; tworzenie drzewa kodowego
;; xs -- lista par znak-częstość występowania
(define (make-code-tree xs)
  (define (convert-list xs h)
    (if (null? xs)
        h
        (let ((s (caar xs))
              (f (cdar xs)))
          (convert-list (cdr xs)
                        (heap-insert (ord (htleaf s) f) h)))))
  (define (merge-elems e1 e2)
    (let ((tr (htnode (ord-key e1) (ord-key e2)))
          (fr (+ (ord-priority e1) (ord-priority e2))))
      (ord tr fr)))
  (define (handle-pqueue h)
    (let ((e1 (heap-min h))
          (h1 (heap-pop h)))
      (if (heap-empty? h1)
          (ord-key e1)
          (let* ((e2 (heap-min h1))
                 (h2 (heap-pop h1))
                 (hr (heap-insert (merge-elems e1 e2) h2)))
            (handle-pqueue hr)))))
  (handle-pqueue (convert-list xs empty-heap)))

;;; słownik z drzewa kodowego Huffmana

(define (code-tree->dict t)
  (define (aux t rcpref d)
    (if (htleaf? t)
        (dict-insert (htleaf-sym t) (reverse rcpref) d)
        (aux (htnode-right t)
             (cons 1 rcpref)
             (aux (htnode-left t)
                  (cons 0 rcpref)
                  d))))
  (aux t null empty-dict))

;; kodowanie listy symboli

(define (encode symlist dict)
  (let ((code-sym
         (lambda (s)
           (let ((kv (dict-find s dict)))
             (if kv
                 (cdr kv)
                 (error "Unknown symbol" s))))))
    (concat-map code-sym symlist)))

;; dekodowanie

(define (decode bitlist tree)
  (define (dec-sym bitlist tree)
    (cond [(htleaf? tree)
           (cons (htleaf-sym tree) bitlist)]
          [(null? bitlist)
           (error "Stream terminated prematurely")]
          [(= 0 (car bitlist))
           (dec-sym (cdr bitlist) (htnode-left tree))]
          [(= 1 (car bitlist))
           (dec-sym (cdr bitlist) (htnode-right tree))]))
  (define (aux bitlist)
    (if (null? bitlist)
        null
        (let ((sb (dec-sym bitlist tree)))
          (cons (car sb) (aux (cdr sb))))))
  (aux bitlist))
          


;|#
(define (mirror t)
  (if (leaf? t)
      'leaf
      (make-node (node-val t) (mirror (node-right t)) (mirror (node-left t)))
  )
)
   #|   
(define (flatten t)
  (if (leaf? t)
      null
      (list (flatten (cddar t)) (cons (cdar t) (flatten (cdddr t))))
  )
)|#

(define (flatten t)
  (define (flat t acc)
    (if (leaf? t)
        acc
        (flat (node-left t) (cons (node-val t) (flat (node-right t) acc)))
    )
    
  )
  (flat t null)
)

(define (treesort l)
  (define (sort l t)
    (if (empty? l)
        t
        (sort (cdr l) (bst-insert (car l) t))
    )
  )
  (flatten (sort l 'leaf))
)

(define (delete t elem)
  (define (remove-root t)
    (cond [(leaf? (node-left t))
           (if (leaf? (node-right t))
               leaf
               (node-right t))]
          [(leaf? (node-right t))
           (node-left t)]
          [else
           (let ((head (car (flatten (node-right t)))))
           (make-node head (node-left t) (delete (node-right t) head)))]))
                  
  (if (leaf? t)
      (error "Leaf")
      (cond [(> elem (node-val t))
             (make-node (node-val t) (node-left t) (delete (node-right t) elem))]
            [(< elem (node-val t))
             (make-node (node-val t) (delete (node-left t) elem) (node-right t))]
            [(= elem (node-val t))
             (remove-root t)])))
             