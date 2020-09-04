class Cube { //<>// //<>// //<>// //<>//

  Cubie[] cube;
  ArrayList<ArrayList<Cubie>> cubieLists = new ArrayList();
  ArrayList<Cubie> rotatingCubies = new ArrayList();
  ArrayList<Cubie> rotatingCubi = new ArrayList();
  HumanAlgorithm hAlgorithm;

  int len = 0;
  int COUNTER = 0;
  char currentAxis = 'X';
  int currentDirection = 0;
  float rotationAngle = 0;
  float rotatingIndex = 0;
  boolean rotatingCubie = false;
  boolean animating = false;
  boolean clockwise = true; 
  boolean turningWholeCube = false;

  Cube() {
    // Sets array size for cubies to be stored in for any cube size
    // If dimensions of cube are 1x1x1, sets the cube size manually as the math above doesn't cater for it.
    cube = dim == 1 ? new Cubie[1] : new Cubie[(int)(pow(dim, 3) - pow(dim-2, 3))];
    // len stores the number value of cubies in cube.
    len = cube.length;
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
    int angleMultiplier = currentDirection > 0 ? -1 : 1;
    int index = 0;
    // For every cubie in the cube
    for (float x = 0; x < dim; x++) {
      for (float y = 0; y < dim; y++) {
        for (float z = 0; z < dim; z++) {
          if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
          // saves transformation state.
          push();
          
          // todo figure out how to rotate face using rotatingCubies arraylist boolean
          if (animating && (turningWholeCube || rotatingCubies.contains(cube[index]))) {
            // Check current axis for cube's rotation
            switch(currentAxis) {
            case 'X': 
              rotateX(angleMultiplier * rotationAngle);
              break;
            case 'Y':
              rotateY(angleMultiplier * rotationAngle);
              break;
            case 'Z':
              rotateZ(angleMultiplier * -rotationAngle);
              break;
            }
          }
          // Show cubie
          cube[index].show();
          pop();
          index++;
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
    // println("Rotating Cubies List");
    for(Cubie c : rotatingCubies) {
      // println("Cubie " + rotatingCubies.indexOf(c) + c.details());
    }
  }

  // Changes booleans to rotate the entire cube along axis
  void turnWholeCube(char axis, int dir) {
    // If cube is already rotating, leave function 
    if (animating) return;
    animating = true;
    turningWholeCube = true;
    currentAxis = axis;
    currentDirection = dir;
    // print("animating is now true\n");
    // if (fixCubeRotation) {
    //   rotationAngle = 0;
    //   animating = false;
    //   finishTurningWholeCube(axis, dir);
    // }
  }

  void finaliseTurn(char faceAxis, float index, int dir) {
    animating = false;
    for (Cubie c : rotatingCubies) { 
      // println("Turned cubie " + rotatingCubies.indexOf(c) + c.details());
      c.turn(faceAxis, dir);
    }
    
    for (int j = 0; j < cubieLists.size(); j++) {
      // Stores list of cubies that will be replaced by newCubies later on
      ArrayList<Cubie> temp = cubieLists.get(j);
      // Holds all the cubies with modified colour faces.
      ArrayList<Cubie> newCubies = new ArrayList(temp);
      // For each list of cubies
      for (int i = 0; i< dim-1-j*2; i++) { 
        // Changes order of cubies in temp arraylist
        if (dir == -1) {
          // println("Removing from end, adding to start");
          //remove from end and add to start
          temp.add(0, temp.remove(temp.size()-1));
        } else if (dir == 2) {
          // temp.
        } else {
          // println("Removing from start, adding to end");
          //remove from front and add to the end
          temp.add(temp.remove(0));
        }
      }
      returnListToCube(newCubies, temp, faceAxis, index, j);
    }
  }

  // finish animating whole cube
  void finishTurningWholeCube(char faceAxis, int dir) {
    // print("finishTurningWholeCube\n");
    animating = false;
    turningWholeCube = false;
    // refreshCube();
    // turn every cubie
    int i = 0;
    for (Cubie c : cube) {
      // println("Cube  " + cube.indexOf(c) + " turning: \t" + c.details()));                                                     
      c.turn(faceAxis, dir); 
    }

    // for each axis (E.g. -1, 0, 1)
    for (float index = -axis; index <= axis; index++) {
      // get all the cubies in that particular axis index and store to cubieLists
      cubieLists = getAllCubiesToRotate(faceAxis, index);
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
        returnListToCube(oldList, temp, faceAxis, index, j);
      }
    }
  }

  // collects cubies from axis at specified index.
  ArrayList<ArrayList<Cubie>> getAllCubiesToRotate(char faceAxis, float index) {
    ArrayList<ArrayList<Cubie>>  temp = new ArrayList();   
    // if index is -axisIndex or axisIndex
    if (index == -axis || index == axis) {
      // Somehow stops bug in center cubie
      for (int i  = 0; i < floor((dim+1)/2); i++) {
        // Add list cubies from specified index/axis
        temp.add(getList(faceAxis, index, i));
      }
      // if cubies are in middle column along axis
    } else {
      temp.add(getList(faceAxis, index, 0));
    }
    return temp;
  } 

  // return list of cubies to the cube object
  void returnListToCube(ArrayList<Cubie> oldList, ArrayList<Cubie> list, char faceAxis, float index, int listNumber) {
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
    clearMoves();
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
          if(allMoves.get(r).currentAxis != copy.currentAxis && allMoves.get(r).index != copy.index) {
            m = allMoves.get(r).copy();
            isDifferent = true;
          }
        } while (!isDifferent);
      }
      copy = new Move(m.currentAxis, m.index, m.dir);
      sequence.add(m);
    }

    int c = 0;
    if (dim <= 3) {
      for (Move m : sequence) {
        if(sequence.indexOf(m) < 10)  {
          println("Initial moves " + sequence.indexOf(m) + "\t\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
        } else {
          println("Initial moves " + sequence.indexOf(m) + "\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
        }
        c++;
        moves += m.moveToString() + ", ";
      }
      println("Original Moves");
      for(Move m: allMoves) {
        println("Move: " + allMoves.indexOf(m) + "\t\t" + m.moveToString() + "\t" + m.currentAxis + "\t" +  m.index + "\t" + m.dir);
      }
    }

    print("Scramble prepared\n");
  }

  // reverses all moves - illusion of a solve from scramble state
  void rScrambleCube() {
    counter = 0;
    ArrayList<Move> reverseSequence = new ArrayList<Move>();
    moves = "";
    // If cube has not been scrambled, return.
    if (sequence.size() == 0) return;
    // store all sequence elements to reverseSequence
    
    for (Move m : sequence) {
      if(sequence.indexOf(m) < 10)  {
        println("Initial moves " + sequence.indexOf(m) + "\t\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      } else {
        println("Initial moves " + sequence.indexOf(m) + "\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      }
      reverseSequence.add(m);
    }
    // Clear current sequence ready for new, re-ordered sequence
    sequence.clear();
    for(Move m : reverseSequence)  {
      // println("Initial moves " + reverseSequence.indexOf(m) + "\t\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
    }
    for (int i = reverseSequence.size() - 1; i >= 0; i--) {
      Move m = reverseSequence.get(i);
      // reverses the move
      m.reverse();
      // if cube is less than or equal to 3x3x3, add notation representing move to string moves, else add message.
      moves += dim <= 3 ? m.moveToString() + ", " : "No notation for " + dim + "x" + dim + "x" + dim + " size cube.";
      // Add move to the sequence
      sequence.add(m);
    }

    for (Move m : sequence) {
      if(sequence.indexOf(m) < 10)  {
        println("Reversed moves " + sequence.indexOf(m) + "\t\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
      } else {
        println("Reversed moves " + sequence.indexOf(m) + "\t" + m.moveToString() + "\t" + m.currentAxis + "\t" + m.index + "\t" + m.dir);
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
  ArrayList<Cubie> getList(char faceAxis, float index, int listNumber) {
    ArrayList<Cubie> list = new ArrayList();

    ArrayList<Cubie> leftRow = new ArrayList();
      ArrayList<Cubie> left1 = new ArrayList();
      ArrayList<Cubie> left2 = new ArrayList();
      ArrayList<Cubie> left3 = new ArrayList();
    ArrayList<Cubie> topRow = new ArrayList();
    ArrayList<Cubie> rightRow = new ArrayList();
    ArrayList<Cubie> bottomRow = new ArrayList();
    // If index is axis or -axis (Because there are no cubies inside the cube)
    if ((index == axis || index == -axis) && listNumber != 0) {
      for (Cubie c : cube) {
        if ((faceAxis == 'X' && c.x == index && c.y == 0 && c.z == 0) ||
            (faceAxis == 'Y' && c.x == 0 && c.y == index && c.z == 0) ||
            (faceAxis == 'Z' && c.x == 0 && c.y == 0 && c.z == index)) {
            list.add(c.copy());
        }
      }
    } else {
      switch(faceAxis) {
      case 'X':
        // Add top, right, bottom, left rows of the face
        // Adds them in a clockwise fashion - easier to interpret and keep track of
        // ------------
        // Inverts z axis value depending on which axis/index is being stored
        // This is to maintain storing in a clockwise fashion regardless of which face
        if(listNumber == 0) {
          for (Cubie c : cube) {
            // Adding left row
            if (c.x == index && c.y == 1 && c.z == -1) {
              left1.add(c.copy());
            } 
            else if (c.x == index && c.y == 0 && c.z == -1) {
              left2.add(c.copy());
            }
            else if (c.x == index && c.y == -1 && c.z == -1) {
              left3.add(c.copy());
            } // Adding top row
            else if (c.x == index  && c.y == -1 && c.z != -1) {
              topRow.add(c.copy());
            } // Adding right row
            else if (c.x == index && c.y != -1 && c.z == 1) {
              rightRow.add(c.copy());
            } // Adding bottom row
            else if (c.x == index && c.y == 1 && c.z == 0) {
              bottomRow.add(c.copy());
            }
          }
        } 
        break;
      case 'Y':
        for (Cubie c : cube) {
          // Adding left row
          if (c.x == -1 && c.y == index && c.z == 1) {
            left1.add(c.copy());
          } 
          else if (c.x == -1 && c.y == index && c.z == 0) {
            left2.add(c.copy());
          }
          else if (c.x == -1 && c.y == index && c.z == -1) {
            left3.add(c.copy());
          } // Adding top row
          else if (c.x != -1  && c.y == index && c.z == -1) {
            topRow.add(c.copy());
          } // Adding right row
          else if (c.x == 1 && c.y == index && c.z != -1) {
            rightRow.add(c.copy());
          } // Adding bottom row
          else if (c.x == 0 && c.y == index && c.z == 1) {
            bottomRow.add(c.copy());
          }
        }
        break;
      case 'Z':
        for (Cubie c : cube) {
          // Adding left row
          if (c.x == -1 && c.y == 1 && c.z == index) {
            left1.add(c.copy());
          } 
          else if (c.x == -1 && c.y == 0 && c.z == index) {
            left2.add(c.copy());
          }
          else if (c.x == -1 && c.y == -1 && c.z == index) {
            left3.add(c.copy());
          } // Adding top row
          else if (c.x != -1  && c.y == -1 && c.z == index) {
            topRow.add(c.copy());
          } // Adding right row
          else if (c.x == 1 && c.y != -1 && c.z == index) {
            rightRow.add(c.copy());
          } // Adding bottom row
          else if (c.x == 0 && c.y == 1 && c.z == index) {
            bottomRow.add(c.copy());
          }
        }
        break;
      }

      leftRow.addAll(left1);
      leftRow.addAll(left2);
      leftRow.addAll(left3);

      list.addAll(leftRow);
      list.addAll(topRow);
      list.addAll(rightRow);
      list.addAll(bottomRow);
    }
    // print("left row added\n");
    // if (list.size() > 1) {
    //   print("Sizes: " + topRow.size() + "\t" + rightRow.size() + "\t" + bottomRow.size() +"\t" + leftRow.size() +"\n");
    // } else {
    //   print("Center piece:\n");
    // }
    // for (Cubie c : list) {
    //   print("ORIGINAL CUBIE: \t" + c.x +"\t" + c.y + "\t" + c.z +"\n");
    // }
    return list;
  }

  Cubie getCubie(int i) {
    return cube[i];
  }
}
