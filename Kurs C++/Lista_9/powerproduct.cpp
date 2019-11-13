
#include "powerproduct.h"
#include <algorithm>


std::ostream& operator << ( std::ostream& out, const powvar & p )
{
   if( p.n == 0 )
   {
      out << "1"; // Should not happen, but we still have to print something.
      return out;
   }

   out << p.v;
   if( p.n == 1 )
      return out;

   if( p.n > 0 )
      out << "^" << p.n;
   else
      out << "^{" << p.n << "}";
   return out;
}


std::ostream& operator << ( std::ostream& out, const powerproduct& c )
{
   if( c. isunit( ))
   {
      out << "1";
      return out;
   }

   for( auto p = c. repr. begin( ); p != c. repr. end( ); ++ p )
   {
      if( p != c. repr. begin( ))
         out << ".";
      out << *p;
   }

   return out;
}


int powerproduct::power( ) const 
{
   int p = 0;
   for( auto pv : repr )
      p += pv. n;
   return p;
}

//1

static bool comp (powvar i, powvar j) 
{
    if(i.v != j.v)
        return (i.v < j.v);
	return 0;
}

void powerproduct::normalize( )
{
//liniowo bez dodatkowego wektora
	std::sort ( repr.begin(), repr.end(), comp );
    
	for ( auto it = repr.begin() ; it != repr.end(); ++ it )
	{
	    if ( it-> n == 0 )
	    {
	        repr.erase ( it );
	        -- it;
	    }
	    else 
	    {
	        
	        while(  it+1 != repr.end() && it-> v == (it+1)-> v )
      	    {
          	    it-> n += ( it+1 )-> n;
                repr.erase ( it+1 );
      	    }
      	    
      	    if( it-> n == 0 )
      	        -- it;
        }
	}
}

//3

powerproduct operator * ( powerproduct c1, const powerproduct& c2 )
{
    c1.repr.reserve( c1.repr.size() + c2.repr.size() );
    c1.repr.insert( c1.repr.end(), c2.repr.begin(), c2.repr.end() );
    c1.normalize();
   
    return c1;
}

