class Move {

  
  int dir;
  int i = 0;
  float x, y, z;
  char currentAxis = 'X';
  float index = 0;
  float angle = 0;
  boolean animating = false;
  boolean finished = false;
  boolean clockwise = true;

  // creates a new move with x, y, z, direction parameters(clockwise, counter-clockwise)
  Move(char axis, float index, int dir) {
    // this.x = x;
    // this.y = y;
    // this.z = z;
    this.currentAxis = axis;
    this.index = index;
    this.dir = dir;
  }

  Move(char axis, int dir)  {
    this.currentAxis = axis;
    this.dir = dir;
    this.index = dim*dim*dim;
  }

  Move(){}

  // Update move being made to screen
  void update() {
    float pi = HALF_PI;
    if (animating) {
      pi = dir == 2 ? pi = PI : pi;
      angle += dir * speed * 0.5;

      if (abs(angle) > pi) {
        angle = 0;
        animating = false;
        finished = true;
        if (abs(z) > 0) {
          turn('z', dir, z);
        } else if (abs(x) > 0) {
          turn('x', dir, x);
        } else if (abs(y) > 0) {
          turn('y', dir, y);
        }
      }
    }
  }

  // Returns a deep copy of a move
  Move copy() {
    return new Move(currentAxis, index, dir);
  }

  // Reverses the direction of a move
  void reverse() {
    if (dir != 2)
      dir *= -1;
  }

  // Starts animation of move
  void start() {
    this.animating = true;
    this.finished = false;
    this.angle = 0;
  }

  boolean finished() {
    return finished;
  }

  Move reset()  {
    this.currentAxis = 'X';
    this.index = 0;
    this.dir = 0;
    Move move = new Move(currentAxis, index, dir);
    return move;
  }
  
  //converts move object to interpretable string 
  String moveToString() {
    String move = "";
    // compares all parameters of m with parameters of all moves
    if (currentAxis == 'X') {
      if(index == axis) {
        if (dir == 1) {
          move += "R";
        } else if (dir == -1) {
          move += "R\'";
        } else {
          move += "R2";
        }
      } else if (index  == -axis) {
        if (dir == 1) {
          move += "L";
        } else if (dir == -1) {
          move += "L\'";
        } else {
          move += "L2";
        }
      } else if (index > axis) {
        if(dir == 1)  {
          move += "Z";
        } else {
          move += "Z\'";
        }
      } else {
        move += "X?";
      }
    } 

    if (currentAxis == 'Y') {
      if(index == axis) {
        if (dir == 1) {
          move += "D";
        } else if (dir == -1) {
          move += "D\'";
        } else {
          move += "D2";
        }
      } else if(index == -axis) {
        if (dir == 1) {
          move += "U";
        } else if (dir == -1) {
          move += "U\'";
        } else {
          move += "U2";
        } 
      } else if (index > axis) {
        if(dir == 1)  {
          move += "Y";
        } else {
          move += "Y\'";
        }
      } else {
        move += "Y?";
      }
    } 

    if (currentAxis == 'Z') {
      if(index == axis) {
        if (dir == 1) {
          move += "F";
        } else if (dir == -1) {
          move += "F\'";
        } else {
          move += "F2";
        }
      } else if(index == -axis) {
        if (dir == 1) {
          move += "B";
        } else if (dir == -1) {
          move += "B\'";
        } else {
          move += "B2";
        } 
      } else if (index > axis) {
        if(dir == 1)  {
          move += "Z";
        } else {
          move += "Z\'";
        }
      } else {
        move += "Z?";
      }
    }
    return move;
  }

}
