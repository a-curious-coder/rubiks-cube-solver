import peasy.*;

// Camera object to visualise a Rubik's Cube
PeasyCam cam;
int displayHeight = 600; 
int displayWidth = 600;
// Cube object
Cube cube;
// Stores the currentMove in the scramble/solve process
Move currentMove;
// Dimensions of the cube
int dim = 3;
// Responsible for counting number of moves made in scramble and solve.
int counter;
// The more complex the cube, the more moves required to scramble it.
int numberOfMoves;
// represents each edge of the cube for each size
float middle;
// Mainly represents each row/column of a cube 
float axis;
// Determines how fast animations / turns are
float speed;
// Stores moves to print to screen.
String moves = "";
// Used to store moves in the solving function in HumanAlgorithm
String turns = "";
// Pausing boolean - enables me to pause the cube's operations.
boolean paused;
// Is the cube scrambling boolean
boolean scramble;
// Is the cube solved boolean
boolean solve;
// Is the cube reversing scramble
boolean reverse;
// Displays hud if true
boolean hud;
ArrayList<Cubie> corners;
ArrayList<Cubie> edges;
ArrayList<Cubie> centers;
// sequence stores the moves to scramble and reverse the cube's scramble
ArrayList<Move> sequence;
// allMoves stores all possible moves for any cube size
ArrayList<Move> allMoves;
// Stores moves as strings - each move accessible via an index
ArrayList<String> fMoves;
// Stores background
PImage background;

// initialises rubik's cube emulation
void setup() {
  // Screen size
  // size(displayHeight, displayWidth, P3D);
  fullScreen(P3D);
  // FPS
  frameRate(60);
  // Sets camera up - sets pov which means it displays all cube sizes to fit in the screen (caters for larger cubes)
  setupCamera();
  // background = loadImage("C:\\Users\\callu\\Desktop\\Processing\\rubiks-cube-solver\\RubiksCube\\bg.png");
  // background.resize(displayHeight, displayWidth);
  // Initialise appropriate variables with default values
  counter = 0;
  numberOfMoves = dim * 8;
  axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
  middle = axis + -axis;
  speed = 0.001;
  scramble = false;
  solve = false;
  reverse = false;
  paused = false;
  hud = false;
  corners = new ArrayList<Cubie>();
  edges = new ArrayList<Cubie>();
  centers = new ArrayList<Cubie>();
  sequence = new ArrayList<Move>();
  allMoves = new ArrayList<Move>();
  fMoves = new ArrayList<String>();
  cube = new Cube();

  // Improves details
  smooth(8);

  updateLists();

  if (dim > 1)  InitialiseMoves();
  currentMove = new Move('X', 0, 0);
}

// draws emulation to screen
void draw() {
  background(220,220,220);
  // background(background);
  // Sets the initial view of the cube
  rotateX(-0.3);
  rotateY(0.6);
  
  updateCam();
  // If boolean paused is false
  if (!paused)  {
    checkColours();
    // If currentMove is finished
    if (!cube.animating) {
      // print sequence of moves to console
      printScrambleInfo();
      // if counter is less than number of sequence of moves
      if (counter <= sequence.size() - 1) {
        // currentMove becomes next move in the sequence
        currentMove = sequence.get(counter);
        // start move
        if(currentMove.index > axis)  {
          cube.turnWholeCube(currentMove.currentAxis, currentMove.dir);
        } else {
          cube.turn(currentMove.currentAxis, currentMove.index, currentMove.dir);
        }
        // iterate counter value
        counter++;
      }
    }
    
    if(solve) {
      if(turns.length() == 0 && !cube.animating)  {
        cube.hAlgorithm.solveCube();
      }
    }
    // Updates rotationAngle for cube
    cube.update();
  }
  // Scales size of cube up so user can see it
  scale(50);
  // Calculates each cubie position / rotation - Shows each cubie in cube
  cube.show();
  
  // If cube is not animating and there are turns to be done
  if (!cube.animating && turns.length() > 0) {
    // Adds 10 moves at a time to moves string
    if(fMoves.size() % 10 == 0) {
      formatMoves();
    }
    // if scramble is done / false
    if (!scramble) {
      // Make first move.
      if (sequence.size() > 0) sequence.clear();
      if (turns.length() > 0) doTurn();
      for (int i = 0; i < sequence.size(); i++) print(sequence.get(i).toString());
    }
  }
  // Always updating positions of every cubie to their respective lists.
  updateLists();
  // creates a HUD which contains relevant information
  if(hud)  {
    cam.beginHUD();
      String ctr = "Moves:\t" + str(counter);
      String fps = nf(frameRate, 1, 1);
      float tSize = 12;
      float x = 0;
      float y = tSize;
      textSize(tSize);
      fill(0);
      //rect(20, 10, 30, 30, 30);
      // x, y, width, height
      x += 20;
      y += 20;
      text(ctr, x, y);
      y += 20;
      text("FPS:\t" + fps, x, y);
      y += 20;
      text("Speed:\t" + nf(speed, 1, 1), x, y);
      y += 20;
      text("Cube:\t" + dim + "x" + dim + "x" + dim, x, y);
      y += 20;
      float nCombinations = dim == 2 ? fact(7) * pow(3, 6) : 1;
      nCombinations = dim == 3 ? ((0.5) * (fact(8) * pow(3, 7)) * fact((dim*dim*dim) - 15) * pow(2, (dim*dim*dim)-16)) : nCombinations;
      text("Total number of combinations:\t" + nfc(nCombinations, 0), x, y);
      y += 20;
      text(moves, x, y);
    cam.endHUD();
  }
}

void setupCamera () {
  //hint(ENABLE_STROKE_PERSPECTIVE);
  float fov      = PI/3;  // field of view
  float nearClip = 1;
  float farClip  = 100000;
  float aspect   = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);  
  cam = new PeasyCam(this, 100 * (dim));
}

void updateCam () {
  //----- perspective -----
  float fov      = PI/3;  // field of view
  float nearClip = 1;
  float farClip  = 100000;
  float aspect   = float(width)/float(height);  
  perspective(fov, aspect, nearClip, farClip);
  //println(cam.getDistance());
}

void doTurn() {
  solve = true;
  counter = 0;
  // turn becomes the first move of turns String
  char turn = turns.charAt(0);
  // Rest of turns are stored back in turns
  turns = turns.substring(1, turns.length());
  boolean clockwise = true;

  // If there are turns left and the new first char is a prime (') - The next move is a prime move
  if (turns.length() > 0 && turns.charAt(0) == '\'') {
    // Rotation - anticlockwise
    clockwise = false;
    // Subtract the 'prime' from the turns String
    turns = turns.substring(1, turns.length());
    // If there are 4 more chars in turns
    if (turns.length() >= 4) {      
      // If the next two turns are both opposites of the rotation move we have
      if (turns.substring(0, 4).equals( "" + turn  + "'" + turn + "'")) {
        // Three moves replaced with a clockwise version of the move
        clockwise = true;
        // Turns subtracts the 4 chars.
        turns = turns.substring(4, turns.length());
      }
    }
  } else {
    // If there are 2 or more chars left in turns String
    if (turns.length() >= 2) {
      // If the next two turns are the same as 'turn' then replace turn with prime version (replaces 3 clockwise rotations)
      if (turns.charAt(0) == turn && turns.charAt(1) == turn) {
        // dir = -1;
        clockwise = false;
        // turns subtracts 2 chars
        turns = turns.substring(2, turns.length());
      }
    }
  }
  // Add turn to fMoves arraylist - to print move to console/screen
  if(clockwise) fMoves.add(turn + "");
  if(!clockwise) fMoves.add(turn + "\'");

  switch(turn) {
  case 'R':
    if (clockwise) {
      // print("Added R to sequence\n");
      cube.turn('X', 1, 1);
    } else {
      // print("Added R' to sequence\n");
      cube.turn('X', 1, -1);
    }
    break;
  case 'L':
    if (clockwise) {
      // print("Added L to sequence\n");
      cube.turn('X', -1, 1);
    } else {
      // print("Added L' to sequence\n");
      cube.turn('X', -1, -1);
    }
    break;
  case 'U':
    if (clockwise) {
      // print("Added U to sequence\n");
      cube.turn('Y', -1, 1);
    } else {
      // print("Added U' to sequence\n");
      cube.turn('Y', -1, -1);
    }
    break;
  case 'D':
    if (clockwise) {
      // print("Added D to sequence\n");
      cube.turn('Y', 1, -1);
    } else {
      // print("Added D' to sequence\n");
      cube.turn('Y', 1, 1);
    }
    break;
  case 'F':
    if (clockwise) {
      // print("Added F to sequence\n");
      cube.turn('Z', 1, 1);
    } else {
      // print("Added F' to sequence\n");
      cube.turn('Z', 1, -1);
    }
    break;
  case 'B':
    if (clockwise) {
      // print("Added B to sequence\n");
      cube.turn('Z', -1, 1);
    } else {
      // print("Added B' to sequence\n");
      cube.turn('Z', -1, -1);
    }
    break;
  case 'X':
    if (clockwise) {
      // print("Added X to sequence\n");
      cube.turnWholeCube('X', 1);
    } else {
      // print("Added X' to sequence\n");
      cube.turnWholeCube('X', -1);
    }
    break;
  case 'Y':
    if (clockwise) {
      // print("Added Y to sequence\n");
      cube.turnWholeCube('Y', 1);
    } else {
      // print("Added Y' to sequence\n");
      cube.turnWholeCube('Y', -1);
    }
    break;
  case 'Z':
    if (clockwise) {
      // print("Added Z to sequence\n");
      cube.turnWholeCube('Z', 1);
    } else {
      // print("Added Z' to sequence\n");
      cube.turnWholeCube('Z', -1);
    }
    break;
  }
}

// resets the cube to original state
void resetCube() {
  setup();
}

void printScrambleInfo() {
  // Prints moves for any cube < 4x4x4 due to lack of notation
  if (dim <= 3) {
    if (scramble) {
      scramble = false;
      print(numberOfMoves + " moves were taken to scramble the cube " + "\n" + moves + "\n");
    } else if (reverse) {
      reverse = false;
      print(numberOfMoves + " moves were taken to solve the cube " + "\n" + moves + "\n");
    }
  }
}

// initialises all possible moves of cube 
// (caters for various cube sizes - scramble can use all possible moves)
void InitialiseMoves() {
  // clear moves arraylist to avoid generating the same moves if cube is reset
  // println("Initialising Moves");
  allMoves.clear();
  for (float i = -axis; i <= axis; i++) {
    if (i != 0) {
      // assigns all x axis movements (R, L)
      allMoves.add(new Move('X', i, 2));   // R2  L2
      allMoves.add(new Move('X', i, 1));   // R   L
      allMoves.add(new Move('X', i, -1));  // R'  L'

      // assigns all y axis movements (U, D)
      allMoves.add(new Move('Y', i, 2));   // U2  D2
      allMoves.add(new Move('Y', i, 1));  // U   D
      allMoves.add(new Move('Y', i, -1));  // U'  D'

      // assigns all z axis movements (F, B)
      allMoves.add(new Move('Z', i, 2));   // F2  B2
      allMoves.add(new Move('Z', i, 1));   // F   B
      allMoves.add(new Move('Z', i, -1));  // F'  B'
    }
  }
  allMoves.add(new Move('X', 1));
  allMoves.add(new Move('X', -1));
  allMoves.add(new Move('Y', 1));
  allMoves.add(new Move('Y', -1));
  allMoves.add(new Move('Z', 1));
  allMoves.add(new Move('Z', -1));
  // debugMoves();
}

long fact(int num) {
        long result = 1;

        for (int factor = 2; factor <= num; factor++) {
            result *= factor;
        }

        return result;
}

String getMoves() {
  return moves;
}

void checkColours() {
  color[] colours = new color[6*dim*dim*dim];
  int pColours = dim*dim;
  int red = 0;
  int orange = 0;
  int white = 0;
  int yellow = 0;
  int blue = 0;
  int green = 0;
  int index = 0;

  for(int j = 0; j < cube.len; j++) {
    for(int i = 0; i < cube.getCubie(j).colours.length; i++) {
      colours[index] = cube.getCubie(j).colours[i];
      index++;
    }
  }
  for (color c : colours) {
    red += c == cube.getCubie(0).red ? 1 : 0;
    orange += c == cube.getCubie(0).orange ? 1 : 0;
    white += c == cube.getCubie(0).white ? 1 : 0;
    yellow += c == cube.getCubie(0).yellow ? 1 : 0;
    blue += c == cube.getCubie(0).blue ? 1 : 0;
    green += c == cube.getCubie(0).green ? 1 : 0;
  }
  if(red > pColours || red < pColours)  {
    paused = true;
    println("Error occured: ");
    println(red + " reds");
  }
  if(orange > pColours || orange < pColours)  {
    paused = true;
    println("Error occured: ");
    println(orange + " oranges");
  }
  if(white > pColours || white < pColours)  {
    paused = true;
    println("Error occured: ");
    println(white + " whites");
  }
  if(yellow > pColours || yellow < pColours)  {
    paused = true;
    println("Error occured: ");
    println(yellow + " yellows");
  }
  if(blue > pColours || blue < pColours)  {
    paused = true;
    println("Error occured: ");
    println(blue + " blues");
  }
  if(green > pColours || green < pColours)  {
    paused = true;
    println("Error occured: ");
    println(green + " greens");
  }
}

void formatMoves()  {

  int counter = 1;

  for(int i = 0; i < fMoves.size(); i++)  {

    if(counter % 10 == 0) {
      moves += fMoves.get(i) + ",\n";
      // print(fMoves.get(i) + ",\n");
    } else if(counter == fMoves.size()) {
      moves += fMoves.get(i) + ".\n";
      // print(fMoves.get(i) + ".\n");
    } else {
      moves += fMoves.get(i) + ", ";
      // print(fMoves.get(i) + ", ");
    }
    counter++;
  }
  fMoves.clear();
}

void clearMoves() {
  moves = "";
  //eachMove.clear();
}

void clearSequence() {
  sequence.clear();
}

void debugMoves() {
  println("Generating Moves...");
  for(Move m : allMoves)  {
    println("Move: " + m.toString() + "\t" + m.currentAxis + "  " + m.index + "  " + m.dir);
  }
  println("Number of moves: " + allMoves.size());
}

void updateLists()  {
  for(int i = 0; i < cube.len; i++) {
    Cubie c = cube.getCubie(i);
    if(c.nCols == 1 && !centers.contains(c))  {
      centers.add(c);
    }
    if(c.nCols == 2 && !edges.contains(c))  {
      edges.add(c);
    }
    if(c.nCols == 3 && !corners.contains(c))  {
      corners.add(c);
    }
  }
}
