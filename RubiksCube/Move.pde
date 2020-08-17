class Move {
  
  float x, y, z;
  int dir, c;
  float angle = 0;
  boolean animating = false;
  boolean finished = false;

  // creates a new move with x, y, z, direction parameters(clockwise, counter-clockwise)
  Move(float x, float y, float z, int dir) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.dir = dir;
  }

  // Returns a deep copy of a move
  Move copy() {
    return new Move(x, y, z, dir);
  }

  // Reverses the direction of a move
  void reverse() {
    if (dir != 2)
      this.dir *= -1;
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
  
  // Update move being made to screen
  void update() {
    float pi = 0;
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

  //converts move object to interpretable string 
  void moveToString() {
    
    // compares all parameters of m with parameters of all moves
    if (this.x == 1) {
      if (this.dir == 1) {
        moves += "R";
      } else if (this.dir == -1) {
        moves += "R\'";
      } else {
        moves += "R2";
      }
    } else if (this.x == -1) {
      if (this.dir == 1) {
        moves += "L";
      } else if (this.dir == -1) {
        moves += "L\'";
      } else {
        moves += "L2";
      }
    }

    if (this.y == 1) {
      if (this.dir == 1) {
        moves += "D";
      } else if (this.dir == -1) {
        moves += "D\'";
      } else {
        moves += "D2";
      }
    } else if (this.y == -1) {
      if (this.dir == 1) {
        moves += "U";
      } else if (this.dir == -1) {
        moves += "U\'";
      } else {
        moves += "U2";
      }
    }

    if (this.z == 1) {
      if (this.dir == 1) {
        moves += "F";
      } else if (this.dir == -1) {
        moves += "F\'";
      } else {
        moves += "F2";
      }
    } else if (this.z == -1) {
      if (this.dir == 1) {
        moves += "B";
      } else if (this.dir == -1) {
        moves += "B\'";
      } else {
        moves += "B2";
      }
    }

    if (c % 10 == 0) {
      moves += "\n";
    } else if (c == sequence.size()) {
      moves += ".\n";
    } else {
      moves += " ";
    }
    c++;
  }
}
