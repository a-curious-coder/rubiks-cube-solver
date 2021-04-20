import sys
import os
import csv
import matplotlib.pyplot as plt
plt.style.use('seaborn-whitegrid')
import numpy as np

# Initialise two 2D lists
np_list = []
p_list = []
# Read in depth and time information to corresponding list
with open(os.path.join(os.path.dirname(__file__),"np_stats.txt"), 'r') as f:
    for line in csv.reader(f, dialect="excel-tab"):
        np_list.append(line)
# ""
with open(os.path.join(os.path.dirname(__file__),"p_stats.txt"), 'r') as f:
    for line in csv.reader(f, dialect="excel-tab"):
        p_list.append(line)

# Remove the column headers and the blank line at the end
np_list.pop(0)
np_list.pop(-1)
p_list.pop(0)
p_list.pop(-1)

# initialise depth and time lists for separating the 2D list
depth = []
time = []

# For every line, separate depth and time info to their own lists
for line in np_list:
    depth.append(int(line[0])) # x axis
    time.append(int(line[1]))  # y axis

# Plot this info
plt.figure(figsize=(15, 5))
# plt.subplot(211)
print(depth)
print(time)
plt.plot(depth, time, linestyle='dashed', color = 'red', marker = 'x', markersize = 6, markerfacecolor = 'red', label = 'No Pruning Tables')
# ax = plt.gca()
# ax.set_ylim([0, 20])
# ax.set_xlim([0, 20])

depth.clear()

time.clear()
# ""
for line in p_list:
    depth.append(int(line[0])) # x axis
    time.append(int(line[1]))  # y axis

# plt.subplot(212)
plt.plot(depth, time, linestyle='dashed', color = 'green', marker = 'o', markersize = 6, markerfacecolor = 'green', label = 'Pruning Tables')
plt.legend(loc = 'best')
ax = plt.gca()
ax.set_ylim([0, 200000])
ax.set_xlim([0, 20])

plt.xlabel("Depth")
plt.ylabel("Time (ms)")
plt.title("Korf's Algorithm\nPruning tables vs. No Pruning Tables")

plt.yticks(np.arange(0, 200000, 25000))
plt.xticks(np.arange(0, 20, 1))
plt.show()

# fig,ax=plt.subplots()
# ax.plot(gapminder_us.year, gapminder_us.lifeExp, marker="o")
# ax.set_xlabel("year")
# ax.set_ylabel("lifeExp")
# ax.plot(gapminder_us.year, gapminder_us["gdpPercap"], marker="o")