#include "csapp.h"

static __thread unsigned seed;

static void rand_usleep(int min, int max) {
  usleep(rand_r(&seed) % (max - min + 1) + min);
}

#define DEBUG
#ifdef DEBUG
static __unused void outc(char c) {
  Write(STDOUT_FILENO, &c, 1);
}

/* XXX Please use following function to simulate malicious scheduler.
 * Just insert a call to rand_yield between instructions in your solution. */
static __unused void rand_yield(void) {
  /* Once every 100 calls to this function (on average)
   * it yields and lets kernel choose another thread. */
  if (rand_r(&seed) % 100 == 42)
    sched_yield();
}
#else
#define outc(c)
#define rand_yield()
#endif

typedef struct ramen {
  /* TODO: Put internal state & mutexes & condvars here. */
  int free_seats;
  int finished_eating;
  int seats;
  bool can_leave;
  pthread_cond_t must_wait;
  pthread_cond_t all_eaten;
  pthread_cond_t left;
  pthread_mutex_t mutex;
  pthread_mutex_t block;
} ramen_t;

static void ramen_init(ramen_t *r, unsigned seats) {
  /* TODO: Initialize internal state of ramen restaurant. */
  r->free_seats = seats;
  r->seats = seats;
  r->finished_eating = 0; 
  r->can_leave = false; 
  pthread_cond_init(&r->must_wait, NULL);
  pthread_cond_init(&r->all_eaten, NULL);
  pthread_cond_init(&r->left, NULL);
  pthread_mutex_init(&r->mutex, NULL);
  pthread_mutex_init(&r->block, NULL);
}

static void ramen_destroy(ramen_t *r) {
  /* TODO: Destroy all synchronization primitives. */
  pthread_mutex_destroy(&r->mutex);
  pthread_mutex_destroy(&r->block);
  pthread_cond_destroy(&r->must_wait);
  pthread_cond_destroy(&r->all_eaten);
  pthread_cond_destroy(&r->left);
}

static void ramen_wait(ramen_t *r) {
  /* TODO: Enter the restaurant unless it's full or people haven't left yet. */
  pthread_mutex_lock(&r->mutex);
  rand_yield();
  while(r->free_seats == 0)
  {
    rand_yield();
    pthread_cond_wait(&r->must_wait, &r->mutex);
    rand_yield();
  }
  r->can_leave = false;
  rand_yield();
  r->free_seats--;
  rand_yield();
  pthread_mutex_unlock(&r->mutex);
}

static void ramen_finish(ramen_t *r) {
  /* TODO: Finished eating, so wait for all other to finish before leaving. */
  pthread_mutex_lock(&r->mutex);
  r->finished_eating++;
  //outc('c');
  while(r->can_leave || r->finished_eating + r->free_seats < r->seats){
    pthread_cond_wait(&r->all_eaten, &r->mutex);
  }
  outc('a');
  r->can_leave = true;
  r->finished_eating--;
  pthread_cond_signal(&r->all_eaten);
  pthread_cond_signal(&r->left);
  
  while(r->finished_eating > 0)
  {
    outc('b');
    pthread_cond_signal(&r->all_eaten);
    pthread_cond_wait(&r->left, &r->mutex);
    pthread_cond_signal(&r->left);
  }
  r->free_seats++;
  pthread_cond_signal(&r->must_wait);
  pthread_mutex_unlock(&r->mutex);
}

void *customer(void *data) {
  ramen_t *r = data;

  seed = (unsigned)pthread_self();

  while (true) {
    /* Wait till you get hungry. */
    rand_usleep(5000, 10000);

    /* Queue for delicious ramen. */
    outc('.');
    ramen_wait(r);

    /* It's so yummy! */
    outc('@');
    rand_usleep(1000, 2000);

    /* Time to leave, but don't be rude or else... */
    ramen_finish(r);
    outc('_');
  }
}

#define THREADS 10
#define SEATS 5

int main(void) {
  ramen_t r;
  ramen_init(&r, SEATS);

  pthread_t tid[THREADS];

  for (int i = 0; i < THREADS; i++)
    Pthread_create(&tid[i], NULL, customer, &r);

  for (int i = 0; i < THREADS; i++)
    Pthread_join(tid[i], NULL);

  ramen_destroy(&r);
  return 0;
}
