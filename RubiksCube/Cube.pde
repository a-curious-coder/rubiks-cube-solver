class Cube { //<>// //<>// //<>// //<>//

  Cubie[] cube;
  ArrayList<ArrayList<Cubie>> cubieLists = new ArrayList();
  HumanAlgorithm hAlgorithm;

  int len = 0;
  int ct = 0;
  float axisIndex = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
  char currentAxis = 'a';
  float rotationAngle = 0;
  boolean turning = false;
  boolean clockwise = true;
  boolean turningWholeCube = false;

  Cube() {
    // Sets array size for cubies to be stored in for any cube size
    // If dimensions of cube are 1x1x1, sets the cube size manually as the math above doesn't cater for it.
    cube = dim == 1 ? new Cubie[1] : new Cubie[(int)(pow(dim, 3) - pow(dim-2, 3))];
    // len stores the number value of cubies in cube.
    len = cube.length;
    // index of cubie that's being stored to cube object
    print("\tCube\t\tx\ty\tz\tcol1\tcol2\tcol3\tcol4\tcol5\tcol6\tnCols\tCubieType\n");
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
          print("\tCube " + (index+1) + "\t");
          cube[index] = new Cubie(matrix, x-axis, y-axis, z-axis);

          index++;
        }
      }
    }
    // Instantiate new human algorithm for this cube.
    hAlgorithm = new HumanAlgorithm(this);
  }
  // Shows cube to screen
  void show(Move m) {
    // Determines whether rotation is clockwise or not
    int angleMultiplier = clockwise ? -1 : 1;
    // For every cubie in the cube
    for (Cubie qb : cube) {
      // saves transformation state.
      push(); 
      // desired position determined by Move m's angle value - updates and rotates each cubie
      // If cubie axis > 0 AND it's equal to move axis then rotate by appropriate axis using move angle
      if (abs(qb.z) > 0 && qb.z == m.z) {
        rotateZ(m.angle);
      } else if (abs(qb.x) > 0 && qb.x == m.x) {
        rotateX(m.angle);
      } else if (abs(qb.y) > 0 && qb.y == m.y) {
        rotateY(-m.angle);
      }
      // If the whole cube is turning
      if (turningWholeCube) {
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
      qb.show();
      pop();
    }
  }
  // Update the cube
  void update() {
    if (turning) {

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
        turning = false;
        int dir = clockwise ? 1 : -1;
        if (turningWholeCube) finishTurningWholeCube(currentAxis, dir);
      }
    }
  }
  // Changes booleans to rotate the entire cube along axis
  void rotateWholeCube(char axis, int dir) {
    // If cube is already rotating, leave function 
    if (turning) return;
    turning = true;
    turningWholeCube = true;
    clockwise = dir == 1 ? true : false;
    currentAxis = axis;
    print("turning is now true\n");
    // if (fixCubeRotation) {
    //   rotationAngle = 0;
    //   turning = false;
    //   finishTurningWholeCube(axis, dir);
    // }
  }
  // finish turning whole cube
  void finishTurningWholeCube(char axisFace, int dir) {
    print("finishTurningWholeCube\n");
    turning = false;
    turningWholeCube = false;

    // turn every cubie
    int i = 0;
    for (Cubie c : cube) {i++;c.turn(axisFace, dir); print("Cube " + i + " turned.\n");}

    // for each axis (E.g. -1, 0, 1)
    for (float index = -axis; index <= axis; index++) {
      // get all the cubies in that particular axis index and store to cubieLists
      cubieLists = getAllCubiesToRotate(index, axisFace);
      for (int j = 0; j < cubieLists.size(); j++) {
        // temp stores arraylist of cubies on specific face
        ArrayList<Cubie> temp = cubieLists.get(j);
        ArrayList<Cubie> oldList = new ArrayList(temp);
        for (int k = 0; k < dim-1-j*2; k++) {
          // if counterclockwise - Re-order cubies from the end of list, add to the start
          if (dir == -1) {temp.add(0, temp.remove(temp.size()-1)); } 
          // Removes from start, adds to end of list
          else {temp.add(temp.remove(0));
          }
        }
        // returns cubies to cube
        returnListToCube(oldList, temp, axisFace, index, j);
      }
    }
  }
  // Index represents the row/col of the axis the cubies are collected from
  ArrayList<ArrayList<Cubie>> getAllCubiesToRotate(float index, char axisFace) {
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
    for (int i = 0; i< temp.size(); i++) {
      print("New list - with " + temp.get(i).size() + " elements\n");
      for (Cubie c : temp.get(i)) {
        print("  " + c.x + "\t" + c.y + "\t" + c.z + "\n");
      }
    }
    return temp;
  } 
  // return list of cubies to the cube object
  void returnListToCube(ArrayList<Cubie> oldList, ArrayList<Cubie> list, char faceAxis, float index, int listNumber) {
    print("\n------- Return list to cube -------\n");
    int size = dim-listNumber * 2;
    // If the cubie along the x axis, right side as +1
    // Then add new cubie from list and remove from list.
    // Else maintain original cubie values.
    print(list.size() + " cubies left to return\n");
    int cr = 0;
    switch(faceAxis) {
    case 'X': 
        for(int i = 0; i < oldList.size(); i++) {
        //   for (Cubie c : cube) {
            
        //     if (list.size() == 0) continue;
        //     if(list.size() == 1 && oldList.get(i).x == c.x && oldList.get(i).y == c.y && oldList.get(i).z == c.z)  {
        //       c = list.remove(0).copy();
        //     }
        //     if(oldList.get(i) == c) {
            
        //       print("Found :\t\t" + c.x + "\t"
        //                      + c.y + "\t"
        //                      + c.z + "\t");
        //       print("\t" + colToString(c.colours[0]) + "\t"
        //                + colToString(c.colours[1]) + "\t"
        //                + colToString(c.colours[2]) + "\t"
        //                + colToString(c.colours[3]) + "\t"
        //                + colToString(c.colours[4]) + "\t"
        //                + colToString(c.colours[5]) + "\n");
        //     c = list.remove(0).copy();
        //     print("Now :\t\t" + c.x + "\t"
        //                      + c.y + "\t"
        //                      + c.z + "\t");
        //     print("\t" + colToString(c.colours[0]) + "\t"
        //                + colToString(c.colours[1]) + "\t"
        //                + colToString(c.colours[2]) + "\t"
        //                + colToString(c.colours[3]) + "\t"
        //                + colToString(c.colours[4]) + "\t"
        //                + colToString(c.colours[5]) + "\n\n");
        //                cr++;
        //     print("Cubie " + cr + "\n"); 
        //   }
        // }
        for(int k = 0; k < cube.length; k++)  {
          if (cube[k] == oldList.get(i))  {
            print("Found :\t\t" + cube[k].x + "\t"
                                + cube[k].y + "\t"
                                + cube[k].z + "\t");
              print("\t" + colToString(cube[k].colours[0]) + "\t"
                       + colToString(cube[k].colours[1]) + "\t"
                       + colToString(cube[k].colours[2]) + "\t"
                       + colToString(cube[k].colours[3]) + "\t"
                       + colToString(cube[k].colours[4]) + "\t"
                       + colToString(cube[k].colours[5]) + "\n");
            cube[k] = list.remove(0).copy();
          }
          print("hi");
        }
      }


      if (list.size() == 0) {print("Success\n");} else {
        print(list.size() + " cubies left. Unsuccessful\n");
        print("       \tx\ty\tz\n");
        for (Cubie c : list) {
          print("Cubie: \t" + c.x + "\t" + c.y + "\t" + c.z + "\n");
        }
      }
      break;
    case 'Y':
      // Check if valid y axis

      break;
    case 'Z':
      // Check if valid z axis

      break;
    }

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
          print("\tCube " + (i+1) + "\t");
          print("\t" + cube[i].x + "\t" + cube[i].y + "\t" + cube[i].z + "\t" + colToString(cube[i].colours[0])
                                                                       + "\t" + colToString(cube[i].colours[1])
                                                                       + "\t" + colToString(cube[i].colours[2])
                                                                       + "\t" + colToString(cube[i].colours[3])
                                                                       + "\t" + colToString(cube[i].colours[4])
                                                                       + "\t" + colToString(cube[i].colours[5]) + "\n");
          i++;
        }
      }
    }
    
    print("------- END OF return list to cube -------\n\n");
    // int r = 0;
    // for(Cubie c : cube) {
    //   r++;
    //   print("Block " + r +  ":\t"+ c.x +"\t" + c.y + "\t" + c.z +"\n");
    // }
  }
  // ----- Getters -----
  // returns a list of all the cubies in the specified axis of cube - only works for 3x3x3 cube
  // todo optimise this function to not iterate through all cubies somehow?
  ArrayList<Cubie> getList(char axisFace, float index, int listNumber) {
    ArrayList<Cubie> list = new ArrayList();

    ArrayList<Cubie> topRow = new ArrayList();
    ArrayList<Cubie> rightRow = new ArrayList();
    ArrayList<Cubie> bottomRow = new ArrayList();
    ArrayList<Cubie> leftRow = new ArrayList();
    switch(axisFace) {
    case 'X':
      // Add top, right, bottom, left rows of the face
      // Adds them in a clockwise fashion - easier to interpret and keep track of
      // ------------
      // Inverts z axis value depending on which axis/index is being stored
      // This is to maintain storing in a clockwise fashion regardless of which face
      if (listNumber == 0) {
        for (Cubie c : cube) {
          // Adding top row
          if (c.x == index  && c.y == -1) {
            topRow.add(c);
          } // Adding right side
          else if (c.x == index  && c.y != -1 && c.z == 1) {
            rightRow.add(c);
          } // Adding bottom row 
          else if (c.x == index && c.y == 1 && c.z != 1) {
            bottomRow.add(c);
          } // Adding left side
          else if (c.x == index && c.y == 0 && c.z == -1) {
            leftRow.add(c);
          }
        }
      } else if (index != 0) {
        for (Cubie c : cube) {
          if (c.x == index && c.y == 0 && c.z == 0) {
            list.add(c);
          }
        }
      }
      break;
    case 'Y':
      for (Cubie c : cube) {
        if (c.y == index && c.z == -1) {
          topRow.add(c);
        } else if (c.y == index && c.x == 1) {
          rightRow.add(c);
        } else if (c.y == index && c.z == 1) {
          bottomRow.add(c);
        } else if (c.y == index && c.x == -1 && c.z == 0) {
          leftRow.add(c);
        }
      }
      break;
    case 'Z':
      for (Cubie c : cube) {
        if (c.z == index && c.y == -1) {
          topRow.add(c);
        } else if (c.z == index && c.x == 1) {
          rightRow.add(c);
        } else if (c.z == index && c.y == 1) {
          bottomRow.add(c);
        } else if (c.z == index && c.x == -1) {
          leftRow.add(c);
        }
      }
      break;
    }

    for (Cubie c : topRow) {
      list.add(c);
    }
    // print("top row added\n");
    for (Cubie c : rightRow) {
      list.add(c);
    }
    // print("right row added\n");
    for (Cubie c : bottomRow) {
      list.add(c);
    }
    // print("bottom row added\n");
    for (Cubie c : leftRow) {
      list.add(c);
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
