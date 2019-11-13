from math import exp, fabs

alfa = 0.0646926359947960

def f(x):
	return x*exp(-x)-0.06064

def blad_rzec(m):
	return fabs(alfa - m)

def blad_osz(n,a0,b0):
	return (2**(-n-1))*(b0-a0)

a0=0.0
b0=1.0
a=a0
b=b0

for i in range(15):
	m=(a+b)/2.0
	print('rzeczywisty', blad_rzec(m),'     ','oszacowanie', blad_osz(i,a0,b0))
	if(f(m) > 0):
		b = m
	else:
		a = m