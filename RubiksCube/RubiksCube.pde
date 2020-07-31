import peasy.*;

PeasyCam cam;

int displayWidth = 600, displayHeight = 600;
int numberOfMoves;
int lNumberOfMoves = 3; // Lowest number of moves
int mNumberOfMoves = 6; // Maximum number of moves
String moves = "";

float speed = 15;
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

// Order of moves:  D, d, U, u, R, r, L, l, F, f, B, b
// Moves indexes:   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
Move[] allMoves = new Move[] {
  new Move(0, 1, 0, 1), 
  new Move(0, 1, 0, -1), 
  new Move(0, -1, 0, 1), 
  new Move(0, -1, 0, -1), 
  new Move(1, 0, 0, 1), 
  new Move(1, 0, 0, -1), 
  new Move(-1, 0, 0, 1), 
  new Move(-1, 0, 0, -1), 
  new Move(0, 0, 1, 1), 
  new Move(0, 0, 1, -1), 
  new Move(0, 0, -1, 1), 
  new Move(0, 0, -1, -1)
};
String[] listOfMoves = {"D", "d", "U", "u", "R", "r", "L", "l", "F", "f", "B", "b"};
ArrayList<Move> sequence = new ArrayList<Move>();
ArrayList<Move> reverseSequence = new ArrayList<Move>();
int counter = 0;

Move currentMove;
Button scrambleButton;

/** sets up emulation **/
void setup() {
  //size(displayWidth, displayHeight, P3D);
  fullScreen(P3D);
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
  scrambleCube();
  //scrambleButton = new Button(displayWidth/10, displayHeight/10, 100, 50, "Scramble cube", 0, 200, 200);
}

/** scrambles the cube **/
void scrambleCube() {
  int n = 1;
  this.numberOfMoves = int(random(lNumberOfMoves, mNumberOfMoves));

  for (int i = 0; i < numberOfMoves; i++) {
    int r = int(random(allMoves.length));
    Move m = allMoves[r];
    sequence.add(m);

    if (i == numberOfMoves -1) {
      moves+= listOfMoves[r] + ". \n";
    } else if (n % 10 == 0) {
      moves += listOfMoves[r] + ", \n";
    } else {
      moves += listOfMoves[r] + ", ";
    }
    n++;
  }
  print("Number of moves required to scramble cube: " + numberOfMoves + "\n" + getMoves());
  currentMove = sequence.get(counter);
}

/** reverses all moves - illusion of a solve from scramble **/
void reverseScramble() {
  
  int n = 0;
  
  for (int f = 0; f < allMoves.length; f++) {
    if(f == sequence.size())
      break;
    if (sequence.get(f) == allMoves[f]) {
      moves += listOfMoves[f] + ", ";
    }
  }
  
  print("Original moves: " + moves + "sequence.size(): " + sequence.size());
  moves = "";
  print("Moves deleted: (nothing should appear) " + moves + "\n");
  
  for (int i = sequence.size()-1; i >= 0; i--) {
    Move nextMove = sequence.get(i);
    print("nextMove " + (n+1) + ": \"" + convertMoveToString(nextMove) + "\"\n");
    nextMove.reverse();
    
    reverseSequence.add(nextMove);
    print("reverseSequence index " + i + ": " + convertMoveToString(reverseSequence.get(reverseSequence.size() -1)) + "\n");
    moves += convertMoveToString(reverseSequence.get(n)) + ", ";
    n++;
  }
  print("Reversed moves: " + moves + "\n");  
  currentMove.start();
}

/** resets the cube to original state **/
void resetScramble() {
  this.counter = 0;
  this.moves = "";
  this.sequence.clear();
}

String convertMoveToString(Move m)  {
  String move = "";
  
  for(int i = 0; i < allMoves.length; i++)  {
    if(m == allMoves[i])  {
     move += listOfMoves[i] + ", ";
    }
  }
  
  return move;
}
/** draws emulation to screen **/
void draw() {
  background(51);

  //rotateX(-0.6);
  //rotateY(3.9);
  //rotateZ(-22);

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

  // HUD to hold buttons/text
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
