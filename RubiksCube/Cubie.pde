class Cubie {
  PMatrix3D matrix;  // Contains all information for each cubie of what is where
  float x = 0;
  float y = 0;
  float z = 0;
  color[] colours = new color[6];
                //    0         1      2        3         4       5
                //   Right    Left     Up      Down     Front    Back
  String[] cols = {"Orange", "Red", "Yellow", "White", "Green", "Blue"};
  color[] completeColourList = new color[6];
  color defaultRGB = color(0, 0, 0, 126);
  color orange = color(255, 140, 0);
  color red = color(255, 0, 0);
  color white = color(255);
  color yellow = color(255, 255, 0);
  color green = color(0, 255, 0);
  color blue  = color(0, 0, 255);
  int nCols = 0;

  Face[] faces = new Face[6];

  // create new cubie with 6 faces
  Cubie(PMatrix3D m, float x, float y, float z) {
    matrix = m;
    this.x = x;
    this.y = y;
    this.z = z;
    // Sets colour for each face of the cube dependant on their position on the cube and whether certain faces are visible
    setColours();
    print("\t" + x + "\t" + y + "\t" + z + "\t");
    for(int i = 0; i < colours.length; i++) {
      print(colToString(colours[i]) + "\t");
    }
    if(nCols == 1){print(nCols + "\tCenter\n");}
    else if(nCols == 2) {print(nCols + "\tEdge\n");}
    else if(nCols == 3) {print(nCols + "\tCorner\n");}
    
    // Sets each face to their required colours
    faces[0] = new Face(new PVector(1, 0, 0), colours[0]); // Orange
    faces[1] = new Face(new PVector(-1, 0, 0), colours[1]); // Red
    faces[2] = new Face(new PVector(0, -1, 0), colours[2]); // Yellow
    faces[3] = new Face(new PVector(0, 1, 0), colours[3]); // White
    faces[4] = new Face(new PVector(0, 0, 1), colours[4]); // Green
    faces[5] = new Face(new PVector(0, 0, -1), colours[5]); // Blue
  }

  Cubie(){};

  // Shows the cubie on screen
  void show() {
    noFill();
    stroke(0);
    strokeWeight(0.3 / dim);
    // Push and Pop Matrix functions means that positioning one box/Cubie does not affect others.
    push();  // Saves transformation states
      applyMatrix(matrix);
      box(1);
      int i = 0;
      for (Face f : faces) {
        f.c = colours[i];
        f.show();
        i++;
      }

    pop();
  }

  // updates the position of cubie
  void update(float x, float y, float z) {
    matrix.reset();
    matrix.translate(x, y, z);
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  Cubie copy()  {
    Cubie copy = new Cubie();
    copy.matrix = matrix;
    copy.x = x;
    copy.y = y;
    copy.z = z;
    copy.colours = colours.clone();
    copy.nCols = nCols;
    return copy;
  }
  void resetColours() {

    for(int i = 0; i < colours.length; i++) {
      colours[i] = color(0);
    }
  }
  void setColours() {
    // variable[i] = IF x == value THEN color(a) ELSE color(b)
    colours[0] = x ==  axis  ?  orange : defaultRGB;   // Orange
    colours[1] = x == -axis  ?  red    : defaultRGB;    // Red
    colours[2] = y == -axis  ?  yellow : defaultRGB;  // Yellow
    colours[3] = y ==  axis  ?  white  : defaultRGB;     // White
    colours[4] = z ==  axis  ?  green  : defaultRGB;   // Green
    colours[5] = z == -axis  ?  blue   : defaultRGB;    // Blue
    for (color c : colours) {nCols += c != defaultRGB ? 1 : 0;}
  }

  // Responsible for turning the faces of the cubies
  void turnFace(char axisFace, int dir) {
    float angle = dir * HALF_PI;
    for (Face f : faces) {
      f.turn(axisFace, angle);
    }
  }

  // For X, Y, Z rotations
  void turn(char axisFace, int dir) {
    //assume always clockwise
    // print("--------- TURN FUNCTION ---------\n");
    color[] newColours = colours.clone();
    // newColours[0] = color(255);
    // print("testing colours\n" + colToString(newColours[0]) + " AND " +
    //                             colToString(colours[0])+ "\n");
    if (dir == 1) {
      int i = 0;
      for(color c : colours)  {
      print("colour[" + i + "] : " + colToString(c) + "\t");
      i++;
    }
    print("\n");
      turn(axisFace, -1); 
      turn(axisFace, -1); 
      turn(axisFace, -1);
      return;
    }
    // Swaps colours based on which axis the cube is rotating
    switch(axisFace) {
    case 'X':
      newColours[2] = colours[4]; // F becomes U 
      newColours[4] = colours[3]; // D becomes F
      newColours[3] = colours[5]; // B becomes D 
      newColours[5] = colours[2]; // U becomes B 
      // newColours[2] = colours[2]; // F becomes U 
      // newColours[4] = colours[4]; // D becomes F
      // newColours[3] = colours[3]; // B becomes D 
      // newColours[5] = colours[5]; // U becomes B 
      break;
    case 'Y':
      newColours[5] = colours[1]; // L becomes B
      newColours[0] = colours[5]; // B becomes R
      newColours[4] = colours[0]; // R becomes F
      newColours[1] = colours[4]; // F becomes L
      break;
    case 'Z':
      newColours[2] = colours[0]; // U becomes R
      newColours[0] = colours[3]; // R becomes D
      newColours[3] = colours[1]; // D becomes L
      newColours[1] = colours[2]; // L becomes U
      break;
    }
    
    colours = newColours.clone();
    int i = 0;
    for(color c : colours)  {
      print("colour[" + i + "] : " + colToString(c) + "\t");
      i++;
    }
    print("\n");
    return;
  }

  // Return char of face with color c
  char getFace(color c) {
    // for every colour
    for (int i = 0; i < colours.length; i++) {
      // if colour[i] is the same as c
      if (colours[i] == c) {
        String faces = "RLUDFB";
        // print("The " + cols[i] + " face is " + faces.charAt(i) + "\n");
        // return the char which should be in the same index in the string as it is in colours array
        return faces.charAt(i);
      }
    }
    return  ' ';
  }

  color getFaceColour() {
    // for every colour
    for (color c : colours) {
      // if c is not the default color
      if (c != defaultRGB) {
        return c;
      }
    }
    return defaultRGB;
  }

  // Checks if two colours are the same
  boolean matchesColours(color[] cols) {
    if (nCols != cols.length) {
      return false;
    }

    for (color c : cols) {
      boolean foundMatch = false;
      for (color b : colours) {
        if (b == c) {
          foundMatch = true;
          // print(colToString(c) + " is the same as " + colToString(colours[j]) + "\n");
          break;
        }
      }
      if (!foundMatch) {return false;}
    }
    return true;
  }
}
