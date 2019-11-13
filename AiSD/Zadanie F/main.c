#include<stdio.h>
#include<stdlib.h>



int main()
{	
	int d;
	scanf( "%d", &d );
	
	for( int i = 0; i < d; i++ )
	{
		int dl;
		scanf( "%d", &dl );
		
		int tab[dl];
		
		//A = (int*) calloc(dl+2, sizeof(int));
		//fgets(A, dl+2, stdin);
		
		for( int j = 0; j < dl; j++ )
			scanf( "%d", &tab[j] );
		
		
		/*for( int j = 0; j < dl; j++ )
			printf( "%d ", tab[j] );
		printf("\n");
		*/
		
		int start[dl], end[dl], max = 1;
		
		
		int tmp = 1;
		end[0] = 1;
		start[dl - 1] = 1;
		for( int j = 1; j < dl; j++ )
		{
			if( tab[j - 1] < tab[j] )
				tmp++;
			else
			{
				if( max < tmp ) max = tmp;
				for( int k = 0; k < tmp; k++ )
				{
					end[j - k - 1] = tmp - k;
					start[j - tmp + k] = tmp - k;
				}
				//printf("%d %d\n", tmp, j);
				tmp = 1;
			}
		}
		
		
		if( max < tmp ) max = tmp;			
		for( int k = tmp; k > 0; k-- )
		{
			end[dl - tmp + k - 1] = k;
			start[dl - k] = k;
		}
		
		/*
		for( int j = 0; j < dl; j++ )
			printf( "%d ", start[j] );
		printf("\n");
		
		printf("%d\n", max );
		
		
		for( int j = 0; j < dl; j++ )
			printf( "%d ", end[j] );
		printf("\n");
		*/
		
		int best = 1;	
		
		int dlugosc[max];
		for( int j = 0; j < max; j++ )
			dlugosc[j] = 2000000000;
			
		
		
		for( int j = 0; j < dl; j++ )
		{
			if( tab[j] < dlugosc[end[j] - 1] )
				dlugosc[end[j] - 1] = tab[j];
			int a = 0, z = max;
			while( a + 1 < z )
			{
				if( dlugosc[(a + z) / 2] == tab[j] )
				{
					z = (a + z) / 2;
				}
				else if( dlugosc[(a + z) / 2] > tab[j] )
					z = (a + z) / 2;
				else
					a = (a + z) / 2;
			}
				
			if( best < start[j] + a + 1 && tab[j] > dlugosc[a] )
			{
				best = start[j] + a + 1;
				//printf("%d, %d, %d, %d\n", j, start[j], a, end
			}
		}
		
		/*for( int j = 0; j < max; j++ )
			printf( "%d ", dlugosc[j] );
		printf("\n");
		*/
		printf( "%d\n", best );
			
			
			
			
	}
}

