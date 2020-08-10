import peasy.*;

PeasyCam cam;

int displayWidth = 600, displayHeight = 600;
int numberOfMoves;
int lNumberOfMoves = 10; // Lowest number of moves
int mNumberOfMoves = 20; // Maximum number of moves
String moves = "";

int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

Move[] allMoves = new Move[] {
  new Move(0, 1, 0, 1), // Index  0 = D
  new Move(0, 1, 0, -1), // Index  1 = d
  new Move(0, -1, 0, 1), // Index  2 = U
  new Move(0, -1, 0, -1), // Index  3 = u
  new Move(1, 0, 0, 1), // Index  4 = R
  new Move(1, 0, 0, -1), // Index  5 = r
  new Move(-1, 0, 0, 1), // Index  6 = L
  new Move(-1, 0, 0, -1), // Index  7 = l
  new Move(0, 0, 1, 1), // Index  8 = F
  new Move(0, 0, 1, -1), // Index  9 = f
  new Move(0, 0, -1, 1), // Index  10 = B
  new Move(0, 0, -1, -1)   // Index  11 = b
};

String[] listOfMoves = {"D", "D\'", "U", "U\'", "R", "R\'", "L", "L\'", "F", "F\'", "B", "B\'"};
ArrayList<Move> sequence = new ArrayList<Move>();
int counter = 0;

Move thisMove;
Move currentMove = new Move (0, 0, 0, 0);
Button scrambleButton;

// initialises rubik's cube emulation
void setup() {
  size(displayWidth, displayHeight, P3D);
  //fullScreen(P3D);
  smooth(8);
  cam = new PeasyCam(this, 400);
  cam.setMinimumDistance(200); // max zoom out
  cam.setMaximumDistance(1000); // max zoom in

  int index = 0;
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      for (int z = -1; z <= 1; z++) {
        PMatrix3D matrix = new PMatrix3D();
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z);
        index++;
      }
    }
  }
}

// scrambles the cube 
void scrambleCube() {
  int n = 1;
  numberOfMoves = int(random(lNumberOfMoves, mNumberOfMoves));
  sequence.clear();
  counter = 0;

  for (int i = 0; i < numberOfMoves; i++) {
    int r = int(random(allMoves.length));
    Move m = allMoves[r];
    sequence.add(m);

    if (i == numberOfMoves -1) {
      moves+= listOfMoves[r] + ". \n";
    } else if (n % 10 == 0) {
      moves += listOfMoves[r] + " \n";
    } else {
      moves += listOfMoves[r] + " ";
    }

    n++;
  }
  print(numberOfMoves + " moves were taken to scramble the cube " + "\n" + getMoves());
  currentMove = sequence.get(counter);
}

// reverses all moves - illusion of a solve from scramble
void reverseScramble() {
  
  int n = 0;
  int c = 1;
  ArrayList<Move> reverseSequence = new ArrayList<Move>();
  counter = 0;
  clearMoves();
  
  if (sequence.size() == 0) {
    return;
  }
  
  //print("Original moves\n" + moves);

  // store all sequence elements to reverseSequence
  for (int i = 0; i < sequence.size(); i++) {
    reverseSequence.add(sequence.get(i));
  }

  sequence.clear();

  for (int i = reverseSequence.size()-1; i >= 0; i--) {
    Move nextMove = reverseSequence.get(i).copy();
    nextMove.reverse();
    sequence.add(nextMove);
    
    if (i == 0) {
      moves += convertMoveToString(sequence.get(n)) + ".\n";
    } else if (c % 10 == 0) {
      moves += convertMoveToString(sequence.get(n)) + " \n";
    } else {
      moves += convertMoveToString(sequence.get(n)) + " ";
    }

    c++;
    n++;
  }

  //print("\nReversed moves \n" + moves + "\n");
  // reset currentMove to first index of new sequence and start sequence of moves
  currentMove = sequence.get(counter);
  currentMove.start();
}

// resets the cube to original state
void resetScramble() {
  this.counter = 0;
  clearMoves();
  clearSequence();
  setup();
}

// converts move object to interpretable string 
String convertMoveToString(Move m) {

  for (int i = 0; i < allMoves.length; i++) {
    // compares all parameters of m with parameters of all moves
    if (m.x == allMoves[i].x &&
      m.y == allMoves[i].y &&
      m.z == allMoves[i].z &&
      m.dir == allMoves[i].dir) {

      String move = listOfMoves[i];

      return move;
    }
  }

  return null;
}

// draws emulation to screen
void draw() {
  background(51);
  
  // Sets the initial view of the cube
  rotateX(-0.3);
  rotateY(0.6);
  //rotateZ(0);

  // updates moves on the screen
  currentMove.update();
  if (currentMove.finished()) {
    if (counter == sequence.size()-1) {
      counter++;
    }
    if (counter < sequence.size()-1) {
      counter++;
      currentMove = sequence.get(counter);
      currentMove.start();
    }
  }
  
  scale(50);
  
  // 
  for (int i = 0; i < cube.length; i++) {
    push();
    if (abs(cube[i].z) > 0 && cube[i].z == currentMove.z) {
      rotateZ(currentMove.angle);
    } else if (abs(cube[i].x) > 0 && cube[i].x == currentMove.x) {
      rotateX(currentMove.angle);
    } else if (abs(cube[i].y) > 0 && cube[i].y ==currentMove.y) {
      rotateY(-currentMove.angle);
    }   
    cube[i].show();
    pop();
  }

  // creates a HUD which contains relevant information
  cam.beginHUD();
  fill(255);
  textSize(32);
  text(counter, 100, 100);
  textSize(14);
  text(getMoves(), 50, 50);
  cam.endHUD();
}

String getMoves() {
  return moves;
}

void clearMoves() {
  moves = "";
}

void clearSequence() {
  sequence.clear();
}
