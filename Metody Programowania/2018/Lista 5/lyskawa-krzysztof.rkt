#lang racket

#|
Krzysztof Łyskawa
Pracownia 5
Współpracownicy: Krzysztof Lis, kod ze skosa
|#

;; pomocnicza funkcja dla list tagowanych o określonej długości
(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))

;; reprezentacja danych wejściowych (z ćwiczeń)
(define (var? x)
  (symbol? x))

(define (var x)
  x)

(define (var-name x)
  x)

;; przydatne predykaty na zmiennych
(define (var<? x y)
  (symbol<? x y))

(define (var=? x y)
  (eq? x y))

(define (literal? x)
  (and (tagged-tuple? 'literal 3 x)
       (boolean? (cadr x))
       (var? (caddr x))))

(define (literal pol x)
  (list 'literal pol x))

(define (literal-pol x)
  (cadr x))

(define (literal-var x)
  (caddr x))

(define (clause? x)
  (and (tagged-list? 'clause x)
       (andmap literal? (cdr x))))

(define (clause . lits)
  (cons 'clause lits))

(define (clause-lits c)
  (cdr c))

(define (cnf? x)
  (and (tagged-list? 'cnf x)
       (andmap clause? (cdr x))))

(define (cnf . cs)
    (cons 'cnf cs))

(define (cnf-clauses x)
  (cdr x))

;; oblicza wartość formuły w CNF z częściowym wartościowaniem. jeśli zmienna nie jest
;; zwartościowana, literał jest uznawany za fałszywy.
(define (valuate-partial val form)
  (define (val-lit l)
    (let ((r (assoc (literal-var l) val)))
      (cond
       [(not r)  false]
       [(cadr r) (literal-pol l)]
       [else     (not (literal-pol l))])))
  (define (val-clause c)
    (ormap val-lit (clause-lits c)))
  (andmap val-clause (cnf-clauses form)))

;; reprezentacja dowodów sprzeczności

(define (axiom? p)
  (tagged-tuple? 'axiom 2 p))

(define (proof-axiom c)
  (list 'axiom c))

(define (axiom-clause p)
  (cadr p))

(define (res? p)
  (tagged-tuple? 'resolve 4 p))

(define (proof-res x pp pn)
  (list 'resolve x pp pn))

(define (res-var p)
  (cadr p))

(define (res-proof-pos p)
  (caddr p))

(define (res-proof-neg p)
  (cadddr p))

;; sprawdza strukturę, ale nie poprawność dowodu
(define (proof? p)
  (or (and (axiom? p)
           (clause? (axiom-clause p)))
      (and (res? p)
           (var? (res-var p))
           (proof? (res-proof-pos p))
           (proof? (res-proof-neg p)))))

;; procedura sprawdzająca poprawność dowodu
(define (check-proof pf form)
  (define (run-axiom c)
    (displayln (list 'checking 'axiom c))
    (and (member c (cnf-clauses form))
         (clause-lits c)))
  (define (run-res x cpos cneg)
    (displayln (list 'checking 'resolution 'of x 'for cpos 'and cneg))
    (and (findf (lambda (l) (and (literal-pol l)
                                 (eq? x (literal-var l))))
                cpos)
         (findf (lambda (l) (and (not (literal-pol l))
                                 (eq? x (literal-var l))))
                cneg)
         (append (remove* (list (literal true x))  cpos)
                 (remove* (list (literal false x)) cneg))))
  (define (run-proof pf)
    (cond
     [(axiom? pf) (run-axiom (axiom-clause pf))]
     [(res? pf)   (run-res (res-var pf)
                           (run-proof (res-proof-pos pf))
                           (run-proof (res-proof-neg pf)))]
     [else        false]))
  (null? (run-proof pf)))


;; reprezentacja wewnętrzna

;; sprawdza posortowanie w porządku ściśle rosnącym, bez duplikatów
(define (sorted? vs)
  (or (null? vs)
      (null? (cdr vs))
      (and (var<? (car vs) (cadr vs))
           (sorted? (cdr vs)))))

(define (sorted-varlist? x)
  (and (list? x)
       (andmap (var? x))
       (sorted? x)))

;; klauzulę reprezentujemy jako parę list — osobno wystąpienia pozytywne i negatywne. Dodatkowo
;; pamiętamy wyprowadzenie tej klauzuli (dowód) i jej rozmiar.
(define (res-clause? x)
  (and (tagged-tuple? 'res-int 5 x)
       (sorted-varlist? (second x))
       (sorted-varlist? (third x))
       (= (fourth x) (+ (length (second x)) (length (third x))))
       (proof? (fifth x))))

(define (res-clause pos neg proof)
  (list 'res-int pos neg (+ (length pos) (length neg)) proof))

(define (res-clause-pos c)
  (second c))

(define (res-clause-neg c)
  (third c))

(define (res-clause-size c)
  (fourth c))

(define (res-clause-proof c)
  (fifth c))

;; przedstawia klauzulę jako parę list zmiennych występujących odpowiednio pozytywnie i negatywnie
(define (print-res-clause c)
  (list (res-clause-pos c) (res-clause-neg c)))

;; sprawdzanie klauzuli sprzecznej
(define (clause-false? c)
  (and (null? (res-clause-pos c))
       (null? (res-clause-neg c))))

;; pomocnicze procedury: scalanie i usuwanie duplikatów z list posortowanych
(define (merge-vars xs ys)
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [(var<? (car xs) (car ys))
         (cons (car xs) (merge-vars (cdr xs) ys))]
        [(var<? (car ys) (car xs))
         (cons (car ys) (merge-vars xs (cdr ys)))]
        [else (cons (car xs) (merge-vars (cdr xs) (cdr ys)))]))

(define (remove-duplicates-vars xs)
  (cond [(null? xs) xs]
        [(null? (cdr xs)) xs]
        [(var=? (car xs) (cadr xs)) (remove-duplicates-vars (cdr xs))]
        [else (cons (car xs) (remove-duplicates-vars (cdr xs)))]))

(define (rev-append xs ys)
  (if (null? xs) ys
      (rev-append (cdr xs) (cons (car xs) ys))))

;; TODO: miejsce na uzupełnienie własnych funkcji pomocniczych



(define (intersection l1 l2)
  
  (if (or (null? l1)
          (null? l2))
      null
      (if (var=? (car l1) (car l2))
          (car l1)
          (if (var<? (car l1) (car l2))
              (intersection (cdr l1) l2)
              (intersection l1 (cdr l2))
          )  
      )
  )
)

(define (clause-trivial? c)
  (if (= (res-clause-size c) 0)
      true
      (not (null? (intersection (res-clause-pos c) (res-clause-neg c))))
  )
)


(define (resolve c1 c2)
  
  (let ((interc1c2 (intersection (res-clause-pos c1)
                                 (res-clause-neg c2)))
        (interc2c1 (intersection (res-clause-neg c1)
                   (res-clause-pos c2)))
        (pos-sum (remove-duplicates-vars (merge-vars (res-clause-pos c1)
                                               (res-clause-pos c2))))
        (neg-sum (remove-duplicates-vars (merge-vars (res-clause-neg c1)
                                              (res-clause-neg c2)))))
        (cond [(not (null? interc1c2)) (res-clause
                                        (remove interc1c2 pos-sum)
                                        (remove interc1c2 neg-sum)
                                        (proof-res interc1c2
                                                   (res-clause-proof c1)
                                                   (res-clause-proof c2)))]
              [(not (null? interc2c1)) (res-clause
                                        (remove interc2c1 pos-sum)
                                        (remove interc2c1 neg-sum)
                                        (proof-res interc2c1
                                                   (res-clause-proof c2)
                                                   (res-clause-proof c1)))]
              [else false])
   )
)

(define (resolve-single-prove s-clause checked pending)
  ;; TODO: zaimplementuj!
  ;; Poniższa implementacja działa w ten sam sposób co dla większych klauzul — łatwo ją poprawić!
  (let* ((resolve-clause (lambda (c) (let ((res (resolve c s-clause)))
                                                     (if (false? res)
                                                         c
                                                         res))))
         (checked-with-resolvents (map resolve-clause checked))
         (pending-with-resolvents (map resolve-clause pending))
         (sorted-checked (sort-clauses (cons s-clause checked-with-resolvents)))
         (sorted-pending (sort-clauses pending-with-resolvents)))
    (cond [(clause-false? (car sorted-checked))
           (list 'unsat (res-clause-proof (car sorted-checked)))]
          [(and (not (null? sorted-pending))
                (clause-false? (car sorted-pending)))
           (list 'unsat (res-clause-proof (car sorted-pending)))]
          [else (resolve-prove sorted-checked sorted-pending)])))

;; wstawianie klauzuli w posortowaną względem rozmiaru listę klauzul
(define (insert nc ncs)
  (cond
   [(null? ncs)                     (list nc)]
   [(< (res-clause-size nc)
       (res-clause-size (car ncs))) (cons nc ncs)]
   [else                            (cons (car ncs) (insert nc (cdr ncs)))]))

;; sortowanie klauzul względem rozmiaru (funkcja biblioteczna sort)
(define (sort-clauses cs)
  (sort cs < #:key res-clause-size))

;; główna procedura szukająca dowodu sprzeczności
;; zakładamy że w checked i pending nigdy nie ma klauzuli sprzecznej
(define (resolve-prove checked pending)
  (cond
   ;; jeśli lista pending jest pusta, to checked jest zamknięta na rezolucję czyli spełnialna
   [(null? pending) (generate-valuation (sort-clauses checked))]
   ;; jeśli klauzula ma jeden literał, to możemy traktować łatwo i efektywnie ją przetworzyć
   [(= 1 (res-clause-size (car pending)))
    (resolve-single-prove (car pending) checked (cdr pending))]
   ;; w przeciwnym wypadku wykonujemy rezolucję z wszystkimi klauzulami już sprawdzonymi, a
   ;; następnie dodajemy otrzymane klauzule do zbioru i kontynuujemy obliczenia
   [else
    (let* ((next-clause  (car pending))
           (rest-pending (cdr pending))
           (resolvents   (filter-map (lambda (c) (resolve c next-clause))
                                     checked))
           (sorted-rs    (sort-clauses resolvents)))
      (subsume-add-prove (cons next-clause checked) rest-pending sorted-rs))]))

;; procedura upraszczająca stan obliczeń biorąc pod uwagę świeżo wygenerowane klauzule i
;; kontynuująca obliczenia. Do uzupełnienia.
;; Procedura pomocnicza sprawdzająca czy zmienna jest łatwiejsza

(define (easier? c1 c2) ;; czy c1 łatwiejsze od c2 - c2 jest podzbiorem c1
  (let ((pos1 (res-clause-pos c1))
        (pos2 (res-clause-pos c2))
        (neg1 (res-clause-neg c1))
        (neg2 (res-clause-neg c2)))
    (cond [(or (< (length pos1) (length pos2)) ;; jeśli lista pozytywów lub negatywów w c1
               (< (length neg1) (length neg2))) false] ;;  jest mniejsza niż w c2 to fałsz
          [(clause-false? c2) true] ;; jesli c1 jest puste to prawda
          [(not (null? pos2)) ;; jeśli istnieje pozytywny literał w c2
           (cond [(var=? (car pos1) (car pos2)) ;; jeśli pierwsze zmienne są równe, to sprawdzamy dla listy bez nich
                  (easier? (res-clause (cdr pos1) neg1 (res-clause-proof c1))
                           (res-clause (cdr pos2) neg2 (res-clause-proof c2)))]
                 [(var<? (car pos1) (car pos2)) ;; jesli pierwsza klauzula w c1 jest mniejsza to sprawdzamy dla listy bez niej
                  (easier? (res-clause (cdr pos1) neg1 (res-clause-proof c1))
                           (res-clause pos2 neg2 (res-clause-proof c2)))]
                 [else false])] ;; jeśli pierwsza klauzula w c1 jest większa, to mamy sprzeczność (bo pierwszej klauzuli z c2 nie ma na liście)
          [else
           (cond [(var=? (car neg1) (car neg2))
                  (easier? (res-clause pos1 (cdr neg1) (res-clause-proof c1))
                           (res-clause pos2 (cdr neg2) (res-clause-proof c2)))]
                 [(var<? (car neg1) (car neg2))
                  (easier? (res-clause pos1 (cdr neg1) (res-clause-proof c1))
                           (res-clause pos2 neg2 (res-clause-proof c2)))]
                 [else false])]) ;; analogicznie jak wyżej
  )
)
                              
  

(define (subsume-add-prove checked pending new)
  (cond
   [(null? new)                 (resolve-prove checked pending)]
   ;; jeśli klauzula do przetworzenia jest sprzeczna to jej wyprowadzenie jest dowodem sprzeczności
   ;; początkowej formuły
   [(clause-false? (car new))   (list 'unsat (res-clause-proof (car new)))]
   ;; jeśli klauzula jest trywialna to nie ma potrzeby jej przetwarzać
   [(clause-trivial? (car new)) (subsume-add-prove checked pending (cdr new))]
   [else
    (if (or (ormap (lambda (x) (easier? (car new) x)) checked) ;; jeśli istnieje trudniejsza klauzula od naszej nowej
            (ormap (lambda (x) (easier? (car new) x)) pending)) ;; to pomijamy naszą nową
        (subsume-add-prove checked pending (cdr new)) ;; w przeciwnym przypadku usuwamy wszystkie łatwiejsze od nasze
        (let ((pending-not-easier (filter (lambda (x) (not (easier? x (car new)))) pending))
              (checked-not-easier (filter (lambda (x) (not (easier? x (car new)))) checked)))
           ;; i je pomijamy
          (subsume-add-prove checked-not-easier (insert (car new) pending-not-easier) (cdr new))))
    ]))

(define (generate-valuation resolved)  ;;lista klauzul posortowanych po rozmiarze

  (define (remove-lit c lit)  ;;usuwa zmienną z klauzuli
    (cond [(not (null? (filter (lambda (x) (var=? x (literal-var lit))) (res-clause-pos c))))
           (if (literal-pol lit)
               null
               (res-clause
                (filter (lambda (x) (not (var=? x (literal-var lit)))) (res-clause-pos c))
                (res-clause-neg)
                (res-clause-proof c)))]
          [(not (null? (filter (lambda (x) (var=? x (literal-var lit))) (res-clause-neg c))))
           (if (literal-pol lit)
               (res-clause
                (res-clause-pos c)
                (filter (lambda (x) (not (var=? x (literal-var lit)))) (res-clause-neg c))
                (res-clause-proof c))
               null)]
          [else c])
  )
        
  (define (remove-from-list clauses lit)  ;;usuwa zmienną z listy klauzul
    (if (null? clauses)
        null
        (let* ([first (car clauses)]
               [clause-without-lit (remove-lit first lit)])
          (if (null? clause-without-lit)
              (remove-from-list (cdr clauses) lit)
              (cons clause-without-lit (remove-from-list (cdr clauses) lit))
          )
        )
    )
  )
  (define (check-dict dict var)  ;;szuka czy zmienna jest już w akumulatorze i zwraca ją wraz z wartością
    (assoc var dict))
  
  (define (iter-val-gen clauses acc)  ;;iterator
    (if (null? clauses)
        acc 
        (let* ([first (car clauses)]
               [pos (res-clause-pos first)]
               [neg (res-clause-neg first)])
          (cond [(clause-false? first) false]
                [(= (res-clause-size first) 1) ;; pierwsza klauzula ma jedną zmienną
                 (if (null? neg)  ;;zmienna jest prawdą
                     (let ((var-val (check-dict acc (car pos))))
                       (if (not var-val) 
                           (iter-val-gen
                            (sort-clauses (remove-from-list (cdr clauses) (literal true (car pos)))) ;; iterujemy dalej usuwając wszystkie wystąpienia zmiennej w pozostałej części listy
                            (cons (cons (car pos) true) acc)
                           )
                           (if (cdr var-val)
                               (iter-val-gen
                                (sort-clauses (remove-from-list (cdr clauses) (literal true (car pos))))
                                (cons (cons (car pos) true) acc)
                               )
                               acc
                           )
                       )
                     )
                     (let ((var-val (check-dict acc (car neg))))
                       (if (not var-val) 
                           (iter-val-gen
                            (sort-clauses (remove-from-list (cdr clauses) (literal true (car neg)))) ;; iterujemy dalej usuwając wszystkie wystąpienia zmiennej w pozostałej części listy
                            (cons (cons (car neg) false) acc)
                           )
                           (if (cdr var-val)
                               (iter-val-gen
                                (sort-clauses (remove-from-list (cdr clauses) (literal false (car neg))))
                                (cons (cons (car neg) false) acc)
                               )
                               acc
                           )
                       )
                     )
              )]
              ;; klauzula ma więcej zmiennych
              [else
               (if (not (null? pos))
                     (let ([var-val (check-dict acc (car pos))])
                       (if (not var-val)
                           ;; zmiennej nie ma w słowniku (akumulatorze)
                           (let ([acc-returned-1 (iter-val-gen (cdr clauses) (cons (cons (car pos) true) acc))])
                             (if (not (false? acc-returned-1))
                                 acc-returned-1  ;; wpisujemy do słownika zmienną z wartością true, sprawdzamy czy to wartościowanie działa
                                 (let ([acc-returned-2 (iter-val-gen clauses (cons (cons (car pos) false) acc))])
                                   (if (not (false? acc-returned-2))
                                       acc-returned-2 ;; jeśli nie, robimy to samo z wartością false, jeśli też nie działa, zwracamy false
                                       false
                                   )
                                 )
                             )
                           )
                           ;; zmienna jest w słowniku
                           (if (cdr var-val)
                               (iter-val-gen (cdr clauses) acc)  ;; zmienna ma wartosć jak w słowniku
                               (iter-val-gen  ;; ma inną wartość
                                (cons (res-clause (cdr pos) neg (res-clause-proof first))
                                      (cdr clauses))
                                acc)
                           )
                       )
                     )
                     (let ([var-val (check-dict acc (car neg))])
                       (if (not var-val)
                           ;; zmiennej nie ma w słowniku (akumulatorze)
                           (let ([acc-returned-1 (iter-val-gen (cdr clauses) (cons (cons (car neg) false) acc))])
                             (if (not (false? acc-returned-1))
                                 acc-returned-1
                                 (let ([acc-returned-2 (iter-val-gen clauses (cons (cons (car neg) true) acc))])
                                   (if (not (false? acc-returned-2))
                                       acc-returned-2
                                       false
                                   )
                                 )
                             )
                           )
                           ;; zmienna jest w słowniku
                           (if (not (cdr var-val))
                               (iter-val-gen (cdr clauses) acc)  ;; zmienna ma wartosć jak w słowniku
                               (iter-val-gen  ;; ma inną wartość
                                (cons (res-clause pos (cdr neg) (res-clause-proof first))
                                      (cdr clauses))
                                acc)
                           )
                       )
                     )
                 )]
              )
          )
        )
    )

  (list 'sat (iter-val-gen resolved null))
)

;; procedura przetwarzające wejściowy CNF na wewnętrzną reprezentację klauzul
(define (form->clauses f)
  (define (conv-clause c)
    (define (aux ls pos neg)
      (cond
       [(null? ls)
        (res-clause (remove-duplicates-vars (sort pos var<?))
                    (remove-duplicates-vars (sort neg var<?))
                    (proof-axiom c))]
       [(literal-pol (car ls))
        (aux (cdr ls)
             (cons (literal-var (car ls)) pos)
             neg)]
       [else
        (aux (cdr ls)
             pos
             (cons (literal-var (car ls)) neg))]))
    (aux (clause-lits c) null null))
  (map conv-clause (cnf-clauses f)))

(define (prove form)
  (let* ((clauses (form->clauses form)))
    (subsume-add-prove '() '() clauses)))

;; procedura testująca: próbuje dowieść sprzeczność formuły i sprawdza czy wygenerowany
;; dowód/waluacja są poprawne. Uwaga: żeby działała dla formuł spełnialnych trzeba umieć wygenerować
;; poprawną waluację.
(define (prove-and-check form)
  (let* ((res (prove form))
         (sat (car res))
         (pf-val (cadr res)))
    (if (eq? sat 'sat)
        (valuate-partial pf-val form)
        (check-proof pf-val form))))

;;; TODO: poniżej wpisz swoje testy
(define c0 (res-clause '() '() 'axiom))
(define c01 (res-clause '(p) '() 'axiom))
(define c02 (res-clause '() '(p) 'axiom))
(define c1 (res-clause '() '(p q r s t) 'axiom))
(define c2 (res-clause '(p q r) '(q s t) 'axiom))
(define c3 (res-clause '(p q r) '(s t u) 'axiom))
(define c4 (res-clause '(a b) '(p c) 'axiom))
(define c5 (res-clause '(p q r s t u v w) '(p q r s t u v w) 'axiom))
(define c6 (res-clause '(p q) '() 'axiom))
(define c7 (res-clause '(p) '(q) 'axiom))
(define c8 (res-clause '(q) '(p) 'axiom))
(define c9 (res-clause '() '(p q) 'axiom))
(define c10 (res-clause '(p q) '(p) 'axiom))
(define c11 (res-clause '(q) '(p q) 'axiom))

"---------Zadanie 1---------"
(clause-trivial? c0)
(clause-trivial? c1)
(clause-trivial? c2)
(clause-trivial? c3)
(resolve c0 c0)
(resolve c1 c2)
(resolve c3 c4)
"---------Zadanie 2---------"
(generate-valuation (list c0))
(generate-valuation (list c0 c1))
(generate-valuation (list c3 c4))
(generate-valuation (list c1 c3 c4))
(generate-valuation (list c1 c2))
(generate-valuation (list c1 c2 c4))
(generate-valuation (list c1 c2 c3 c4))
(generate-valuation (list c01 c02))
"---------Zadanie 3---------"
(easier? c5 c3)
(easier? c0 c1)
(easier? c1 c0)
(easier? c1 c5)
(easier? c5 c1)
(easier? c3 c3)
(resolve-prove '() (list c1 c2 c3 c4 c5))
(resolve-prove '() (list c01 c02))
(resolve-prove '() (list c02 c4))
(resolve-prove '() (list c6 c7 c8 c9))
(subsume-add-prove '() '() (list c10 c11))