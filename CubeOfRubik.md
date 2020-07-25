# Computer solution of puzzle game ([Rubik's Cube]())

##### Table of contents

1. [Project Description.](#desc)
2. [What should be achieved during this project's production.](#achieve)
3. [What skills / knowledge should you have to create this or a similar project?](#skill)
4. [References](#references)

---

### Project Description <a name="desc"></a>

There is a wide variety of turn-based “solitaire” puzzle games. Often, these puzzles are [amenable](https://dictionary.cambridge.org/dictionary/english/amenable) to solution by computer, either using some kind of [heuristic-guided local search](https://www.youtube.com/watch?v=XUNGtxoBbPQ), or by encoding them as a [constraint-satisfaction problem](https://en.wikipedia.org/wiki/Constraint_satisfaction_problem) and using a generic external solver. The goal of this project is to produce a novel solver for such a game and **evaluate its effectiveness**. You might also consider the problem of how to *generate interesting puzzle instances of varying difficulty*. Some idea would be: Solver for "Rush Hour" block-sliding traffic puzzles; Solver and generator for Sokoban (crate pushing) puzzles; and Generator for crossword puzzles.

How to make the 'puzzle instance' more difficult? - By adding more [cubies](https://www.yourdictionary.com/cubie) to the overall Rubik's cube; increasing the difficulty and increasing the time in solving the puzzle.

---

### What should be achieved during this project's production <a name="achieve"></a>

**Mandatory**

- [ ] Use **local search** or **constraint solvers** to solve well-specified problems
- [ ] Evaluate empirically the effectiveness of a solution method for a problem - (This step will be the hardest I believe)
- [ ] Develop a computer implementation of a puzzle game.

**Optional**

- [ ] Allow user to create custom cube sizes
- [ ] Allow user to create a custom cube scramble
- [ ] Provide output of solving steps to user as well as number of steps required to solve the cube from its scrambled state

---

### What skills / knowledge should you have to create this or a similar project? <a name="skill"></a>

- Local search (Heuristic-based)
- SAT / Constraint solver
- Sufficient knowledge of basic conventions regarding the programming language being used to create the rubiks cube simulator/solver

*"A specific idea of a **puzzle game** you would like to write a solver for, and experience of solving instances of those puzzles yourself."*

I've spent a considerable amount of time with solving Rubik's cubes. I have a familiarity with solving a Rubik's Cube using various methods with various cube sizes ranging from 2\*2 to 5\*5. I find this particular puzzle an interesting project to pursue as the complexity a Rubik's Cube has always fascinated me.

---

### **References** <a name="references"></a>

The intention here is to use these references as inspiration for features, ideas or conventions to implement into my own Rubik's Cube Solver. 

1. [Python Rubiks Cube Solver](https://github.com/sylvain-reynaud/RubiksSolver/)
2. [Code Bullet Rubiks Cube Solver](https://github.com/Code-Bullet/RubiksCubeAI)
3. [Rotation Matrix Wiki Page](https://en.wikipedia.org/wiki/Rotation_matrix)
4. 

