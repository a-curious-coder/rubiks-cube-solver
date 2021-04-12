void keyPressed() {
  if (enterMoves.isFocus() == true) {
    if(enterMoves.getText().contains("Enter scramble here")) {
      enterMoves.setText("");
    }
    if(key == '\'') {
      enteredMoves = enterMoves.getText();
      enterMoves.setText(enteredMoves + key);
    } else if(key == BACKSPACE) {
      enterMoves.setText("");
    } else if(key == ENTER) {
      cube.testAlgorithm(enterMoves.getText());
      enterMoves.setText("");
    }
    return;
  }
  keyPress = key;
  if(testing || threadRunning) {
    if(keyPress == 'p')  {
      paused = !paused;
    }
    return;
  }
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
    case '\\':
      slowCube = !slowCube;
      break;
    case ' ':
      cube.scrambleCube();
      break;
    case 'a':
      // thread("aboutWindow");
      thread("pixWindow");
      break;
    case 't': // Solves various cubes x amount of times using specified method.
        // thread("testHumanAlgorithmSolver");
        // thread("testKorfs");
        // create_slice_table();
        // create_e_slice_table();
        // create_ms_slice_table();
        // create_tetrad_table();
        // generateScrambles(50, 50);
        // println("" + popcount(4095));
        // create_edges_p_table();
        // create_corners_p_table();
        // thread("testThistlethwaite");
        // thread("testKociembas");
        // create_es_co_table();
        // create_corner_p_ms_table();
        // create_ms_slice_table();
        // create_e_slice_table();
        // create_double_turn_table();
        // thread("testAlgorithm");
        // create_half_turn_table();
        thread("korfsAlgorithm");
        thread("nodesPerSecond");
        // create_ms_slice_table();
        // e_slice_tables(12, 4);
      break;
    case 'c':
      // Cube2 tmp = new Cube2(cube);
      if(!testing)  {
        testing = true;
        thread("testHumanAlgorithmSolver");
      }
      break;
    case 'h':
      hud = !hud;
      // thread("controlsWindow");
      break;
    case 's':
      if(bigTroll()) break;
      // cube.hardcodedScrambleCube();
      Cube2 ha = new Cube2(cube);
      ha.imageState();
      // cube.testAlgorithm(cube.generateScramble(10000));
      break;
    case 'x':
      currentScreen++;
      if (currentScreen > 1) { currentScreen = 0; }
      break;
    case ']':
      lsSolve = !lsSolve;
      break;
    case '0':
      break;
    case '1':
      resetCube();
      break;
    case '2':
      thread("humanAlgorithm");
      break;
    case '3':
      thread("korfsAlgorithm");
      break;
    case '4':
      thread("thistlethwaiteAlgorithm");
      break;
    case '5':
      thread("kociembaAlgorithm");
      break;
    case '6':
      println("Testing moves X");
      // cube.testMoves('X');
      cube.testMove(allMoves.get(10));
      // Z move - -axis+1, Z
      break;
    case '7':
      println("Testing moves Y");
      cube.testMoves('Y');
      break;
    case '8':
      cube.testAlgorithm("R U R' U' R' F R2 U' R' U' R U R' F'");
      break;
    case '9':
      display2D = !display2D;
      break;
    case '+':
      speed *= 10;
      break;
    case '-':
      speed *= 0.10;
      break;
    case 'q':
      int oldMoves = numberOfMoves;
      numberOfMoves = 1;
      cube.scrambleCube();
      numberOfMoves = oldMoves;
      break;
    case 'o':
      speed = 0.01;
      break;
    case 'p':
      paused = !paused;
      break;
    case 'w':
      oldMoves = numberOfMoves;
      numberOfMoves = 5;
      cube.scrambleCube();
      numberOfMoves = oldMoves;
      break;
    case 'e':  
      oldMoves = numberOfMoves;
      numberOfMoves = 15;
      cube.scrambleCube();
      numberOfMoves = oldMoves;
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

char decodeByte(byte i) {
        char col = 'O';
        if(i == 1)  col = 'R';
        if(i == 2)  col = 'Y';
        if(i == 3)  col = 'W';
        if(i == 4)  col = 'G';
        if(i == 5)  col = 'B';
        return col;
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
