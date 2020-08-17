import peasy.*;

PeasyCam cam;

// Dimensions of the cube
int dim = 25;
int counter = 0;

// The more complex the cube, the more moves required to scramble it.
int numberOfMoves = dim * 5;
// represents each edge of the cube for each size
float axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
float speed = 0.5;

String moves = "";

boolean scramble;
boolean reverse;
boolean bool = false;

// Now only holds the least amount of cubies for the cube size.
Cubie[] cube;

Move currentMove;
ArrayList<Move> sequence = new ArrayList<Move>();
ArrayList<Move> allMoves = new ArrayList<Move>();

// initialises rubik's cube emulation
void setup() {
  size(800, 800, P3D);
  //fullScreen(P3D);
  frameRate(60);
  setupCamera();

  smooth(8);
  scramble = false;
  reverse = false;
  cam = new PeasyCam(this, 100 * (dim));

  int index = 0;
  //cube = new Cubie[(int)pow(dim, 3)];
  cube = new Cubie[(int)(pow(dim, 3) - pow(dim-2, 3))];
  //for (float x = -axis; x <= axis; x++) {
  //  for (float y = -axis; y <= axis; y++) {
  //    for (float z = -axis; z <= axis; z++) {
  //      PMatrix3D matrix = new PMatrix3D();
  //      matrix.translate(x, y, z);
  //      cube[index] = new Cubie(matrix, x, y, z);
  //      index++;
  //    }
  //  }
  //}
  // Need to use 0 to dim for if statement that checks whether to store each cubie.
  // Inner cubies aren't stored.
  for (float x = 0; x < dim; x++) {
    for (float y = 0; y < dim; y++) {
      for (float z = 0; z < dim; z++) {
        if (x > 0 && x < dim - 1 && 
          y > 0 && y < dim - 1 && 
          z > 0 && z < dim - 1) continue;
        PMatrix3D matrix = new PMatrix3D();
        // translates all cubies to center by subtracting axis from x, y, z
        matrix.translate(x-axis, y-axis, z-axis);
        cube[index] = new Cubie(matrix, x-axis, y-axis, z-axis);
        index++;
      }
    }
  }

  if (dim > 1)
    InitialiseMoves();

  currentMove = new Move (0, 0, 0, 0);
}

// draws emulation to screen
void draw() {
  background(51);
  // Sets the initial view of the cube
  rotateX(-0.3);
  rotateY(0.6);

  updateCam();

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
    if ( counter == sequence.size() -1 )
      counter++;
    if (counter < sequence.size()-1) {
      //counter = currentMove.dir == 2 ? counter+2 : counter + 1;
      counter++;
      currentMove = sequence.get(counter);
      currentMove.start();
    }
  }


  scale(50);

  rotateFace(currentMove);

  // creates a HUD which contains relevant information
  cam.beginHUD();
  String ctr = "Moves:\t" + str(counter);
  String fps = nf(frameRate, 1, 1);
  float tSize = 12;
  textSize(tSize);
  fill(255);
  //rect(20, 10, 30, 30, 30);
  // x, y, width, height
  text(ctr, 20, 20);
  text("FPS:\t" + fps, 20, 20 + tSize);
  text("Speed:\t" + speed, 20, 20+20+tSize);
  text("Cube:\t" + dim + "x" + dim + "x" + dim, 20, 20+20+20+tSize);
  fill(255);
  textSize(14);
  if (!scramble)
    text(getMoves(), 50, 50);
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
