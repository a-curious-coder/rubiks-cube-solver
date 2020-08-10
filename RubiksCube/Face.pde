class Face {
  PVector normal;
  color c;
  
  // Creates new face with a default position and colour
  Face(PVector normal, color c) {
    this.normal = normal;
    this.c = c;
  }
  
  // turns face on x axis 
  void turnX(float angle) {
    PVector v = new PVector();
    v.y = round(normal.y * cos(angle) - normal.z * sin(angle));
    v.z = round(normal.y * sin(angle) + normal.z * cos(angle));
    v.x = round(normal.x);
    this.normal = v;
  }
  
  void turnY(float angle) {
    PVector v = new PVector();
    v.x = round(normal.x * cos(angle) - normal.z * sin(angle));
    v.z = round(normal.x * sin(angle) + normal.z * cos(angle));
    v.y = round(normal.y);
    this.normal = v;
  }
  
  void turnZ(float angle) {
    PVector v = new PVector();
    v.x = round(normal.x * cos(angle) - normal.y * sin(angle));
    v.y = round(normal.x * sin(angle) + normal.y * cos(angle));
    v.z = round(normal.z);
    this.normal = v;
  }
  
  
  void show() {
    pushMatrix();
    fill(c);
    noStroke();
    rectMode(CENTER);
    translate(0.5*normal.x, 0.5*normal.y, 0.5*normal.z);
    
    if (abs(normal.x) > 0) {
      rotateY(HALF_PI);
    } else if (abs(normal.y) > 0) {
      rotateX(HALF_PI);
    }
    square(0, 0, 1);
    popMatrix();
  }
}
