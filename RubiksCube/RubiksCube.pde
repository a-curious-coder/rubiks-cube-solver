import peasy.*;

PeasyCam cam;
int displayWidth = 1280;
int displayHeight = 1400; 

int dim = 3;

int counter;
int moveCounter;
int numberOfMoves;
float middle;
float axis;
float speed;
String moves = "";
String turns = "";
boolean paused;
boolean scramble;
boolean solve;
boolean reverse;
boolean hud;
boolean counterReset;
boolean display2D;
ArrayList<Cubie> corners;
ArrayList<Cubie> edges;
ArrayList<Cubie> centers;
ArrayList<Move> sequence;
ArrayList<Move> allMoves;
ArrayList<String> fMoves;
ArrayList<Cubie> back = new ArrayList();
ArrayList<Cubie> front = new ArrayList();
ArrayList<Cubie> left = new ArrayList();
ArrayList<Cubie> right = new ArrayList();
ArrayList<Cubie> top = new ArrayList();
ArrayList<Cubie> down = new ArrayList();
PImage background;
Cube cube;
Move currentMove;

void setup() {
  size(displayWidth, displayHeight, P3D);
  // fullScreen(P3D);
  frameRate(60);
  setupCamera();
  // background = loadImage("C:\\Users\\callu\\Desktop\\Processing\\rubiks-cube-solver\\RubiksCube\\bg.png");
  // background.resize(displayHeight, displayWidth);
  counter = 0;
  moveCounter = 0;
  numberOfMoves = dim * 8;
  axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
  middle = axis + -axis;
  speed = 0.001;
  scramble = false;
  solve = false;
  reverse = false;
  paused = false;
  hud = false;
  counterReset = false;
  display2D = true;
  corners = new ArrayList<Cubie>();
  edges = new ArrayList<Cubie>();
  centers = new ArrayList<Cubie>();
  sequence = new ArrayList<Move>();
  allMoves = new ArrayList<Move>();
  fMoves = new ArrayList<String>();
  cube = new Cube();

  smooth(8);
  updateLists();
  if (dim > 1)  InitialiseMoves();
  currentMove = new Move('X', 0, 0);
}

void draw() {
  background(220,220,220);
  // background(background);

  rotateX(-0.3);
  rotateY(0.6);
  
  updateCam();
  if (!paused)  {
    checkColours();
    if (!cube.animating) {
      printScrambleInfo();
      if (counter <= sequence.size() - 1) {
        currentMove = sequence.get(counter);
        if(currentMove.index > axis)  {
          cube.turnWholeCube(currentMove.currentAxis, currentMove.dir);
        } else {
          cube.turn(currentMove.currentAxis, currentMove.index, currentMove.dir);
        }
        counter++;
      } 
      if(counter == sequence.size()-1)  {
        counterReset = true;
      }
    }
    if(solve) {
      if(turns.length() == 0 && !cube.animating)  {
        if(counterReset)  {
          counter = 0;
          counterReset = false;
        }
        cube.hAlgorithm.solveCube();
      }
    }
    cube.update();
  }
  scale(50);
  cube.show();
  
  if (!cube.animating && turns.length() > 0) {
    if (!scramble) {
      if (sequence.size() > 0) sequence.clear();
      if (turns.length() > 0) {
        doTurn();
      }
    }
  }
  if(cube.hAlgorithm.solved)  formatMoves();
  updateLists();

  // HUD - contains relevant information
  if(!hud)  {
    cam.beginHUD();
      String ctr = "Moves:\t" + str(counter);
      String fps = nf(frameRate, 1, 1);
      float tSize = 12;
      float x = 0;
      float y = tSize;
      textSize(tSize);
      fill(0);
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
      text(moves, x, displayHeight-y);
      if(display2D) twoDimensionalView(displayWidth * 0.75, displayHeight/20);
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
  char turn = turns.charAt(0);
  turns = turns.substring(1, turns.length());
  // boolean clockwise = true;
  int dir = 1;

  if (turns.length() > 0 && turns.charAt(0) == '\'') {
    // clockwise = false;
    dir = -1;
    turns = turns.substring(1, turns.length());
    if (turns.length() >= 4) {      
      if (turns.substring(0, 4).equals( "" + turn  + "'" + turn + "'")) {
        // clockwise = true;
        dir = 1;
        turns = turns.substring(4, turns.length());
      }
    }
  } else if(turns.length() > 0 && turns.charAt(0) == '2') {
    dir = 2;
    turns = turns.substring(1, turns.length());
  } else {
    if (turns.length() >= 2) {
      if (turns.charAt(0) == turn && turns.charAt(1) == turn) {
        // clockwise = false;
        dir = -1;
        turns = turns.substring(2, turns.length());
      }
    }
  }
  // if(clockwise) fMoves.add(turn + "");
  // if(!clockwise) fMoves.add(turn + "\'");
  if(dir == 1)  fMoves.add(turn + "");
  if(dir == -1) fMoves.add(turn + "\'");
  if(dir == 2) fMoves.add(turn + "2");

  switch(turn) {
  case 'R':
    cube.turn('X', 1, dir);
    break;
  case 'L':
      cube.turn('X', -1, dir);
    break;
  case 'U':
      cube.turn('Y', -1, dir);
    break;
  case 'D':
      cube.turn('Y', 1, dir);
    break;
  case 'F':
      cube.turn('Z', 1, dir);
    break;
  case 'B':
      cube.turn('Z', -1, dir);
    break;
  case 'X':
      cube.turnWholeCube('X', dir);
    break;
  case 'Y':
      cube.turnWholeCube('Y', dir);
    break;
  case 'Z':
      cube.turnWholeCube('Z', dir);
    break;
  }
  counter++;
}

void resetCube() {
  setup();
}

void printScrambleInfo() {
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
void InitialiseMoves() {
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
}

long fact(int num) {
        long result = 1;

        for (int factor = 2; factor <= num; factor++) {
            result *= factor;
        }

        return result;
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
  moveCounter = 1; 
  int lineLimit = 10;
  if(fMoves.size() > 100)  lineLimit = 15;
  for(int i = 0; i < fMoves.size(); i++)  {
    if(moveCounter % lineLimit == 0) {
      moves += fMoves.get(i) + "\n";
    } else if(moveCounter == fMoves.size() ) {
      moves += fMoves.get(i) + ".\n";
    } else {
      if(fMoves.get(i).length() == 2) moves += fMoves.get(i) + " ";
      if(fMoves.get(i).length() == 1) moves += fMoves.get(i) + "  ";
    }
    moveCounter++;
  }
  fMoves.clear();
}


void debugMoves() {
  println("Generating Moves...");
  for(Move m : allMoves)  {
    println("Move: " + m.toString() + "\t" + m.currentAxis + "  " + m.index + "  " + m.dir);
  }
  println("Number of moves: " + allMoves.size());
}

// Always updating positions of every cubie to their respective lists.
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

void twoDimensionalView(float x, float y) {
  int numberOfFaces = 6;
  int numOfColours = dim*dim*dim*numberOfFaces;
  fill(0);
  rect(x+10, y-50, 280, 210);

  resetLists();
  populateLists();
  fill(255);
  text("Right", x + 175, y-30);
  text("Back, Up, Front, Down", x + 150, y-10);
  text("Left", x + 180, y+ 10);
  drawSide(back, 5, x, y); // Back - 5
  x += 65;
  y += 65;
  drawSide(left, 1, x, y);// Left - 0
  y -= 65;
  drawSide(top, 2, x, y); // Top - 2
  y -= 65;
  drawSide(right, 0, x, y); // Right - 1
  x += 65;
  y += 65;
  drawSide(front, 4, x, y); // Front - 4
  x += 65;
  drawSide(down, 3, x, y); // Down - 3
}

void drawSide(ArrayList<Cubie> cubies, int face, float xPos, float yPos) {
  int cubieSize = 20;
  float radius = 5;
  float resetXPos = xPos;
  noStroke();

  for(int  i = 0; i < cubies.size(); i++) {
    fill(cubies.get(i).colours[face]);
    if(i % 3 == 0)  {
      xPos = resetXPos;
      yPos = yPos + (cubieSize+1);
    }
    xPos = xPos + (cubieSize+1);
    rect(xPos, yPos, cubieSize, cubieSize, radius, radius, radius, radius);
  }
}

void populateLists()  {
  ArrayList<Cubie> newBack = new ArrayList();
  ArrayList<Cubie> newFront = new ArrayList();
  ArrayList<Cubie> newLeft = new ArrayList();
  ArrayList<Cubie> newRight = new ArrayList();
  ArrayList<Cubie> newTop = new ArrayList();
  ArrayList<Cubie> newDown = new ArrayList();

  for(int i = 0; i < cube.len; i++) {
    Cubie c = cube.getCubie(i);
    if(c.z == -axis) newBack.add(c);
    if(c.z == axis) newFront.add(c);
    if(c.x == -axis) newLeft.add(c);
    if(c.x == axis) newRight.add(c);
    if(c.y == -axis) newTop.add(c);
    if(c.y == axis) newDown.add(c);
  }
  left = getOrderedList(newLeft, -1, 'X');
  right = getOrderedList(newRight, 1, 'X');
  top = getOrderedList(newTop, -1, 'Y');
  down = getOrderedList(newDown, 1, 'Y');
  front = getOrderedList(newFront, 1, 'Z');
  back = getOrderedList(newBack, -1, 'Z');
}

ArrayList<Cubie> getOrderedList(ArrayList<Cubie> cubies, int index, char cubeAxis) {
  Cubie[] newList = new Cubie[cubies.size()];
  for(int i = 0; i < cubies.size(); i++) {
    newList[i] = cubies.get(i);
  }
  ArrayList<Cubie> list = new ArrayList();
  switch(cubeAxis)  {
    case 'X':
    for(Cubie c : cubies) {
      if(index == 1)  {
        if(c.y == axis*index && c.z == -axis) {
          newList[0] = c;
          continue;
        }
        if(c.y == axis*index && c.z == middle) {
          newList[1] = c;
          continue;
        }
        if(c.y == axis*index && c.z == axis)  {
          newList[2] = c;
          continue;
        }
        if(c.y == middle && c.z == -axis)  {
          newList[3] = c;
          continue;
        }
        if(c.y == middle && c.z == middle)  {
          newList[4] = c;
          continue;
        }
        if(c.y == middle && c.z == axis) {  
          newList[5] = c;
          continue;
        }
        if(c.y == -axis*index && c.z == -axis)  {
          newList[6] = c;
          continue;
        }
        if(c.y == -axis*index && c.z == middle)  {
          newList[7] = c;
          continue;
        }
        if(c.y == -axis*index && c.z == axis) {
          newList[8] = c;
          continue;
        }
      }
    }
    break;
    case 'Y':
      for(Cubie c : cubies) {
        if(c.x == axis && c.z == axis*index)  {
          newList[0] = c;
          continue;
        }
        if(c.x == axis && c.z == middle) {
          newList[1] = c;
          continue;
        }
        if(c.x == axis && c.z == -axis*index ) {
          newList[2] = c;
          continue;
        }
        if(c.x == middle && c.z == axis*index) {  
          newList[3] = c;
          continue;
        }
        if(c.x == middle && c.z == middle)  {
          newList[4] = c;
          continue;
        }
        if(c.x == middle && c.z == -axis*index)  {
          newList[5] = c;
          continue;
        }
        if(c.x == -axis && c.z == axis*index) {
          newList[6] = c;
          continue;
        }
        if(c.x == -axis && c.z == middle)  {
          newList[7] = c;
          continue;
        }
        if(c.x == -axis && c.z == -axis*index)  {
          newList[8] = c;
          continue;
        }
      }
      break;
    case 'Z':
      for(Cubie c : cubies) {
        if(c.x == axis && c.y == -axis*index ) {
          newList[0] = c;
          continue;
        }
        if(c.x == axis && c.y == middle) {
          newList[1] = c;
          continue;
        }
        if(c.x == axis && c.y == axis*index)  {
          newList[2] = c;
          continue;
        }
        if(c.x == middle && c.y == -axis*index)  {
          newList[3] = c;
          continue;
        }
        if(c.x == middle && c.y == middle)  {
          newList[4] = c;
          continue;
        }
        if(c.x == middle && c.y == axis*index) {  
          newList[5] = c;
          continue;
        }
        if(c.x == -axis && c.y == -axis*index)  {
          newList[6] = c;
          continue;
        }
        if(c.x == -axis && c.y == middle)  {
          newList[7] = c;
          continue;
        }
        if(c.x == -axis && c.y == axis*index) {
          newList[8] = c;
          continue;
        }
      break;
    }
  }
  for(Cubie c : newList)  {
    list.add(c);
  }
  return list;
}

void resetLists() {
  back.clear();
  front.clear();
  left.clear();
  right.clear();
  top.clear();
  down.clear();
}
