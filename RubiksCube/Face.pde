class Face {
  PVector normal;
  color c;
  
  // Creates new face with a default position and colour
  Face(PVector normal, color c) {
    this.normal = normal;
    this.c = c;
  }
  
  
  void turn(char axis, float angle)  {
    PVector v = new PVector();
    
    switch (axis)  {
      case 'x':
        v.x = round(normal.x);
        v.y = round(normal.y * cos(angle) - normal.z * sin(angle));
        v.z = round(normal.y * sin(angle) + normal.z * cos(angle));
        //print("\nx:\t(" + v.x + ", " + v.y + ", " + v.z + ");");
        break;
      case 'y':
        v.x = round(normal.x * cos(angle) - normal.z * sin(angle));
        v.y = round(normal.y);
        v.z = round(normal.x * sin(angle) + normal.z * cos(angle));
        //print("\ny:\t(" + v.x + ", " + v.y + ", " + v.z + ");");
        break;
      case 'z':
        v.x = round(normal.x * cos(angle) - normal.y * sin(angle));
        v.y = round(normal.x * sin(angle) + normal.y * cos(angle));
        v.z = round(normal.z);
        //print("\nz:\t(" + v.x + ", " + v.y + ", " + v.z + ");");
        break;
    }
    
    normal = v;
  }
  
  color getColour()  {
    return c;
  }
  
  void show() {
    push();
    
    fill(c);
    noStroke();
    rectMode(CENTER);
    translate(0.5*normal.x, 0.5*normal.y, 0.5*normal.z);
    rotate(HALF_PI, normal.y, normal.x, normal.z);
    
    square(0, 0, 1);
    pop();
  }
}
