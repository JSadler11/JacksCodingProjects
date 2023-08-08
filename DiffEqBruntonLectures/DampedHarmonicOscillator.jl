using LinearAlgebra
using Plots
using DifferentialEquations

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
xlabel! = "Time"
ylabel! = "xF[1, :]"

#Define differential equation

function odefunc!(dx, x, p, t)
    dx .= A * x
end

#Create the time span
tspan = (0.0, T)

#Solve the ODE using the 'ode45' function
prob = ODEProblem(odefunc!, x0, tspan)
sol = solve(prob, saveat = dt)

#Extract the solution
t = sol.t
xGood = sol.u

plot_layout = @layout [a b]

p1 = plot(t, xF[1, :], color = "black", label = "Forward Euler")
plot!(t, xGood[1, :], color = "red", label = "ODE 45 (RK4)")
xlabel!("Time")
ylabel!("Position")
legend!()

plot(p1, layout = plot_layout)


#compute better integral using built-in MATLAB code
#4th-order Runge Kutta
#[TOUT, YOUT] = ODE45(ODEFUN, TSPAN, Y0)

[t, xGood] = ode45( @(t, x) A*x, 0:dt:T, x0);

#using function handle to define @(t, x) A*x... right hand side
#of \dot{x} = Ax... ode45 wants us to include time in @(t, x), in 
#case there is time dependence


