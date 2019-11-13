
#include "vectortest.h"

#include <random>
#include <chrono> 
#include <algorithm>

std::vector< std::string >

vectortest::randomstrings( size_t nr, size_t s )
{
   static std::default_random_engine gen( 
      std::chrono::system_clock::now( ). time_since_epoch( ). count( ) );
         // Narrowing long int into int, but that is no problem.

   static std::string alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345689";
   static std::uniform_int_distribution<int> distr( 0, alphabet. size( ) - 1);
      // More narrowing.

   std::vector< std::string > res;

   for( size_t i = 0; i < nr; ++ i )
   {
      std::string rand;
      for( size_t j = 0; j < s; ++ j )
      {
         rand. push_back( alphabet[ distr( gen ) ] );  
      }

      res. push_back( std::move( rand ));
   }
   return res;
}
         
std::vector<std::string> 
vectortest::readfile( std::istream& input ) 
{
	std::vector<std::string> v;
	char c;
	std::vector< char > s;
	while(true)
	{
		input >> std::noskipws >> c;if( !input.good()) break;
		//if(c == '\n')
		//	break;
		if ( isspace(c) || ispunct(c) )
		{
			if( !(s.empty()) ){
			//s.push_back(0);
			v.push_back( std::string(s.begin(),s.end() ) );
			s.clear();
			}
		}
		else
			s.push_back(c);
		
	}
	if ( !(s.empty()) )
	{
		s.push_back(0);
		v.push_back( std::string( &s[0] ) );
	}
	return v;
}	



void vectortest::sort_assign( std::vector< std::string > & v )
{
	std::vector< std::string > tmp = std::move( v );	
	for( auto j = tmp.begin( ); j != tmp.end( ); j++ )
		for( auto i = tmp.begin(); i != j; i++ )
		{
			if( *i > *j ){
				std::string s = *i;
				*i = *j;
				*j = s;
			}
		}
}
void vectortest::sort_move( std::vector< std::string > & v )
{
	std::vector< std::string > tmp = std::move( v );
	
	for( auto j = tmp.begin(); j != tmp.end(); j++ )
	{
		for( auto i = tmp.begin(); i != j; i++ )
		{
			if( *i > *j )
				std::swap( *i, *j );
		}
	}
	v = std::move( tmp );
}
void vectortest::sort_std( std::vector< std::string > & v )
{
	std::vector< std::string > tmp = std::move( v );	
	std::sort( tmp. begin( ), tmp. end( ));
	v = std::move( tmp );
}



std::ostream& 
operator << ( std::ostream& out, const std::vector< std::string > & vect ) 
{
	for( const std::string& i : vect )
		out << i << ", ";

	out << '\n';
	return out;
}



