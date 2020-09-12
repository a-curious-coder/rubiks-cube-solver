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

      switch(stage) {
      case 0:
        whiteCross();
        break;
      case 1:

      }
    }
  }

  // Step 1
  // Solves the white cross on the cube.
  void whiteCross() {
    // If the D face does not have a white center
    if (!(getFaceColour('D') == white)) {
      // Positions the white center piece to the Downward face
      positionFace(white, 'D', 'X');
      println(turns);
      return;
    } else {
      println("White center cubie is on D face");
    }
    // if there are turns left to make, return to start this function again.
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(red);
    // Checks if the turns are empty, if not the edge hasn't finished moving so return.
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(orange);
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(blue);
    if (turns.length() != 0)  return;
    positionWhiteCrossEdge(green);
    if (turns.length() == 0) {
      println("Step 1 - White cross complete.");
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
      // Caters for moves later else it'll get stuck in a loop.
      turnCubeToFacePiece(edge, white, 'Y');

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

  // Positions 'face' with colour 'c' toward 'dir'
  void positionFace (color c, char face, char dir) {

    String faces = "RLUDFB";
    char fromFace = 'F';
    // checks every face for match with colour c
    // print("---- positionFace ----\n");
    for (int i = 0; i < faces.length(); i++) {
      // Locates the face of the cube that has the same colour as colour 'c' on the edge.
      if (getFaceColour(faces.charAt(i)) == c) {
        print("The face with " + c + " is located on the " + faces.charAt(i) + " face\n");
        // fromFace holds the face containing the same colour as c
        fromFace = faces.charAt(i);
        println("Face we're looking for: " + colToString(fromFace));
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

  // Returns the colours of the labelled faces
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

  }

  void positionBottomCorner() {

  }

  // finish bottom two rows (edges)

  // position top cross (pattern)

  // finish top cross pattern

  // get corners in correct position

  // final rotations (OLL)

  
}
