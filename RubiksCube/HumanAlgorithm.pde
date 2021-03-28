class HumanAlgorithm {

  Cube cube;
  int stage = 0;
  int completedCorners = 0;
  int completedEdges = 0;
  int solutionMoves = 0;
  String faces = "RLUDFB";
  String[] cols = {"Orange", "Red", "Yellow", "White", "Green", "Blue"};
  boolean nextStep = false;
  boolean isLargerCube = false;
  boolean solved = false;
  boolean solveStarted = false;
  boolean captionsOn = true;
  long start;
  HumanAlgorithm(Cube cube) {
    setColours();
    this.cube = cube;
    isLargerCube = dim > 3 ? isLargerCube = true : false;
  }
  
  // Responsible for solving the cube and applying the appropriate stage
  void solve() {
    if(!solveStarted) {
      start = System.currentTimeMillis();
      solveStarted = true;
    }
    if(testing) captionsOn = false;
    memConsumptionArray.add(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory());
    if (isLargerCube) {
      print("Larger cube solving coming soon...");
      return;
    }
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
      if(cube.evaluateCube()) {
        solved = true;
        resetHumanAlgorithm();
        long end = System.currentTimeMillis();
        float duration = (end-start) / 1000F;

        if(captionsOn)  {
          println("Rubik's cube\nSolved in " + moveCounter + " moves.\nSolved in " + duration + " seconds.");
          outputBox.append("Rubik's cube\nSolved in " + moveCounter + " moves.\nSolved in " + duration + " seconds.\n");
        }
        solutionMoves = moveCounter;
        counterReset = true;
        hAlgorithmRunning = false;
        moveCounter = solutionMoves;
      } else {
        if(captionsOn)  println("Something went wrong during solve - try solving again.");
      }
      solveStarted = false;
      solving = false;
      break;
    }
  }

  /**
  * Step 1
  * Solves the white cross on the cube
  */
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
      if(captionsOn)    {
        println("Stage 1 - White cross complete.");
        outputBox.setText("Step 1 - White cross complete\n");
      }
      stage++;
    }
  }

  /**
  * Positions/Aligns the white edges to the appropriate centers
  *
  * @param  c The center colour we need to align the white edge to. The white edge should already be aligned with the white center
  */
  void positionWhiteCrossEdge (color c) {
    color[] colours = {c, white};
    Cubie edge = findCenterEdge(colours);

    // IF EDGE IS IN BOTTOM ROW
    if (edge.y == 1) {
      // if the white face of the edge is facing DOWN, the same direction as the center white cubie
      if (edge.getFace(white) == 'D') {
        // The white face is facing the correct way
        // if the edge's other colour is not facing the same way as it's center cubie with same colour
        if (getFaceColour(edge.getFace(c)) != c) {
          char faceToTurn = edge.getFace(c);
          // it needs to be repositioned
          turns += "" + faceToTurn + faceToTurn;
          // add faceToTurn to the turns String
          // Throws it to top of cube for later
          // print(faceToTurn + " " + faceToTurn + "\n");
        }
        return; // ignore this edge for now
      }
      // Get the face the white colour is facing on the cube
      char edgeFace = edge.getFace(white);
      // Get direction of 'F' face from edgeFace, store in temp
      String temp = getDirection(edgeFace, 'F');
      // if there are two moves and they're the same
      if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
        // rotate the entire cube instead of adding moves
        temp = "YY";
      }

      // Add temp moves to turns - edge should be at Down Front edge.
      turns += temp;
      // Add two front moves to turns to move this edge piece to top
      turns += "FF";
      return;
    } 

    // IF EDGE IS IN MIDDLE ROW
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

    // IF EDGE IS IN TOP ROW
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

  // Replaces two of the same move with dir.
  /**
  * Replaces two of the same move with a 'single' double move
  *
  * @param  temp  The string of moves
  * @param  dir   The direction of the move
  * @return       The newly made double move. E.g. D, D turns into D2
  */
  String replaceDoubles(String temp, char dir) {
    // If temp has two moves and they're the same
    if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
      // Change the moves to dir * 2
      temp = "" + dir + dir;
    }
    return temp;
  }

  /**
  * Turn the cube to position the edge piece on the F face
  *
  * @param  edge  The edge we want at the front of the cube
  * @param  c     The colour that's on the edge we want at the front
  * @param  dir   The direction we need to be going to get the edge to be on the F face
  */
  void turnCubeToFacePiece(Cubie edge, color c, char dir) {
    // edgeFace is the face that the colour c is located on the edge
    char edgeFace = edge.getFace(c);
    // temp stores direction from edgeFace to 'F' face and stores to temp
    String temp = getDirection(edgeFace, 'F');
    // If temp has two moves and they're the same
    if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
      // Change the moves to dir * 2
      temp = "" + dir + dir;
    }
    // Add temp moves to turns
    turns += temp;
  }

  /** TODO: Rewrite comment
  * Finds the center edge
  *
  * @param  cubieColours  The colours of the edge cubie
  * @return               The edge to...
  */
  Cubie findCenterEdge(color[] cubieColours) {
    for (int i = 0; i < edges.size(); i++) {
      if (edges.get(i).matchesColours(cubieColours)) {
        // println("Found center edge");
        return edges.get(i);
      }
    }
    return null;
  }

  /**
  * Step 2
  * Position bottom corners of the cube
  */
  void bottomCorners()  {
    // if(completedCorners == 0) println("Entering stage 2");
    color[][] corners = {{red, green}, {green, orange}, {orange, blue}, {blue, red}};
    // if(!nextCorner) return;
      
    while(completedCorners < 4) {
      positionBottomCorner(corners[completedCorners][0], corners[completedCorners][1]);
      if(turns.length() > 0)  return;
      completedCorners++;
    }
    if(captionsOn)  {
      println("Stage 2 - Bottom corners aligned complete.");
      outputBox.append("Stage 2 - Bottom corners aligned complete.\n");
    }
    stage++;
  }
  
  /**
  * positions the corner piece we've found to the bottom.
  *
  * @param  c1
  * @param  c2
  */
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
      turns += corner.colours[0] == white ? "RUR'" : "";
      turns += corner.colours[4] == c2 ? "F'UUFUF'U'F" : "";
    }
    // If corner is on bottom row
    else if(corner.y == axis) {
      // println("Bottom row: " + colToString(c1) + " " + colToString(c2) + " " + colToString(white));
      
      to = new PVector(axis, axis, axis);
      from = new PVector(corner.x, corner.y, corner.z);
      // 
      // if corner is not bottom,right,front OR corner is incorrectly oriented
      if(!from.equals(to) || corner.colours[3] != white) {
        String temp = getDirectionOfCorners(from, to);
        // println("if this is being spammed, I'm stuck");
        // println(temp);
        // println(from.x + " " + from.y + " " + from.z);
        // println(to.x + " " + to.y + " " + to.z);
        turns += temp;
        turns += "RUR'";
        turns += reverseMoves(temp);
        // println(turns);
      }
    }
    
  }


  Cubie findCorner(color[] cubieColours)  {
    for(Cubie c : corners)  {
      if(c.matchesColours(cubieColours))  {
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
    if(captionsOn)  {
      println("Stage 3 - Middle edges correctly positioned");
      outputBox.append("Stage 3 - Middle edges correctly positioned\n");
    }
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
      if(captionsOn)  {
        println("Stage 4 - Yellow cross complete");
        outputBox.append("Stage 4 - Yellow cross complete\n");
      }
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
          if(captionsOn)  {
            println("Stage 5 - Yellow cross edges positioned correctly");
            outputBox.append("Stage 5 - Yellow cross edges positioned correctly\n");
          }
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
      if(captionsOn)  {
        println("Stage 6 - Corners correctly relocated");
        outputBox.append("Stage 6 - Corners correctly relocated\n");
      }
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
        if(captionsOn)  {
          println("Stage 7 - Orient top corners\nCube solved.");
          outputBox.append("Stage 7 - Orient top corners\nCube is solved!\n");
        }
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
    hSolve = !hSolve;      
  }

}