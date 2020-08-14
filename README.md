<h2 align = "center"> Computer solution of puzzle game - Rubik's Cube Solver </h2>

---
![Rubik's Banner](Images/Banner.png)

<p align = "center">[Live Demo Coming Soon]()</p>
---

<h3> Table of contents</h3>

1. [Project Description.](#desc)
2. [Goals for this project.](#achieve)
3. [Terminology and Notation](#notation)
4. [Project background.](#skill)
5. [Stages of creation.](#stages)
6. [Issues faced during project creation.](#issues)
7. [References.](#references)

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

- [ ] Adapt the code to cater for larger cubes
- [ ] Save computing power by only storing visible cubies

   When generating a Rubik's cube of any size, the program literally stores every single cube even though it doesn't actually need to store any that are hidden inside. E.g. a 100x100x100 cube contains 1,000,000 cubies - (An extreme example). This takes a lot of computing power for a computer to even render, let alone scramble. 98*98*98 of those cubes stored aren't actually required as they're not visible.
<h3>Mandatory</h3>

- [ ] Use **local search** or **constraint solvers** to solve well-specified problems
- [ ] Evaluate empirically the effectiveness of a solution method for a problem - (This step will be the hardest I believe)
- [ ] Develop a computer implementation of a puzzle game.

<h3>Optional</h3>

- [ ] Allow user to create custom cube sizes
- [ ] Allow user to create a custom cube scramble
- [ ] Provide output of scramble/solve steps to console for the user
- [ ] The number of steps required to solve the cube from its scrambled state - [God's number](https://www.cube20.org/#:~:text=New%20results%3A%20God's%20Number%20is,requires%20more%20than%20twenty%20moves) could be a factor used to help determine the efficiency (based on number of moves) of the solve. God's Number is the theory that any traditional 3x3x3 Rubik's cube can be solved in 20 moves or lesss.

---
<h2>Terminology and Notation</h2> <a name="notation"></a>
Notation of a Rubik's Cube indicates what face on the cube is rotating and in which direction.

 - A letter by itself refers to a clockwise rotation of a single face by 90°
 - A letter followed by an apostrophe means the face rotates counter-clockwise 90°
 - A letter with the number 2 after it marks a double turn 180°


---

<h2> Background <a name="skill"></a></h2>

- Local search (Heuristic-based)
- SAT / Constraint solver
- Sufficient knowledge of basic conventions regarding the programming language being used to create the rubiks cube simulator/solver

> "A specific idea of a **puzzle game** you would like to write a solver for, and experience of solving instances of those puzzles yourself."

I've spent countless hours with learning solve Rubik's cubes of various sizes using human methods. I discovered the fortunate aspect of learning the 3x3x3 cube is that you don't have to learn much more to solve cubes of larger sizes. I find the idea of emulating this puzzle for the computer to solve extremely interesting. I'm hoping after applying local search and SAT algorithms, it will be a good stepping stone to integrating an algorithm that calculates (if not close to)  the most efficient solve for a scrambled cube - I will be basing this particular problem off god's number.

---

<h2> Stages of creation</h2> <a name="stages"></a>

<!--Stages 1 and 2-->
<table align = "center">
  <tr>
    <td>
      <h4>Stage 1 - Generate cube of cubies
    </td>
    <td>
      <h4>Stage 2 - Scramble cube
    </td>
  </tr>
  <tr>
    <td>
      <p align="center"><img src=Gifs/Stage1.gif width="100%" height ="100%"/></p>
    </td>
    <td>
    <p align="center"><img src=Gifs/Stage2.gif width="100%" height ="100%"/></p>
    </td>
  </tr>
  <tr>
   <td width = 25% align="">
   The first objective was to calculate the initial position of each cubie to build the 3x3x3 Rubik's Cube.
   </td>
   <td width = 25%>
   I created each possible move for the cube which required each face's axis and direction of the rotation for that face. I created a function that randomly generates moves and applies them to the cube.
   </td>
  </tr>
</table>

<!--Stages 3 and 4-->
<table align = "center">
  <tr>
    <td>
      <h4>Stage 3 - Animations | Notation | Counter
    </td>
    <td>
      <h4>Stage 4 - Reverse scramble
    </td>
  </tr>
  <tr>
    <td>
      <p align="center"><img src=Gifs/Stage3.gif width="300" height ="300"/></p>
    </td>
    <td>
    <p align="center"><img src=Gifs/Stage4.gif width="300" height ="300"/></p>
    </td>
  </tr>
  <tr>
   <td width = 25%>
   I followed the last part of Coding Train's tutorial for adding animation to the rotations of the cube's faces. I also added a counter to count each move and converted these moves to a string format to ensure each move was correct (I've since updated to proper notation as in a previous commit I used incorrect notation).
   </td>
   <td width = 25%>
   This was included in Coding Train's tutorial of creating the scramble - This involved storing the sequence of moves to scramble backwards somewhere else to then reverse each of the moves' directions. I then played these moves back and voila - the illusion of a solve.
   </td>
  </tr>
</table>

<!-- Stage 5 and 6-->
<table align = "center";>
  <tr>
    <td colspan ="2">
      <h4>Stage 5 - Generating & scrambling different cube sizes and an unsuccessful scramble
    </td>
  </tr>
  <tr>
    <td>
      <p align="center"><img src=Gifs/Stage5.gif width="300" height ="300"/></p>
    </td>
    <td>
    <p align="center"><img src=Gifs/Stage5.1.gif width="300" height ="300"/></p>
    </td>
  </tr>
  <tr>
   <td width = 25%>
      This 5x5x5 cube scrambles successfully (gave me great amount of satisfaction after working on it for countless hours.)
   </td>
   <td width = 25%>
      I thought I'd document this issue as it's an interesting problem. When I tried to scramble any even numbered cube that wasn't a 2x2x2, it did something similar to this. The new positions calculated for the cubies to move to are incorrect - I need to figure out what's causing it.
   </td>
  </tr>
</table>

---
<a name="issues"></a>
<h2>Issues faced during project creation</h2>
<h4>Notation issue</h4>
Standard 3x3x3 cubes have a recognised notation for each move but as the cubes get bigger - typically beyond a 5x5x5 cube, the notation for moves being done aren't identifiable. However, this fortunately didn't mean I was limited in regards to actually generating moves for all edges of all cube sizes. The moves generated for each cube are based on the size of the cube itself which means the program will be able to scramble any sized cube... Or so I thought.
<h4>Computing power issue</h4>
A 20x20x20 cube has 8,000 cubies. A 100x100x100 cube has 1,000,000 cubies. The majority of these stored cubies are borderline useless as they're not visible to the user which means the CPU is unecessarily put under strain when calculating each cubie's position when starting the program. 
This isn't such an issue for a traditional 3x3x3 Rubik's cube since the program only stores 27 cubies. 
<h4>Even numbered cubes issue</h4>
After countless gruelling hours of research alongside trial and error, I finally managed to adapt my program to cater for all cube sizes. The next objective was the scramble. It worked perfectly for odd numbered cubes of any size but, as exampled above, any cube with an even number of cubies would almost dismantle when being scrambled.

---

<h2> References <a name="references"></a></h2>

The intention here is to use these references as a guide or inspiration for features, ideas or conventions to apply my own Rubik's Cube Solver. 

1. [Python Rubiks Cube Solver](https://github.com/sylvain-reynaud/RubiksSolver/)
2. [Code Bullet Rubiks Cube Solver](https://github.com/Code-Bullet/RubiksCubeAI)
3. [Rotation Matrix Wiki Page](https://en.wikipedia.org/wiki/Rotation_matrix)
4. [Rubik's Cube Emulator - Part 1](https://www.youtube.com/watch?v=9PGfL4t-uqE)
5. [Rubik's Cube Emulator - Part 2](https://www.youtube.com/watch?v=EGmVulED_4M)
6. [Rubik's Cube Emulator - Part 3](https://www.youtube.com/watch?v=8U2gsbNe1Uo)
7. [Rubik's Cube Notation](https://ruwix.com/the-rubiks-cube/notation/)
8. [Terminology and Notation](https://ruwix.com/the-rubiks-cube/notation/)
9. [Markdown Cheatsheet](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)