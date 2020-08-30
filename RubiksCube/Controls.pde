void keyPressed() {

  switch(key) {
  case 's':
    if(bigTroll()) break;
    cube.hAlgorithm.scramble();
    break;
  case '0':
    cube.hAlgorithm.solveCube();
    break;
  case '1':
    cube.hAlgorithm.reverseScramble();
    break;
  case '2':
    resetCube();
    break;
  case '3':
    print(cube.len + " are being stored\n");
    print((int)(pow(dim, 3)) + " would have been stored\n");
    print(((int)(pow(dim, 3)) - cube.len) + " cubies are not being stored, saving cpu power\n\n");
    break;
  case 'm':
    speed += 0.10;
    break;
  case 'n':
    speed -= 0.10;
    break;
  case 'i':
    speed = 10;
    break;
  case 'o':
    speed = 0.01;
    break;
  case 'p':
    paused = !paused;
    break;
  case 'w':  
    dim ++;
    resetCube();
    break;
  case 'e':  
    dim--;
    resetCube();
    break;
  default: 
    // if a cube is animating, skip  switch case
    if (currentMove.animating) {
      print("animating\n");
      return;
    }
    applyMove(key);
    break;
  }

  //print(key + "\n");
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
    return move = new Move(-axis, 0, 0, -1);
  case "L\'":
    return move = new Move(-axis, 0, 0, 1);
  case "F":
    return move = new Move(0, 0, axis, 1);
  case "F\'":
    return move = new Move(0, 0, axis, -1);
  case "B":
    return move = new Move(0, 0, -axis, -1);
  case "B\'":
    return move = new Move(0, 0, -axis, 1);
  case "D":
    return move = new Move(0, axis, 0, -1);
  case "D\'":
    return move = new Move(0, axis, 0, 1);
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
    currentMove.start();
    break;
  case 'F':
    currentMove = makeAMove("F\'");
    currentMove.start();
    break;
  case 'b':
    currentMove = makeAMove("B");
    currentMove.start();
    break;
  case 'B':
    currentMove = makeAMove("B\'");
    currentMove.start();
    break;
  case 'r':
    currentMove = makeAMove("R");
    currentMove.start();
    break;
  case 'R':
    currentMove = makeAMove("R\'");
    currentMove.start();
    break;
  case 'l':
    currentMove = makeAMove("L");
    currentMove.start();
    break;
  case 'L':
    currentMove = makeAMove("L\'");
    currentMove.start();
    break;
  case 'u':
    currentMove = makeAMove("U");
    currentMove.start();
    break;
  case 'U':
    currentMove = makeAMove("U\'");
    currentMove.start();
    break;
  case 'd':
    currentMove = makeAMove("D");
    currentMove.start();
    break;
  case 'D':
    currentMove = makeAMove("D\'");
    currentMove.start();
    break;
  case 'x':
    cube.rotateWholeCube('X', 1);
    break;
  case 'X':
    cube.rotateWholeCube('X', -1);
    break;
  case 'y':
    cube.rotateWholeCube('Y', 1);
    break;
  case 'Y':
    cube.rotateWholeCube('Y', -1);
    break;
  case 'z':
    cube.rotateWholeCube('Z', 1);
    break;
  case 'Z':
    cube.rotateWholeCube('Z', -1);
    break;
  default:
    return;
  }
}

boolean bigTroll() {
  if (dim == 1) {
    scramble = false;
    String[] prompts = new String[5];
    prompts[0] = "lol, why are you trying to scramble a 1x1x1 cube.";
    prompts[1] = "How d'you think this would actually scramble?";
    prompts[2] = "How would you be able to scramble 1x1x1 cube?";
    prompts[3] = "Oh yeah... I'll get my program to scramble a 1x1x1 cube ( ͡° ͜ʖ ͡°)";
    prompts[4] = "What are you expecting to happen rn? ¯\\_(ツ)_/¯ ";
    moves = prompts[(int)random(5)];
    return true;
  }
  return false;
}
