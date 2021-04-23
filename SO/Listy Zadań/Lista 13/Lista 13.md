# SO Lista 13

###### tags: `SO`

## Zadanie 1

**producent-konsument** - sytuacja w której wątki dzielą się na producentów i konsumentów. Producenci produkują dane i umieszczają je w buforze, a konsumenci biorą dane z tego bufora i coś z nimi robią

```python=
def producer():
    while True:
        item = produce()
        if queue.full():
            sleep()
        queue.push(item)
        if not queue.empty():
            wakeup(consumer)
def consumer():
    while True:
        if queue.empty():
            sleep()
        item = queue.pop()
        if not queue.full():
            wakeup(producer)
        consume(item)
```

a)
1. Producent pordukuje jeden element. Sprawdza linię 7 - if jest prawdziwy. Zanim zdąży wykonać linię 8 zostaje wywłaszczony.
2. Konsument konsumuje jeden (jedyny) element z kolejki. Chce skonsumować kolejny, ale kolejka jest pusta więc idzie spać.
3. Producent budzi konsumenta po czym zostaje wywłaszczony.
4. Konsument próbuje skonsumować element z kolejki, ale jest ona pusta.

Dla błędu wykonania w 6 linijce będzie analogicznie w drugą stronę.

b) 
1. kolejka jest pusta. Konsument zaczyna działać. If w lini 12 jest prawdą, ale zanim konsumer zdąży zasnąć, zostaje wywłaszczony.
2. Producent zaczyna działać. If w lini 7 jest prawdą, ale wakeup nie będzie miało żadnego efektu ponieważ konsument nie śpi. Producent zapełnia kolejkę po czym zasypia w linii 5.
3. Konsument zasypia w linii 13. Oba procesy śpią.
