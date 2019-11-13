#lang racket

#|
Pracownia 7
Krzysztof Łyskawa
Współpracownicy: Krzysztof Lis, Oleś Kulczewicz, kod ze skosa
Sortowanie jest identyczne, robione wspólnie i przerzucone z jednego
komputera na drugi pendrivem, bo przepisywanie byłoby zbyt mozolne
i już nam się nie chciało
|#

;; expressions

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-cons op args)
  (cons op args))

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

(define (arith/let-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith/let-expr? (op-args t)))
      (and (let? t)
           (arith/let-expr? (let-expr t))
           (arith/let-expr? (let-def-expr (let-def t))))
      (var? t)))

;; let-lifted expressions

(define (arith-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith-expr? (op-args t)))
      (var? t)))

(define (let-lifted-expr? t)
  (or (and (let? t)
           (let-lifted-expr? (let-expr t))
           (arith-expr? (let-def-expr (let-def t))))
      (arith-expr? t)))

;; generating a symbol using a counter

(define (number->symbol i)
  (string->symbol (string-append "x" (number->string i))))

;; environments (could be useful for something)

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; the let-lift procedure

(define (let-lift e)  
  (define (let-lift-rec expr num dict)
    ;; jeżeli expr jest stałą, to zwraca to samo wyrażenie jako wyrażenie bez letów,
    ;; nie zmienia licznika podmiany i zwraca pustą let-listę 
    (cond [(const? expr) (list expr num '())]
          ;; jeżeli expr jest zmienną, to funkcja podmienia ją na naszą słownikową,
          ;; nie zmienia licznika podmiany i zwraca pustą let-listę
          [(var? expr) (list (find-in-env expr dict) num '())]
          ;; jeżeli expr jest wyrażeniem arytmetycznym, to wywołujemy let-lifta dla każdego argumentu wyrażenia,
          ;; zwiększamy odpowiednio licznik i wyniki wywołań zwracamy jako wyrazenie bez letów i let-listę
          [(op? expr) (let* ((args-result (map-iter (op-args expr) num dict null null))
                            (expr-list    (first args-result))
                            (new-num      (second args-result))
                            (let-list      (third args-result)))
                        (list (op-cons (op-op expr) expr-list) new-num let-list))]
          ;; jeżeli expr jest letem, to najpierw wywołujemy let-lifta dla wyrażenia w jego definicji
          ;; następnie dodajemy podmienioną zmienną do słownika i wywołujemy let-lifta dla wyrażenia leta
          [(let? expr) (let* ((let-def-expr-result (let-lift-rec (let-def-expr (let-def expr)) num dict))
                              (expr-list           (first let-def-expr-result))
                              (new-num             (second let-def-expr-result))
                              (let-list            (third let-def-expr-result))
                              (let-expr-result     (let-lift-rec (let-expr expr)
                                                                 (+ 1 new-num)
                                                                 (add-to-env (let-def-var (let-def expr))
                                                                             (number->symbol new-num)
                                                                             dict)))
                              (expr-list2          (first let-expr-result))
                              (new-num2            (second let-expr-result))
                              (let-list2           (third let-expr-result)))
                         ;; zwracamy listę w postaci: wyrażenie bez letów wynikowe dla let-wyrażenia,
                         ;; powiększony dwukrotnie licznik, obie let-listy zmergowane i zconsowane z letem z tej instancji
                         (list expr-list2 new-num2 (cons
                                                    (let-def-cons (number->symbol new-num) expr-list)
                                                    (append let-list let-list2))
    ))]))
    ;; funkcja odpowiadająca mapowi, służąca do przejścia po liście wyrażeń ze zmianą licznika podmiany
    (define (map-iter exprs num dict expr-acc let-list-acc)
      (if (null? exprs)
          ;; na koniec iteracji zwracamy zakumulowane wyrażenie bez letów, zakumulowaną let-listę
          ;; i licznik podmiany otrzymany po przejściu
          (list (reverse expr-acc) num let-list-acc)
          ;; w środku listy wywołujemy naszego lifta dla pojedynczego wyrażenia z opa
          (let* ((result (let-lift-rec (car exprs) num dict))
                 (res-expr (first result))   ;; selektory
                 (res-num (second result))
                 (res-let-list (third result)))
            ;; wywołujemy kolejną iterację dla reszty listy wyrażeń, nowego (powiększonego) licznika, tego samego słownika
            ;; i powiększonych o wynik wywołania let-lifta akumulatory
            (map-iter (cdr exprs) res-num dict (cons res-expr expr-acc) (append res-let-list let-list-acc)))
      )
    )
  ;; generator wyrażenia - robi let-wyrażenie z pierwszym elementem listy i
  ;; akumulatorem (początkowy akumulator to wyrażenie bez letów)
  (define (gen-output let-list acc)
    (if (null? let-list)
        acc
        (gen-output (cdr let-list) (let-cons (car let-list) acc))))
    
  (let* ((result      (let-lift-rec e 1 empty-env))
         (expr-list   (first result))
         (let-list    (third result)))
    (gen-output (sort-let-list let-list) expr-list)
  )
)


;; pomocnicza funkcja, ktora zamienia symbol wieloznakowy na liste symboli jednoznakowych
;; przyklad: 'abc -> '(a b c)
(define (symbol->list-of-symbols s)
  (map (lambda (x) (string->symbol (string x)))
       (string->list (symbol->string s)))
)

;; pomocnicza funkcja, ktora zamienia liste symboli jednoznakowych na jeden symbol wieloznakowy
;; przyklad: '(a b c) -> 'abc
(define (list-of-symbols->symbol l)
  (string->symbol (string-join (map symbol->string l) ""))
)

(define (sort-let-list list)
  (sort list (lambda (x y) (> (string->number (symbol->string (list-of-symbols->symbol
                                                               (cdr (symbol->list-of-symbols (let-def-var x))))))
                              (string->number (symbol->string (list-of-symbols->symbol
                                                               (cdr (symbol->list-of-symbols (let-def-var y)))))))))
)

;; testy
(let-lift '(+ 10 (* (let (x 7) (+ x 2)) 2)))
(let-lift '(+ (let (x 5) x) (let (x 1) x)))
(let-lift '(let (x (- 2 (let (z 3) z))) (+ x 2))) ;; przy braku sortowania jeden z tych
(let-lift '(let (x 1) (let (y (+ x 2)) (* x y)))) ;; letów jest w złej kolejności
(let-lift '(/ (let (a (+ (let (e 67) 37) 74 (+ 15 2 16))) 14) 48 (let (a 25) (/ a 82 12))))
(let-lift '(/ 68 (let (d 5) d) (let (d (+ 58 71 75)) (let (b 49) d))))
(let-lift '(let (e (* (let (e 43) 4) 37 (/ 31 84 32))) 11))
(let-lift '(+ 19 94 (let (b (/ (/ 52 24 9) (let (a 25) a) (- 43 0 37))) 63)))
(let-lift '(let (c (let (a 18) (let (a 91) (let (d 74) a)))) 4))
(let-lift '(let (b (/ (+ 3 33 68) (- 65 26 37) (let (e 96) 70))) b))
(let-lift '(* 16 (/ (let (c 38) 54) (+ 73 33 14) 76) (- 31 54 0)))
(let-lift '(let (c 85) (let (b (let (d c) (- (let (b (let (a (let (b 51) 48)) c)) 90) 5 (* 33 (let (c (/ (let (a (let (b 13) (let (d c) d))) (let (e 81) (+ e e d))) c c)) (+ c (/ (let (a (let (d c) 81)) (+ a a 8)) (* c 93 (let (e c) c)) (* 33 c (let (b c) 90))) c)) c)))) 87)))
(let-lift '(+ a 3))
