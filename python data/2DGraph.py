import sys
import os
import csv
import matplotlib.pyplot as plt
plt.style.use('seaborn-whitegrid')
import numpy as np

np_list = []
p_list = []
with open(os.path.join(os.path.dirname(__file__),"np_stats.txt"), 'r') as f:
    for line in csv.reader(f, dialect="excel-tab"):
        np_list.append(line)

with open(os.path.join(os.path.dirname(__file__),"p_stats.txt"), 'r') as f:
    for line in csv.reader(f, dialect="excel-tab"):
        p_list.append(line)

np_list.pop(0)
np_list.pop(-1)
p_list.pop(0)
p_list.pop(-1)

print(np_list)

depth = []
time = []

for line in np_list:
    depth.append(line[0]) # x axis
    time.append(line[1])  # y axis

plt.plot(depth, time, linestyle='dashed', marker = 'x', markersize = 6, markerfacecolor = 'red')
depth.clear()
time.clear()

for line in p_list:
    depth.append(line[0]) # x axis
    time.append(line[1])  # y axis

plt.plot(depth, time, linestyle='dashed', marker = 'o', markersize = 6, markerfacecolor = 'green')
# plt.plot(depth, time)

plt.xlim(0, 20)
plt.xlabel("Depth")
plt.ylabel("Time (ms)")
plt.title("Pruning tables vs. No Pruning Tables")

# plt.yticks(np.arange(0, max(time), 10000))
plt.xticks(np.arange(1, 21), np.arange(1, 21))
plt.show()