class Move {
  
  float angle = 0;
  int x, y, z, dir;
  float speed = 0.1;
  boolean animating = false;
  boolean finished = false;
  
  // creates a new move with x, y, z, direction parameters(clockwise, counter-clockwise)
  Move(int x, int y, int z, int dir) {
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
  
  
  void update() {
    
    if (animating) {
      angle += dir * speed;
      
      if (abs(angle) > HALF_PI) {
        
        angle = 0;
        animating = false;
        finished = true;
        
        if (abs(z) > 0) {
          turnZ(z, dir);
        } else if (abs(x) > 0) {
          turnX(x, dir);
        } else if (abs(y) > 0) {
          turnY(y, dir);
        }
      }
    }
  }
  
  int getDir()  {
    return dir;
  }
}
