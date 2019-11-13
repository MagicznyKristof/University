function calc_using_delta(a, b, c)
    d = b*b - 4.0*a*c
    if d < 0
        println("delta can't be < 0 !")
    end
    f(x) = a * x^2 + b * x + c
        
    x1 = (-b - sqrt(d)) / (2*a)
    x2 = (-b + sqrt(d)) / (2*a)

    println("x1 = ", x1, "\nf(x1) = ", f(x1), "\nx2 = ", x2, "\nf(x2) = ", f(x2))
    print("---------------------- \n")
    return f, x1, x2
end

function calc_using_viete(a, b, c)
    d = b*b - 4.0*a*c

    x1 = (-b + sqrt(d) * (-sign(b))) / (2.0*a)
    x2 = c / (a * x1)

    f(x) = a * x^2 + b * x + c
    println("x1 = ", x1, "\nf(x1) = ", f(x1), "\nx2 = ", x2, "\nf(x2) = ", f(x2))
    println("---------------------- \n")
    return f, x1, x2
end

print("\nSzkolna: \n")

a1, b1, c1 = 1e-5, 10 ^ 12, 1.0
a2, b2, c2 = 1.0, 10 ^ 7, 1e-3
a3, b3, c3 = 1e-10, 10^10, 10.0

calc_using_delta(a1, b1, c1)

calc_using_delta(a2, b2, c2)

calc_using_delta(a3, b3, c3)

print("\nViete\n\n")

calc_using_viete(a1, b1, c1)

calc_using_viete(a2, b2, c2)

calc_using_viete(a3, b3, c3)
