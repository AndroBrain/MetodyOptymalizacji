import numpy as np
import cvxpy as cp

xLek1 = cp.Variable()
xLek2 = cp.Variable()
xSur1 = cp.Variable()
xSur2 = cp.Variable()

objective = cp.Minimize(
    (100 * xSur1 + 199.90 * xSur2 + 700 * xLek1 + 800 * xLek2) - (6500 * xLek1 + 7100 * xLek2)
)

constraints = [
    0.01 * xSur1 + 0.02 * xSur2 - 0.5 * xLek1 - 0.6 * xLek2 >= 0,
    xSur1 + xSur2 <= 1000,
    90 * xLek1 + 100 * xLek2 <= 2000,
    40 * xLek1 + 50 * xLek2 <= 800,
    100 * xSur1 + 199.9 * xSur2 + 700 * xLek1 + 800 * xLek2 <= 100000,
    xSur1 >= 0,
    xSur2 >= 0,
    xLek1 >= 0,
    xLek2 >= 0,
]

p1 = cp.Problem(objective, constraints)
p1.solve()
print("--------------")
print(xLek1.value)
print(xLek2.value)
print(xSur1.value)
print(xSur2.value)
print("--------------")
