#include"stack.h"


void stack::ensure_capacity( size_t c )
{
	if( current_capacity < c )
	{
		
		if( c < 2 * current_capacity )
			c = 2 * current_capacity;
		
		double* newtab = new double[ c ];
		for( size_t i = 0; i < current_size; ++ i )
			newtab[i] = tab[i];
		current_capacity = c;
		delete[] tab;
		tab = newtab;

	}
}


stack::stack() : current_size{0}, current_capacity{0},tab{nullptr} {}


stack::stack( std::initializer_list<double> d ) : current_size{0}, current_capacity{d.size()}, tab{new double[d.size()]}
{
	for (double s : d)
	{
		tab[current_size] = s;
		current_size++;
	}
}
		


stack::stack( const stack& s ) : current_size{s.size()}, current_capacity{s.current_capacity}, tab {new double[s.current_capacity]}
{
	for (size_t i = 0; i < s.size(); i++)
		tab[i] = s.tab[i];
}


void stack::operator = ( const stack& s )
{
	double* tmp = new double[s.current_capacity];
	current_size = s.current_size;
	current_capacity = s.current_capacity;

	for (size_t i = 0; i < s.current_size; i++)
		tmp[i] = s.tab[i];
	delete[] tab;
	tab = tmp;
}


void stack::push( double d )
{
	ensure_capacity( current_size + 1 );
	tab[current_size] = d;
	current_size++;
}


void stack::pop( ) { current_size--; }



void stack::reset( size_t s )
{
	current_size = s;
}
