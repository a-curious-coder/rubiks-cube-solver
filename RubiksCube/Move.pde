class Move {

  float x, y, z;
  int dir;
  int i = 0;
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

  //converts move object to interpretable string 
  String moveToString() {
    String move = "";
    // compares all parameters of m with parameters of all moves
    if (x == 1) {
      if (dir == 1) {
        move += "R";
      } else if (dir == -1) {
        move += "R\'";
      } else {
        move += "R2";
      }
    }
    if (x == -1) {
      if (dir == 1) {
        move += "L";
      } else if (dir == -1) {
        move += "L\'";
      } else {
        move += "L2";
      }
    }

    if (this.y == 1) {
      if (this.dir == 1) {
        move += "D";
      } else if (this.dir == -1) {
        move += "D\'";
      } else {
        move += "D2";
      }
    }
    if (this.y == -1) {
      if (this.dir == 1) {
        move += "U";
      } else if (this.dir == -1) {
        move += "U\'";
      } else {
        move += "U2";
      }
    }

    if (this.z == 1) {
      if (this.dir == 1) {
        move += "F";
      } else if (this.dir == -1) {
        move += "F\'";
      } else {
        move += "F2";
      }
    } 
    if (this.z == -1) {
      if (this.dir == 1) {
        move += "B";
      } else if (this.dir == -1) {
        move += "B\'";
      } else {
        move += "B2";
      }
    }


    i++;
    if (i % 10 == 0) {
      move += "\n";
    } else if (i == sequence.size()) {
      move += ".\n";
    } else {
      move += " ";
    }
    moves += move;
    return move;
  }
}
