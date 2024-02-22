import numpy as np
import cvxpy as cp
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import linprog

data = pd.read_csv("data01.csv")

plt.scatter(data['x'], data['y'], 2, color='red')
plt.xlim(0, 10)
plt.ylim(0, 10)

fi = np.zeros(shape=(201, 2))
fi[:, 0] = data['x']
fi[:, 1] = 1
y = np.matrix(data['y'])

fi_t = np.linalg.pinv(fi)
y_t = np.transpose(y)
result = np.matmul(fi_t, y_t)
aLS = result[0, 0]
bLS = result[1, 0]
print(aLS)
print(bLS)

plt.plot(data['x'], data['x'] * aLS + bLS, 1)
plt.show()
