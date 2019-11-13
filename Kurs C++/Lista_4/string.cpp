
#include "string.h"

std::ostream& operator << ( std::ostream& out, const string& s )
{
   for( size_t i = 0; i < s.len; ++ i )
      out << s.p[i];
   return out; 
}

void string::operator += ( char c )
{
	len++;
	char* tmp = new char[ len ];
	for (size_t i = 0; i < len - 1; i++)
	{
		tmp[i] = p[i];
	}
	tmp[ len - 1 ] = c;
	delete[] p;
	p = tmp;
}

void string::operator += ( const string& s )
{
	char* tmp = new char [len + s.len];
	for (size_t i = 0; i < len; i++)
	{
		tmp[i] = p[i];
	}
	for (size_t i = len; i < s.len; i++)
	{
		tmp[i] = s[i];
	}
	delete[] p;
	p = tmp;
}

char string::operator [] ( size_t i ) const
{
   	return p[i];
}
char& string::operator [] ( size_t i )
{
   	return p[i];
}

string operator + ( string s1, const string& s2 )
{
   s1 += s2;
   return s1;
}

bool operator == ( const string& s1, const string& s2 )
{
   	if( s1.len != s2.len )
		return false;
	for( size_t i = 0; i < s1.len; i++)
	{
		if( s1.p[i] != s2.p[i] )
			return false;
	}
	return true;
}

bool operator != ( const string& s1, const string& s2 )
{
	return !(s1 == s2);
}

bool operator < ( const string& s1, const string& s2 )
{
	size_t tmp = std::min( s1.len, s2.len);

	for( size_t i = 0; i < tmp; i++)
	{
		if( s1.p[i] == s2.p[i] )
			continue;
		else return  s1.p[i] < s2.p[i];
	}
	return s1.len < s2.len;
}

bool operator > ( const string& s1, const string& s2 )
{
	return (s2 < s1);
}

bool operator >= ( const string& s1, const string& s2 )
{
	return !(s1 < s2);
}

bool operator <= ( const string& s1, const string& s2 )
{
	return !(s1 > s2);
}
