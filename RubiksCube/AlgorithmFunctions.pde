String XRotation = "FDBU";
String YRotation = "FLBR";//'F', 'R', 'B', 'R'};
String ZRotation = "LDRB";//{'L', 'D', 'R', 'B'};

color[] colours = new color[6];
color orange = color(255, 140, 0);
color red = color(255, 0, 0);
color white = color(255);
color yellow = color(255, 255, 0);
color green = color(0, 255, 0);
color blue  = color(0, 0, 255);
color defaultRGB = color(0);

Cubie[] upperCorners = new Cubie[4];
Cubie[] lowerCorners = new Cubie[4];
Cubie[] upperEdges = new Cubie[4];
Cubie[] lowerEdges = new Cubie[4];

// Get the direction of where the cube is going to rotate. - E.g. L to F
String getDirection(char fromFace, char toFace) {
  // Checks to see if faces are valid for a X rotation
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);

  if (fromIndex != -1 && toIndex != -1) {
    return foundRotation(fromIndex, toIndex, 'X');
  }

  // Checks to see if faces are valid for a Y rotation
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);

  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'Y');
  }
  // Checks to see if faces are valid for a Z rotation
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);

  if (fromIndex != -1 && toIndex != -1) {
    return foundRotation(fromIndex, toIndex, 'Z');
  }
  return "";
}

// Determines whether the rotation should be clockwise / anticlockwise or 2 rotations
String foundRotation(int fromIndex, int toIndex, char turnCharacter) {
  // E.g. L, F  = 1, 0
  String finalString = "";
  // If there are 2 of the same move
  if (abs(fromIndex - toIndex) == 2) {
    return "" + turnCharacter + turnCharacter;
  }
  
  if (fromIndex <= toIndex) {
    for (int i = fromIndex; i < toIndex; i++) { 
      finalString += turnCharacter + "\'";
    }
  } else {
    for (int i = toIndex; i < fromIndex; i++) { 
      finalString += turnCharacter;
    }
  }
  return finalString;
}

String getTurns(char fromFace, char toFace, int index) {
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index == 0) {
      return foundRotation(fromIndex, toIndex, 'L');
    } else {
      return foundRotation(fromIndex, toIndex, 'R');
    }
  }
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index ==0) {
      return foundRotation(fromIndex, toIndex, 'U');
    } else {
      return foundRotation(fromIndex, toIndex, 'D');
    }
  }
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index ==0) {
      return foundRotation(fromIndex, toIndex, 'B');
    } else {
      return foundRotation(fromIndex, toIndex, 'F');
    }
  }
  return "";
}

String getDirectionOfCorners(PVector from, PVector to)  {

  for(Cubie c : corners)  {
    if(c.y == -axis)  {
      // Back left, front left, front right, back right
      if(c.x == -axis && c.z == -axis) upperCorners[0] = c;
      if(c.x == -axis && c.z == axis) upperCorners[1] = c;
      if(c.x == axis && c.z == axis)  upperCorners[2] = c;
      if(c.x == axis && c.z == -axis) upperCorners[3] = c;
    } else if (c.y == axis) {
      if(c.x == -axis && c.z == -axis) lowerCorners[0] = c;
      if(c.x == -axis && c.z == axis) lowerCorners[1] = c;
      if(c.x == axis && c.z == axis)  lowerCorners[2] = c;
      if(c.x == axis && c.z == -axis) lowerCorners[3] = c;
    }
  }

  int fromIndex = getLocationOfCubie(upperCorners, from);
  int toIndex = getLocationOfCubie(upperCorners, to);

  if(fromIndex >= 0 && toIndex >= 0)  {return foundRotation(fromIndex, toIndex, 'U');}

  fromIndex = getLocationOfCubie(lowerCorners, from);
  toIndex = getLocationOfCubie(lowerCorners, to);

  if(fromIndex >= 0 && toIndex >= 0)  {return foundRotation(fromIndex, toIndex, 'D');}

  return "";
}

String getDirectionOfEdges(PVector from, PVector to)  {

  for(Cubie c : edges)  {
    if(c.y == -axis)  {
      if(c.x == middle && c.z == -axis) upperEdges[0] = c;
      if(c.x == axis && c.z == middle) upperEdges[1] = c;
      if(c.x == middle && c.z == axis) upperEdges[2] = c;
      if(c.x == -axis && c.z == middle) upperEdges[3] = c;
    } else if (c.y == axis) {
      if(c.x == middle && c.z == -axis) lowerEdges[0] = c;
      if(c.x == -axis && c.z == middle) lowerEdges[1] = c;
      if(c.x == middle && c.z == axis) lowerEdges[2] = c;
      if(c.x == axis && c.z == middle) lowerEdges[3] = c;
    }
  }

  int fromIndex = getLocationOfCubie(upperEdges, from);
  int toIndex = getLocationOfCubie(upperEdges, to);
  if(fromIndex >= 0 && toIndex >= 0)  return foundRotation(fromIndex, toIndex, 'U');

  fromIndex = getLocationOfCubie(lowerEdges, from);
  toIndex = getLocationOfCubie(lowerEdges, to);
  if(fromIndex >= 0 && toIndex >= 0)  return foundRotation(fromIndex, toIndex, 'D');

  return "";
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
  
// Returns the index with the matching values same as location from corners arraylist
int getLocationOfCubie(Cubie[] cubies, PVector location)  {
  // println("Cubies length: " + cubies.length);
  // println("Location: " + location.x + " " + location.y + " " + location.z);
  for(int i = 0; i < cubies.length; i++)  {
    Cubie c = cubies[i];
    // println(c.details());
    if(location.x == c.x && location.y == c.y && location.z == c.z) return i;
  }
  return -1;
}

String reverseMoves(String moves) {
  String reverse = "";

  for(int i = 0; i < moves.length(); i++) {
    if(i+1 < moves.length() && moves.charAt(i+1) == '\'')  {
      reverse = moves.charAt(i) + reverse;
      i+= 1;
    } else {
      reverse = moves.charAt(i) + "'" + reverse;
    }
  }
  return reverse;
}

void setColours() {
  // variable[i] = IF x == value THEN color(a) ELSE color(b)
  colours[0] = orange;  // Orange
  colours[1] = red;  // Red
  colours[2] = yellow;  // Yellow
  colours[3] = white;  // White
  colours[4] = green;  // Green
  colours[5] = blue;  // Blue
}

String colToString(color c) {
  String col = "-----";
    col = c == orange ? "Orange" : col;
    col = c == red ? "Red" : col;
    col = c == yellow ? "Yellow" : col;
    col = c == white ? "White" : col;
    col = c == green ? "Green" : col;
    col = c == blue ? "Blue" : col;
  return col;
}
