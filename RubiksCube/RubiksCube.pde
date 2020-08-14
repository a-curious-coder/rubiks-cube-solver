import peasy.*;

PeasyCam cam;

int c = 1;
// Dimensions of the cube
int dim = 25;
int counter = 0;
// The more complex the cube, the more moves required to scramble it.
int numberOfMoves = dim * 10;

// represents each edge of the cube for each size
float axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
float speed = 0.1;

String moves = "";

boolean scramble;
boolean reverse;

/* States number of cubies to be held by cube
/* Hoping to optimise this in future so hidden cubies aren't stored nor drawn
/* Saving computing power */
Cubie[] cube = new Cubie[(int)pow(dim, 3)];

Move currentMove;
ArrayList<Move> sequence = new ArrayList<Move>();
ArrayList<Move> allMoves = new ArrayList<Move>();
//Button scrambleButton;


// initialises rubik's cube emulation
void setup() {
  size(600, 600, P3D);
  //fullScreen(P3D);

  smooth(8);
  scramble = false;
  reverse = false;
  cam = new PeasyCam(this, 100 * (dim));
  // Removing Min/Max distance for zoom as it obstructs the view of larger cubes.
  //cam.setMinimumDistance(200); // max zoom out
  //cam.setMaximumDistance(displayWidth); // max zoom in

  int index = 0;

  for (float x = -axis; x <= axis; x++) {
    for (float y = -axis; y <= axis; y++) {
      for (float z = -axis; z <= axis; z++) {
        PMatrix3D matrix = new PMatrix3D();
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z);
        index++;
      }
    }
  }
  if(dim > 1)  {
    InitialiseMoves();
    setupScramble();
  }
  currentMove = new Move (0, 0, 0, 0);
}

// draws emulation to screen
void draw() {
  background(51);

  // Sets the initial view of the cube
  rotateX(-0.3);
  rotateY(0.6);

  // updates moves on the screen
  currentMove.update();
  if (currentMove.finished()) {
    // Prints moves for any cube less than 4x4x4 due to lack of notation
    if (dim <= 3) {
      if (scramble) {
        scramble = false;
        print(numberOfMoves + " moves were taken to scramble the cube " + "\n" + moves + "\n");
      } else if (reverse) {
        reverse = false;
        print(numberOfMoves + " moves were taken to solve the cube " + "\n" + moves + "\n");
      }
    }

    if (counter < sequence.size()-1) {
      counter++;
      currentMove = sequence.get(counter);
      currentMove.start();
    }
  }

  scale(50);

  rotateFace(currentMove);

  // creates a HUD which contains relevant information
  cam.beginHUD();
    fill(255);
    rect(20, 10, 30, 30, 30);
    fill(0);
    text(counter, 30, 30);
    fill(255);
    textSize(14);
    if (!scramble)
      text(getMoves(), 50, 50);
  cam.endHUD();
}

// scrambles the cube 
void setupScramble() {
  scramble = true;
  sequence.clear();
  clearMoves();
  counter = 0;

  for (int i = 0; i < numberOfMoves; i++) {
    int r = int(random(allMoves.size()));
    Move m = allMoves.get(r);
    if (dim <= 3)
      m.moveToString();
    sequence.add(m);
  }

  print("Scramble prepared\n");

  currentMove = sequence.get(counter);
}

// reverses all moves - illusion of a solve from scramble state
void reverseScramble() {

  ArrayList<Move> reverseSequence = new ArrayList<Move>();
  clearMoves();
  counter = 0;

  // If cube has not been scrambled, return.
  if (sequence.size() == 0) {
    return;
  }

  // store all sequence elements to reverseSequence
  for (int i = 0; i < sequence.size(); i++) {
    reverseSequence.add(sequence.get(i));
  }

  sequence.clear();

  for (int i = reverseSequence.size()-1; i >= 0; i--) {
    Move m = reverseSequence.get(i).copy();
    m.reverse();
    if (dim <= 3)
      m.moveToString();
    sequence.add(m);
  }

  if (moves != "")
    print(numberOfMoves + " moves were taken to solve the cube " + "\n" + moves);
  else
    print("Solving cube...");
    
  // reset currentMove to index 0 of new sequence and start sequence of moves
  currentMove = sequence.get(counter);
  currentMove.start();
}

// resets the cube to original state
void resetCube() {
  this.counter = 0;
  clearMoves();
  clearSequence();
  setup();
}

// initialises all possible moves of cube (caters for various cube sizes - scramble can use all possible moves)
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

// rotates a face determined by parameter
void rotateFace(Move m) {
  for (int i = 0; i < cube.length; i++) {
    push();
    if (abs(cube[i].z) > 0 && cube[i].z == m.z) {
      rotateZ(m.angle);
    } else if (abs(cube[i].x) > 0 && cube[i].x == m.x) {
      rotateX(m.angle);
    } else if (abs(cube[i].y) > 0 && cube[i].y == m.y) {
      rotateY(-m.angle);
      //print("cube.y\t" + cube[i].y + "\n");
      //print("move is rotating...\n");
    }   
    cube[i].show();
    pop();
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
