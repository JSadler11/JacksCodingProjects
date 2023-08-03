using LinearAlgebra
using Plots
using Polynomials

r = 0.05
println(1+r)

(1+r/12)^12

(1+r/365)^365

exp(r)

#Taylor series for cos and sin
x = range(-10, stop = 10, length = 2000)
y = sin.(x)
plot(x, y, color="black", linewidth = 2)
xlims!(-10, 10)
ylims!(-10, 10)
grid!(true)


#First order Taylor Series Approximation
#P = [1, 0]
#yT1 = evalpoly(P, x)
yT1 = x
plot!(x, yT1, linestyle=:dash, color="blue", linewidth = 1.2, label = "First Order")


#Third order TaylorSA
#P = [-1/factorial(3), 0, 1, 0]
#yT3 = evalpoly(P, x)
yT3 = x - x.^3 / factorial(3)
plot!(x, yT3, linestyle=:dash, color="red", linewidth = 1.2, label = "Third Order")
#Fifth order TaylorSA
yT5 = x - x.^3 / factorial(3) + x.^5 / factorial(5)
plot!(x, yT5, linestyle=:dash, color = "green", linewidth=1.2, label = "Fifth Order")

#Seventh order TaylorSA
yT7 = x - x.^3 / factorial(3) + x.^5 / factorial(5) - x.^7 / factorial(7)
plot!(x, yT7, linestyle = :dash, color = "yellow", linewidth=1.2, label = "Seventh Order")

#Ninth Order Taylor TaylorSA
yT9 = x - x.^3 / factorial(3) + x.^5 / factorial(5) - x.^7 / factorial(7) + x.^9 / factorial(9)
plot!(x, yT9, linestyle = :dash, color = "purple", linewidth = 1.2, label = "Ninth Order")