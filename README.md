<h2 align = "center"> Computer solution of puzzle game - Rubik's Cube Solver </h2>

---
![Rubik's Banner](Images/Banner.png)

<p align = "center">[Live Demo Coming Soon]()</p>
---

<h3> Table of contents</h3>

1. [Project Description.](#desc)
2. [Goals for this project.](#achieve)
3. [Terminology and Notation](#notation)
4. [What skills / knowledge are required to create this or similar projects?](#skill)
5. [Stages of creation.](#stages)
6. [References.](#references)

---

<h2>Project Description <a name="desc"></a></h2>

> "There is a wide variety of turn-based “solitaire” puzzle games. Often, these puzzles are [amenable](https://dictionary.cambridge.org/dictionary/english/amenable) to solution by computer, either using some kind of [heuristic-guided local search](https://www.youtube.com/watch?v=XUNGtxoBbPQ), or by encoding them as a [constraint-satisfaction problem](https://en.wikipedia.org/wiki/Constraint_satisfaction_problem) and using a generic external solver. The goal of this project is to produce a novel solver for such a game and **evaluate its effectiveness**. You might also consider the problem of how to *generate interesting puzzle instances of varying difficulty*. Some idea would be: Solver for "Rush Hour" block-sliding traffic puzzles; Solver and generator for Sokoban (crate pushing) puzzles; and Generator for crossword puzzles."

<h4> How can the 'puzzle instance' difficulty be changed?</h4>

By adding or subtracting [cubies](https://www.yourdictionary.com/cubie) to the overall Rubik's cube; increasing the difficulty and increasing the time in solving the puzzle.

---

<h2> Goals for this project <a name="achieve"></a></h2>

My first o is to create an emulator of the puzzle game in order to be able to work on guiding a computer to solving it. I've chosen to use Processing Java as the language to create the Rubiks cube emulator.
<h3> Main Objectives </h3>

- [x] Emulation of cube
- [x] Scramble function for cube
- [x] Animation of each move
- [x] Reverse scramble of cube

<h3>Mandatory</h3>

- [ ] Use **local search** or **constraint solvers** to solve well-specified problems
- [ ] Evaluate empirically the effectiveness of a solution method for a problem - (This step will be the hardest I believe)
- [ ] Develop a computer implementation of a puzzle game.

<h3>Optional</h3>

- [ ] Allow user to create custom cube sizes
- [ ] Allow user to create a custom cube scramble
- [ ] Provide output of scramble/solve steps to console for the user
- [ ] The number of steps required to solve the cube from its scrambled state - could be a factor used to help determine the efficiency of the solve ([God's number]([https://www.cube20.org/#:~:text=New%20results%3A%20God's%20Number%20is,requires%20more%20than%20twenty%20moves.](https://www.cube20.org/#:~:text=New results%3A God's Number is,requires more than twenty moves.)))

---
<h2>Terminology and Notation</h2> <a name="notation"></a>

 - A letter by itself refers to a clockwise rotation of a single face by 90°

 - A letter followed by an apostrophe means the face rotates counter-clockwise 90°

 - A letter with the number 2 after it marks a double turn (180 degrees)

---

<h2> Background <a name="skill"></a></h2>

- Local search (Heuristic-based)
- SAT / Constraint solver
- Sufficient knowledge of basic conventions regarding the programming language being used to create the rubiks cube simulator/solver

> "A specific idea of a **puzzle game** you would like to write a solver for, and experience of solving instances of those puzzles yourself."

I've spent a considerable amount of time with solving Rubik's cubes using human methods. I have a familiarity with solving a Rubik's Cube with various cube sizes ranging from 2\*2 to 5\*5. I find this particular puzzle interesting to emulate and solve digitally as the complexity a Rubik's Cube has always fascinated me.

---

<h2> Stages of creation</h2> <a name="stages"></a>

<h3>Stage 1 - Cube of cubies</h3>

<p align="center"><img src=Gifs/Stage1.gif width="300" height ="300"/></p>

<h3>Stage 2 - Scramble the cube</h3>

<p align="center"><img src=Gifs/Stage2.gif width="300" height ="300"/></p>

<h3>Stage 3 - Move animations | On screen counter and move notation</h3>

<p align="center"><img src=Gifs/Stage3.gif width="300" height ="300"/></p>

<h3>Stage 4 - Reverse Scramble</h3>
<p align="center"><img src=Gifs/Stage4.gif width="300" height ="300"/></p>

---

<h2> References <a name="references"></a></h2>

The intention here is to use these references as inspiration for features, ideas or conventions to implement into my own Rubik's Cube Solver. 

1. [Python Rubiks Cube Solver](https://github.com/sylvain-reynaud/RubiksSolver/)
2. [Code Bullet Rubiks Cube Solver](https://github.com/Code-Bullet/RubiksCubeAI)
3. [Rotation Matrix Wiki Page](https://en.wikipedia.org/wiki/Rotation_matrix)
4. Rubik's Cube Emulator
   1. [Part 1](https://www.youtube.com/watch?v=9PGfL4t-uqE)
   2. [Part 2](https://www.youtube.com/watch?v=EGmVulED_4M)
   3. [Part 3](https://www.youtube.com/watch?v=8U2gsbNe1Uo)
5. [Rubik's Cube Notation](https://ruwix.com/the-rubiks-cube/notation/)
6. [Terminology and Notation](https://ruwix.com/the-rubiks-cube/notation/)
