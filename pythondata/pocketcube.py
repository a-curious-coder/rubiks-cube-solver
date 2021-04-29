import sys
import os
import csv
import pylab
import matplotlib.pyplot as plt
plt.style.use('seaborn-whitegrid')
import numpy as np

# Initialise two 2D lists
god_list = []
# Read in depth and time information to corresponding list
# with open(os.path.join(os.path.dirname(__file__),"pGods_results.txt"), 'r') as f:
with open(os.path.join(os.path.dirname(__file__),"pkociemba_results.txt"), 'r') as f:
# with open(os.path.join(os.path.dirname(__file__),"pthistlethwaites_results.txt"), 'r') as f:
# with open(os.path.join(os.path.dirname(__file__),"phuman_results.txt"), 'r') as f:
# with open(os.path.join(os.path.dirname(__file__),"pkorfs_results.txt"), 'r') as f:
    for line in csv.reader(f):
        god_list.append(line)

# Remove the column headers and the blank line at the end
god_list.pop(0)

# Separate time and solution length to their own lists and convert to appropriate data types
solution_length = list(map(int, [line[2] for line in god_list]))
time = list(map(float, [line[3] for line in god_list]))

# Plot this info
fig = plt.figure(figsize=(14, 7))

m = "H"
if god_list[0][0] == "1":
    plt.title("Human Algorithm")
if god_list[0][0] == "2":
    plt.title("Thistlethwaite's Algorithm")
    m = "D"
if god_list[0][0] == "3":
    plt.title("Kociemba's Algorithm")
    m = "d"
if god_list[0][0] == "4":
    plt.title("Korf's Algorithm")
    m = "*"
if god_list[0][0] == "5":
    plt.title("Pocket Cube : God's Algorithm")
    m = "X"

average_time = 0
average_moves = 0
for value in range(0, len(solution_length)):
    average_time += time[value]
    average_moves += solution_length[value]
    plt.plot(solution_length[value], time[value], color = 'orange', marker = m,  markersize =10, markerfacecolor = 'orange', markeredgecolor = (0,0,0,1)) 

if god_list[0][0] == "5":
    plt.yscale('linear')
    plt.ylabel("CPU Time (s)")
else:
    plt.yscale('log')
    # plt.yscale('linear')
    plt.ylabel("CPU Time (s, log scale)")

my_formatter = "{0:.2f}"
average_time = float(my_formatter.format(average_time / len(time)))
average_moves = my_formatter.format(average_moves / len(solution_length))

if average_time > 60:
    day = average_time // (24 * 3600)
    time = average_time % (24 * 3600)
    hour = average_time // 3600
    average_time %= 3600
    minutes = average_time // 60
    average_time %= 60
    seconds = average_time
    time = ""
    if seconds < 60 and minutes < 1:
        time = "%d seconds" % (seconds)
    elif minutes > 1 and hour < 1:
        time = "%d minutes, %d seconds" % (minutes, seconds)
    elif  hour < 24:
        time = "%d hours, %d minutes, %d seconds" % (hour, minutes, seconds)
    elif  hour > 24:
        time = "%d days, %d hours, %d minutes, %d seconds" % (day, hour, minutes, seconds)
    txt = "    ".join([f"Average Solution Length: {average_moves}",  f"Average Solving Time:  {time}"])
else:
    txt = "    ".join([f"Average Solution Length: {average_moves}",  f"Average Solving Time:  {average_time}s"])
# plt.axis([0, 11, 0, 2])
# plt.xlim([0, 20])
# plt.xticks(np.arange(0, 20, 1))
plt.xlabel("Solution Length")

# plt.ylim([0, 125000])
# plt.yticks(np.arange(0, 125000, 25000))


# Write text to graph
fig.text(.5, .012, txt, ha = 'center')
ax = plt.gca()
fig.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()
