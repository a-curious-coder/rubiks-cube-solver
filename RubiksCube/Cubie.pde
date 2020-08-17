class Cubie {
  PMatrix3D matrix;  // Contains all information for each cubie of what is where
  float x = 0;
  float y = 0;
  float z = 0;
  color[] colours = new color[6];
  int nCols = 0;
  
  
  Face[] faces = new Face[6];

  // create new cubie with 6 faces
  Cubie(PMatrix3D m, float x, float y, float z) {
    matrix = m;
    this.x = x;
    this.y = y;
    this.z = z;
    // Sets colour for each face of the cube.
    setColours();
    
    faces[0] = new Face(new PVector(1, 0, 0),  colours[0]); // Orange
    faces[1] = new Face(new PVector(-1, 0, 0), colours[1]); // Red
    faces[2] = new Face(new PVector(0, 1, 0),  colours[2]); // White
    faces[3] = new Face(new PVector(0, -1, 0), colours[3]); // Yellow
    faces[4] = new Face(new PVector(0, 0, 1),  colours[4]); // Green
    faces[5] = new Face(new PVector(0, 0, -1), colours[5]); // Blue
  }
  
  Cubie(){};
  
  Cubie copy()  {
    Cubie copyqb = new Cubie();
    copyqb.matrix = matrix;
    copyqb.x = x;
    copyqb.y = y;
    copyqb.z = z;
    copyqb.faces = faces;
    return copyqb;
  }
  
  void setColours()  {
    color defaultRGB = color(255);
    
   // variable[i] = IF x == value THEN color(a) ELSE color(b)
      colours[0] = x == axis ? color(255, 140, 0)  : defaultRGB;  // Orange
      colours[1] = x == -axis ? color(255, 0, 0)   : defaultRGB;  // Red
      colours[2] = y == axis ? color(255)          : defaultRGB;  // White
      colours[3] = y == -axis ? color(255, 255, 0) : defaultRGB;  // Yellow
      colours[4] = z == axis ? color(0, 255, 0)    : defaultRGB;  // Green
      colours[5] = z == -axis ? color(0, 0, 255)   : defaultRGB;  // Blue
      
      for(color c : colours)  {
        if(c != defaultRGB)  {
          nCols++;
        }
      }
  }
  
  void turnFace(char axis, int dir) {
    float angle = dir * HALF_PI;
    for (Face f : faces) {
      f.turn(axis, angle);
    }
  }

  void update(float x, float y, float z) {
    matrix.reset();
    matrix.translate(x, y, z);
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void show() {
    noFill();
    stroke(0);
    strokeWeight(0.3 / dim);

    // Push and Pop Matrix functions means that positioning one box/Cubie does not affect others.
    push();  // Saves transformation states
    applyMatrix(matrix);
    box(1);
    for (Face f : faces) {
      f.show();
    }
    popMatrix();
  }
}
