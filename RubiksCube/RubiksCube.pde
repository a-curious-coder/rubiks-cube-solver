import peasy.*;

PeasyCam cam;

int displayWidth = 600, displayHeight = 600;
int numberOfMoves;
String moves = "";
int lNumberOfMoves = 5; // Lowest number of moves
int mNumberOfMoves = 10; // Maximum number of moves

float speed = 0.05;
int dim = 3;
Cubie[] cube = new Cubie[dim*dim*dim];

  // Order of moves:  U, u, D, d, R, r, L, l, F, f, B, b
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
String[] listOfMoves = {"U", "u", "D", "d", "R", "r", "L", "l", "F", "f", "B", "b"};

ArrayList<Move> sequence = new ArrayList<Move>();
int counter = 0;


Move currentMove;
Button scrambleButton;

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
  // initialises cube.
  scrambleCube();
  //scrambleButton = new Button(displayWidth/10, displayHeight/10, 100, 50, "Scramble cube", 0, 200, 200);
}

// Scrambles the cube.
void scrambleCube() {
  resetScramble();
  int n = 1;
  
  for (int i = 0; i < numberOfMoves; i++) {
    int r = int(random(allMoves.length));
    Move m = allMoves[r];
    sequence.add(m);
    
    if(i == numberOfMoves -1)  {
      moves+= listOfMoves[r] + ". \n";
    }  else if (n % 10 == 0)  {
      moves += listOfMoves[r] + ", \n";
    }  else  {
      moves += listOfMoves[r] + ", ";
    }
    n++;
  }
  
  print("Number of moves required to scramble cube: " + numberOfMoves + "\n" + getMoves());
  currentMove = sequence.get(counter);
}
  // Reverses all moves - illusion of a solve from scramble
  //for (int i = sequence.size()-1; i >= 0; i--) {
  //  Move nextMove = sequence.get(i).copy();
  //  nextMove.reverse();
  //  sequence.add(nextMove);
  //}

  //currentMove.start();

void resetScramble()  {
  this.counter = 0;
  this.moves = "";
  this.numberOfMoves = int(random(lNumberOfMoves, mNumberOfMoves));
}
String getMoves() {
  return moves;
}


void draw() {
  background(51);

  // HUD to hold buttons/text
  cam.beginHUD();
  fill(255);
  textSize(32);
  text(counter, 100, 100);
  textSize(8);
  text(getMoves(), 50, 50);
  cam.endHUD();

  rotateX(-0.6);
  rotateY(-0.8);
  //rotateZ(-0.85);



  currentMove.update();
  if (currentMove.finished()) {
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
  //printMoves();
}
