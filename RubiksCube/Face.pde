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
        v.y = round(normal.y * cos(angle) - normal.z * sin(angle));
        v.z = round(normal.y * sin(angle) + normal.z * cos(angle));
        v.x = round(normal.x);
        break;
      case 'y':
        v.x = round(normal.x * cos(angle) - normal.z * sin(angle));
        v.z = round(normal.x * sin(angle) + normal.z * cos(angle));
        v.y = round(normal.y);
        break;
      case 'z':
        v.x = round(normal.x * cos(angle) - normal.y * sin(angle));
        v.y = round(normal.x * sin(angle) + normal.y * cos(angle));
        v.z = round(normal.z);
        break;
    }
    
    normal = v;
  }
  
  //// turns face on x axis 
  //void turnX(float angle) {
  //  PVector v = new PVector();
  //  v.y = round(normal.y * cos(angle) - normal.z * sin(angle));
  //  v.z = round(normal.y * sin(angle) + normal.z * cos(angle));
  //  v.x = round(normal.x);
  //  this.normal = v;
  //}
  
  //void turnY(float angle) {
  //  PVector v = new PVector();
  //  v.x = round(normal.x * cos(angle) - normal.z * sin(angle));
  //  v.z = round(normal.x * sin(angle) + normal.z * cos(angle));
  //  v.y = round(normal.y);
  //  this.normal = v;
  //}
  
  //void turnZ(float angle) {
  //  PVector v = new PVector();
  //  v.x = round(normal.x * cos(angle) - normal.y * sin(angle));
  //  v.y = round(normal.x * sin(angle) + normal.y * cos(angle));
  //  v.z = round(normal.z);
  //  this.normal = v;
  //}
  
  
  void show() {
    push();
    fill(c);
    noStroke();
    rectMode(CENTER);
    translate(0.5*normal.x, 0.5*normal.y, 0.5*normal.z);
    rotate(HALF_PI, normal.y, normal.x, normal.z);
    
//    if (abs(normal.x) > 0) {
//      rotateY(HALF_PI);
//    } else if (abs(normal.y) > 0) {
//      rotateX(HALF_PI);
//    } else {
//      rotateZ(HALF_PI);
//    }
    
    square(0, 0, 1);
    pop();
  }
}
