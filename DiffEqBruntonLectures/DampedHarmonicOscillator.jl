using LinearAlgebra
using Plots

ω = 2*π #natural frequency
d = 0.25 #damping ratio

#spring mass damper system
A = [0 1; -ω^2 -2d*ω];

dt = 0.01 #time step
T = 10 #amount of time to integrate
n = Int(T/dt)
t = range(0, stop=T, length=n)

x0 = [2; 0]; #initial condition (x=2, v=0)

#iterate forward Euler
xF = zeros((2, n+1)) #2x(n+1) matrix to store results
tF = zeros(n+1) #Vector of all time points

#Implement loop

for k in 1:n
    tF[k+1] = k * dt; #Update the time points
    xF[:, k+1] = (Matrix(I, 2, 2) + dt * A) * xF[:, k] #Calculate the next state of the xF matrix using array slicing to update the elements of tF and matrix multiplication to compute the next state of xF.
end

plot(tF, xF[1, :], color = "black", legend = false, xlabel = "Time", ylabel = "xF[1, :]", title = "Plot of xF[1, :] vstF")

