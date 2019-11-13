using Plots
plotly()

a, b, c, xs = 3.0, 5.0, 1.0, 1:10 # delta > 0
# a, b, c, xs = 3.0, 10000.0, 1000.0, linspace(-3600.0, 250.0) # delta > 0
# a, b, c, xs = 500.0, 10000.0, 12.0, linspace(-100.0, 100.0)
# a, b, c, xs = 11.0, 100000000.0, 10.0, linspace(-1000.0, 100.0)
# a, b, c, xs = 0.1, 2.0, 10.0, 1:10

# Z zajęć:
# a, b, c, xs = 99.0, 9999999999.0, 1.0, 1:10
# a, b, c, xs = 1.54e-15, 999999.0, 1.00212, 1:10
# a, b, c, xs = -241e-42, 534151.0, 1.0, 1:10


f(x) = a*x^2 + b*x + c
ys = map(f, xs)
plot(xs, ys)


delta = b^2 - 4*a*c
x0 = (-b + sqrt(delta))/(2*a)
x1 = (-b - sqrt(delta))/(2*a)
println((delta, x0, x1))

println("--- Wzory Viete'a!")
println((x0 + x1, -b/a, x0 + x1 == -b/a))
println((x0 * x1, c/a, x0 * x1 == c/a))
println("--- Wartości funkcji w miejscach zerowych")
println((f(x0), f(x0) == 0.0))
println((f(x1), f(x1) == 0.0))


function x(n::Int64)
    n += 1 # Julia numeruje tablice od 1, nie od 0
    T = Array{Float64}(2)
    T[1] = 1.
    T[2] = (- 1.) / 7.
    for k = 3:n
        push!(T, (13. * T[k - 1] + 2.*T[k - 2]))
    end
    return T[n]
end

println((x(25), ((-1.)/7.)^25, x(25) == ((-1.)/7.)^25))

function p(n::Int64)
    return (-1.)^n/((2. * n) + 1.)
end

pi-4*sum(p, 0:2*10^5-2)

function mI(n::Int64)
    T = Array{Float32}(1)
    T[1] = log(Float32(5.) / Float32(6.))
    for k = 2:n
        push!(T, (Float32(1.) / Float32(k) - Float32(5.) * T[k - 1]))
    end
    return T[n]
end

collect(map(mI, 1:20))

1/20 - (mI(20) + 5*mI(19))

