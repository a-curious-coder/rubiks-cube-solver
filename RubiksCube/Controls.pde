void keyPressed() {
  if(testing) return;
  keyPress = key;
  if(choosing)  {
    println("choosing");
    switch(key) {
      case 1: 
        filler = color(255);
        choosing = false;
        break;
    }
  } else {
  switch(key) {
    case 'a':
      if(!threadRunning)  {
        threadRunning = true;
        loadPruningTables();
        cube.iksolve();
        cube.ksolve.solve();
      }
      break;
    case 't': // Test...
      if(!testing)  {
        testing = true;
        // thread("testHumanAlgorithmSolver");
        thread("testDFSSolver");
      }
      break;
    case 'c':

      // colouring = true;
      break;
    case 'h':
      hud = !hud;
      break;
    case 's':
      if(bigTroll()) break;
      cube.scrambleCube();
      // cube.hardcodedScrambleCube();
      break;
    case '0':
      hSolve = true;
      break;
    case ']':
      lsSolve = !lsSolve;
      break;
    case '1':
      cube.rScrambleCube();
      break;
    case '2':
      resetCube();
      break;
    case '3':
      print(cube.len + " are being stored\n");
      print((int)(pow(dim, 3)) + " would have been stored\n");
      print(((int)(pow(dim, 3)) - cube.len) + " cubies are not being stored, saving cpu power\n\n");
      break;
    case '4':
      for(int i = 0; i < 999; i++)  {
        println("");
      }
    case 'm':
      speed *= 10;
      break;
    case 'n':
      speed *= 0.10;
      break;
    case '6':
      println("Testing moves X");
      cube.testMoves('X');
      break;
    case '7':
      println("Testing moves Y");
      cube.testMoves('Y');
      break;
    case '8':
      println("Testing moves Z");
      cube.testMoves('Z');
      break;
    case '9':
      for(Cubie c : centers)  {
        println(c.details());
      }
    case 'q':
      println("Cube solved: " + cube.evaluateCube());
      break;
    case 'o':
      speed = 0.01;
      break;
    case 'p':
      paused = !paused;
      break;
    case 'w':  
      dim++;
      resetCube();
      break;
    case 'e':  
      if(dim > 1) {
        dim--;
      }
      resetCube();
      break;
    default: 
      // if a cube is animating, skip  switch case
      if (currentMove.animating) {
        print("animating\n");
        return;
      }
      // println("Key pressed: " + key);
      applyMove(key);
      break;
  }
  }
}

// R L on X
// U D on Y
// F B on Z
void makeAMove(String move) {
  switch(move) {
  case "R2":
    cube.turn('X', axis, 2);
    break;
  case "L2":
    cube.turn('X', -axis, 2);
    break;
  case "D2":
    cube.turn('Y', axis, 2);
    break;
  case "U2":
    cube.turn('Y', -axis, 2);
    break;
  case "F2":
    cube.turn('Z', axis, 2);
    break;
  case "B2":
    cube.turn('Z', -axis, 2);
    break;
  case "R":
    cube.turn('X', axis, 1);
    break;
  case "R\'":
    cube.turn('X', axis, -1);
    break;
  case "L":
    cube.turn('X', -axis, 1);
    break;
  case "L\'":
    cube.turn('X', -axis, -1);
    break;
  case "F":
    cube.turn('Z', axis, 1);
    print(axis);
    break;
  case "F\'":
    cube.turn('Z', axis, -1);
    break;
  case "B":
    cube.turn('Z', -axis, 1);
    break;
  case "B\'":
    cube.turn('Z', -axis, -1);;
    break;
  case "D":
    cube.turn('Y', axis, 1);
    break;
  case "D\'":
    cube.turn('Y', axis, -1);
    break;
  case "U":
    cube.turn('Y', -axis, 1);
    break;
  case "U\'":
    cube.turn('Y', -axis, -1);
    break;
  case "X":
    cube.turnWholeCube('X', 1);
    break;
  case "X\'":
    cube.turnWholeCube('X', -1);
    break;
  case "Y":
    cube.turnWholeCube('Y', 1);
    break;
  case "Y\'":
    cube.turnWholeCube('Y', -1);
    break;
  case "Z":
    cube.turnWholeCube('Z', 1);
    break;
  case "Z\'":
    cube.turnWholeCube('Z', -1);
    break;
  default:
    return;
  }
}

// For scramblers reference
void applyMove(char move) {
  switch(move) {
  case 'f':
    makeAMove("F");
    break;
  case 'F':
    makeAMove("F\'");
    break;
  case 'b':
    makeAMove("B");
    break;
  case 'B':
    makeAMove("B\'");
    break;
  case 'r':
    makeAMove("R");
    break;
  case 'R':
    makeAMove("R\'");
    break;
  case 'l':
    makeAMove("L");
    break;
  case 'L':
    makeAMove("L\'");
    break;
  case 'u':
    makeAMove("U");
    break;
  case 'U':
    makeAMove("U\'");
    break;
  case 'd':
    makeAMove("D");
    break;
  case 'D':
    makeAMove("D\'");
    break;
  case 'x':
    makeAMove("X");
    break;
  case 'X':
    makeAMove("X\'");
    break;
  case 'y':
    makeAMove("Y");
    break;
  case 'Y':
    makeAMove("Y\'");
    break;
  case 'z':
    makeAMove("Z");
    break;
  case 'Z':
    makeAMove("Z\'");
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
