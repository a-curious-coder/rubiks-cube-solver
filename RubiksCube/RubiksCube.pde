import peasy.*;

PeasyCam cam;

// Cube object
Cube cube;
Cubie[] edges;
// Stores the currentMove in the scramble/solve process
Move currentMove;
// Dimensions of the cube
int dim = 3;
// Responsible for counting number of moves made in scramble and solve.
int counter = 0;
// The more complex the cube, the more moves required to scramble it.
int numberOfMoves = dim * 5;
// represents each edge of the cube for each size
float middle = dim / 2;
// axis is the width/height/thickness of a cubie.
// Mainly represents the rows/columns of a cube
float axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
float speed = 0.08;
// Stores moves to print to screen.
String moves = "";
// Used to store moves in the solving function in HumanAlgorithm
String turns = "";
// Pausing boolean - enables me to pause the cube's operations.
boolean paused = false;
// Is the cube scrambling boolean
boolean scramble;
// Is the cube solved boolean
boolean solve;
// Is the cube reversing scramble
boolean reverse;
// sequence stores the moves to scramble and reverse the cube's scramble
ArrayList<Move> sequence = new ArrayList<Move>();
// allMoves stores all possible moves for any cube size
ArrayList<Move> allMoves = new ArrayList<Move>();


// initialises rubik's cube emulation
void setup() {
  // Screen size
  size(1200,1200, P3D);
  // fullScreen(P3D);
  // FPS
  frameRate(120);
  // Sets camera up (caters for larger cubes)
  setupCamera();
  scramble = false;
  solve = false;
  reverse = false;
  cam = new PeasyCam(this, 100 * (dim));
  cube = new Cube();
  smooth(8);

  if (dim == 3) {
    int n = 0;
    edges = new Cubie[12];
    for (int i = 0; i < cube.len; i++) {
      Cubie qb = cube.getCubie(i);
      if (qb.nCols == 2) {
        edges[n] = qb;
        n++;
      }
    }
  }

  if (dim > 1)  InitialiseMoves();
  currentMove = new Move('X', 0, 0);
}

// draws emulation to screen
void draw() {
  background(220,220,220);
  // Sets the initial view of the cube
  rotateX(-0.3);
  rotateY(0.6);
  
  updateCam();
  // If boolean paused is false
  if (!paused)  {
    // If currentMove is finished
    if (!cube.animating) {
      // print sequence of moves to console
      printScrambleInfo();
      // counter is equal to sequence size - 1 then iterate final counter number
      if(counter == sequence.size()-1)  {
        counter++;
        cube.animating = false;
      }
      
      // if counter is less than number of sequence of moves
      if (counter < sequence.size() - 1) {
        // iterate counter value
        counter++;
        // currentMove becomes next move in the sequence
        currentMove = sequence.get(counter);
        // start move
        if(currentMove.index > axis)  {
          cube.turnWholeCube(currentMove.currentAxis, currentMove.dir);
        } else {
          cube.turn(currentMove.currentAxis, currentMove.index, currentMove.dir);
        }
      }
    }
    // Updates rotationAngle for cube
    cube.update();
  }
  // Scales size of cube up so user can see it
  scale(50);
  // Calculates each cubie position / rotation - Shows each cubie in cube
  cube.show();
  
  // If cube is not turning and there are turns to be done
  if (!cube.animating && turns.length() > 0) {
    // if scramble is done / false
    if (!scramble) {
      // Make first move.
      if (sequence.size() > 0) sequence.clear();
      while (turns.length() != 0) {doTurn();}
      // for (int i = 0; i < sequence.size(); i++) {
      //   print(sequence.get(i).moveToString());
      // }
    }
  }
  // creates a HUD which contains relevant information
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
    nCombinations = dim > 2 ? ((0.5) * (fact(8) * pow(3, 7)) * fact((dim*dim*dim) - 15) * pow(2, (dim*dim*dim)-16)) : nCombinations;
    text("Total number of combinations:\t" + nf(nCombinations, 1, 0), x, y);
    y += 20;
    text(getMoves(), x, y);
  cam.endHUD();
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
  print("\n---- turnFace ----\n");
  print("\n" + turns.length() + " chars in turns left.\t"+ turns +"\n");
  // turn becomes the first move of turns String
  char turn = turns.charAt(0);
  // Rest of turns are stored back in turns
  turns = turns.substring(1, turns.length());
  // Clockwise rotation default true
  // int dir = 1;
  boolean clockwise = true;
  // If there are turns left and the new first char is a prime (')
  if (turns.length() > 0 && turns.charAt(0) == '\'') {
    // Rotation will not be clockwise
    // dir = -1;
    clockwise = false;
    // Subtract the prime from the turns String
    turns = turns.substring(1, turns.length());
    // If there are 4 more chars in turns
    if (turns.length() >= 4) {      
      //  If the next turns are both opposite of rotations of turn prime
      if (turns.substring(0, 4).equals( "" + turn  + "'" + turn + "'")) {
        // dir = 1;
        clockwise = true;
        // Turns subtracts the 4 chars.
        turns = turns.substring(4, turns.length());
      }
    }
  } else {
    // If there are 2 or more chars left in turns String
    if (turns.length() >= 2) {
      // If the first and second chars in turns is the same as turn
      if (turns.charAt(0) == turn && turns.charAt(1) == turn) {
        // dir = -1;
        clockwise = false;
        // turns subtracts 2 chars
        turns = turns.substring(2, turns.length());
      }
    }
  }

  // if turn is right, down or a front face rotation
  if (turn == 'R' || turn =='D' || turn == 'F') {
    // reverse clockwise boolean
    // dir *= -1;
    clockwise = !clockwise;
  }
  switch(turn) {
  case 'R':
    if (clockwise) {
      print("Added R to sequence\n");
      cube.turn('X', 1, 1);
    } else {
      print("Added R' to sequence\n");
      cube.turn('X', 1, -1);
    }
    break;
  case 'L':
    if (clockwise) {
      print("Added L to sequence\n");
      cube.turn('X', -1, 1);
    } else {
      print("Added L' to sequence\n");
      cube.turn('X', -1, -1);
    }
    break;
  case 'U':
    if (clockwise) {
      print("Added U to sequence\n");
      cube.turn('Y', -1, 1);
    } else {
      print("Added U' to sequence\n");
      cube.turn('Y', -1, -1);
    }
    break;
  case 'D':
    if (clockwise) {
      print("Added D to sequence\n");
      cube.turn('Y', 1, 1);
    } else {
      print("Added D' to sequence\n");
      cube.turn('Y', 1, -1);
    }
    break;
  case 'F':
    if (clockwise) {
      print("Added F to sequence\n");
      cube.turn('Z', 1, 1);
    } else {
      print("Added F' to sequence\n");
      cube.turn('Z', 1, -1);
    }
    break;
  case 'B':
    if (clockwise) {
      print("Added B to sequence\n");
      cube.turn('Z', -1, 1);
    } else {
      print("Added B' to sequence\n");
      cube.turn('Z', -1, -1);
    }
    break;
  case 'X':
    if (clockwise) {
      print("Added X to sequence\n");
      cube.turnWholeCube('X', 1);
    } else {
      print("Added X' to sequence\n");
      cube.turnWholeCube('X', -1);
    }
    break;
  case 'Y':
    if (clockwise) {
      print("Added Y to sequence\n");
      cube.turnWholeCube('Y', 1);
    } else {
      print("Added Y' to sequence\n");
      cube.turnWholeCube('Y', -1);
    }
    break;
  case 'Z':
    if (clockwise) {
      print("Added Z to sequence\n");
      cube.turnWholeCube('Z', 1);
    } else {
      print("Added Z' to sequence\n");
      cube.turnWholeCube('Z', -1);
    }
    break;
  }
  cube.animating = !cube.animating;
}

// resets the cube to original state
void resetCube() {
  cube = new Cube();
  sequence.clear();
  counter = 0;
  moves = "";
  // setup();
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
  println("Initialising Moves");
  allMoves.clear();
  for (float i = -axis; i <= axis; i++) {
    if (i != 0) {
      // assigns all x axis movements (R, L)
      // allMoves.add(new Move('X', i, 2));   // R2  L2
      allMoves.add(new Move('X', i, 1));   // R   L
      allMoves.add(new Move('X', i, -1));  // R'  L'

      // assigns all y axis movements (U, D)
      // allMoves.add(new Move('Y', i, 2));   // U2  D2
      allMoves.add(new Move('Y', i, 1));  // U   D
      allMoves.add(new Move('Y', i, -1));  // U'  D'

      // assigns all z axis movements (F, B)
      // allMoves.add(new Move('Z', i, 2));   // F2  B2
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

int fact(int num) {
  return num == 1? 1 : fact(num - 1)*num;
}

String getMoves() {
  return moves;
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
    println("Move: " + m.moveToString() + "\t" + m.currentAxis + "  " + m.index + "  " + m.dir);
  }
  println("Number of moves: " + allMoves.size());
}
