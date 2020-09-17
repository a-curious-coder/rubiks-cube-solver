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

Cubie[] upperCorners = new Cubie[4];
Cubie[] lowerCorners = new Cubie[4];
Cubie[] upperEdges = new Cubie[4];
Cubie[] lowerEdges = new Cubie[4];

// Get the direction of where the cube is going to rotate.
// E.g. L to F
String getDirection(char fromFace, char toFace) {
  // Checks to see if faces are valid for a X rotation
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);

  // If fromIndex and toIndex have valid faces
  if (fromIndex != -1 && toIndex != -1) {
    // print("Need to make x rotation\n");
    return foundRotation(fromIndex, toIndex, 'X');
  }

  // Checks to see if faces are valid for a Y rotation
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);

  // If fromIndex and toIndex have valid faces
  if (fromIndex != -1 && toIndex !=-1) {
    // print("Need to make y rotation\n");
    return foundRotation(fromIndex, toIndex, 'Y');
  }
  // Checks to see if faces are valid for a Z rotation
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);

  if (fromIndex != -1 && toIndex != -1) {
    // print("Need to make z rotation\n");
    return foundRotation(fromIndex, toIndex, 'Z');
  }
  return "";
}

// Finds out whether the rotation should be clockwise / anticlockwise
String foundRotation(int fromIndex, int toIndex, char turnCharacter) {
  // E.g. L, F  = 1, 0
  String finalString = "";
  // If there are 2 of the same move
  // Clockwise / Anticlockwise doesn't matter - end up in same place.
  if (abs(fromIndex - toIndex) == 2) {
    return "" + turnCharacter + turnCharacter;
  }
  
  if (fromIndex <= toIndex) {
    // adds the turnCharacters as they came, clockwise rotations
    for (int i = fromIndex; i < toIndex; i++) { 
      finalString += turnCharacter;
    }
  } else {
    // Changes the moves to anticlockwise rotations
    for (int i = toIndex; i < fromIndex; i++) { 
      finalString += turnCharacter + "\'";
    }
  }
  return finalString;
}

String getTurns(char fromFace, char toFace, int index) {
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index ==0) {
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
  // println("Upper corners");
  // for(Cubie c : upperCorners) {
    // println(c.details());
  // }
  // println("Lower corners");
  // for(Cubie c : lowerCorners) {
    // println(c.details());
  // }

  int fromIndex = getLocationOfCubie(upperCorners, from);
  int toIndex = getLocationOfCubie(upperCorners, to);

  if(fromIndex >= 0 && toIndex >= 0) {
    return foundRotation(fromIndex, toIndex, 'U');
  }

  fromIndex = getLocationOfCubie(lowerCorners, from);
  toIndex = getLocationOfCubie(lowerCorners, to);

  if(fromIndex >= 0 && toIndex >= 0) {
    return foundRotation(fromIndex, toIndex, 'D');
  }

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

  if(fromIndex >= 0 && toIndex >= 0)  {
    return foundRotation(fromIndex, toIndex, 'U');
  }

  fromIndex = getLocationOfCubie(lowerEdges, from);
  toIndex = getLocationOfCubie(lowerEdges, to);
  if(fromIndex >= 0 && toIndex >= 0)  {
    return foundRotation(fromIndex, toIndex, 'D');
  }

  return "";
}

// Returns the index with the matching values as location from corners arraylist
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
