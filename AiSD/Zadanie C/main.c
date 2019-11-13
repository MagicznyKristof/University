#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<stdint.h>

void czy_slowo( int n, int m1, uint8_t type1[m1][3], uint8_t P[n][n] )
{
	for( int i = 1; i < n; i++ )
		for( int j = 0; j < n - i + 1; j++ )
			for( int k = 0; k < i; k++ )
				for( int l = 0; l < m1; l++ )
					if((( P[k][j]&type1[l][1] ) == type1[l][1] )&&(( P[i - k - 1][j + k + 1]&type1[l][2] ) == type1[l][2]))	//zamiast tego precalc co może wyjść z czego
						P[i][j] |= type1[l][0];
					


/*printf( "%d andujemy z %d, %d z %d, dostajemy %d - pozycje [%d][%d] i [%d][%d], produkcja %d\n", P[k][j], type1[l][1], P[i - k - 1][j + k + 1], type1[l][2], type1[l][0], k, j, i - k - 1, j + k + 1, );
}
					for( int i = 0; i < n; i++ ){
						for( int j = 0; j < n; j++ )
							printf("%d ", P[i][j]);
						printf("\n");
					}
					printf("\n");
				}
	

	for( int i = 0; i < n; i++ ){
		for( int j = 0; j < n; j++ )
			printf("%d ", P[i][j]);
		printf("\n");
	}*/

	if( (P[n - 1][0]&1) == 1 )
		printf("TAK\n");
	else
		printf("NIE\n");
}

int8_t pot( int x )
{
	if (x == 1)   return 1;
	return 2 * pot (x - 1);
}

int main()
{
	int d;
	scanf( "%d\n", &d );

	for ( int i = 0; i < d; i++ )
	{
		int m1, m2;
		scanf("%d %d\n", &m1, &m2);

		char type1[m1][3], type2[m2][2];

		for( int j = 0; j < m1; j++ )
			scanf( "%c %c %c\n", &type1[j][0], &type1[j][1], &type1[j][2] );
			

		for( int j = 0; j < m2; j++ )
			scanf( "%c %c\n", &type2[j][0], &type2[j][1] );

		
		
		uint8_t bettertype1[m1][3];
		for( int j = 0; j < m1; j++ )
		{
			bettertype1[j][0] = pot( type1[j][0] - 'A' + 1 );

			bettertype1[j][1] = pot( type1[j][1] - 'A' + 1 );

			bettertype1[j][2] = pot( type1[j][2] - 'A' + 1 );

		}

		
		char word[1000];
		memset( &word[0], 0, sizeof(word) );
		fgets(word, 1002, stdin);


		int n = 999;
		
		while( word[n] == 0 )
			n--;
		
		uint8_t table[n][n];
		for( int j = 0; j < n; j++ )
			for( int k = 0; k < n; k++ )
				table[j][k] = 0;

		for( int j = 0; j < n; j++ )
			for( int k = 0; k < m2; k++ )
				if( word[j] == type2[k][1] )
					table[0][j] |= pot( type2[k][0] - 'A' + 1 );

		czy_slowo(n, m1, bettertype1, table);		
	}

	return 0;
} 
