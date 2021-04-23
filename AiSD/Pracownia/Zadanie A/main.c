#include<stdio.h>
#include<stdlib.h>

int n, m;
void miastoB(char **tablica, int i, int j);
void miastoC(char **tablica, int i, int j);
void miastoD(char **tablica, int i, int j);
void miastoE(char **tablica, int i, int j);
void miastoF(char **tablica, int i, int j);
void miasto(char **tablica, int i, int j);



int main()
{
	scanf("%d%d\n", &n, &m);
	char **tablica = (char**) calloc (n, sizeof(char*));

	for (int i = 0; i < n; i++)
	{
    		tablica[i] = (char*) calloc(m+2, sizeof(char));
		
		fgets(tablica[i], m+2, stdin);
	}
	/*
	for(int i1 = 0; i1 < n ; i1++){
		for (int j1 = 0; j1 < m; j1++)
			printf("%c", tablica[i1][j1]);
		printf("\n");
	}
	printf("\n");*/

	int result = 0;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			if(tablica[i][j]!='A')
			{
				result++;
				miasto(tablica, i, j);
				
			}
	printf("%d", result);
	for (int i = 0; i < n; i++)
		free(tablica[i]);
	free(tablica);
	return 0;
}

void miastoB(char **tablica, int i, int j)
{
	if(i != n-1 && (tablica[i+1][j] == 'C' || tablica[i+1][j] == 'D' || tablica[i+1][j] == 'F'))

		miasto(tablica, i + 1, j);

	if(j != 0 && (tablica[i][j-1] == 'D' || tablica[i][j-1] == 'E' || tablica[i][j-1] == 'F'))
		miasto(tablica, i, j - 1);

	return;
}

void miastoC(char **tablica, int i, int j)
{
	if(i != 0 && (tablica[i-1][j] == 'B' || tablica[i-1][j] == 'E' || tablica[i-1][j] == 'F'))
		miasto(tablica, i - 1, j);
	if(j != 0 && (tablica[i][j-1] == 'D' || tablica[i][j-1] == 'E' || tablica[i][j-1] == 'F'))
		miasto(tablica, i, j - 1);
	return;
}

void miastoD(char **tablica, int i, int j)
{
	if(i != 0 && (tablica[i-1][j] == 'B' || tablica[i-1][j] == 'E' || tablica[i-1][j] == 'F'))
		miasto(tablica, i - 1, j);
	if(j != m-1 && (tablica[i][j+1] == 'B' || tablica[i][j+1] == 'C' || tablica[i][j+1] == 'F'))
		miasto(tablica, i, j + 1);
	return;
}

void miastoE(char **tablica, int i, int j)
{
	if(i != n-1 && (tablica[i+1][j] == 'C' || tablica[i+1][j] == 'D' || tablica[i+1][j] == 'F'))
		miasto(tablica, i + 1, j);

	if(j != m-1 && (tablica[i][j+1] == 'B' || tablica[i][j+1] == 'C' || tablica[i][j+1] == 'F'))
		miasto(tablica, i, j + 1);
	return;
}

void miastoF(char **tablica, int i, int j)
{
	if(i != 0)
		if(tablica[i-1][j] == 'B' || tablica[i-1][j] == 'E' || tablica[i-1][j] == 'F')
			miasto(tablica, i - 1, j);

	if(i != n-1)
		if(tablica[i+1][j] == 'C' || tablica[i+1][j] == 'D' || tablica[i+1][j] == 'F')
			miasto(tablica, i + 1, j);

	if(j != m-1)
		if(tablica[i][j+1] == 'B' || tablica[i][j+1] == 'C' || tablica[i][j+1] == 'F')
			miasto(tablica, i, j + 1);

	if(j != 0)
		if(tablica[i][j-1] == 'D' || tablica[i][j-1] == 'E' || tablica[i][j-1] == 'F')
			miasto(tablica, i, j - 1);
	return;
}

void miasto(char **tablica, int i, int j)
{
	char tmp = tablica[i][j];
	tablica[i][j] = 'A';	
	switch (tmp) {	
	   case 'B':
		miastoB(tablica, i, j);
		break;
	   case 'C':
		miastoC(tablica, i, j);
		break;
	   case 'D':
		miastoD(tablica, i, j);
		break;
	   case 'E':
		miastoE(tablica, i, j);
		break;
	   case 'F':
		miastoF(tablica, i, j);
		break;
	}
	return;
}
