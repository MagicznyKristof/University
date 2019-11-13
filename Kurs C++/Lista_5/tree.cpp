
#include "tree.h"
//2
tree::~tree()
{
    pntr -> refcnt--;
    if(pntr -> refcnt == 0)
	delete pntr;
}

//4
std::ostream& operator << ( std::ostream& stream, const tree& t ) 
{ 
	stream << t.functor() << '\n';
	if(t.nrsubtrees() == 0)
		return stream;
	else for (size_t i = 0; i < t.nrsubtrees(); i++)  stream << t[i] << " ";

	return stream;
}

//5
void tree::ensure_not_shared()
{
	if (pntr -> refcnt != 1)
	{
		pntr -> refcnt--;
		pntr = new trnode(pntr -> f, pntr -> subtrees, 1);
	}
}

string& tree::functor()
{
	ensure_not_shared();
	return pntr -> f;
}

//6
tree subst( const tree& t, const string& var, const tree& val )
{
	if ( t. nrsubtrees() == 0 )
	{
		if ( t.functor() == var )
			return val;
		else
			return t;
	}
	
		tree res = t;
		for( size_t i = 0; i < t. nrsubtrees(); i++ )
			res.replacesubtree( i, subst( t[i], var, val ));
		return res;
	
}

void tree::replacesubtree( size_t i, const tree& t )
{
	if( pntr -> subtrees[i]. pntr != t. pntr )
	{
		ensure_not_shared( );
		pntr -> subtrees[i] = t;
	}
}


void tree::replace_functor( const string& functor )
{
	if( functor != pntr -> f )
	{
		ensure_not_shared();
		pntr -> f = functor;
	}
}




