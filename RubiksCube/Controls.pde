// Order of moves:  D, d, U, u, R, r, L, l, F, f, B, b
// Moves indexes:   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
// Reference for allMoves[]  
void keyPressed() {
  switch(key) {
  case 'D':
    currentMove = allMoves[0];
    currentMove.start();
    break;
  case 'd':
    currentMove = allMoves[1];
    currentMove.start();
    break;
  case 'U':
    currentMove = allMoves[2];
    currentMove.start();
    break;
  case 'u':
    currentMove = allMoves[3];
    currentMove.start();
    break;
  case 'R':
    currentMove = allMoves[4];
    currentMove.start();
    break;
  case 'r':
    currentMove = allMoves[5];
    currentMove.start();
    break;
  case 'L':
    currentMove = allMoves[6];
    currentMove.start();
    break;
  case 'l':
    currentMove = allMoves[7];
    currentMove.start();
    break;
  case 'F':
    currentMove = allMoves[8];
    currentMove.start();
    break;
  case 'f':
    currentMove = allMoves[9];
    currentMove.start();
    break;
  case 'B':
    currentMove = allMoves[10];
    currentMove.start();
    break;
  case 'b':
    currentMove = allMoves[11];
    currentMove.start();
    break; 
// --------------------------------
  case 's':
    currentMove.start();
    break; 
  case 'S':
    currentMove.start();
    break; 
  case '1':
    reverseScramble();
    break; 
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
