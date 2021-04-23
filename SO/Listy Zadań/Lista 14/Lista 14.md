# SO Lista 14

###### tags: `SO`

## Zadanie 1

**semafor** - zmienna używana do kontrolowania dostępu do zasobów, które są dzielone przez wiele procesów/wątków

```c=
typedef struct sem_t {
    pthread_mutex_t mutex;
    pthread_cond_t waiters;
    int value;
} sem_t;

// only one thread can call this
void sem_init(sem_t *s, int value) {
    s->value = value;
    pthread_cond_init(&s->waiters, NULL);
    pthread_mutex_init(&s->mutex, NULL);
}

void sem_wait(Zem_t *s) {
    pthread_mutex_lock(&s->mutex);
    while (s->value <= 0)
        pthread_cond_wait(&s->waiters, &s->mutex);
    s->value--;
    pthread_mutex_unlock(&s->mutex);
}

void sem_post(Zem_t *s) {
    pthread_mutex_lock(&s->mutex);
    s->value++;
    pthread_cond_signal(&s->waiters);
    pthread_mutex_unlock(&s->mutex);
}

```
