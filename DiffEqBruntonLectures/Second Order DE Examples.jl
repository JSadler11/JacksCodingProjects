#Second Order DE Examples
using DifferentialEquations
using LinearAlgebra
using Plots

 A = [0 1; -2 -3]
eigenvalues = eigvals(A)

t = 0:0.01:10
tspan = (0.0, 10.0)
y0 = [2; -3]

x = exp.(-t) .+ exp.(-2 .* t)

plot(t, x, label = "Analytic", color="black")
xlabel!("Time")
ylabel!("Solution x")
ylims!(0, 2)

function myODE!(dy, y, p, t)
    A = [0 1; -2 -3]
    dy .= A * y
end

prob = ODEProblem(myODE!, y0, tspan)
sol = solve(prob, DP5())

plot!(sol, label = "DP5", color="red")

B = [0 1; -2 3]
eigvals(B)

C = [0 1; 2 -1]
eigvals(C)