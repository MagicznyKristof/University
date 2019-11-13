from math import log
def g(x):

	return float(x**2 - log(x + 2))

def polowienie_przedzialow(a, b, epsilon):

	if g(a) == 0.0:
		return a
	if g(b) == 0.0:
		return b

	srodek = float(a+b)/2.0

	if b - a <= epsilon:
		return srodek

	if g(a) * g(srodek) < 0:
		return polowienie_przedzialow(a, srodek, epsilon)

	return polowienie_przedzialow(srodek, b, epsilon)


def zad5(x0, R, n):

	for i in range(n+1):
		x0 = x0*(2-x0*R)
		
		print('Krok', i, ':', x0)

	return x0


def zad6(x0, a, n):
	
	for i in range(n+1):
		x0 = x0*(3/2-(x0**2)*a/2)

		print('Krok', i, ':', x0)
	
	return x0

print('zad4')

x1 = polowienie_przedzialow(-1.0, -0.1, 10e-10)
x2 = polowienie_przedzialow(0.5, 1.4, 10e-10)

#print('x dla [-1, -0.1]: ', x1, '   wolphram: -0.587608827976115', '    błąd: ', abs(-0.587608827976115 - x1))
#print('x dla [0.1, 1.5]: ', x2, '   wolphram: 1.05710354999474', '    błąd: ', abs(1.05710354999474 - x2))

print()

print('zad5')
#zad5
#zad5(0.05, 15.0, 10)
#print()
#zad5(10000.0, -7.0, 10)
#print()
#zad5(0.000021, 1e5, 20)
#print()
#zad5(10e-12, 5*10e9, 10)
#print()
#zad5(0.01, 1e20, 10)
#print()
#zad5(2.0, 1.0, 10)


print()
print('zad6')
#zad6
zad6(0.2, 25.0, 10)
print()
zad6(0.00001, 10e5, 10)
print()
zad6(0.00001, 0.000005, 10)
print()
zad6(10e5, 0.0001, 10)
print()
zad6(10e10, 10e5, 10)
print()
zad6(2.0, 0.75, 10)
