#include <iostream>
#include "stack.h"
using namespace std;
std::ostream& operator << ( std::ostream& stream, const stack& s )
{
	
	for (size_t i = 0; i < s.current_size; i++)
		stream << " " << s.tab[i];
	return stream;
}

int main()
{

	stack s1 = { 1, 2, 3, 4, 5 };
	stack s2 = s1; 

	for( unsigned int j = 0; j < 20; ++ j )
		s2. push( j * j );
	s1 = s2;
	s1 = s1;
	s1 = { 100,101,102,103 };
	cout << s1 << "\n";
#if 1
	const stack&sconst = s1;
	sconst. top() = 20;
	sconst. push(15);
#endif
}
