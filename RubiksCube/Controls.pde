
  
void keyPressed() {
  switch(key) {
  case 'f':
    turnZ(1, 1);
    break;
  case 'F':
    turnZ(1, -1);
    break;
  case 'b':
    turnZ(-1, 1);
    break;
  case 'B':
    turnZ(-1, -1);
    break;
  case 'r':
    turnX(1, 1);
    break;
  case 'R':
    turnX(1, -1);
    break;
  case 'l':
    turnX(-1, 1);
    break;
  case 'L':
    turnX(-1, -1);
    break;
  case 'u':
    turnY(-1, 1);
    break;
  case 'U':
    turnY(-1, -1);
    break;
  case 'd':
    turnY(1, 1);
    break;
  case 'D':
    turnY(1, -1);
    break;
  case 's':
    scrambleCube();
    //currentMove.start();
  case 'S':
    scrambleCube();
    currentMove.start();
  }
}

// For scramblers reference
void applyMove(char move) {
  switch(move) {
  case 'f':
    turnZ(1, 1);
    break;
  case 'F':
    turnZ(1, -1);
    break;
  case 'b':
    turnZ(-1, 1);
    break;
  case 'B':
    turnZ(-1, -1);
    break;
  case 'r':
    turnX(1, 1);
    break;
  case 'R':
    turnX(1, -1);
    break;
  case 'l':
    turnX(-1, 1);
    break;
  case 'L':
    turnX(-1, -1);
    break;
  case 'u':
    turnY(-1, 1);
    break;
  case 'U':
    turnY(-1, -1);
    break;
  case 'd':
    turnY(1, 1);
    break;
  case 'D':
    turnY(1, -1);
    break;
  }
}
