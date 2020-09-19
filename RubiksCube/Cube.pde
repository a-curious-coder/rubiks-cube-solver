class Cube {

  Cubie[] cube;
  ArrayList<ArrayList<Cubie>> cubieLists;
  ArrayList<Cubie> rotatingCubies;
  HumanAlgorithm hAlgorithm;
  int len;
  char currentAxis;
  int currentDirection;
  float rotationAngle;
  float rotatingIndex;
  boolean rotatingCubie = false;
  boolean animating = false;
  boolean clockwise = true; 
  boolean turningWholeCube = false;

  Cube() {

    cube = dim == 1 ? new Cubie[1] : new Cubie[(int)(pow(dim, 3) - pow(dim-2, 3))];
    cubieLists = new ArrayList();
    rotatingCubies = new ArrayList();
    len = cube.length;
    currentDirection = 0;
    rotationAngle = 0;
    rotatingIndex = 0;
    int index = 0;

    for (float x = 0; x < dim; x++) {
      for (float y = 0; y < dim; y++) {
        for (float z = 0; z < dim; z++) {
          // If cubie is within the cube, it's not created/stored
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          PMatrix3D matrix = new PMatrix3D();
          matrix.translate(x-axis, y-axis, z-axis);
          cube[index] = new Cubie(matrix, x-axis, y-axis, z-axis);

          index++;
        }
      }
    }
    hAlgorithm = new HumanAlgorithm(this);
  }

  // Shows cube to screen
  void show() {
    int angleMultiplier = currentDirection;

    int i = 0;
    for (float x = 0; x < dim; x++) {
      for (float y = 0; y < dim; y++) {
        for (float z = 0; z < dim; z++) {
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          push();
          if (animating && (turningWholeCube || rotatingCubies.contains(cube[i]))) {
            switch(currentAxis) {
            case 'X': 
              if(rotatingIndex == -axis)  {
                rotateX(angleMultiplier * -rotationAngle);
              } else {
                rotateX(angleMultiplier * rotationAngle);
              }
              break;
            case 'Y':
              rotateY(angleMultiplier * -rotationAngle);
              break;
            case 'Z':
              if(rotatingIndex == -axis)  {
                rotateZ(angleMultiplier * -rotationAngle);
              } else {
                rotateZ(angleMultiplier * rotationAngle);
              }
              break;
            }
          }
          // Show cubie
          cube[i].show();
          pop();
          i++;
        }
      }
    }
  }

  // Update the cube
  void update() {
    if (animating) {
      if (rotationAngle < HALF_PI) {
        float scrambleMultiplier = 1;
        if (scramble) {
          scrambleMultiplier = 5;
        } 
        int turningEaseCoeff = 2;
        if (rotationAngle < HALF_PI/4) {
          rotationAngle += scrambleMultiplier * speed / map(rotationAngle, 0, HALF_PI/4, turningEaseCoeff, 1);
        } else if (rotationAngle > HALF_PI-HALF_PI/4) {
          rotationAngle += scrambleMultiplier * speed / map(rotationAngle, HALF_PI-HALF_PI/4, HALF_PI, 1, turningEaseCoeff);
        } else {
          rotationAngle += scrambleMultiplier * speed;
        }
      }
      if (rotationAngle >= HALF_PI) {
        rotationAngle = 0;
        animating = false;
        int dir = clockwise ? 1 : -1;
        if (turningWholeCube) {
          finishTurningWholeCube(currentAxis, currentDirection);
        } else {
          finaliseTurn(currentAxis, rotatingIndex, currentDirection);
        }
      }
    }
  }

  // Turns specified face of the cube
  void turn(char axisFace, float index, int dir) {
    if (animating) {
      rotationAngle = 0;
      finaliseTurn(currentAxis, rotatingIndex, currentDirection);
    }

    currentAxis = axisFace;
    currentDirection = dir;
    rotatingIndex = index;
    animating = true;
    cubieLists = getAllCubiesToRotate(currentAxis, index);

    rotatingCubies.clear();

    for (int i = 0; i < cubieLists.size(); i++) {
      rotatingCubies.addAll(cubieLists.get(i)); 
    }
  }

  void turnWholeCube(char axis, int dir) {
    if (animating) return;

    animating = true;
    turningWholeCube = true;
    currentAxis = axis;
    currentDirection = dir;
    rotatingIndex = 0;
  }
  
  // Finalises a turn after global variables are prepared by turn function
  void finaliseTurn(char axisFace, float index, int dir) {
    animating = false;
    if(axisFace == 'X' && index > -axis && dir != 2)  dir = -currentDirection;
    if(axisFace == 'Z' && index == -axis && dir != 2) dir = -currentDirection;

    for (Cubie c : rotatingCubies) { 
      c.turn(axisFace, dir); 
    }
    for (int j = 0; j < cubieLists.size(); j++) {
      ArrayList<Cubie> temp = cubieLists.get(j);
      ArrayList<Cubie> newCubies = new ArrayList(temp);
      for (int i = 0; i< dim-1-j*2; i++) { 
        if (dir == -1) {
          //remove from end and add to start
          temp.add(0, temp.remove(temp.size()-1));
        } else {
          //remove from front and add to the end
          if(dir == 2) temp.add(temp.remove(0));
          temp.add(temp.remove(0));
        }
      }
      returnListToCube(newCubies, temp, axisFace, index, j);
    }
  }

  void finishTurningWholeCube(char axisFace, int dir) {
    dir = axisFace == 'X' ? -currentDirection : currentDirection;
    animating = false;
    turningWholeCube = false;
    int i = 0;
    for (Cubie c : cube) {
        c.turn(axisFace, dir); 
    }

    for (float index = -axis; index <= axis; index++) {
      cubieLists = getAllCubiesToRotate(axisFace, index);
      for (int j = 0; j < cubieLists.size(); j++) {
        ArrayList<Cubie> temp = cubieLists.get(j);
        ArrayList<Cubie> newCubies = new ArrayList(temp);
        for (int k = 0; k < dim-1-j*2; k++) {
          if (dir == -1) {
            temp.add(0, temp.remove(temp.size()-1)); 
          } else {
            temp.add(temp.remove(0));
          }
        }
        returnListToCube(newCubies, temp, axisFace, index, j);
      }
    }
  }

  // Collects cubies from axis at specified index.
  ArrayList<ArrayList<Cubie>> getAllCubiesToRotate(char axisFace, float index) {
    ArrayList<ArrayList<Cubie>>  temp = new ArrayList();   
    if (index == -axis || index == axis) {
      for (int i  = 0; i < floor((dim+1)/2); i++) {
        temp.add(getList(axisFace, index, i));
      }
    } else {
      temp.add(getList(axisFace, index, 0));
    }
    return temp;
  }

  // Return list of cubies to the cube object
  void returnListToCube(ArrayList<Cubie> oldList, ArrayList<Cubie> list, char axisFace, float index, int listNumber) {
    int size = dim-listNumber * 2;
    for(int i = 0; i < list.size(); i++)  {
      boolean found = false;
      if(found) continue;
      for(Cubie c : cube) {
        if (list.get(i).x == c.x && list.get(i).y == c.y && list.get(i).z == c.z) {
          c.colours = oldList.remove(0).copy().colours;
          found = true;
        }
      }
    }
    // Updates the cube with new colours - reevaluates each cubies position.
    int i = 0;
    for (int x = 0; x < dim; x++) { 
      for (int y = 0; y < dim; y++) { 
        for (int z = 0; z < dim; z++) { 
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          PMatrix3D matrix = new PMatrix3D();
          matrix.translate(x-axis, y-axis, z-axis);
          cube[i].matrix = matrix;
          cube[i].x = x-axis;
          cube[i].y = y-axis;
          cube[i].z = z-axis;
          i++;
        }
      }
    }
  }

  // Scramble Cube
  void scrambleCube() {
    scramble = true;
    sequence.clear();
    moves = "";
    fMoves.clear();
    counter = 0;
    Move copy = new Move();
    boolean isDifferent = true;

    for (int i = 0; i < numberOfMoves; i++) {
      int r = int(random(allMoves.size()));
      Move m = allMoves.get(r).copy();

      if(m.currentAxis == copy.currentAxis) {
        do{
          r = int(random(allMoves.size()));
          if(allMoves.get(r).currentAxis != copy.currentAxis && allMoves.get(r).index != copy.index) {
            m = allMoves.get(r).copy();
            isDifferent = false;
          }
        } while (isDifferent);
      }
      if(m.index > axis || m.index < -axis) i--;
      if(m.dir == 2)  i++;
      copy = new Move(m.currentAxis, m.index, m.dir);
      sequence.add(m);
    }
    print("Scramble prepared\n");
    for(Move m: sequence) { 
      fMoves.add(m.toString()); 
    }
    formatMoves();
  }

  /** Tests all possible moves along specified axis regardless of cube size
  *
  * @param {char} axisFace Specifies which axis the moves are being made along
  */
  void testMoves(char axisFace) {
    scramble = true;
    sequence.clear();
    moves = "";
    fMoves.clear();
    counter = 0;

    int numberOfZMoves = 0;
    ArrayList<Move> allZMoves = new ArrayList();

    for(Move m : allMoves)  {
      if(m.currentAxis == axisFace)  allZMoves.add(m);
    }

    for (Move m : allZMoves) {
      sequence.add(m.copy());
    }
    
    ArrayList <Move> doubleMoves = new ArrayList();
    ArrayList <Move> primeMoves = new ArrayList();
    ArrayList <Move> normalMoves = new ArrayList();
    ArrayList <Move> wholeMoves = new ArrayList();

    for(int i = 0; i < sequence.size(); i++)  {
      if(sequence.get(i).index > axis || sequence.get(i).index < -axis)  {
        wholeMoves.add(sequence.get(i));
      } else if(sequence.get(i).dir == 2)  {
        doubleMoves.add(sequence.get(i));
      } else if(sequence.get(i).dir == -1)  {
        primeMoves.add(sequence.get(i));
      } else if(sequence.get(i).dir == 1) {
        normalMoves.add(sequence.get(i));
      }
    }
    sequence.clear();
    sequence.addAll(normalMoves);
    sequence.addAll(primeMoves);
    sequence.addAll(doubleMoves);
    sequence.addAll(wholeMoves);
    
    for(Move m: sequence) {
      fMoves.add(m.toString());
    }
    formatMoves();
  }

  // Reverses all moves made by scramble function - gives the illusion of a solve.
  void rScrambleCube() {
    counter = 0;
    ArrayList<Move> reverseSequence = new ArrayList<Move>();
    if (sequence.size() == 0) return;
    for (Move m : sequence) {
      reverseSequence.add(m);
    }
    sequence.clear();

    for (int i = reverseSequence.size() - 1; i >= 0; i--) {
      Move m = reverseSequence.get(i);
      if(m.dir != 2)  m.reverse();
      if(dim <= 3)  fMoves.add(m.toString());
      sequence.add(m);
    }
    
    if (moves != "")
      print(numberOfMoves + " moves were taken to unscramble the cube " + "\n" + moves);
    else
      print("Solving cube...");
  }

  /**
  * Generates a list of cubies from specified index in axis
  *
  * @param {char} axisFace Axis of which the face of cubies is located
  * @param {float} index Index of which row/column of the axis in the cube is to be chosen
  * @param {int} listNumber List number plays part in how far into the cube we go to retrieve cubies.
  */
  ArrayList<Cubie> getList(char axisFace, float index, int listNumber) {

    int size = dim - listNumber * 2;
    ArrayList<Cubie> list = new ArrayList();

    ArrayList<Cubie> leftRow = new ArrayList();
    ArrayList<Cubie> topRow = new ArrayList();
    ArrayList<Cubie> rightRow = new ArrayList();
    ArrayList<Cubie> bottomRow = new ArrayList();
    ArrayList<Cubie> temp = new ArrayList();
    int leftSize = 0;
    int indexOfCubie = 0;

    switch(axisFace) {
    case 'X':
      // Order cubies are stored: left, top, right, bottom - clockwise
      // Left row
      for(Cubie c : cube) {
        for(float i = 0; i < size; i++)  {
          if(c.x == index && c.y == (i-axis+listNumber) && c.z == (-axis+listNumber) ) {
            if(leftRow.contains(c)) continue;
            leftRow.add(c.copy());
          }
        }
        // Top row
        for(float i = 1; i < size; i++) {
          if(c.x == index && c.y == (-axis + listNumber) && c.z > (-axis+listNumber) && c.z <= (axis-listNumber)  && topRow.size() != size)  {
            if(topRow.contains(c)) {
              continue;
            } else {
              topRow.add(c.copy());
            }
          }
        }
        // Right row
        for(float i = 1; i < size; i++) {
          if(c.x == index && c.y > (-axis+listNumber) && c.z == (axis-listNumber)) {
            if(rightRow.contains(c)) {
              continue;
            } else {
              if(c.y <= (axis-listNumber))  rightRow.add(c.copy());
            }
          }
        }
        
        // Bottom row
        for(float i = 2; i < size; i++)  {
          if(c.x == index && c.y == (axis-listNumber) && c.z <= axis-0.5-listNumber && c.z >= -axis+0.5+listNumber)  {
            if(bottomRow.contains(c))  {
              continue;
            } else {
              bottomRow.add(c.copy());
            } 
          }
        }
        indexOfCubie++;
      }
      temp = new ArrayList();
      leftSize = leftRow.size();
      for(int i = 0; i < leftSize; i++) {
        temp.add(leftRow.remove(leftRow.size()-1));
      }
      leftRow.addAll(temp);
      break;
      
    case 'Y':
      for(Cubie c : cube) {
        for(float i = 0; i < size; i++)  {
          if(c.x == (-axis+listNumber) &&  c.y == index &&  c.z == (i-axis+listNumber) ) {
            if(leftRow.contains(c)) continue;
            leftRow.add(c.copy());
          }
        }
        for(float i = 1; i < size; i++) {
          if(c.x > (-axis+listNumber) && c.x <= (axis-listNumber) &&  c.y == index &&  c.z == (-axis+listNumber)  && topRow.size() != size)  {
            if(topRow.contains(c)) continue;
            topRow.add(c.copy());
          }
        }
        for(float i = 1; i < size; i++) {
          if(c.x == (axis-listNumber) &&  c.y == index &&  c.z > (-axis+listNumber)) {
            if(rightRow.contains(c)) {
              continue;
            } else {
              if(c.z <= (axis-listNumber))  rightRow.add(c.copy());
            }
          }
        }
        for(float i = 2; i < size; i++)  {
          if(c.x <= (axis-0.5-listNumber) && c.x >= (-axis+0.5+listNumber) &&  c.y == index &&  c.z == (axis-listNumber))  {
            if(bottomRow.contains(c)) continue;
            bottomRow.add(c.copy());
          }
        }
        indexOfCubie++;
      }
      temp = new ArrayList();
      leftSize = leftRow.size();
      for(int i = 0; i < leftSize; i++) {
        temp.add(leftRow.remove(leftRow.size()-1));
      }
      leftRow.addAll(temp);
      
      break;
    case 'Z':
      
      for(Cubie c : cube) {
        for(float i = 0; i < size; i++)  {
          if(c.x == (-axis+listNumber)  && c.y == (i-axis+listNumber) && c.z == index) {
            if(leftRow.contains(c)) continue;
            leftRow.add(c.copy());
          }
        }
        for(float i = 1; i < size; i++) {
          if(c.x > (-axis+listNumber) && c.x <= (axis-listNumber) && c.y == (-axis+listNumber) &&  c.z == index && topRow.size() != size)  {
            if(topRow.contains(c)) continue;
            topRow.add(c.copy());
          }
        }
        for(float i = 1; i < size; i++) {
          if(c.x == (axis-listNumber) && c.y > (-axis+listNumber)  &&   c.z == index) {
            if(rightRow.contains(c))  continue;
            if(c.y <= (axis-listNumber))  rightRow.add(c.copy());
          }
        }
        for(float i = 2; i < size; i++)  {
          if(c.x <= axis-0.5-listNumber && c.x >= -axis+0.5+listNumber && c.y == (axis-listNumber) && c.z == index)  {
            if(bottomRow.contains(c)) continue;
            bottomRow.add(c.copy());
          }
        }
        indexOfCubie++;
      }
      
      temp = new ArrayList();
      leftSize = leftRow.size();
      for(int i = 0; i < leftSize; i++) {
        temp.add(leftRow.remove(leftRow.size()-1));
      }
      leftRow.addAll(temp);
      break;
    }
    list.addAll(leftRow);
    list.addAll(topRow);
    list.addAll(rightRow);
    list.addAll(bottomRow);
    return list;
  }

  Cubie getCubie(int i) {
    return cube[i];
  }

  boolean evaluateCube() {
    int oCounter = 0;
    int rCounter = 0;
    int wCounter = 0;
    int yCounter = 0;
    int gCounter = 0;
    int bCounter = 0;

    int index = 0;
    for (float x = 0; x < dim; x++) {
      for (float y = 0; y < dim; y++) {
        for (float z = 0; z < dim; z++) {
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          Cubie c = cube[index];
          if(c.getRight() == orange) oCounter++;
          if(c.getLeft() == red)  rCounter++;
          if(c.getTop() == yellow) yCounter++;
          if(c.getDown() == white) wCounter++;
          if(c.getFront() == green) gCounter++;
          if(c.getBack() == blue) bCounter++;
          index++;
        }
      }
    }
    int numFaces = dim*dim;
    if(oCounter == numFaces &&
      rCounter == numFaces &&
      yCounter == numFaces &&
      wCounter == numFaces &&
      gCounter == numFaces &&
      bCounter == numFaces) return true;
    return false;
  }


}