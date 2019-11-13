
#include "tree.h"


int main( int argc, char* argv [ ] )
{
   tree t1( string( "a" ));
   tree t2( string( "b" )); 
   tree t3 = tree( string( "f" ), { t1, t2 } ); 
   
   tree test("test", {t3,t3});
   std::cout << test << "\n";
   test = subst(test, "f", tree("rdsdcad"));
   std::cout << test << "\n";

   std::vector< tree > arguments = { t1, t2, t3 };
   std::cout << tree( "F", std::move( arguments )) << "\n";

   t2 = t3;
   t2 = std::move(t3);
   
}



