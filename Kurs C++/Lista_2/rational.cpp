
#include "rational.h"
 

int rational::gcd( int n1, int n2 )
{
	while (n2 != 0)
	{
		int tmp = n1%n2;
		n1 = n2;
		n2 = tmp;
	}
	return n1;
}

void rational::normalize( )
{
	if (denum == 0)
		return;
	int sign = 1;
	if (num < 0)
	{
		sign = -1;
		num = -num;
	}	
	if (denum < 0)
	{
		sign = -sign;
		denum = -denum;
	}
	
	int tmp = gcd(num, denum);
	num = sign * (num / tmp);
	denum = denum / tmp;
}



rational operator - ( rational r )
{
	r.num = r.num * -1;
	return r;
}

rational operator + ( const rational& r1, const rational& r2 )
{
	rational result(
		r1.num * r2.denum + r2.num * r1.denum,
		r1.denum *  r2.denum);
	result.normalize();
	return result;
}
rational operator - ( const rational& r1, const rational& r2 )
{
	rational result(
                r1.num * r2.denum - r2.num * r1.denum,
                r1.denum * r2.denum);
        result.normalize();
	return result;
}
rational operator * ( const rational& r1, const rational& r2 )
{
	rational result(
                r1.num * r2.num,
                r1.denum * r2.denum);
        result.normalize();
        return result;
}
rational operator / ( const rational& r1, const rational& r2 )
{
	rational result(
                r1.num * r2.denum,
                r1.denum * r2.num);
        result.normalize();
        return result;

}
bool operator == ( const rational& r1, const rational& r2 )
{
	if(r1.num * r2.denum - r2.num * r1.denum == 0)
		return true;
	return false;
}
bool operator != ( const rational& r1, const rational& r2 )
{
	if(r1.num * r2.denum - r2.num * r1.denum == 0)
                return false;
        return true;
}
std::ostream& operator << ( std::ostream& stream, const rational& r ) 
{
	stream << r.num << "/" << r.denum;
	return stream;
}

