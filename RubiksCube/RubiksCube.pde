import peasy.*;

PeasyCam cam;
PGraphics pg;

int dim = 3, counter = 0;
int numberOfMoves = int(random(20, 50));
int displayWidth = 800, displayHeight = 800;
String sequence = "";
String[] allMoves = {"f", "b", "u", "d", "l", "r"};
Button scrambleButton;
// Cube object with x, y, z sizes of dim value
Cubie[] cube = new Cubie[dim*dim*dim];


void setup() {
  size(displayWidth, displayHeight, P3D);
  smooth(8);
  cam = new PeasyCam(this, 400);
  cam.setMinimumDistance(200);
  cam.setMaximumDistance(1000);
  
  int index = 0;
  for (int x = -1; x <= 1; x++) {
    for (int y = -1; y <= 1; y++) {
      for (int z = -1; z <= 1; z++) {
        PMatrix3D matrix= new PMatrix3D();
        matrix.translate(x, y, z);
        cube[index] = new Cubie(matrix, x, y, z);     
        index++;
      }
    }
  }
  // automatically scrambles cube upon setup
  //scrambleCube();
  scrambleButton = new Button(displayWidth/10, displayHeight/10, 100, 50, "Scramble cube", 0, 200, 200);
}

// Scrambles the cube.
void scrambleCube()  {
 for (int i = 1; i < numberOfMoves + 1; i++) {
    int r = int(random(allMoves.length));
    if (random(1) < 0.5) {
      this.sequence += allMoves[r] + ", ";
    } else {
      this.sequence += allMoves[r].toUpperCase() + ", ";
    }

    if (i % 10 == 0) {
      this.sequence += "\n";
    }
  }
  print("Number of moves required to scramble cube: " + numberOfMoves + "\n" + sequence); 
}

// Flips the move case. Represents if rotation is clockwise or anti-clockwise
String flipCase(char c) {
  String s = "" + c;
  if (s.equals(s.toLowerCase())) {
    return s.toUpperCase();
  } else {
    return s.toLowerCase();
  }
}

// Draws objects to screen
void draw() {
  background(51);
  push();
  // Shows moves on cube.
  if (counter < sequence.length()) {
    if (frameCount % 1 == 0) {
      char move = sequence.charAt(counter);
      applyMove(move);
      counter++;
    }
  }
  // Scales size of cubies 50*
  scale(50);
  
  // For every cube at index 'i', show it on the screen.
  for (int i = 0; i < cube.length; i++) {
    cube[i].show();
  }
  pop();
  // Separate HUD from camera.
  cam.beginHUD();
    if(scrambleButton.isClicked())
    {
      scrambleCube();
    }
    scrambleButton.update();
    scrambleButton.render();
    fill(-1);
    rectMode(CENTER);
    rect(displayWidth/2, displayHeight/10, 80, 100);
    textAlign(CENTER, CENTER);
    fill(0);
    text("Rubiks Cube Solver - zardoss©", displayWidth/2, displayHeight/10);
  cam.endHUD();
  
}
