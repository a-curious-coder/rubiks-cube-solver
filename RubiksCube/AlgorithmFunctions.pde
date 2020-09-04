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

// Get the direction of where the cube is going to rotate.
// E.g. L to F
String getDirection(char fromFace, char toFace) {
  // Checks to see if faces are valid for a X rotation
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);

  // If fromIndex and toIndex have valid faces
  if (fromIndex != -1 && toIndex != -1) {
    print("Need to make x rotation\n");
    return foundRotation(fromIndex, toIndex, 'X');
  }

  // Checks to see if faces are valid for a Y rotation
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);

  // If fromIndex and toIndex have valid faces
  if (fromIndex != -1 && toIndex !=-1) {
    print("Need to make y rotation\n");
    return foundRotation(fromIndex, toIndex, 'Y');
  }
  // Checks to see if faces are valid for a Z rotation
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);

  if (fromIndex != -1 && toIndex !=-1) {
    print("Need to make z rotation\n");
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
