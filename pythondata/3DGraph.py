from mpl_toolkits.mplot3d import Axes3D
import pandas as pd
from matplotlib import pyplot as plt
from mpl_toolkits.axes_grid1.inset_locator import inset_axes
from matplotlib import animation
from matplotlib import colors as c
import numpy as np
import os
import time

def getGroup(method):
    try:
        methods.append(grouped.get_group(method))
        print(methods)
    except Exception as e:
        print(f"No {algos[method-1]}\nRemoving")
        legends.remove(algos[method-1])

algos = ["Human Algorithm", "Korfs Algorithm", "Kociemba's Algorithm", "Pocket Cube : God's Algorithm"]
legends = ["Human Algorithm", "Korfs Algorithm", "Kociemba's Algorithm", "Pocket Cube : God's Algorithm"]

os.chdir("c:\\Users\\callu\\Desktop\\Sync-Folder\\rubiks-cube-solver\\pythondata\\")
filename = "data2.csv"

# Read file to dataframe
df = pd.read_csv(filename)

plt.style.use('seaborn')
plt.rcParams['animation.ffmpeg_path'] = 'C:\\ffmpeg\\bin\\ffmpeg.exe'
fig = plt.gcf()
fig.set_size_inches(11,8)
fig.canvas.set_window_title('Rubik\'s Cube Solving Methodology Performance Graph')
fig.patch.set_facecolor('xkcd:gray')
ax = fig.add_subplot(111, projection='3d')

# https://stackoverflow.com/questions/14088687/how-to-change-plot-background-color
ax.set_facecolor('xkcd:grey')
# plt.title('Solver Methodology Performance Graph', fontsize= 14, color="black")


# Collect all memory consumption values from csv file
memconsum_list = df["memconsum"].tolist()

# Calculate a corresponding normlisation value between 0-1 for each of the memory consumptions.
max_mcs = max(memconsum_list)

# Group data from csv by method
grouped = df.groupby(df.method)

# Initialise methods list - https://www.kite.com/python/answers/how-to-split-a-pandas-dataframe-into-multiple-dataframes-by-column-value-in-python
methods = []

getGroup(1)
getGroup(2)
getGroup(3)
getGroup(5)

# print(methods)

cmap = c.LinearSegmentedColormap.from_list("", ["green","yellow","red"])
# Different marker for each method
markers = ["v", "o", "x", "P"]
# Same colour for all plots. Alpha value (Transparency) should be based on how much memory a method consumed during operation.
# colours = ["red", "blue"]
# To select the index for each method being plotted in scatter plot graph
colours = ["red", "green", "blue", "cyan"]
ctr = 0
for m in methods:
    method = m['method'] # Colour
    solve = m['solve']   # X
    scramble = m['scramble']
    time = m['time']         # Y
    mcs = m['memconsum'] # Z
    # Calculate a corresponding normlisation value between 0-1 for each of the memory consumptions.
    normalised_mcs = [v/max_mcs for v in mcs]
    p = ax.scatter(solve, time, scramble, s=160, c = normalised_mcs, cmap = cmap, edgecolors = 'black', marker = markers[ctr], alpha = 0.8)
    # alpha = normalised_memconsum[ctr]
    ctr = ctr +1
    # print(solve, time)

# Methods used
ax.legend(legends, fontsize=10, bbox_to_anchor=(1.3, 1.1), loc='upper right') # https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.legend.html
# plt.legend([len(methods[0]), " : Human", "Korf"], fontsize=10, loc=('upper left')) # https://matplotlib.org/stable/api/_as_gen/matplotlib.pyplot.legend.html
# cbaxes = fig.add_axes([0.8, 0.1, 0.03, 0.8])
axins = inset_axes(ax,
                width="5%",  # width = 5% of parent_bbox width
                height="75%",  # height : 50%
                loc='center left',
                bbox_to_anchor=(1.1, 0., 1, 1),
                bbox_transform=ax.transAxes,
                borderpad=0,
                )
cbar=plt.colorbar(p, cax = axins, ticks= [0, 10])
cbar.set_label("Memory Consumption")

ax.set_xlabel("Moves to solve")
ax.set_ylabel("Time (s)")
ax.set_zlabel("Moves to scramble")
# Get rid of colored axes planes
# First remove fill
ax.xaxis.pane.fill = True
ax.yaxis.pane.fill = True
ax.zaxis.pane.fill = True

# Now set color to white (or whatever is "invisible")
ax.xaxis.pane.set_edgecolor('grey')
ax.yaxis.pane.set_edgecolor('grey')
ax.zaxis.pane.set_edgecolor('grey')

# https://medium.com/the-owl/magnifying-dense-regions-in-matplotlib-plots-c765db7ba431
# def animate(i):
#     # "i" is updated for each frame i = 10 when frame = 10
#     # for 360 frames, azim will take 360 values for a round display of the 3D plot
#     ax.view_init(elev=10., azim=i)
#     return fig,

# anim = animation.FuncAnimation(fig, animate, init_func=None, frames=720, interval=20, blit=True)

# anim.save('3D_animated_plot.mp4', fps=30, extra_args=['-vcodec', 'libx264'])

plt.show()


# Measure - 50 solves using solver and 50 solved using human algorithm using scrambles at 20-100 moves each using same scrambles... Might need to generate 50 sets of scrambles.
# Method used - colour
# Moves taken x
# Time taken  y
# Computing/CPU power taken - size
# moves, time, method, memcsptn