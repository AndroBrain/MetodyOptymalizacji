import numpy as np
import cvxpy as cp

###############################
## method 1
###############################
x1 = cp.Variable()
x2 = cp.Variable()
x3 = cp.Variable()
objective = cp.Minimize(300 * x1 + 500 * x2 + 800 * x3)
constraints = [0.8 * x1 + 0.3 * x2 + 0.1 * x3 >= 0.3,
               0.01 * x1 + 0.4 * x2 + 0.7 * x3 >= 0.7,
               0.15 * x1 + 0.1 * x2 + 0.2 * x3 >= 0.1,
               x1 >= 0,
               x2 >= 0,
               x3 >= 0]
p1 = cp.Problem(objective, constraints)
p1.solve()
print("--------------")
print(x1.value)
print(x2.value)
print(x3.value)
print("--------------")
