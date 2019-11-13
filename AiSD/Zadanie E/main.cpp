#include<stdio.h>
#include<stdlib.h>
#include<stdint.h>
#include<queue>


struct uklad
{
	int t[7];
	int suma;
	int length;
};

struct node
{
	int val;
	int length;
	struct node *left;
	struct node *right;
};

struct map
{
	//int16_t suma; 
	int kolejka;
	struct node *tree;
};

int hash( int t[7] )
{
	int tmp = t[6];
	for( int i = 5; i >= 0; i-- )
	{
		tmp = tmp * 400009 + t[i];
	}
	return tmp;
}

int max;
int ile;

std::queue < struct uklad > queue;
struct uklad *start= (struct uklad*) malloc( sizeof( struct uklad ) );
struct map mapa[7000];// = (struct map*) malloc( sizeof( struct map )*7000 );
	
void del( struct node *a )
{
	//if( a == NULL )
		//printf("ergs" );
	if( a != NULL )
	{
		//printf("asdfs\t%d %d\n", a -> length, max); 
	
		if( a -> length > max )
			max = a -> length;
		del( a -> left );
		del( a -> right );
	}
}

bool check ( struct uklad *a, int n )
{

	//printf("poczatkowa kolejka = %d\n", mapa[a -> suma].kolejka );
	
	//printf("%d\tsuma = %d\n", mapa[a->suma].kolejka, a->suma);
	//printf("new = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
	int key = hash ( a -> t );
	struct node *drzewo = mapa[a -> suma].tree;	
	//if( drzewo == NULL )
		//printf("xDDD\n");
	while( drzewo != NULL )
	{
		if( key == drzewo -> val )
		{
			if( a -> length < drzewo -> length )
				drzewo -> length = a -> length;
			return false;
		}
		if( key > drzewo -> val)
			drzewo = drzewo -> right;
		else
			drzewo = drzewo -> left;
	}

	drzewo = (struct node*) malloc( sizeof( struct node ) );
	drzewo -> val = key;
	drzewo -> length = a -> length;
  drzewo -> left = NULL;    
  drzewo -> right = NULL;
	
	mapa[a -> suma].kolejka++;
	//printf("kolejka = %d\t\tsuma = %d\tmax = %d\n", mapa[a -> suma].kolejka, a -> suma, max);
	//printf("new = %d, %d, %d, %d, %d, %d, %d\n\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] );
	ile++;
	queue.push( *a );
	return true;
}

void dodaj ( struct uklad *a, int n )
{
	int sum = 0;
	//printf( "\n\n\nn = %d \n", n );
	//printf("uklad = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						
	for( int i = 0; i < n; i++ )
	{
		sum += a -> t[i];
		if( a -> t[i] != 0 )
		{
			for( int j = 0; j < i; j++ )
			{
				if( a -> t[j] != start -> t[j])
				{
					int tmp;
					if( start -> t[j] - a -> t[j] < a -> t[i] )
					{
		//				printf("\ntmp = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						tmp = start -> t[j] - a -> t[j];
						a -> t[i] -= tmp;
						a -> t[j] += tmp;
						//a -> suma -= tmp;
						a -> length++;
						//printf("i = %d, j = %d\n", i, j);
						///printf("inserted = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						check ( a, n );
						a -> t[j] -= tmp;
						a -> t[i] += tmp;
						//a -> suma += tmp;
						a -> length--;
	//					printf("after = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
					}
					else
					{
//						printf("\ntmp = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						tmp = a -> t[i];
						a -> t[j] += tmp;
						a -> t[i] = 0;
						//a -> suma -= tmp;
						a -> length++;
	//					printf("i = %d, j = %d\n", i, j);
		//				printf("%d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						 check ( a, n );
						//	queue.push( *a );
						a -> t[j] -= tmp;
						a -> t[i] += tmp;
						//a -> suma += tmp;
						a -> length--;
			//			printf("after = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
					}
				}
			}
			for( int j = i+1; j < n; j++ )
			{
				if( a -> t[j] != start -> t[j])
				{
					int tmp;
					if( start -> t[j] - a -> t[j] < a -> t[i] )
					{
//						printf("\ntmp = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						tmp = start -> t[j] - a -> t[j];
						a -> t[i] -= tmp;
						a -> t[j] += tmp;
						//a -> suma -= tmp;
						a -> length++;
	//					printf("i = %d, j = %d\n", i, j);
		//				printf("%d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						check ( a, n );
						a -> t[j] -= tmp;
						a -> t[i] += tmp;
						//a -> suma -= tmp;
						a -> length--;
			//			printf("after = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
					}
					else
					{
				//		printf("\ntmp = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						tmp = a -> t[i];
						a -> t[j] += tmp;
						a -> t[i] = 0;
						//a -> suma -= tmp;
						a -> length++;
					//	printf("i = %d, j = %d\n", i, j);
						//printf("%d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
						check ( a, n );
						a -> t[j] -= tmp;
						a -> t[i] += tmp;
						//a -> suma += tmp;
						a -> length--;
	//					printf("after = %d, %d, %d, %d, %d, %d, %d\n", a -> t[0], a -> t[1], a -> t[2], a -> t[3], a -> t[4], a -> t[5], a -> t[6] ); 
					}
				}
			
		int tmp = a -> t[i];
		a -> t[i] = 0;
		a -> length++;
		a -> suma -= tmp;
		check ( a, n );
		a -> t[i] = tmp;
		a -> length--;
		a -> suma += tmp;
		}
	}
	}
	//printf("%d\n", sum);
	mapa[sum].kolejka--;
	//printf("kolejka na koniec = %d\tsuma = %d\n", mapa[sum].kolejka, sum);
	if( mapa[sum].kolejka == 0 )
	{
		//printf("weszlo\n");
		del( mapa[sum].tree );
	}
		//del( mapa[sum].tree );
	queue.pop();
}

void cleartree( struct node *tree )
{
	if( tree != NULL )
	{
		cleartree( tree -> left );
		cleartree( tree -> right );
		tree = NULL;
	}
}

void clearmap(  )
{
	for( int i = 0; i < 7000; i++ )
	{
		if( mapa[i].tree != NULL )
			cleartree( mapa[i].tree );
	}
}

int main()
{
	int d;
	scanf( "%d", &d );
	
	for( int i = 0; i < d; i++ )
	{
		int8_t n;
		scanf( "%d", &n );
		int t[n];
		int sum = 0;
		max = 0;
		ile = 1;
		for( int j = 0; j < n; j++ )
		{
			
			scanf( "%d", &t[j] );
			start -> t[j] = t[j];
			sum += t[j];
		}
		start -> suma = sum;
		start -> length = 0;
			
		
		for( int j = 0; j <= sum; j++ )
		{
			//mapa[j].suma = j;
			//del ( mapa[j] -> tree );
			mapa[j].kolejka = 0;
		}
		mapa[sum].kolejka = 1;
		
		int key = hash( start -> t );
		
		struct node *drzewo = (struct node*) malloc( sizeof( struct node ) );
		drzewo -> val = key;
	    drzewo -> left = NULL;    
	    drzewo -> right = NULL;

		queue.push( *start );
		while( queue.size() != 0 )
		{
			//printf("rozmiar kolejki = %d", queue.size() ); 
			struct uklad current = queue.front();
			dodaj( &current, n );
		}
		printf( "%d %d\n", ile, max );
		clearmap( );
	}
	return 0;
}



