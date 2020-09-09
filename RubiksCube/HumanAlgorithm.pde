class HumanAlgorithm {

  Cube cube;
  String faces = "RLUDFB";


  String[] cols = {"Orange", "Red", "Yellow", "White", "Green", "Blue"};
  int middle = dim / 2;
  int stage = 0;

  boolean isLargerCube = false;

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
      solve = true;
      print("This is used for 3x3x3 cubes only.\n");
      switch(stage) {
      case 0:
        print("\n--- White cross stage ---\n");
        whiteCross();
        break;
      }
      print("Must've solved the cube?\n");
    }
  }


  // Solves the white cross on the cube.
  void whiteCross() {
    // 
    if (!(getFaceColour('D') == white)) {
      positionFace(white, 'D', 'X');
      print(turns);
      return;
    }

    if (turns.length() != 0) { 
      return;
    }
    print("White/Red stage\n");
    positionWhiteCrossEdge(red);

    // Checks if the turns are empty, if not the edge hasn't finished moving so return.
    if (turns.length() != 0) {
      print("White/Red not finished...");
      return;
    }
    print("White/Red stage finished\n");
    sequence.clear();
    print("White/Orange stage\n");
    positionWhiteCrossEdge(orange);
    if (turns.length() != 0) { 
      return;
    }
    print("White/Blue stage\n");
    positionWhiteCrossEdge(blue);
    if (turns.length() != 0) { 
      return;
    }
    print("White/Green stage\n");
    positionWhiteCrossEdge(green);
    if (turns.length() == 0) {
      print("Cross complete\n");
      stage++;
    }
  }

  // Positions an edge with white and color c in the (hopefully) correct place.
  void positionWhiteCrossEdge (color c) {
    color[] colours = {c, white};
    Cubie edge = findCenterEdge(colours);

    // CHECK IF EDGE IS AT BOTTOM ROW
    if (edge.y == 1) {
      print("\n----------------\n\n");
      print("The " + colToString(c) + " and " + colToString(white) + " edge is at the bottom row\n");
      // if the white face of the edge is facing DOWN, the same direction as the center white cubie
      if (edge.getFace(white) == 'D') {
        // The white face is facing the correct way
        // if the edge's other colour is not facing the same way as it's center cubie with same colour
        if (getFaceColour(edge.getFace(c)) != c) {
          print(colToString(c) + " is not correctly oriented.\n");
          char faceToTurn = edge.getFace(c);
          // it needs to be repositioned
          turns += "" + faceToTurn + faceToTurn;
          // add faceToTurn to the turns String
          // Throws it to top of cube for later
          print(faceToTurn + " " + faceToTurn + "\n");
        } else {
          print("must be correctly oriented\n");
        }
        return; // ignore this edge for now
      }
      // Get the face the white colour is facing on the cube
      char edgeFace = edge.getFace(white);
      // Get direction of 'F' face from edgeFace, store in temp
      String temp = getDirection(edgeFace, 'F');
      print("\ntemp :" + temp);
      // if there are two moves and they're the same
      if (temp.length() == 2 && temp.charAt(0) == temp.charAt(1)) {
        // rotate the entire cube instead of adding moves
        temp = "YY";
        print("\ntemp " + temp + "\n");
      }

      // Add temp moves to turns - edge should be at Down Front edge.
      turns += temp;
      // Add two front moves to turns to move this edge piece to top
      turns += "FF";
      return;
    } 

    // CHECK IF EDGE IS AT MIDDLE ROW
    if (edge.y == 0) {
      print("\n----------------\n\n");
      print("The " + colToString(c) + " and " + colToString(white) + " edge is at the middle row\n");
      // turnCubeToFacePiece(edge, white, 'Y');

      if (turns.length() > 0) {
        return;
      }
      print("edge.x : " + edge.x + "\n");
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
      print("\n----------------\n\n");
      print("The " + colToString(c) + " and " + colToString(white) + " edge is at the top row\n\n");
      // if the colour on face 'F' is not the same colour as c
      if (getFaceColour('F') != c) {
        // Set the face with colour'c' to the 'F'
        positionFace(c, 'F', 'Y');
        print("positioning face\n");

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
        print(turns);
      }
    }
  }


  void positionFace (color c, char face, char dir) {
    String faces = "RLUDFB";
    char fromFace = 'F';
    // checks every face for match with colour c
    print("---- positionFace ----\n");
    for (int i = 0; i < faces.length(); i++) {
      // Locates the face of the cube that has the same colour as colour 'c' on the edge.
      if (getFaceColour(faces.charAt(i)) == c) {
        print("The face with " + cols[i] + " is located on the " + faces.charAt(i) + " face\n");
        // fromFace holds the face containing the same colour as c
        fromFace = faces.charAt(i);
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

  // Returns the edge piece with the same colours as cubieColours
  Cubie findCenterEdge(color[] cubieColours) {
    for (int i = 0; i < edges.size(); i++) {
      if (edges.get(i).matchesColours(cubieColours)) {
        print("Found center edge\n");
        return edges.get(i);
      }
    }
    return null;
  }

  color getFaceColour(char f) {

    switch(f) {
    case 'U':
      return yellow;
    case 'D':
      return white;
    case 'R':
      return orange;
    case 'L':
      return red;
    case 'B':
      return blue;
    case 'F':
      return green;
    }
    return color(0);
  }

  // Bottom corner function 
  //
  // finish bottom two rows (edges)

  // position top cross (pattern)

  // finish top cross pattern

  // get corners in correct position

  // final rotations (OLL)

  
}
