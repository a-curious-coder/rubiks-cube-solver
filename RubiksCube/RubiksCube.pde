import peasy.*;

PeasyCam cam;

// Cube object
Cube cube;
Cubie[] edges;
// Stores the currentMove in the scramble/solve process
Move currentMove;

float rotationAngle = 0;
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
float speed = 0.01;
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
  size(800, 800, P3D);
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
  currentMove = new Move (0, 0, 0, 0);
}

// draws emulation to screen
void draw() {
  background(51);
  // Sets the initial view of the cube
  rotateX(-0.3);
  rotateY(0.6);
  
  updateCam();
  // If boolean paused is false
  if (!paused)
    // updates moves on the screen
    currentMove.update();
  // If currentMove is finished
  if (currentMove.finished()) {
    // print sequence of moves to console
    printScrambleInfo();
    // counter is equal to sequence size - 1 then
    if (counter == sequence.size() - 1) {
      // Iterate final counter number
      counter++;
      // if scramble is false, reset currentMove to nothing.
      currentMove = !scramble ? new Move(0, 0, 0, 0) : currentMove;
    }
    // if counter is less than number of sequence of moves
    if (counter < sequence.size() - 1) {
      // iterate counter value
      counter++;
      // currentMove becomes next move in the sequence
      currentMove = sequence.get(counter);
      // start move
      currentMove.start();
    }
  }
  // Scales size of cube up so user can see it
  scale(50);
  // Calculates each cubie position / rotation - Shows each cubie in cube
  cube.show(currentMove);
  // Updates rotationAngle for cube
  cube.update();
  // If cube is not turning and there are turns to be done
  if (!cube.turning && turns.length() > 0) {
    // if scramble is done / false
    if (!scramble) {
      // Make first move.
      if (sequence.size() > 0) sequence.clear();
      while (turns.length() != 0) {turnFace();}
      for (int i = 0; i < sequence.size(); i++) {print(sequence.get(i).moveToString());}
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
  fill(255);
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
  fill(255);
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

void turnFace() {
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
      sequence.add(new Move(1, 0, 0, 1));
    } else {
      print("Added R' to sequence\n");
      sequence.add(new Move(1, 0, 0, -1));
    }
    // sequence.add(new Move(1, 0, 0, dir));
    break;
  case 'L':
    if (clockwise) {
      print("Added L to sequence\n");
      this.sequence.add(new Move(-1, 0, 0, 1));
    } else {
      print("Added L' to sequence\n");
      this.sequence.add(new Move(-1, 0, 0, -1));
    }
    // cube.rotateSide(-1, 0, 0, dir);
    // currentMove = new Move(-1, 0, 0, dir);
    // currentMove.start();

    break;
  case 'U':
    if (clockwise) {
      print("Added U to sequence\n");
      this.sequence.add(new Move(0, -1, 0, 1));
    } else {
      print("Added U' to sequence\n");
      this.sequence.add(new Move(0, -1, 0, -1));
    }
    // currentMove = new Move(0, -1, 0, dir);
    // currentMove.start();
    // cube.rotateSide(0, -1, 0, dir);

    break;
  case 'D':
    // currentMove = new Move(0, 1, 0, dir);
    // currentMove.start();
    // cube.rotateSide(0, 1, 0, dir);
    sequence.add(new Move(0, 1, 0, 1));
    break;
  case 'F':
    // currentMove = new Move(0, 0, 1, dir);
    // currentMove.start();
    // cube.rotateSide(0, 0, 1, dir);
    sequence.add(new Move(0, 0, 1, 1));
    break;
  case 'B':
    // currentMove = new Move(0, 0, -1, dir);
    // currentMove.start();
    // cube.rotateSide(0, 0, -1, dir);
    sequence.add(new Move(0, 0, -1, 1));
    break;
    // Have yet to get a full cube rotation.
  case 'X':
    if (clockwise)
      print("Added X");
    else
      print("Added X' ");
    cube.rotateWholeCube('X', 1);
    break;
  case 'Y':
    if (clockwise)
      print("Added Y");
    else
      print("Added Y' ");
    cube.rotateWholeCube('Y', 1);
    break;
  case 'Z':
    if (clockwise)
      print("Added Z");
    else
      print("Added Z' ");
    cube.rotateWholeCube('Z', 1);
    break;
  }
  cube.turning = !cube.turning;
}

// resets the cube to original state
void resetCube() {
  Cube cube = new Cube();
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
  for (float i = -axis; i <= axis; i++) {
    if (i != 0) {
      // assigns all x axis movements (R, L)
      allMoves.add(new Move(i, 0, 0, 2));   // R2  L2
      allMoves.add(new Move(i, 0, 0, 1));   // R   L
      allMoves.add(new Move(i, 0, 0, -1));  // R'  L'

      // assigns all y axis movements (U, D)
      allMoves.add(new Move(0, i, 0, 2));   // U2  D2
      allMoves.add(new Move(0, i, 0, 1));   // U   D
      allMoves.add(new Move(0, i, 0, -1));  // U'  D'

      // assigns all z axis movements (F, B)
      allMoves.add(new Move(0, 0, i, 2));   // F2  B2
      allMoves.add(new Move(0, 0, i, 1));   // F   B
      allMoves.add(new Move(0, 0, i, -1));  // F'  B'
    }
  }
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
