
#include <fstream>
#include <iostream>
#include <random>

#include "listtest.h"
#include "vectortest.h"
#include "timer.h"


int main( int argc, char* argv [] )
{

   std::vector< std::string > vect;
   std::list<std::string> l;

   vect = vectortest::readfile( std::cin );
   std::cout << vect << "\n";

   // Or use timer:

   auto t1 = std::chrono::high_resolution_clock::now( ); 
   //vectortest::sort_move( vect );
   vect = vectortest::randomstrings( 10000, 50 );
   vectortest::sort_assign( vect );
   auto t2 = std::chrono::high_resolution_clock::now( );


   std::chrono::duration< double > d = ( t2 - t1 );
   //std::cout << vect << "\n";


   std::cout << "vector assign sorting took " << d. count( ) << " seconds\n";

   t1 = std::chrono::high_resolution_clock::now( ); 
   //vectortest::sort_move( vect );
   vect = vectortest::randomstrings( 20000, 50 );
   vectortest::sort_move( vect );
   t2 = std::chrono::high_resolution_clock::now( );

   d = ( t2 - t1 );
   std::cout << "vector move sorting took " << d. count( ) << " seconds\n";

   t1 = std::chrono::high_resolution_clock::now( ); 
   //vectortest::sort_move( vect );
   vect = vectortest::randomstrings( 10000, 50 );
   vectortest::sort_std( vect );
   t2 = std::chrono::high_resolution_clock::now( );

   d = ( t2 - t1 );
   //std::cout << vect << "\n";


   std::cout << "vector std sorting took " << d. count( ) << " seconds\n";


   t1 = std::chrono::high_resolution_clock::now( ); 
   vect = vectortest::randomstrings( 10000, 50 );
   l = ( listtest::vector_to_list( vect ));
   listtest::sort_assign( l );
   t2 = std::chrono::high_resolution_clock::now( );

   d = ( t2 - t1 );
   std::cout << "list assign sorting took " << d. count( ) << " seconds\n";

   t1 = std::chrono::high_resolution_clock::now( ); 
   vect = vectortest::randomstrings( 20000, 50 );
   l = ( listtest::vector_to_list( vect ));
   listtest::sort_move( l );
   t2 = std::chrono::high_resolution_clock::now( );

   d = ( t2 - t1 );
   std::cout << "list move sorting took " << d. count( ) << " seconds\n";

   
   return 0;
}


