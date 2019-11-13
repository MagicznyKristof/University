#lang racket

#|
Pracownia 12
Krzysztof Łyskawa
Współpracownicy: Krzysztof Lis, Oleś Kulczewicz, kod ze skosa
|#

;; sygnatura: grafy
(define-signature graph^
  ((contracted
    [graph        (-> list? (listof edge?) graph?)]
    [graph?       (-> any/c boolean?)]
    [graph-nodes  (-> graph? list?)]
    [graph-edges  (-> graph? (listof edge?))]
    [edge         (-> any/c any/c edge?)]
    [edge?        (-> any/c boolean?)]
    [edge-start   (-> edge? any/c)]
    [edge-end     (-> edge? any/c)]
    [has-node?    (-> graph? any/c boolean?)]
    [outnodes     (-> graph? any/c list?)]
    [remove-node  (-> graph? any/c graph?)]
    )))

;; prosta implementacja grafów
(define-unit simple-graph@
  (import)
  (export graph^)

  (define (graph? g)
    (and (list? g)
         (eq? (length g) 3)
         (eq? (car g) 'graph)))

  (define (edge? e)
    (and (list? e)
         (eq? (length e) 3)
         (eq? (car e) 'edge)))

  (define (graph-nodes g) (cadr g))

  (define (graph-edges g) (caddr g))

  (define (graph n e) (list 'graph n e))

  (define (edge n1 n2) (list 'edge n1 n2))

  (define (edge-start e) (cadr e))

  (define (edge-end e) (caddr e))

  (define (has-node? g n) (not (not (member n (graph-nodes g)))))
  
  (define (outnodes g n)
    (filter-map
     (lambda (e)
       (and (eq? (edge-start e) n)
            (edge-end e)))
     (graph-edges g)))

  (define (remove-node g n)
    (graph
     (remove n (graph-nodes g))
     (filter
      (lambda (e)
        (not (eq? (edge-start e) n)))
      (graph-edges g)))))

;; sygnatura dla struktury danych
(define-signature bag^
  ((contracted
    [bag?       (-> any/c boolean?)]
    [empty-bag  (and/c bag? bag-empty?)]
    [bag-empty? (-> bag? boolean?)]
    [bag-insert (-> bag? any/c (and/c bag? (not/c bag-empty?)))]
    [bag-peek   (-> (and/c bag? (not/c bag-empty?)) any/c)]
    [bag-remove (-> (and/c bag? (not/c bag-empty?)) bag?)])))

;; struktura danych - stos
(define-unit bag-stack@
  (import)
  (export bag^)

  (define (bag-cons l)
    (list 'stack l))
  (define (bag-list b)
    (second b))

  (define (bag? b)
    (and (list? b)
         (eq? (length b) 2)
         (eq? (car b) 'stack)))
  (define (bag-empty? b)
    (null? (bag-list b)))
  (define empty-bag
    (bag-cons null))
  (define (bag-insert b e)
    (bag-cons (cons e (bag-list b))))
  (define (bag-peek b)
    (first (bag-list b)))
  (define (bag-remove b)
    (bag-cons (cdr (bag-list b))))
  
  )

;; struktura danych - kolejka FIFO
;; do zaimplementowania przez studentów
(define-unit bag-fifo@
  (import)
  (export bag^)
  
  (define (bag-cons l1 l2)
    (if (null? l2)
        (list 'queue null (reverse l1))
        (list 'queue l1 l2)))
  (define (bag-list-first b)
    (second b))
  (define (bag-list-second b)
    (third b))

  (define (bag? b)
    (and (list? b)
         (eq? (length b) 3)
         (eq? (car b) 'queue)))
  (define (bag-empty? b)
    (and (null? (bag-list-first b))
         (null? (bag-list-second b))))
  (define empty-bag
    (bag-cons null null))
  (define (bag-insert b e)
    (bag-cons (cons e (bag-list-first b)) (bag-list-second b)))
  (define (bag-peek b)
    (first (bag-list-second b)))
  (define (bag-remove b)
    (bag-cons (bag-list-first b) (cdr (bag-list-second b))))
  )

;; sygnatura dla przeszukiwania grafu
(define-signature graph-search^
  (search))

;; implementacja przeszukiwania grafu
;; uzależniona od implementacji grafu i struktury danych
(define-unit/contract graph-search@
  (import bag^ graph^)
  (export (graph-search^
           [search (-> graph? any/c (listof any/c))]))
  (define (search g n)
    (define (it g b l)
      (cond
        [(bag-empty? b) (reverse l)]
        [(has-node? g (bag-peek b))
         (it (remove-node g (bag-peek b))
             (foldl
              (lambda (n1 b1) (bag-insert b1 n1))
              (bag-remove b)
              (outnodes g (bag-peek b)))
             (cons (bag-peek b) l))]
        [else (it g (bag-remove b) l)]))
    (it g (bag-insert empty-bag n) '()))
  )

;; otwarcie komponentu grafu
(define-values/invoke-unit/infer simple-graph@)

;; graf testowy
(define test-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4))))
;; TODO: napisz inne testowe grafy!

;; otwarcie komponentu stosu
;(define-values/invoke-unit/infer bag-stack@)
;; opcja 2: otwarcie komponentu kolejki
 (define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)

;; test przykładowy: jeśli do pustej struktury dodamy element
;; i od razu go usuniemy, wynikowa struktura jest pusta
(quickcheck
 (property ([s arbitrary-symbol]
            [t arbitrary-symbol])
           (bag? (bag-remove (bag-insert empty-bag s)))
           (bag-empty? (bag-remove (bag-insert empty-bag s)))
           (eq? s (bag-peek (bag-insert empty-bag s)))
           (bag-empty? empty-bag)
           (bag? (bag-insert empty-bag s))
           ;; stos
           ;; (eq? t (bag-peek (bag-insert (bag-insert empty-bag s) t)))
           ;; kolejka
           ;; (eq? s (bag-peek (bag-insert (bag-insert empty-bag s) t)))
           
           
           ))
;; TODO: napisz inne własności do sprawdzenia!
;; jeśli jakaś własność dotyczy tylko stosu lub tylko kolejki,
;; wykomentuj ją i opisz to w komentarzu powyżej własności

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)

;; genetuje n grafów z dokładnie ver-num wierzchołków
(define (generate-graphs n ver-num)

  ;; konstruktory i selektory superwierzchołków
  ;; takich jak w algorytmie Boruvki (ale dla grafów nieważonych)
  (define (super-vert-cons l)
    (list 'sup-ver l))
  (define (super-vert-list s)
    (second s))
  (define (super-vertice? s)
    (and (list? s)
         (= 2 (length s))
         (eq? (first s) 'sup-ver)))
  
  ;; generuje drzewo na wszystkich wierzchołkach
  (define (tree-generator svl el)
    ;; losuje dwa superwierzchołki, łączy je, dodaje krawędź do listy krawędzi i nowy superwierzchołek do listy wierzchołków
    (define (rand-2-of-list)
      (let* ([sver1-ind (random (length svl))]
             [sver2-ind (random (- (length svl) 1))]
             [sv1       (list-ref svl sver1-ind)]
             [sv2       (list-ref svl (if (> sver1-ind sver2-ind) sver2-ind (+ 1 sver2-ind)))] 
             [new-svl   (remove sv2 (remove sv1 svl))]
             [sv1-v     (list-ref (super-vert-list sv1) (random (length (super-vert-list sv1))))]
             [sv2-v     (list-ref (super-vert-list sv2) (random (length (super-vert-list sv2))))]
             ;; zakładamy, że graf jest nieskierowany
             [new-e     (if (< sv1-v sv2-v)
                            (edge sv1-v sv2-v)
                            (edge sv2-v sv1-v))]
             [new-sv    (super-vert-cons (append (super-vert-list sv1) (super-vert-list sv2)))])
        (cons (cons new-sv new-svl) (cons new-e el))))

    (if (= (length svl) 1)
        el
        (let* ((app-res (rand-2-of-list))
               (res-svl (car app-res))
               (res-el (cdr app-res)))
          (tree-generator res-svl res-el))))
  ;;Generuje wszystkie możliwe krawędzie w grafie
  (define (generate-edges ver-list)
    (if (null? ver-list)
        null
        (append (map (lambda (x) (edge (car ver-list) x)) (cdr ver-list))
                (generate-edges (cdr ver-list)))))
  ;; najpierw buduje drzewo, następnie dolosowuje pozostałe krawędzie
  (define (generate-graph)
    ;; iteracyjnie dolosowuje krawędzie
    (define (iter el n acc)
      (if (= n 0)
          acc
          (let ([edge (list-ref el (random (length el)))])
            (iter (remove edge el) (- n 1) (cons edge acc)))))
    (let* ((graph-vertices  (build-list ver-num values))
           (tree-edges      (tree-generator (map super-vert-cons (build-list ver-num list)) null))
           (all-edges       (generate-edges graph-vertices))
           (edges-to-choose (remove* tree-edges all-edges))
           (how-many-edges  (random (+ 1 (/ (* (- ver-num 2) (- ver-num 1)) 2)))))
      
      (graph graph-vertices
             (sort (iter edges-to-choose how-many-edges tree-edges)
                   (lambda (x y) (if (= (edge-start x) (edge-start y))
                                     (< (edge-end x) (edge-end y))
                                     (< (edge-start x) (edge-start y))))))
      ))
  (if (= n 0)
      null
      (cons (generate-graph) (generate-graphs (- n 1) ver-num))
  ))
  
      

  
;; uruchomienie przeszukiwania na przykładowym grafie
(search test-graph 1)

;; uruchamia funkcję search na n grafach o k wierzchołkach
(define (test-graphs n k)
  (let ((graphs (generate-graphs n k)))
    (map (lambda (x) (cons x (search x 0))) graphs)))

(test-graphs 10 7)