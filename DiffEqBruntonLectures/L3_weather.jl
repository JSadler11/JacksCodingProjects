using LinearAlgebra
using Plots

A = [0.5 0.5 0.25;
    0.25 0.0 0.25;
    0.25 0.5 0.5]

println(A)

xtoday = [1; 0; 0;]

println(xtoday)

println(A * xtoday)

the_weather = zeros((3,50))

for k in 1:50
    xtomorrow = A * xtoday
    the_weather[:,k] = xtomorrow
    println(xtomorrow)
    xtoday = xtomorrow
end

transposed_the_weather = transpose(the_weather)

plot(transposed_the_weather)


