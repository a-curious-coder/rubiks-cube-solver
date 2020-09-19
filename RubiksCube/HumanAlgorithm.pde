class HumanAlgorithm {

  Cube cube;
  String faces = "RLUDFB";
  String[] cols = {"Orange", "Red", "Yellow", "White", "Green", "Blue"};
  int stage = 0;
  int completedCorners = 0;
  int completedEdges = 0;
  boolean nextStep = false;
  boolean isLargerCube = false;
  boolean solved = false;

  HumanAlgorithm(Cube cube) {
    setColours();
    this.cube = cube;
    isLargerCube = dim > 3 ? isLargerCube = true : false;
  }

  void solveCube() {
    if (isLargerCube) {
      print("Larger cube solving coming soon...");
    }
    if (!isLargerCube) {

      switch(stage) {
      case 0:
        whiteCross();
        break;
      case 1:
        bottomCorners();
        break;
      case 2:
        finishMiddleEdges();
        break;
      case 3:
        yellowCross();
        break;
      case 4:
        fixYellowCrossEdges();
        break;
      case 5:
        topCorners();
        break;
      case 6: 
        finalRotations();
        break;
      case 7:
        // TODO: Evaluate whether cube is actually solved or not.
        if(cube.evaluateCube()) {
          solved = true;
          resetHumanAlgorithm();
          println("Rubik's cube is solved in " + counter + " moves.");
          counterReset = true;
        } else {
          println("Something went wrong during solve - try solving again.");
        }
        
        // TODO: print timer
        // TODO: print number of moves
        // TODO: pause after finished
        // TODO: rotate cube?
        break;
      }
    }
  }

  // Step 1
  // Solves the white cross on the cube.
  void whiteCross() {
    if (!(getFaceColour('D') == white)) {
      positionFace(white, 'D', 'X');
      return;
    }

    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(red);
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(orange);
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(blue);
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(green);
    if (turns.length() == 0) {
      println("Stage 1 - White cross complete.");
      stage++;
    }
  }

  void positionWhiteCrossEdge (color c) {
    color[] colours = {c, white};
    Cubie edge = findCenterEdge(colours);

    // CHECK IF EDGE IS AT BOTTOM ROW
    if (edge.y == 1) {
      // print("\n----------------\n\n");
      // print("The " + colToString(c) + " and " + colToString(white) + " edge is at the bottom row\n");
      // if the white face of the edge is facing DOWN, the same direction as the center white cubie
      if (edge.getFace(white) == 'D') {
        // The white face is facing the correct way
        // if the edge's other colour is not facing the same way as it's center cubie with same colour
        if (getFaceColour(edge.getFace(c)) != c) {
          // print(colToString(c) + " is not correctly oriented.\n");
          char faceToTurn = edge.getFace(c);
          // it needs to be repositioned
          turns += "" + faceToTurn + faceToTurn;
          // add faceToTurn to the turns String
          // Throws it to top of cube for later
          // print(faceToTurn + " " + faceToTurn + "\n");
        } else {
          // print("must be correctly oriented\n");
        }
        return; // ignore this edge for now
      }
      // Get the face the white colour is facing on the cube
      char edgeFace = edge.getFace(white);
      // Get direction of 'F' face from edgeFace, store in temp
      String temp = getDirection(edgeFace, 'F');
      // print("\ntemp :" + temp);
      // if there are two moves and they're the same
      if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
        // rotate the entire cube instead of adding moves
        temp = "YY";
        // print("\ntemp " + temp + "\n");
      }

      // Add temp moves to turns - edge should be at Down Front edge.
      turns += temp;
      // Add two front moves to turns to move this edge piece to top
      turns += "FF";
      return;
    } 

    // CHECK IF EDGE IS AT MIDDLE ROW
    if (edge.y == 0) {
      // print("\n----------------\n\n");
      // print("The " + colToString(c) + " and " + colToString(white) + " edge is at the middle row\n");
      // Caters for moves later else it'll get stuck in a loop.
      turnCubeToFacePiece(edge, white, 'Y');

      if (turns.length() > 0) {
        return;
      }
      // print("edge.x : " + edge.x + "\n");
      // If edge.x is on left side
      if (edge.x == -1) {
        // Add moves to turns
        turns += "L'U'L";
        // else if it's on right side
      } else {
        turns += "RUR'";
      }
    }

    // CHECK IF EDGE IS AT TOP ROW
    if (edge.y == -1) {
      // print("\n----------------\n\n");
      // print("The " + colToString(c) + " and " + colToString(white) + " edge is at the top row\n\n");
      // if the colour on face 'F' is not the same colour as c
      if (getFaceColour('F') != c) {
        // Set the face with colour'c' to the 'F'
        positionFace(c, 'F', 'Y');
        // print("positioning face\n");
        return;
      }

      // If the colour white on the edge piece is on the 'F' face
      if (edge.getFace(white) == 'F') {
        // Add these moves to turns
        turns += "ULF'L";
        // Else if the colour c on the edge is on the 'F' face
      } else if (edge.getFace(c) == 'F') {
        // Add these moves to turns
        turns += "FF";
      } else {
        // Store the face of the edge with colour c
        char edgeFace = edge.getFace(c);
        // If the edge face is the same as / on the 'U' face
        if (edgeFace == 'U') {
          // edgeFace changes to whatever cube face the white face of the edge is located.
          edgeFace = edge.getFace(white);
        }

        // temp stores the turns required to move the edgeFace to the 'F' face
        String temp = getTurns(edgeFace, 'F', 0);
        // if temp has 2 moves and they're the same, they will be replaced with two 'U' moves
        temp = replaceDoubles(temp, 'U');
        // Add temp moves to turns
        turns += temp;
        // print(turns);
      }
    }
  }

  void positionFace (color c, char face, char dir) {

    String faces = "RLUDFB";
    char fromFace = 'F';
    // checks every face for match with colour c
    // print("---- positionFace ----\n");
    for (int i = 0; i < faces.length(); i++) {
      // Locates the face of the cube that has the same colour as colour 'c' on the edge.
      if (getFaceColour(faces.charAt(i)) == c) {
        // print("The face with " + colToString(c) + " is located on the " + faces.charAt(i) + " face\n");
        // fromFace holds the face containing the same colour as c
        fromFace = faces.charAt(i);
        // println("Face we're looking for: " + colToString(getFaceColour(fromFace)));
        break;
      }
    }

    String temp = getDirection(fromFace, face);
    // if temp has 2 moves AND they're the same move then
    if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
      // temp gets renewed with dir * 2
      temp = "" + dir + dir;
    }
    // Adds the temp moves to turns
    turns += temp;
  }

  // Replaces two of the same move with dir.
  String replaceDoubles(String temp, char dir) {
    // If temp has two moves and they're the same
    if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
      // Change the moves to dir * 2
      temp = "" + dir + dir;
    }
    return temp;
  }

  void turnCubeToFacePiece(Cubie edge, color c, char dir) {
    // edgeFace is the face that the colour c is located on the edge
    char edgeFace = edge.getFace(c);
    // temp stores direction from dgeFace to 'F' face and stores to temp
    String temp = getDirection(edgeFace, 'F');
    // If temp has two moves and they're the same
    if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
      // Change the moves to dir * 2
      temp = "" + dir + dir;
    }
    // Add temp moves to turns
    turns += temp;
  }

  Cubie findCenterEdge(color[] cubieColours) {
    for (int i = 0; i < edges.size(); i++) {
      if (edges.get(i).matchesColours(cubieColours)) {
        // println("Found center edge");
        return edges.get(i);
      }
    }
    return null;
  }

  color getFaceColour(char f) {

    int middle = dim / 2;
    int last = dim - 1;
    int index = 0;
    color colour = color(0);


    switch(f) {
    case 'U':
      for(Cubie c : centers)  {
        // Finding center cubie located on U face
        if(c.y == -axis)  {
          for(color col : c.colours)  {
            // if colour is not black (only other colour can be the face's current colour)
            colour = col != color(0) ? col : colour;
          }
        }
      }
      return colour;
    case 'D':
      for(Cubie c : centers)  {
        // Finding center cubie located on U face
        if(c.y == axis)  {
          for(color col : c.colours)  {
            // if colour is not black (only other colour can be the face's current colour)
            colour = col != color(0) ? col : colour;
          }
        }
      }
      
      return colour;
    case 'R':
      for(Cubie c : centers)  {
        // Finding center cubie located on U face
        if(c.x == axis)  {
          for(color col : c.colours)  {
            // if colour is not black (only other colour can be the face's current colour)
            colour = col != color(0) ? col : colour;
          }
        }
      }
      
      return colour;
    case 'L':
      for(Cubie c : centers)  {
        // Finding center cubie located on U face
        if(c.x == -axis)  {
          for(color col : c.colours)  {
            // if colour is not black (only other colour can be the face's current colour)
            colour = col != color(0) ? col : colour;
          }
        }
      }
      
      return colour;
    case 'B':
      for(Cubie c : centers)  {
        // Finding center cubie located on U face
        if(c.z == -axis)  {
          for(color col : c.colours)  {
            // if colour is not black (only other colour can be the face's current colour)
            colour = col != color(0) ? col : colour;
          }
        }
      }
      
      return colour;
    case 'F':
      for(Cubie c : centers)  {
        // Finding center cubie located on U face
        if(c.z == axis)  {
          for(color col : c.colours)  {
            // if colour is not black (only other colour can be the face's current colour)
            colour = col != color(0) ? col : colour;
          }
        }
      }
      
      return colour;
    }
    return color(0);
  }

  // Step 2
  // Bottom corner function 
  void bottomCorners()  {
    color[][] corners = {{red, green}, {green, orange}, {orange, blue}, {blue, red}};
    // if(!nextCorner) return;
      
    while(completedCorners < 4) {
      positionBottomCorner(corners[completedCorners][0], corners[completedCorners][1]);
      if(turns.length() > 0)  return;
      completedCorners++;
    }
    println("Stage 2 - Bottom corners aligned complete.");
    stage++;
  }
  
  void positionBottomCorner(color c1, color c2) {
    // c1 is left of c2 when white is in correct position on cube.
    color[] cornerCols = {c1, c2, white};
    Cubie corner = findCorner(cornerCols);
    PVector from = new PVector(corner.x, corner.y, corner.z);
    // println("Positioning : " + colToString(c1) + ", " + colToString(c2) + ", White");
    // Top, Right, Front corner.
    PVector to = new PVector(axis, -axis, axis);

    if(!(getFaceColour('F') == c1))  {
      positionFace(c1, 'F', 'Y');
      return;
    }
    // If corner is on top row
    if(corner.y == -axis) {
      // println("Top row: " + colToString(c1) + " " + colToString(c2) + " " + colToString(white));
      
      String temp = getDirectionOfCorners(from, to);
      if(!temp.equals(""))  {
        turns += temp;
        return;
      }

      // If colour on top,right,front is white then
      turns += corner.colours[4] == white ? "F'U'F" : "";
      turns += corner.colours[4] == c1 ? "RUR'" : ""; // red
      turns += corner.colours[4] == c2 ? "F'UUFUF'U'F" : ""; // green
    }
    // If corner is on bottom row
    else if(corner.y == axis) {
      // println("Bottom row: " + colToString(c1) + " " + colToString(c2) + " " + colToString(white));
      
      to = new PVector(axis, axis, axis);
      from = new PVector(corner.x, corner.y, corner.z);
      // if corner is not bottom,right,front OR corner is incorrectly oriented
      if(!from.equals(to) || corner.colours[3] != white) {
        String temp = getDirectionOfCorners(from, to);
        // println(from.x + " " + from.y + " " + from.z);
        // println(to.x + " " + to.y + " " + to.z);
        turns += temp;
        turns += "RUR'";
        turns += reverseMoves(temp);
      }
    }
    
  }


  Cubie findCorner(color[] cubieColours)  {
    for(Cubie c : corners)  {
      if(c.matchesColours(cubieColours))  {
        // println("Found corner");
        return c;
      }
    }
    return null;
  }

  // Step 3
  // finish bottom two rows (edges)
  void finishMiddleEdges()  {
    color[][] middleEdges = {{blue, red}, {red, green}, {green, orange}, {orange, blue}};
    while(completedEdges < 4) {
      // println("Trying to orient " + colToString(middleEdges[completedEdges][0]) + " and " + colToString(middleEdges[completedEdges][1]) + " edge");
      positionMiddleEdge(middleEdges[completedEdges][0], middleEdges[completedEdges][1]);
      if(turns.length() > 0)  {
        return;
      }
      completedEdges++;
    }
    println("Stage 3 - middle edges correctly positioned");
    stage++;
  }

  void positionMiddleEdge(color c1, color c2) {
    color[] cols = {c1, c2};
    Cubie middleEdge = findCenterEdge(cols);
    // Where the edge is currently located
    PVector from = new PVector(middleEdge.x, middleEdge.y, middleEdge.z);
    // This will hold the location of where we want this edge to be
    PVector to = new PVector(middle, -axis, axis);

    // if edge in on top of cube
    if(middleEdge.y == -axis) {
      // println("Edge is located at top");
      // println("Edge location: " + from + "\tto: " + to);

      // Check the colour at index 2 (Colour in index 2 always faces UP)
      // If colour 2 is c1 then it becomes c2 else becomes c1 if it's c2
      color frontColour = middleEdge.colours[2] == c1 ? c2 : c1;
      if(getFaceColour('F') != frontColour) {
        // Orient the cube to have the face with fColour at it's center to the Front
        positionFace(frontColour, 'F', 'Y');
        return;
      }
      
      // Figures out where the cubie is and where it needs to be - orients the cube so it's at the front.
      String temp = getDirectionOfEdges(from, to);
      if(!temp.equals(""))  {
        turns += temp;
        return;
      }

      // If c1 is facing up on top of cube in the center between top corners of F face
      // Needs to be placed to the right middle
      if(frontColour == c1) {
        // Places cubie to right side
        turns += "URU'R'U'F'UF";
      } else {
        // Places cubie to left side
        turns += "U'L'ULUFU'F'";
      }
      // If edge is in the middle of the cube
    } else if(middleEdge.y == middle) {
      // println("MIDDLE");
      // println("Edge location: " + from);
      // Assume it's incorrectly positioned
      boolean incorrectlyPositioned = true;
      // If 
      if(middleEdge.colours[2] == c1) {
        color frontColour = c2;
        to = new PVector(-axis, middle, axis);
        incorrectlyPositioned = (from.equals(to) && middleEdge.colours[4] == getFaceColour('F'));
      } else {
        color frontColour = c1;
        to = new PVector(axis, middle, axis);
        incorrectlyPositioned = (from.equals(to) && middleEdge.colours[4] == getFaceColour('F'));
      }

      if(!incorrectlyPositioned)  {
        turnCubeToFacePiece(middleEdge, c1, 'Y');
        if(turns.length() != 0) return;
        
        if(middleEdge.x == axis)  {
          turns += "URU'R'U'F'UF";
        } else {
          turns += "U'L'ULUFU'F'";
        }
      }
    }
  }

  // Step 4
  // position top cross (pattern)
  void yellowCross()  {
    boolean[] topEdges = new boolean[4];
    int edgeCount = 0;
    //        Indexes     0    1    2   3
    // Edges are ordered - Back, Front, Left, Right
    for(Cubie c : edges)  {
      if(c.y == -axis) {
        if(c.x == middle && c.z == -axis) topEdges[0] = c.colours[2] == yellow ? true : false;
        if(c.x == middle && c.z == axis) topEdges[1] = c.colours[2] == yellow ? true : false;
        if(c.x == -axis && c.z == middle) topEdges[2] = c.colours[2] == yellow ? true : false;
        if(c.x == axis && c.z == middle) topEdges[3] = c.colours[2] == yellow ? true : false;
      }
    }

    for(boolean b : topEdges) {
      edgeCount += b ? 1 : 0;
    }

    // If all edges have yellow facing up - cross is done.
    if(edgeCount == topEdges.length)  {
      stage++;
      println("Stage 4 - Yellow cross complete");
      return;
    }

    // If all edges on top of cube don't have any yellow facing up
    if(edgeCount == 0)  {
      turns += "FRUR'U'F'";
      return;
    }

    // If there is a line across top face, perform moves
    if(topEdges[0] && topEdges[1])  {
      turns += "UFRUR'U'F''";
      return;
    } else if (topEdges[2] && topEdges[3]) {
      turns += "FRUR'U'F'";
      return;
    }
    // Objective here is to move the L to top-right corner of cube
    if(topEdges[0] && topEdges[3])  {
      turns += "U'";
      // If L symbol is back and left or front and right
    } else if(topEdges[1] && topEdges[2]) {
      turns += "U";
    } else if(topEdges[1] && topEdges[3]){
      turns += "UU";
    }
    turns +="FRUR'U'RUR'U'F'";
  }

  // Step 5
  // Ensure top cross pattern correlates with neighboured face colours
  void fixYellowCrossEdges()  {
    
    // Position green face to the front.
    if(getFaceColour('F') != green) {
      positionFace(green, 'F', 'Y');
      return;
    }
    boolean perfectMatch = true;
    Cubie[] topEdges = new Cubie[4];
    color[] edgeCols = new color[4];
    // Order - Front, Right, Back, Left
    for(Cubie c : edges)  {
      if(c.y == -axis) {
        if(c.x == middle && c.z == axis)  {edgeCols[0] = c.colours[4]; topEdges[0] = c;}
        if(c.x == axis && c.z == middle)  {edgeCols[1] = c.colours[0]; topEdges[1] = c;}
        if(c.x == middle && c.z == -axis) {edgeCols[2] = c.colours[5]; topEdges[2] = c;}
        if(c.x == -axis && c.z == middle) {edgeCols[3] = c.colours[1]; topEdges[3] = c;}
      }
    }
    if(edgeCols[0] != green)  {
      turns += "U";
      return;
    }
    // Iterate through each colour in edgeCols and check if they're in the correct order
    for(int i = 0; i < edgeCols.length; i++) {
      if(edgeCols[i] == blue) {
        // if col 3
        if(i == edgeCols.length-1) {
          if(edgeCols[0] != red  || edgeCols[1] != green) {perfectMatch = false;}
        }
        // if col 2
        if(i == edgeCols.length-2) {
          if(edgeCols[3] != red || edgeCols[0] != green) {perfectMatch = false;}
        }
        // if col 1
        if(i == edgeCols.length-3)  {
          if(edgeCols[2] != red || edgeCols[3] != green) {perfectMatch = false;}
        }
        if( i == 0) {
          if(edgeCols[1] != red || edgeCols[2] != green) {perfectMatch = false;}
        }
      }
    }
    if(perfectMatch)  {
      // Ensure orientation of top edges correlates with face colours.
      for(int j = 0; j < edgeCols.length; j++) {
      Cubie c = topEdges[j];
        if(edgeCols[j] == green)  {
          if(c.x == -axis && c.z == middle)     { 
            turns += "U'";
          } else if(c.x == axis && c.z == middle) { 
            turns += "U";
          } else if(c.x == middle & c.z == -axis) { 
            turns += "UU";
          }
          stage++;
          println("Stage 5 - Yellow cross edges positioned correctly");
          return;
        }
      }
    }
    if(edgeCols[1] == red && edgeCols[2] != blue)  {
      turns += "URUR'URUUR'U";
    } else if(edgeCols[1] == red && edgeCols[2] == blue)  {
      turns += "UURUR'URUUR'UUBUB'UBUUB'U";
    } else if(edgeCols[1] == blue && edgeCols[2] == red) {
      turns += "U'BUB'UBUUB''U";
    } else if(edgeCols[1] == orange && edgeCols[2] != blue) {
      turns += "FUF'UFUUF'U";
    } else if(edgeCols[1] == blue && edgeCols[2] == orange) {
      turns += "BUB'UBUUB''U";
    } else if(edgeCols[1] == red && edgeCols[2] == orange)  {
      turns += "URUR'URUUR'U";
    }
  }
  // Step 6
  // get corners in correct position
  void topCorners()  {
    // if(!nextStep) return;
    int correctlyAllocated = 0;
    // Frontleft, backleft, backright, frontright
    Cubie[] topCorners = new Cubie[4];
    PVector from = new PVector();
    for(Cubie c : corners)  {
      if(c.y == -axis)  {
        if(c.x == -axis && c.z == axis)  topCorners[0] = c;
        if(c.x == -axis && c.z == -axis)  topCorners[1] = c;
        if(c.x == axis && c.z == -axis)  topCorners[2] = c;
        if(c.x == axis && c.z == axis)  topCorners[3] = c;
      }
    }
    // Check if any of the corners are correctly oriented
    // Green face should be at front from last step
    if(topCornerInCorrectLocation('L', 'U', 'F', topCorners[0]))  {
      // println("Top corner frontleft is correctly allocated");
      correctlyAllocated++;
    }

    if(topCornerInCorrectLocation('L', 'U', 'B', topCorners[1]))  {
      // println("Top corner backleft is correctly allocated");
      correctlyAllocated++;
      from = new PVector(topCorners[1].x, topCorners[1].y, topCorners[1].z);
    }

    if(topCornerInCorrectLocation('R', 'U', 'B', topCorners[2]))  {
      // println("Top corner backright is correctly allocated");
      correctlyAllocated++;
      from = new PVector(topCorners[2].x, topCorners[2].y, topCorners[2].z);
    }

    if(topCornerInCorrectLocation('R', 'U', 'F', topCorners[3]))  {
      // println("Top corner frontright is correctly allocated");
      correctlyAllocated++;
      from = new PVector(topCorners[3].x, topCorners[3].y, topCorners[3].z);
    }
    // If none are correctly positioned, perform moves to get at least one in correct position
    if(correctlyAllocated == 0) {
      turns += "URU'L'UR'U'L";
      return;
    }
    // delay(2500);
    if(correctlyAllocated == 4) {
      println("Stage 6 - Corners correctly relocated");
      stage++;
      return;
    }
    nextStep = !nextStep;
    // println("Number of corners correctly allocated: " + correctlyAllocated);
    // Vector of top, right, front corner (Where we want the correctly positioned cubie to go)
    PVector to = new PVector(axis, -axis, axis);
    String temp = getDirectionOfCorners(from, to);
    turns += temp;
    turns += "URU'L'UR'U'L";
    turns += reverseMoves(temp);
  }

  boolean topCornerInCorrectLocation(char f1, char f2, char f3, Cubie corner)  {

    color c1 = getFaceColour(f1);
    color c2 = getFaceColour(f2);
    color c3 = getFaceColour(f3);

    // if getFace doesn't return a face with a colour on, it's not on this corner
    // Aka it's not in the correct corner location
    if(corner.getFace(c1) == ' ') {return false;}
    if(corner.getFace(c2) == ' ') {return false;}
    if(corner.getFace(c3) == ' ') {return false;}
    return true;

  }
  // Step 7
  // final rotations (OLL)
  int cubiesTurned = 0;
  void finalRotations() {
    if(getFaceColour('D') != white) {
      positionFace(white, 'D', 'X');
      return;
    }
    Cubie[] topCorners = new Cubie[4];
    for(Cubie c : corners)  {
      if(c.y == -axis)  {
        if(c.x == -axis && c.z == axis)  topCorners[0] = c;
        if(c.x == -axis && c.z == -axis)  topCorners[1] = c;
        if(c.x == axis && c.z == -axis)  topCorners[2] = c;
        if(c.x == axis && c.z == axis)  topCorners[3] = c;
      }
    }
    // If top, right, front corner is correctly oriented
    if(correctlyOriented(topCorners[3]))  {
      // If all 4 top corners have been turned
      if(cubiesTurned == 4) {
        // FINISHED SOLVING - THIS TOOK TOO LONG
        println("Stage 7 - Orient top corners\nCube solved.");
        stage++;
        return;
      } else {
        // Rotate U face to move different corner to axis,axis,axis
        turns += "U";
        cubiesTurned++;
        return;
      }
    } else {
      // Perform necessary algorithms to solve cube
      turns += "R'D'RDR'D'RD";
    }
  
  }

  // Checks if upward facing colour is yellow - correctly oriented
  boolean correctlyOriented(Cubie c) {
    return (c.colours[2] == yellow);
  }

  void resetHumanAlgorithm()  {
    cubiesTurned = 0;
    completedCorners = 0;
    completedEdges = 0;
    stage = 0;
    solve = !solve;      
  }

}