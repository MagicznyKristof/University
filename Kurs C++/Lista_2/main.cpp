
#include "rational.h"
#include "matrix.h"

int main( int argc, char* argv [ ] )
{
   matrix m1 = { { rational(1,2), rational(-2,7) }, { rational(1,3), rational(2,8) } };

   matrix m2 = { { rational(-1,3), rational(2,5) }, { rational(2,7), rational(-1,7) } }; 

   matrix m3 = m1 * m2;

   vector v1(rational(10, 3), rational(3, 7));

   std::cout << m3 << "\n";

   std::cout << m1.inverse() << "\n";

   std::cout << ((m1 * m2) * m3) - (m1 * (m2 * m3)) << "\n";

   std::cout << (m1 * (m2 + m3)) - ((m1 * m2) + (m1 * m3)) << "\n";

   std::cout << ((m1 + m2) * m3) - ((m1 * m3) + (m2 * m3)) << "\n";

   std::cout << m1(m2(v1)) << (m1 * m2)(v1) << "\n";

   std::cout << (m1.determinant() * m2.determinant()) - m3.determinant() << "\n\n";

   std::cout << m1 * m1.inverse() << "\n" << m1.inverse() * m1 << "\n";

}

