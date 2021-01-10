class Face {
  float radius = 0.06;
  float faceWidth = 0.95;
  float faceHeight = 0.95;
  PVector normal;
  int c;

  // Creates new face with a default position and colour
  Face(PVector normal, int c) {
    this.normal = normal;
    this.c = c;
  }

  // Clone face constructor
  Face(Face f)  {
    this.normal = f.normal.copy();
    this.c = f.c;
  }

  Face(){};

  void turn(char axis, float angle) {
    PVector v = new PVector();

    switch (axis) {
    case 'x':
      v.x = round(normal.x);
      v.y = round(normal.y * cos(angle) - normal.z * sin(angle));
      v.z = round(normal.y * sin(angle) + normal.z * cos(angle));
      break;
    case 'y':
      v.x = round(normal.x * cos(angle) - normal.z * sin(angle));
      v.y = round(normal.y);
      v.z = round(normal.x * sin(angle) + normal.z * cos(angle));
      break;
    case 'z':
      v.x = round(normal.x * cos(angle) - normal.y * sin(angle));
      v.y = round(normal.x * sin(angle) + normal.y * cos(angle));
      v.z = round(normal.z);
      break;
    }
    normal = v;
  }

  void show() {
    push();
      // noStroke();
      stroke(0);
      rectMode(CENTER);
      translate(0.5*normal.x, 0.5*normal.y, 0.5*normal.z);
      rotate(HALF_PI, normal.y, normal.x, normal.z);
      fill(c);
      rect(0,0,faceWidth, faceHeight, radius, radius, radius, radius);
      // fill(0);
      // text("i", 0, 0);
    pop();
  }

  color getColour() {
    return c;
  }
}
