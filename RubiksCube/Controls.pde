
void keyPressed() {
  // if a cube is animating, skip  switch case
  if(currentMove.animating)  {
    print("animating\n");
    return;
  }
  switch(key)  {
    case 's':
      currentMove = sequence.get(counter);
      currentMove.start();
      counter = 0;
      break;
    case '1':
      reverseScramble();
      break;
    case '2':
      resetCube();
      break;
  }
  
  //print(key + "\n");
  applyMove(key);
}


Move makeAMove(String m) {
  Move move = null;
  //moves += m;
  switch (m) {
  case "R2":
    return move = new Move(axis, 0, 0, 2);
  case "L2":
    return move = new Move(-axis, 0, 0, 2);
  case "D2":
    return move = new Move(0, axis, 0, 2);
  case "U2":
    return move = new Move(0, -axis, 0, 2);
  case "F2":
    return move = new Move(0, 0, axis, 2);
  case "B2":
    return move = new Move(0, 0, -axis, 2);
  case "R":
    return move = new Move(axis, 0, 0, 1);
  case "R\'":
    return move = new Move(axis, 0, 0, -1);
  case "L":
    return move = new Move(-axis, 0, 0, 1);
  case "L\'":
    return move = new Move(-axis, 0, 0, -1);
  case "F":
    return move = new Move(0, 0, axis, 1);
  case "F\'":
    return move = new Move(0, 0, axis, -1);
  case "B":
    return move = new Move(0, 0, -axis, 1);
  case "B\'":
    return move = new Move(0, 0, -axis, -1);
  case "D":
    return move = new Move(0, axis, 0, 1);
  case "D\'":
    return move = new Move(0, axis, 0, -1);
  case "U":
    return move = new Move(0, -axis, 0, 1);
  case "U\'":
    return move = new Move(0, -axis, 0, -1);
  }
  return move;
}


// For scramblers reference
void applyMove(char move) {
  switch(move) {
  case 'f':
    currentMove = makeAMove("F");
    break;
  case 'F':
    currentMove = makeAMove("F\'");
    break;
  case 'b':
    currentMove = makeAMove("B");
    break;
  case 'B':
    currentMove = makeAMove("B\'");
    break;
  case 'r':
    currentMove = makeAMove("R");
    break;
  case 'R':
    currentMove = makeAMove("R\'");
    break;
  case 'l':
    currentMove = makeAMove("L");
    break;
  case 'L':
    currentMove = makeAMove("L\'");
    break;
  case 'u':
    currentMove = makeAMove("U");
    break;
  case 'U':
    currentMove = makeAMove("U\'");
    break;
  case 'd':
    currentMove = makeAMove("D");
    break;
  case 'D':
    currentMove = makeAMove("D\'");
    break;
  }
  currentMove.start();
}
