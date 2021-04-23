/*
Krzysztof Łyskawa 279606

Oświadczam że jestem jedynym autorem kodu źródłowego, (a przynajmniej tych jego
fragmentów,
które nie zostały umieszczone w CSAPP i w przykładowej wersji programu
(mm_naive)).

Program jest w większości modyfikacją kodu z książki CSAPP. Większość kodu
została wzięta z tej książki.
Program działa na zasadzie Implicit Free List - listy są blokami pamięci z
nagłówkiem i stopką opisującymi rozmiar bloku.

Minimalny rozmiar bloku wynosi 16 bajtów. Na pierwszych 4 i ostatnich 4 bajtach
znajduje się nagłówek i stopka zawierające rozmiar bloku i to, czy jest zajęty,
dzięki czemu można łatwo znaleźć poprzedni i następny blok.

Przydział bloku następuje poprzez znalezienie pierwszego wolnego bloku co
najmniej tak dużego jak szukana pamięć.
Jeśli pozostałe miejsce w bloku jest większe niż minimalny rozmiar bloku, to
trzeba tą część odciąć i utworzyć nowy blok. Jeśli tak nie jest, to przydzielamy
cały dostępny blok.

Zwolnienie pamięci następuje poprzez zaznaczenie że blok jest wolny i ewentualne
scalenie go z sąsiadującymi wolnymi blokami.
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include <unistd.h>

#include "mm.h"
#include "memlib.h"

/* If you want debugging output, use the following macro.  When you hand
 * in, remove the #define DEBUG line. */
//#define DEBUG
#ifdef DEBUG
#define debug(...) printf(__VA_ARGS__)
#else
#define debug(...)
#endif

/* do not change the following! */
#ifdef DRIVER
/* create aliases for driver tests */
#define malloc mm_malloc
#define free mm_free
#define realloc mm_realloc
#define calloc mm_calloc
#endif /* def DRIVER */

/* code directly taken from CSAPP */
#define WSIZE 4            /* Word and header/footer size (bytes) */
#define DSIZE 8            /* Double word size (bytes) */
#define CHUNKSIZE (1 << 8) /* Extend heap by this amount (bytes) */
                           /* The lower it is, the more      \
                              efficient memory usage is but the more instructions are needed              \
                              61,2% memory utilization and 23,5k instructions per operation for 12,       \
                              69,2% memory utilization and 30,8k instructions per operation for 8 on the  \
                              same (not fully optimised) code -                                         \
                              those are borderline values I checked, 9 to 11 fall in between */

#define MAX(x, y) ((x) > (y) ? (x) : (y))

/* Pack a size and allocated bit into a word */
#define PACK(size, alloc) ((size) | (alloc))

/* Read and write a word at address p */
#define GET(p) (*(unsigned int *)(p))
#define PUT(p, val) (*(unsigned int *)(p) = (val))

/* Read the size and allocated fields from address p */
#define GET_SIZE(p) (GET(p) & ~0x7)
#define GET_ALLOC(p) (GET(p) & 0x1)

/* Given block ptr bp, compute address of its header and footer */
#define HDRP(bp) ((char *)(bp)-WSIZE)
#define FTRP(bp) ((char *)(bp) + GET_SIZE(HDRP(bp)) - DSIZE)

/* Given block ptr bp, compute address of next and previous blocks */
#define NEXT_BLKP(bp) ((char *)(bp) + GET_SIZE(((char *)(bp)-WSIZE)))
#define PREV_BLKP(bp) ((char *)(bp)-GET_SIZE(((char *)(bp)-DSIZE)))

void *heap_listp;

static size_t round_up(size_t size) {
  return (size + ALIGNMENT - 1) & -ALIGNMENT;
}

/*
 * find_fit - idea taken from CSAPP, go through the list of blocks until you
 * find a block that fits the request (first-fit policy)
 */
void *find_fit(size_t asize) {
  void *bp = heap_listp;
  while (GET_SIZE(HDRP(bp)) < asize || GET_ALLOC(HDRP(bp))) {
    if (GET_SIZE(HDRP(bp)) == 0)
      return NULL;
    bp = NEXT_BLKP(bp);
  }
  return bp;
}
/*
 * place - idea taken from CSAPP, place the requested block at the start of the
 * free block
 * and if there's more than the minimum block size space left, create new block
 * from it
 */
void place(void *bp, size_t asize) {
  size_t size = GET_SIZE(HDRP(bp)) - asize;

  if (size > ALIGNMENT) {
    PUT(HDRP(bp), PACK(asize, 1));
    PUT(FTRP(bp), PACK(asize, 1));
    bp = NEXT_BLKP(bp);
    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));
  } else {
    PUT(HDRP(bp), PACK(GET_SIZE(HDRP(bp)), 1));
    PUT(FTRP(bp), PACK(GET_SIZE(HDRP(bp)), 1));
  }
}

/* code taken from CSAPP */
void *coalesce(void *bp) {
  size_t prev_alloc = GET_ALLOC(FTRP(PREV_BLKP(bp)));
  size_t next_alloc = GET_ALLOC(HDRP(NEXT_BLKP(bp)));
  size_t size = GET_SIZE(HDRP(bp));

  if (prev_alloc && next_alloc) { /* Case 1 */
    return bp;
  }

  else if (prev_alloc && !next_alloc) { /* Case 2 */
    size += GET_SIZE(HDRP(NEXT_BLKP(bp)));
    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));
  }

  else if (!prev_alloc && next_alloc) { /* Case 3 */
    size += GET_SIZE(HDRP(PREV_BLKP(bp)));
    PUT(FTRP(bp), PACK(size, 0));
    PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
    bp = PREV_BLKP(bp);
  }

  else { /* Case 4 */
    size += GET_SIZE(HDRP(PREV_BLKP(bp))) + GET_SIZE(FTRP(NEXT_BLKP(bp)));
    PUT(HDRP(PREV_BLKP(bp)), PACK(size, 0));
    PUT(FTRP(NEXT_BLKP(bp)), PACK(size, 0));
    bp = PREV_BLKP(bp);
  }
  return bp;
}

/* code taken from CSAPP, modified in line size = round_up(words) */
void *extend_heap(size_t words) {
  char *bp;
  size_t size;

  /* Allocate an even number of words to maintain alignment */
  size = round_up(words);
  if ((long)(bp = mem_sbrk(size)) == -1)
    return NULL;

  /* Initialize free block header/footer and the epilogue header */
  PUT(HDRP(bp), PACK(size, 0));         /* Free block header */
  PUT(FTRP(bp), PACK(size, 0));         /* Free block footer */
  PUT(HDRP(NEXT_BLKP(bp)), PACK(0, 1)); /* New epilogue header */

  /* Coalesce if the previous block was free */
  return coalesce(bp);
}

/*
 * mm_init - Called when a new trace starts.
 * code taken from CSAPP, modified a bit, in particular the manipulations of
 * heap_listp and 3 PUTs
 * are the result of testing what works and what doesn't + couning bytes on
 * paper
 */
int mm_init(void) {
  /* Create the initial empty heap */
  if ((heap_listp = mem_sbrk(8 * WSIZE)) == (void *)-1)
    return -1;

  heap_listp += 3 * WSIZE;
  // PUT(heap_listp, 0); /* Alignment padding */
  PUT(heap_listp, PACK(2 * DSIZE, 1));               /* Prologue header */
  PUT(heap_listp + (3 * WSIZE), PACK(2 * DSIZE, 1)); /* Prologue footer */
  PUT(heap_listp + (4 * WSIZE), PACK(0, 1));         /* Epilogue header */
  heap_listp += (1 * WSIZE);

  /* Extend the empty heap with a free block of CHUNKSIZE bytes */
  if (extend_heap(CHUNKSIZE / WSIZE) == NULL)
    return -1;

  return 0;
}

/*
 * malloc - code from CSAPP, modified in lines asize = round_up(size+DSIZE); and
 * if ((bp = extend_heap(extendsize)) == NULL)
 */
void *mm_malloc(size_t size) {
  size_t asize;      /* Adjusted block size */
  size_t extendsize; /* Amount to extend heap if no fit */
  char *bp;

  /* Ignore spurious requests */
  if (size == 0)
    return NULL;

  /* Adjust block size to include overhead and alignment reqs. */
  if (size <= DSIZE)
    asize = 2 * DSIZE;
  else
    asize = round_up(size + DSIZE);

  /* Search the free list for a fit */
  if ((bp = find_fit(asize)) != NULL) {
    place(bp, asize);
    return bp;
  }

  /* No fit found. Get more memory and place the block */
  extendsize = MAX(asize, CHUNKSIZE);
  if ((bp = extend_heap(extendsize)) == NULL)
    return NULL;
  place(bp, asize);
  return bp;
}

/* code taken from CSAPP, added the if clause at the start */
void mm_free(void *bp) {
  if (bp != NULL) {
    size_t size = GET_SIZE(HDRP(bp));

    PUT(HDRP(bp), PACK(size, 0));
    PUT(FTRP(bp), PACK(size, 0));
    coalesce(bp);
  }
}

/*
 * realloc - Change the size of the block by mallocing a new block,
 *      copying its data, and freeing the old block.
 */
void *realloc(void *old_ptr, size_t size) {
  /* If size == 0 then this is just free, and we return NULL. */
  if (size == 0) {
    free(old_ptr);
    return NULL;
  }

  /* If old_ptr is NULL, then this is just malloc. */
  if (!old_ptr)
    return malloc(size);

  size_t old_size = GET_SIZE(HDRP(old_ptr));
  size_t asize = round_up(size + DSIZE);
  /*
   * if old_size is bigger than asize then we don't have to allocate new block.
   * if the new size if small enough that we can get a free block at the end
   * then we do that
   */
  if (old_size >= asize) {
    if (old_size >= asize + ALIGNMENT) {
      PUT(HDRP(old_ptr), PACK(asize, 1));
      PUT(FTRP(old_ptr), PACK(asize, 1));
      PUT(HDRP(NEXT_BLKP(old_ptr)), PACK(old_size - asize, 0));
      PUT(FTRP(NEXT_BLKP(old_ptr)), PACK(old_size - asize, 0));
      coalesce(NEXT_BLKP(old_ptr));
      return old_ptr;
    }
    return old_ptr;
  }

  /*
   * if there's a free block after of our block big enough that we can fit
   * the additional size then we do that (we cut from the new block
   * as litte as we can, creating a new free block if there's enough space)
   */
  size_t next_size = GET_SIZE(HDRP(NEXT_BLKP(old_ptr)));
  if (GET_ALLOC(HDRP(NEXT_BLKP(old_ptr))) == 0 &&
      old_size + next_size >= asize) {
    if (old_size + next_size >= asize + ALIGNMENT) {
      PUT(HDRP(old_ptr), PACK(asize, 1));
      PUT(FTRP(old_ptr), PACK(asize, 1));
      PUT(HDRP(NEXT_BLKP(old_ptr)), PACK(old_size + next_size - asize, 0));
      PUT(FTRP(NEXT_BLKP(old_ptr)), PACK(old_size + next_size - asize, 0));
      return old_ptr;
    }
    PUT(HDRP(old_ptr), PACK(old_size + next_size, 1));
    PUT(FTRP(old_ptr), PACK(old_size + next_size, 1));
    return old_ptr;
  }

  void *new_ptr = malloc(size);

  /* If malloc() fails, the original block is left untouched. */
  if (!new_ptr)
    return NULL;

  /* Copy the old data. */
  if (size < old_size)
    old_size = size;
  memcpy(new_ptr, old_ptr, old_size);

  /* Free the old block. */
  free(old_ptr);

  return new_ptr;
}

/*
 * calloc - Allocate the block and set it to zero.
 */
void *calloc(size_t nmemb, size_t size) {
  size_t bytes = nmemb * size;
  void *new_ptr = malloc(bytes);

  /* If malloc() fails, skip zeroing out the memory. */
  if (new_ptr)
    memset(new_ptr, 0, bytes);

  return new_ptr;
}

/*
 * mm_checkheap - So simple, it doesn't need a checker!
 */
void mm_checkheap(int verbose) {
  /*
  void* bp = heap_listp;
  while(GET_SIZE(HDRP(bp)))
  {
    printf("block position: %p\n", bp);
    printf("block size: %d\n", GET_SIZE(HDRP(bp)));
    printf("block status: %d\n", GET_ALLOC(HDRP(bp)));
    bp = NEXT_BLKP(bp);
  }
    printf("block position: %p\n", bp);
    printf("block size: %d\n", GET_SIZE(HDRP(bp)));
    printf("block status: %d\n\n", GET_ALLOC(HDRP(bp)));
    */
  /*
 size_t size = 100000;
 while(GET_SIZE(HDRP(bp))){
   if(size > GET_SIZE(HDRP(bp)))
     size = GET_SIZE(HDRP(bp));
   bp = NEXT_BLKP(bp);
 }
 printf("min size = %ld\n", size);
 */
}
