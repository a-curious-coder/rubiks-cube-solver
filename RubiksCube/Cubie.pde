class Cubie {
  PMatrix3D matrix;  // Contains all information for each cubie of what is where
  int x = 0;
  int y = 0;
  int z = 0;
  color c;
  Face[] faces = new Face[6];
  
  
  Cubie(PMatrix3D m, int x, int y, int z) {
    matrix = m;
    this.x = x;
    this.y = y;
    this.z = z;
    //c = color(255);
    
    // Sets colour for each face of the cube.
    faces[0] = new Face(new PVector(0, 0, -1), color(0, 0, 255)); // Blue face
    faces[1] = new Face(new PVector(0, 0, 1), color(0, 255, 0)); // Green face
    faces[2] = new Face(new PVector(0, 1, 0), color(255, 255, 255)); // White face
    faces[3] = new Face(new PVector(0, -1, 0), color(255, 255, 0));
    faces[4] = new Face(new PVector(1, 0, 0), color(255, 150, 0));
    faces[5] = new Face(new PVector(-1, 0, 0), color(255, 0, 0));
  }
  
  void turnFacesX(int dir)  {
    for(Face f : faces)  {
     f.turnX(dir * HALF_PI); 
    }
  }
  
  void turnFacesY(int dir)  {
    for(Face f : faces)  {
     f.turnY(dir * HALF_PI); 
    }
  }
  
  void turnFacesZ(int dir)  {
    for(Face f : faces)  {
     f.turnZ(dir * HALF_PI); 
    }
  }
  
  void update(int x, int y, int z)  {
    matrix.reset();
    matrix.translate(x, y, z);
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void show() {
    noFill();
    stroke(0);
    strokeWeight(0.05);
    
    //Push and Pop Matrix functions means that positioning one box/Cubie does not affect others.
    pushMatrix();  // Saves transformation states
    applyMatrix(matrix);
    box(1);
    for(Face f : faces)  {
       f.show(); 
    }
    popMatrix();
  }
}
