#include <iostream>
#include <map>
#include <unordered_map>
#include <string>
#include <fstream>
#include <vector>
#include <cstdio>
#include "vectortest.h"

//3
struct case_insensitive_cmp
{
	bool operator( ) ( const std::string& s1, const std::string& s2 ) const
	{
		auto p1 = s1.begin();
		for( auto p2 = s2.begin(); p2 != s2.end(); p2 ++)
		{
			if( p1 == s1.end() )	return false;
			char c1 = tolower( *p1 );
			char c2 = tolower( *p2 );
			if (c1 == c2)
				p1++;
			else
				return ( c1 < c2 );
		}
		if( p1 != s1.end() )	return true;
		return false;
	}
};


//1
std::map< std::string, unsigned int, case_insensitive_cmp > frequencytable( const std::vector< std::string > & text )
{
	std::map< std::string, unsigned int, case_insensitive_cmp > mapa;
	for( const auto &i : text )
		mapa[i]++;
	return mapa;
	
}

//2
std::ostream& operator << ( std::ostream& stream, const std::map< std::string, unsigned int, case_insensitive_cmp > & freq )
{
	for( const auto &i: freq )
		stream << i.first << "\t" << i.second <<"\n";
	stream << "\n";
	return stream;
}

//5

struct case_insensitive_hash
{
	size_t operator ( ) ( const std::string& s ) const
	{
		size_t hash = 0;
		for(size_t i = 0; i < s.size(); i++)
			hash = (hash * 27) + (tolower(s[i]) + 1);
		return hash;
	}
};

struct case_insensitive_equality
{
	bool operator ( ) ( const std::string& s1, const std::string& s2 ) const
	{
		if( s1.size() != s2.size() )	return false;
		for(auto p1 = s1.begin(), p2 = s2.begin(); p1 != s1.end(); p1++, p2++)
			if (tolower( *p1 ) != tolower( *p2 ))	return false;
		return true;
	}		
};

//6
std::unordered_map< std::string, unsigned int, case_insensitive_hash, case_insensitive_equality> hashed_frequencytable(const std::vector<std::string> & text)
{
	std::unordered_map<std::string, unsigned int, case_insensitive_hash, case_insensitive_equality > mapa;
	for( auto iter = text.begin(); iter != text.end(); ++iter )
		mapa[*iter]++;
	return mapa;

}

//7
void book( std::map< std::string, unsigned int, case_insensitive_cmp > mapa)
{
	auto max = mapa.begin();
	for( auto p = mapa. begin( ); p != mapa. end( ); ++ p )
	{
		if( max -> second < p -> second )
			max = p;
		if( p -> first == "Magnus" )
			std::cout << p -> first << "\t"  << p -> second << "\n" ;
		if( p -> first == "hominum" )
			std::cout << p -> first << "\t" << p -> second << "\n" ;
		if( p -> first == "memoria" )
			std::cout << p -> first << "\t" << p -> second << "\n" ;
	
	}
	std::cout << max -> first << "\t" << max -> second << "\n" ;
	
}

int main()
{
/*	case_insensitive_cmp c;
	std::cout << c( "a", "A" ) << c( "a","b" ) << c( "A", "b" ) << "\n";

	case_insensitive_hash h;
	std::cout << h( "xxx" ) << " " << h( "XXX" ) << "\n";
	std::cout << h( "Abc" ) << " " << h( "abC" ) << "\n";
	// Hash value should be case insensitive.
	case_insensitive_equality e;
	std::cout << e( "xxx", "XX	X" ) << "\n";
	// Prints ’1’.

	auto M = hashed_frequencytable(std::vector< std::string > {"Aa","aa", "bb", "Cab"} );
	std::cout << M["aa"] << "\n";
*/
	std::ifstream myReadFile;
 	myReadFile.open("Book 1.txt");
	
	std::vector< std::string > vect = vectortest::readfile( myReadFile );

	auto M = frequencytable( vect );
	book(M);
	

	


	return 0;
}
