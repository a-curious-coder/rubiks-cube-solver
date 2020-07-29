# Computer solution of puzzle game ([Rubik's Cube]([https://en.wikipedia.org/wiki/Rubik%27s_Cube](https://en.wikipedia.org/wiki/Rubik's_Cube)))

##### Table of contents

1. [Project Description.](#desc)
2. [What should be achieved during this project.](#achieve)
3. [What skills / knowledge are required to create this or similar projects?](#skill)
4. [Stages of creation.](#stages)
5. [References](#references).

---

### Project Description <a name="desc"></a>

There is a wide variety of turn-based “solitaire” puzzle games. Often, these puzzles are [amenable](https://dictionary.cambridge.org/dictionary/english/amenable) to solution by computer, either using some kind of [heuristic-guided local search](https://www.youtube.com/watch?v=XUNGtxoBbPQ), or by encoding them as a [constraint-satisfaction problem](https://en.wikipedia.org/wiki/Constraint_satisfaction_problem) and using a generic external solver. The goal of this project is to produce a novel solver for such a game and **evaluate its effectiveness**. You might also consider the problem of how to *generate interesting puzzle instances of varying difficulty*. Some idea would be: Solver for "Rush Hour" block-sliding traffic puzzles; Solver and generator for Sokoban (crate pushing) puzzles; and Generator for crossword puzzles.

How to make the 'puzzle instance' more difficult? - By adding more [cubies](https://www.yourdictionary.com/cubie) to the overall Rubik's cube; increasing the difficulty and increasing the time in solving the puzzle.

---

### What should be achieved during this project <a name="achieve"></a>

First thing's first is to create an emulator of the puzzle game in order to be able to work on guiding a computer to solving it. I've chosen to use Processing Java as the language to create the Rubiks cube emulator.

**Mandatory**

- [ ] Use **local search** or **constraint solvers** to solve well-specified problems
- [ ] Evaluate empirically the effectiveness of a solution method for a problem - (This step will be the hardest I believe)
- [ ] Develop a computer implementation of a puzzle game.

**Optional**

- [ ] Allow user to create custom cube sizes
- [ ] Allow user to create a custom cube scramble
- [ ] Provide output of scramble/solve steps to console for the user
- [ ] The number of steps required to solve the cube from its scrambled state - could be a factor used to help determine the efficiency of the solve ([God's number]([https://www.cube20.org/#:~:text=New%20results%3A%20God's%20Number%20is,requires%20more%20than%20twenty%20moves.](https://www.cube20.org/#:~:text=New results%3A God's Number is,requires more than twenty moves.)))

---

### What skills / knowledge should you have to create this or a similar project? <a name="skill"></a>

- Local search (Heuristic-based)
- SAT / Constraint solver
- Sufficient knowledge of basic conventions regarding the programming language being used to create the rubiks cube simulator/solver

*"A specific idea of a **puzzle game** you would like to write a solver for, and experience of solving instances of those puzzles yourself."*

I've spent a considerable amount of time with solving Rubik's cubes. I have a familiarity with solving a Rubik's Cube using various methods with various cube sizes ranging from 2\*2 to 5\*5. I find this particular puzzle an interesting project to pursue as the complexity a Rubik's Cube has always fascinated me.

---

**Stages of creation** <a name="stages"></a>

Stage 1

<img src=Stages/Stage1.gif width="300" height ="300"/>

Stage 2

<img src=Stages/Stage2.gif width="300" height ="300"/>

Stage 3



---------------------------------------------------------------------------------------------



### **References** <a name="references"></a>

The intention here is to use these references as inspiration for features, ideas or conventions to implement into my own Rubik's Cube Solver. 

1. [Python Rubiks Cube Solver](https://github.com/sylvain-reynaud/RubiksSolver/)
2. [Code Bullet Rubiks Cube Solver](https://github.com/Code-Bullet/RubiksCubeAI)
3. [Rotation Matrix Wiki Page](https://en.wikipedia.org/wiki/Rotation_matrix)
4. Rubiks Cube Emulator
   1. [Part 1](https://www.youtube.com/watch?v=9PGfL4t-uqE)
   2. [Part 2](https://www.youtube.com/watch?v=EGmVulED_4M)
   3. [Part 3](https://www.youtube.com/watch?v=8U2gsbNe1Uo)

