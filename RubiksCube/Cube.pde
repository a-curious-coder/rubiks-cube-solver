class Cube { //<>// //<>// //<>// //<>//

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
    // Sets array size for cubies to be stored in for any cube size
    // If dimensions of cube are 1x1x1, sets the cube size manually as the math above doesn't cater for it.
    cube = dim == 1 ? new Cubie[1] : new Cubie[(int)(pow(dim, 3) - pow(dim-2, 3))];
    cubieLists = new ArrayList();
    rotatingCubies = new ArrayList();
    // len stores the number value of cubies in cube.
    len = cube.length;
    currentDirection = 0;
    rotationAngle = 0;
    rotatingIndex = 0;
    // index of cubie that's being stored to cube object
    // print("\tCube\t\tx\ty\tz\tcol1\tcol2\tcol3\tcol4\tcol5\tcol6\tnCols\tCubieType\n");
    int index = 0;
    for (float x = 0; x < dim; x++) {
      for (float y = 0; y < dim; y++) {
        for (float z = 0; z < dim; z++) {
          // if cubie is more than 0 and less than dim-1 in all axis, skip this iteration in the for loop 
          // Basically if the cubie's not visible to user, don't store it.
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          PMatrix3D matrix = new PMatrix3D();
          // translates all cubies to center of rotation by subtracting axis from x, y, z
          matrix.translate(x-axis, y-axis, z-axis);
          // Store cubie using the translated matrix and x,y,z values subtracting the axis.
          // print("\tCube " + (index+1) + "\t");
          cube[index] = new Cubie(matrix, x-axis, y-axis, z-axis);

          index++;
        }
      }
    }
    // Instantiate new human algorithm for this cube.
    hAlgorithm = new HumanAlgorithm(this);
  }

  // Shows cube to screen
  void show() {
    // Determines whether rotation is clockwise or not
    int angleMultiplier = currentDirection;

    int i = 0;
    // For every cubie in the cube
    for (float x = 0; x < dim; x++) {
      for (float y = 0; y < dim; y++) {
        for (float z = 0; z < dim; z++) {
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          // saves transformation state.
          push();
          // todo figure out how to rotate face using rotatingCubies arraylist boolean
          if (animating && (turningWholeCube || rotatingCubies.contains(cube[i]))) {
            // Check current axis for cube's rotation
            switch(currentAxis) {
            case 'X': 
              // Checks which face is moving along the current axis and rotates the correct direction.
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

    if (animating) {//finish the turn
      rotationAngle = 0;
      finaliseTurn(currentAxis, rotatingIndex, currentDirection);
    }
    
    // Setting global variables
    currentAxis = axisFace;
    currentDirection = dir;
    rotatingIndex = index;
    // Animating begins for this turn
    animating = true;
    // Collect all cubies appropriate for move
    cubieLists = getAllCubiesToRotate(currentAxis, index);
    rotatingCubies.clear();
    for (int i = 0; i < cubieLists.size(); i++) {
      rotatingCubies.addAll(cubieLists.get(i)); 
    }

    // println("Rotating Cubies List" + rotatingCubies.size());
    // for(Cubie c : rotatingCubies) {
    //   println("Cubie " + rotatingCubies.indexOf(c) + c.details());
    // }
  }

  // Changes booleans to rotate the entire cube along axis
  void turnWholeCube(char axis, int dir) {
    // If cube is already rotating, leave function 
    if (animating) return;
    animating = true;
    turningWholeCube = true;
    currentAxis = axis;
    currentDirection = dir;
    // Reset rotating index.
    rotatingIndex = 0;
    // print("animating is now true\n");
    // if (fixCubeRotation) {
    //   rotationAngle = 0;
    //   animating = false;
    //   finishTurningWholeCube(axis, dir);
    // }
  }

  void finaliseTurn(char axisFace, float index, int dir) {
    animating = false;
    if(axisFace == 'X' && index > -axis && dir != 2)  { dir = -currentDirection; }
    if(axisFace == 'Z' && index == -axis && dir != 2) { dir = -currentDirection; }

    for (Cubie c : rotatingCubies) { c.turn(axisFace, dir); }

    for (int j = 0; j < cubieLists.size(); j++) {
      // Stores list of cubies that will be replaced by newCubies later on
      ArrayList<Cubie> temp = cubieLists.get(j);
      // for(Cubie c : temp) {
      //   println("Cubie " + temp.indexOf(c) + "\t" + c.details());
      // }
      // Holds all the cubies with modified colour faces.
      ArrayList<Cubie> newCubies = new ArrayList(temp);
      // For each list of cubies
      for (int i = 0; i< dim-1-j*2; i++) { 
        // Changes order of cubies in temp arraylist
        if (dir == -1) {
          // println("Removing from end, adding to start");
          //remove from end and add to start
          temp.add(0, temp.remove(temp.size()-1));
        } else {
          // println("Removing from start, adding to end");
          //remove from front and add to the end
          if(dir == 2) temp.add(temp.remove(0));
          temp.add(temp.remove(0));
        }
      }
      returnListToCube(newCubies, temp, axisFace, index, j);
    }
  }

  // finish animating whole cube
  void finishTurningWholeCube(char axisFace, int dir) {
    // print("finishTurningWholeCube\n");
    dir = axisFace == 'X' ? -currentDirection : currentDirection;
    animating = false;
    turningWholeCube = false;
    // refreshCube();
    // turn every cubie
    int i = 0;
    for (Cubie c : cube) {
      // println("Cube  " + cube.indexOf(c) + " turning: \t" + c.details()));
        c.turn(axisFace, dir); 
    }

    // for each axis (E.g. -1, 0, 1)
    for (float index = -axis; index <= axis; index++) {
      // get all the cubies in that particular axis index and store to cubieLists
      cubieLists = getAllCubiesToRotate(axisFace, index);
      for (int j = 0; j < cubieLists.size(); j++) {
        // temp stores arraylist of cubies on specific face
        ArrayList<Cubie> temp = cubieLists.get(j);
        ArrayList<Cubie> oldList = new ArrayList(temp);
        for (int k = 0; k < dim-1-j*2; k++) {
          // if counterclockwise - Re-order cubies from the end of list, add to the start
          if (dir == -1) {
            temp.add(0, temp.remove(temp.size()-1)); 
          } 
          // Removes from start, adds to end of list
          else {
            temp.add(temp.remove(0));
          }
        }
        // returns cubies to cube
        returnListToCube(oldList, temp, axisFace, index, j);
      }
    }
  }

  // collects cubies from axis at specified index.
  ArrayList<ArrayList<Cubie>> getAllCubiesToRotate(char axisFace, float index) {
    ArrayList<ArrayList<Cubie>>  temp = new ArrayList();   
    // if index is -axisIndex or axisIndex
    if (index == -axis || index == axis) {
      // Somehow stops bug in center cubie
      for (int i  = 0; i < floor((dim+1)/2); i++) {
        // Add list cubies from specified index/axis
        temp.add(getList(axisFace, index, i));
      }
      // if cubies are in middle column along axis
    } else {
      temp.add(getList(axisFace, index, 0));
    }
    
    return temp;
  }

  // return list of cubies to the cube object
  void returnListToCube(ArrayList<Cubie> oldList, ArrayList<Cubie> list, char axisFace, float index, int listNumber) {
    // print("\n------- Return list to cube -------\n");
    int size = dim-listNumber * 2;
    // If the cubie along the x axis, right side as +1
    // Then add new cubie from list and remove from list.
    // Else maintain original cubie values.
   
    for(int i = 0; i < list.size(); i++)  {
      // if(list.size() == 1) continue;
      boolean found = false;
      if(found) continue;

      for(Cubie c : cube) {
        if (list.get(i).x == c.x && list.get(i).y == c.y && list.get(i).z == c.z) {
          c.colours = oldList.remove(0).copy().colours;
          // print("Updated cubie: " + c.details());
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
          // print("Cube: \t" + cube[indx].x + "\t" + cube[indx].y + "\t" + cube[indx].z + "\t" + axisIndex + "\n");
          PMatrix3D matrix = new PMatrix3D();
          matrix.translate(x-axis, y-axis, z-axis);
          cube[i].matrix = matrix;
          cube[i].x = x-axis;
          cube[i].y = y-axis;
          cube[i].z = z-axis;
          // println("Cubie " + i + cube[i].details());
          i++;
        }
      }
    }
    // print("------- END OF return list to cube -------\n\n");
  }

  // Scramble Cube
  void scrambleCube() {
    scramble = true;
    sequence.clear();
    moves = "";
    fMoves.clear();
    counter = 0;

    // Initialising copy move - used to compare previous move with.
    Move copy = new Move();
    boolean isDifferent = true;

    // Generate as many moves as valued by numberOfMoves
    for (int i = 0; i < numberOfMoves; i++) {
      // generate random integer based off number of all possible moves
      int r = int(random(allMoves.size()));
      // store move at index r in allMoves list to m
      Move m = allMoves.get(r).copy();
      //
      if(m.currentAxis == copy.currentAxis) {
        isDifferent = false;
        do{
          r = int(random(allMoves.size()));
          // If axis and index are not the same as previous move
          if(allMoves.get(r).currentAxis != copy.currentAxis && allMoves.get(r).index != copy.index) {
            m = allMoves.get(r).copy();
            isDifferent = true;
          }
        } while (!isDifferent);
      }

      // If move is a whole cube rotation, don't count it as a move as it does not impact cube's scramble.
      if(m.index > axis || m.index < -axis) { i--; }
      // If move has dir of 2 - count it as two moves.
      if(m.dir == 2)  { i++; }
      // Store current move to copy for reference when generating next move
      copy = new Move(m.currentAxis, m.index, m.dir);
      // Store generated move to sequence
      sequence.add(m);
    }
 
    print("Scramble prepared\n");
    // Add each move in the sequence to fMoves arraylist in string format
    for(Move m: sequence) { fMoves.add(m.toString()); }
    // format and store moves to a single string called moves.
    formatMoves();
  }

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

  // reverses all moves - illusion of a solve from scramble state
  void rScrambleCube() {
    moves = "";
    counter = 0;
    ArrayList<Move> reverseSequence = new ArrayList<Move>();
    // If cube has not been scrambled, return.
    if (sequence.size() == 0) return;
    // store all sequence elements/moves to reverseSequence - for every move in sequence
    for (Move m : sequence) {
      if(sequence.indexOf(m) < 10)  {
        // println("Initial moves " + sequence.indexOf(m) + "\t\t" + m.toString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      } else {
        // println("Initial moves " + sequence.indexOf(m) + "\t" + m.toString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      }
      // Add sequence move m
      reverseSequence.add(m);
    }
    // Empties current sequence to store reversed sequence later
    sequence.clear();
    for (int i = reverseSequence.size() - 1; i >= 0; i--) {
      Move m = reverseSequence.get(i);
      // Reverses the move
      if(m.dir != 2)
        m.reverse();
      // if cube is less than or equal to 3x3x3, add notation representing move to string, else add message.
      moves += dim <= 3 ? m.toString() + ", " : "No notation for " + dim + "x" + dim + "x" + dim + " size cube.";
      // Add modified move to the new sequence
      sequence.add(m);
    }

    for (Move m : sequence) {
      if(sequence.indexOf(m) < 10)  {
        // println("Reversed moves " + sequence.indexOf(m) + "\t\t" + m.toString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      } else {
        // println("Reversed moves " + sequence.indexOf(m) + "\t" + m.toString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      }
    }
    
    if (moves != "")
      print(numberOfMoves + " moves were taken to unscramble the cube " + "\n" + moves);
    else
      print("Solving cube...");
  }

  // ----- Getters -----
  // returns a list of all the cubies in the specified axis of cube - only works for 3x3x3 cube
  // todo optimise this function to cater for all cube sizes
  // As list number gets bigger, the collection moves inward toward the center of the cube's face to collect cubies.
  ArrayList<Cubie> getList(char axisFace, float index, int listNumber) {
    // println("\nGetting list number - " + listNumber);
    int size = dim - listNumber*2;
    // 3 - 0 * 2 = 6
    // 3 - 1 * 2 = 4
    // 3 - 2 * 2 = 2
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
        // Add top, right, bottom, left rows of the face
        // Adds them in a clockwise fashion - easier to interpret and keep track of
        // ------------
        // Inverts z axis value depending on which axis/index is being stored
        // This is to maintain storing in a clockwise fashion regardless of which face
       
        // Adds left row - Ideally starting with bottom left all the way to the top left in order.
        // Size reflects the number of possible cubies to collect on any given side - its value changes throughout.
        // For each cubie on the left side of the cube (Regardless of which listnumber is being collected...)
        // Iterate over every cube
        for(Cubie c : cube) {

          // iterates to cube dim
          for(float i = 0; i < size; i++)  {
            // Adds left row - issue with this collection...
            if(c.x == index && 
               c.y == (i-axis+listNumber) && 
               c.z == (-axis+listNumber) ) {
              if(leftRow.contains(c)) continue;
              // Add copy of cubie to leftRow's list
              leftRow.add(c.copy());
            }
          }

          // Adds top row (1 less than top row because left should collect the first top cube.)
          for(float i = 1; i < size; i++) {
            // If y is (-axis + listNumber) - caters for moving inward every list.
            if(c.x == index && 
               c.y == (-axis + listNumber) && 
               c.z > (-axis+listNumber) && c.z <= (axis-listNumber)  && topRow.size() != size)  {
              // Avoid storing copies of same cubies
              if(topRow.contains(c)) {
                continue;
              } else {
                topRow.add(c.copy());
              }
             
            }
          }

          // Add right row
          for(float i = 1; i < size; i++) {
            // Skip y row of -axis, if z is == to axis-listNumber to cater moving inward each iteration of this method.
            if(c.x == index && 
               c.y > (-axis+listNumber) && 
               c.z == (axis-listNumber)) {
              if(rightRow.contains(c)) {
                continue;
              } else {
                if(c.y <= (axis-listNumber))  {
                  rightRow.add(c.copy());
                }
              }
            }
          }
          
          // Bottom row
          for(float i = 2; i < size; i++)  {
            // If cube y == axis - listNumber and z < axis-listNumber and z > -axis + listnumber
            if(c.x == index && 
               c.y == (axis-listNumber) && 
               c.z <= axis-0.5-listNumber && c.z >= -axis+0.5+listNumber)  {
              if(bottomRow.contains(c))  {
                continue;
              } else {
                bottomRow.add(c.copy());
              } 
            }
          }

          // Increases index of each cubie object that can be added each loop iteration
          indexOfCubie++;
        }
        // Re orders left row as it's collected in the reverse order I wanted
        temp = new ArrayList();
        leftSize = leftRow.size();
        for(int i = 0; i < leftSize; i++) {
          temp.add(leftRow.remove(leftRow.size()-1));
        }
        leftRow.addAll(temp);
        
        break;
        
      case 'Y':

        for(Cubie c : cube) {

          // Adds left row
          for(float i = 0; i < size; i++)  {
            if(c.x == (-axis+listNumber) && 
               c.y == index && 
               c.z == (i-axis+listNumber) ) {
              if(leftRow.contains(c)) continue;
              leftRow.add(c.copy());
            }
          }

          // Adds top row (1 less than top row because left should collect the first top cube.)
          for(float i = 1; i < size; i++) {
            if(c.x > (-axis+listNumber) && c.x <= (axis-listNumber) && 
               c.y == index && 
               c.z == (-axis+listNumber)  && topRow.size() != size)  {
              // Avoid storing copies of same cubies
              if(topRow.contains(c)) continue;
              topRow.add(c.copy());
            }
          }

          // Add right row
          for(float i = 1; i < size; i++) {
            if(c.x == (axis-listNumber) && 
               c.y == index && 
               c.z > (-axis+listNumber)) {
              if(rightRow.contains(c)) {
                continue;
              } else {
                if(c.z <= (axis-listNumber))  {
                  rightRow.add(c.copy());
                }
              }
            }
          }
          
          // Bottom row
          for(float i = 2; i < size; i++)  {
            // If cube y == axis - listNumber and z < axis-listNumber and z > -axis + listnumber
            if(c.x <= (axis-0.5-listNumber) && c.x >= (-axis+0.5+listNumber) && 
               c.y == index && 
               c.z == (axis-listNumber))  {
              if(bottomRow.contains(c)) continue;
              bottomRow.add(c.copy());
            }
          }

          // Increases index of each cubie object that can be added each loop iteration
          indexOfCubie++;
        }
        // Re orders left row as it's collected in the reverse order I wanted
        temp = new ArrayList();
        leftSize = leftRow.size();
        for(int i = 0; i < leftSize; i++) {
          temp.add(leftRow.remove(leftRow.size()-1));
        }
        leftRow.addAll(temp);
        
        break;
      case 'Z':
        
        for(Cubie c : cube) {

          // Adds left row
          for(float i = 0; i < size; i++)  {
            if(c.x == (-axis+listNumber)  &&
               c.y == (i-axis+listNumber) &&
               c.z == index) {
              if(leftRow.contains(c)) continue;

              leftRow.add(c.copy());
            }
          }

          // Adds top row (1 less than top row because left should collect the first top cube.)
          for(float i = 1; i < size; i++) {
            if(c.x > (-axis+listNumber) && c.x <= (axis-listNumber) &&
               c.y == (-axis+listNumber) && 
               c.z == index && topRow.size() != size)  {
              // Avoid storing copies of same cubies
              if(topRow.contains(c)) continue;
              topRow.add(c.copy());
            }
          }

          // Add right row
          for(float i = 1; i < size; i++) {
            if(c.x == (axis-listNumber) &&
               c.y > (-axis+listNumber)  &&  
               c.z == index) {
              if(rightRow.contains(c))  continue;
              if(c.y <= (axis-listNumber))  {
                rightRow.add(c.copy());
              }
            }
          }
          
          // Bottom row
          for(float i = 2; i < size; i++)  {
            // If cube y == axis - listNumber and z < axis-listNumber and z > -axis + listnumber
            if(c.x <= axis-0.5-listNumber && c.x >= -axis+0.5+listNumber &&
               c.y == (axis-listNumber) &&
               c.z == index)  {
              if(bottomRow.contains(c)) continue;

              bottomRow.add(c.copy());
            }
          }

          // Increases index of each cubie object that can be added each loop iteration
          indexOfCubie++;
        }
        
        // Re orders left row as it's collected in the reverse order I wanted
        temp = new ArrayList();
        leftSize = leftRow.size();
        for(int i = 0; i < leftSize; i++) {
          temp.add(leftRow.remove(leftRow.size()-1));
        }
        leftRow.addAll(temp);

        break;
      }

    // println("Left row\t" + leftRow.size());
    // for(Cubie c : leftRow)  
    // { println("\tCubie " + (leftRow.indexOf(c) + 1) + "\t" + c.details()); }

    // println("Top row\t\t" + topRow.size());
    // for(Cubie c : topRow)  
    // { println("\tCubie " + (topRow.indexOf(c) + 1) + "\t" + c.details()); }

    // println("Right row\t" + rightRow.size());
    // for(Cubie c : rightRow)  
    // { println("\tCubie " + (rightRow.indexOf(c) + 1) + "\t" + c.details()); }

    // println("Bottom row\t" + bottomRow.size());
    // for(Cubie c : bottomRow)  
    // { println("\tCubie " + (bottomRow.indexOf(c) + 1) + "\t" + c.details()); }

    list.addAll(leftRow);
    list.addAll(topRow);
    list.addAll(rightRow);
    list.addAll(bottomRow);
    
    return list;
  }

  Cubie getCubie(int i) {
    return cube[i];
  }
}
