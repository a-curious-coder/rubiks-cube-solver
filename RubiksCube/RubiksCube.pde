import peasy.*;

PeasyCam cam;
int displayWidth = 900;
int displayHeight = 900; 

int dim = 3;
char keyPress = 'a';
int counter;
int moveCounter;
int numberOfMoves;
String msg;

float middle;
float axis;
float speed;

String moves = "";
String turns = "";

boolean paused;
boolean scramble;
boolean hSolve;
boolean lsSolve;
boolean reverse;
boolean hud;
boolean counterReset;
boolean display2D;
boolean choosing;

ArrayList<Cubie> corners;
ArrayList<Cubie> edges;
ArrayList<Cubie> centers;
ArrayList<Move> sequence;
ArrayList<Move> allMoves;
ArrayList<String> fMoves;

ArrayList<Cubie> back = new ArrayList();
ArrayList<Cubie> front = new ArrayList();
ArrayList<Cubie> left = new ArrayList();
ArrayList<Cubie> right = new ArrayList();
ArrayList<Cubie> top = new ArrayList();
ArrayList<Cubie> down = new ArrayList();

PImage background;
Cube cube;
Cube completeCube;
Move currentMove;
color filler = color(255,192,203);
TextBox t = new TextBox();

void setup() {
	size(displayWidth, displayHeight, P3D);
	// fullScreen(P3D);
	frameRate(60);
	setupCamera();
	// background = loadImage("C:\\Users\\callu\\Desktop\\Processing\\rubiks-cube-solver\\RubiksCube\\bg.png");
	// background.resize(displayHeight, displayWidth);
	counter = 0;
	moveCounter = 0;
	numberOfMoves = 20;
	axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
	middle = axis + - axis;
	speed = 0.001;
	scramble = false;
	hSolve = false;
	lsSolve = false;
	reverse = false;
	paused = false;
	hud = false;
	counterReset = false;
	display2D = true;
	choosing = false;
	corners = new ArrayList<Cubie>();
	edges = new ArrayList<Cubie>();
	centers = new ArrayList<Cubie>();
	sequence = new ArrayList<Move>();
	allMoves = new ArrayList<Move>();
	fMoves = new ArrayList<String>();
	cube = new Cube();
	completeCube = new Cube();
	initTextBox();
	
	smooth(8);
	updateLists();
	if (dim > 1)  InitialiseMoves();
	currentMove = new Move('X', 0, 0);
}

void draw() {
	background(220,220,220);
	// background(background);
	rotateX( - 0.3);
	rotateY(0.6);
	
	updateCam();
	if (!paused)  {
		checkColours();
		if (!cube.animating) {
			printScrambleInfo();
			if (counter <= sequence.size() - 1) {
				currentMove = sequence.get(counter);
				if (currentMove.index > axis)  {
					cube.turnWholeCube(currentMove.currentAxis, currentMove.dir);
				} else {
					cube.turn(currentMove.currentAxis, currentMove.index, currentMove.dir);
				}
				counter++;
			} 
			if (counter == sequence.size() - 1)  {
				counterReset = true;
				sequence.clear();
			}
		}
		if (hSolve) {
			if (turns.length() == 0 && !cube.animating)  {
				if (counterReset)  {
					counter = 0;
					counterReset = false;
				}
				cube.hAlgorithm.solveCube();
			}
		}
		
		if (lsSolve) {
			if (turns.length() == 0 && !cube.animating)  {
				if (counterReset)  {
					counter = 0;
					counterReset = false;
				}
				cube.lsAlgorithm.solveCube();
			}
		}
		
		cube.update();
	}
	scale(50);
	cube.show();
	
	if (!cube.animating && turns.length() > 0) {
		if (!scramble) {
			if (sequence.size() > 0) sequence.clear();
			if (turns.length() > 0) {
				doTurn(cube);
			}
		}
	}
	if (cube.hAlgorithm.solved)  formatMoves();
	updateLists();
	
	// HUD - contains relevant information
	if (!hud)  {
		cam.beginHUD();
		String ctr = "Moves : \t" + str(counter);
		String fps = nf(frameRate, 1, 1);
		float tSize = 12;
		float x = 0;
		float y = tSize;
		textSize(tSize);
		fill(0);
		x += 20;
		y += 20;
		text(ctr, x, y);
		y += 20;
		text("FPS : \t" + fps, x, y);
		y += 20;
		text("Speed : \t" + nf(speed, 1, 1), x, y);
		y += 20;
		text("Cube : \t" + dim + "x" + dim + "x" + dim, x, y);
		// y += 20;
		// float nCombinations = dim == 2 ? fact(7) * pow(3, 6) : 1;
		// nCombinations = dim == 3 ? ((0.5) * (fact(8) * pow(3, 7)) * fact((dim*dim*dim) - 15) * pow(2, (dim*dim*dim)-16)) : nCombinations;
		// text("Total number of combinations:\t" + nfc(nCombinations, 0), x, y);
		// y += 20;
		// text(moves, x, displayHeight-y);
		// y += 20;
		// text(mouseX + ", " + mouseY, x, y);
		// y += 20;
		// text(keyPress, x, y);
		// t.draw();
		if (display2D) twoDimensionalView(displayWidth * 0.75, displayHeight / 20);
		cam.endHUD();
	}
}

void setupCamera() {
	//hint(ENABLE_STROKE_PERSPECTIVE);
	float fov      = PI / 3;  // field of view
	float nearClip = 1;
	float farClip  = 100000;
	float aspect   = float(width) / float(height);  
	perspective(fov, aspect, nearClip, farClip);  
	cam = new PeasyCam(this, 100 * (dim));
}

void updateCam() {
	//----- perspective -----
	float fov      = PI / 3;  // field of view
	float nearClip = 1;
	float farClip  = 100000;
	float aspect   = float(width) / float(height);  
	perspective(fov, aspect, nearClip, farClip);
	//println(cam.getDistance());
}

void initTextBox()  {
	t.W = 300;
	t.H = 35;
	t.X = (displayWidth - t.W) / 2;
	t.Y = displayHeight - displayHeight / 10;
}

void mousePressed() {
	t.pressed(mouseX, mouseY);
}

// void keyPressed() {
//   if(t.keyIsPressed(key, keyCode)) {
//     msg += key;
//   }
// }

void doTurn(Cube cube) {
	// hSolve = true;
	if (turns.length() == 0) return;
	char turn = turns.charAt(0);
	turns = turns.substring(1, turns.length());
	if (turns.length() != 0)	{
		if (turns.charAt(0) == '(' || turns.charAt(0) == ')' || turns.charAt(0) == ' ')  {
			// print(turn + turns.charAt(0) + ", ")
			turns = turns.substring(1, turns.length());
			doTurn(cube);
			return;
		} else if (turns.charAt(0) == '\'' || turns.charAt(0) == '2') {
			print(turn + turns.charAt(0) + ", ");
		} else {
			print(turn + ", ");
		}
	}
	
	
	// boolean clockwise = true;
	int dir = 1;
	
	if (turns.length() > 0 && turns.charAt(0) == '\'') {
		// clockwise = false;
		dir = - 1;
		turns = turns.substring(1, turns.length());
		if (turns.length() >= 4) {      
			if (turns.substring(0, 4).equals("" + turn  + "'" + turn + "'")) {
				//clockwise = true;
				dir = 1;
				turns = turns.substring(4, turns.length());
			}
		}
	} else if (turns.length() > 0 && turns.charAt(0) == '2') {
		dir = 2;
		turns = turns.substring(1, turns.length());
	} else {
		if (turns.length() >= 2) {
			if (turns.charAt(0) == turn && turns.charAt(1) == turn) {
				//clockwise = false;
				dir = - 1;
				turns = turns.substring(2, turns.length());
			}
		}
	}
	if (dir == 1)  fMoves.add(turn + "");
	if (dir == - 1) fMoves.add(turn + "\'");
	if (dir == 2) fMoves.add(turn + "2");
	
	switch(turn) {
		case 'R':
		cube.turn('X', 1, dir);
		// println("R");
		break;
		case 'L':
		cube.turn('X', - 1, dir);
		// println("L");
		break;
		case 'U':
		cube.turn('Y', - 1, dir);
		// println("U");
		break;
		case 'D':
		cube.turn('Y', 1, dir);
		// println("D");
		break;
		case 'F':
		cube.turn('Z', 1, dir);
		// println("F");
		break;
		case 'B':
		cube.turn('Z', - 1, dir);
		// println("B");
		break;
		case 'X':
		cube.turnWholeCube('X', dir);
		// println("X");
		break;
		case 'Y':
		cube.turnWholeCube('Y', dir);
		// println("Y");
		break;
		case 'Z':
		cube.turnWholeCube('Z', dir);
		// println("Z");
		break;
	}
	counter++;
}

void resetCube() {
	setup();
}

void printScrambleInfo() {
	if (dim <= 3) {
		if (scramble) {
			scramble = false;
			print(numberOfMoves + " moves were taken to scramble the cube " + "\n" + moves + "\n");
		} else if (reverse) {
			reverse = false;
			print(numberOfMoves + " moves were taken to solve the cube " + "\n" + moves + "\n");
		}
	}
}

// initialises all possible moves of cube 
void InitialiseMoves() {
	allMoves.clear();
	for (float i = - axis; i <= axis; i++) {
		if (i != 0) {
			// assigns all x axis movements (R, L)
			allMoves.add(new Move('X', i, 2));   // R2  L2
			allMoves.add(new Move('X', i, 1));   // R   L
			allMoves.add(new Move('X', i, - 1));  // R'  L'
			
			// assigns all y axis movements (U, D)
			allMoves.add(new Move('Y', i, 2));   // U2  D2
			allMoves.add(new Move('Y', i, 1));  // U   D
			allMoves.add(new Move('Y', i, - 1));  // U'  D'
			
			// assigns all z axis movements (F, B)
			allMoves.add(new Move('Z', i, 2));   // F2  B2
			allMoves.add(new Move('Z', i, 1));   // F   B
			allMoves.add(new Move('Z', i, - 1));  // F'  B'
		}
	}
	allMoves.add(new Move('X', 1));
	allMoves.add(new Move('X', - 1));
	allMoves.add(new Move('Y', 1));
	allMoves.add(new Move('Y', - 1));
	allMoves.add(new Move('Z', 1));
	allMoves.add(new Move('Z', - 1));
}

long fact(int num) {
	long result = 1;
	
	for (int factor = 2; factor <= num; factor++) {
		result *= factor;
	}
	
	return result;
}

void checkColours() {
	color[] colours = new color[6 * dim * dim * dim];
	// Quantity of each colour of the cube. Should NOT be more or less than this number.
	int qColours = dim * dim;
	// int red = 0;
	// int orange = 0;
	// int white = 0;
	// int yellow = 0;
	// int blue = 0;
	// int green = 0;
	color[] cubeColours = { cube.getCubie(0).red,
			cube.getCubie(0).orange,
			cube.getCubie(0).white,
			cube.getCubie(0).yellow,
			cube.getCubie(0).blue,
			cube.getCubie(0).green};
	
	String[] fColours = {"Red", "Orange", "White", "Yellow", "Blue", "Green"};
	int counter = 0;
	
	for (int j = 0; j < cube.len; j++) {
		for (int i = 0; i < cube.getCubie(j).colours.length; i++) {
			colours[counter] = cube.getCubie(j).colours[i];
			counter++;
		}
	}
	// TODO: Cater checking centers for all cube sizes.
	// Checks centers
	for (Cubie c : centers)  {
		boolean colFound = true;
		color[] cubieColours = new color[6];
		float[] axis = {c.x, c.y, c.z};
		float[] index = { - this.axis, this.axis};
		// print("Center " + centers.indexOf(c) + "\t");
		
		// For x, y, z of cubie
		for (float cAxis : axis) {
			// for axis index of cubie
			for (float axisIndex : index)  {
				//Check if no colours are found for a center.
				if (!colFound)  {
					// println("One of the centers are invalid");
					paused = true;
					continue;
				}
				if (cAxis == axisIndex) {
					colFound = false;
					for (color cCol : cubeColours) {
						for (color cubieColour : c.colours)  {
							if (cubieColour == cCol)  {
								// println(colToString(cCol));
								colFound = true;
								break;
							}
						}
						
					}
				}
			}
		}
	}
	
	// Check edges
	for (Cubie c : edges)  {
		// println("Checking edge " + edges.indexOf(c));
		// for(color cCol : c.colours) {
		//   print("\t" + colToString(cCol));
		// }
		// println("");
		float[] index = { - this.axis, this.axis};
		float[][] colCombos = { {4,2} , {4,0} , {4,3} , {4,1} ,
			  {1,2} , {2,0} , {3,1} , {3,0} ,
			  {5,2} , {5,0} , {5,3} , {5,1} };
		int thisEdge = 0;
		boolean cubieFace1 = true;
		boolean cubieFace2 = true;
		color cubieFace1Colour = color(0);
		color cubieFace2Colour = color(0);
		boolean invalidEdge = true;
		
		if (c.y == - axis && c.z == axis) thisEdge = 0;
		if (c.x == axis && c.z == axis)  thisEdge = 1;
		if (c.y == axis && c.z == axis)  thisEdge = 2;
		if (c.x == - axis && c.z == axis) thisEdge = 3;
		
		if (c.y == - axis && c.x == - axis)thisEdge = 4;
		if (c.y == - axis && c.x == axis) thisEdge = 5;
		if (c.y == axis && c.x == - axis) thisEdge = 6;
		if (c.y == axis && c.x == axis)  thisEdge = 7;
		
		if (c.y == - axis && c.z == - axis)thisEdge = 8;
		if (c.x == axis && c.z == - axis) thisEdge = 9;
		if (c.y == axis && c.z == - axis) thisEdge = 10;
		if (c.x == - axis && c.z == - axis)thisEdge = 11;
		// For every edge
		// TODO: Get it to check which faces of each edge are visible then check those faces of the edge for colours. 
		// If colours are anything but red, orange, blue, green, white or yellow -> it's shit.
		cubieFace1 = false;
		cubieFace2 = false;
		// if(c.colours[(int)colCombos[thisEdge][0]] == color(0) || c.colours[(int)colCombos[thisEdge][1]] == color(0))  continue;
		
		// For every colour that can be on a cubie
		for (color cCol : cubeColours)  {
			if (c.colours[(int)colCombos[thisEdge][0]] == cCol) {
				cubieFace1Colour = c.colours[(int)colCombos[thisEdge][0]];
				cubieFace1 = true;
			}
			if (c.colours[(int)colCombos[thisEdge][1]] == cCol)  {
				cubieFace2Colour = c.colours[(int)colCombos[thisEdge][1]];
				cubieFace2 = true;
			}
			// Checks if valid colours have been found for the edge pieces
			
		}
		if (cubieFace1 && cubieFace2) invalidEdge = false;
		if (cubieFace1Colour == color(0) || cubieFace2Colour == color(0))  invalidEdge = true;
		// if cubieface1 and 2 have colours and they're the same
		if ((cubieFace1 && cubieFace2) && (cubieFace1Colour == cubieFace2Colour))  {
			invalidEdge = true;
			println("apparently " + colToString(cubieFace1Colour) + " is the same as "  + colToString(cubieFace2Colour));
		}
		if (invalidEdge) {
			paused = true;
			println("This cubie edge shouldn't exist");
			println("Edge " + edges.indexOf(c) + "\nDetails : " + c.details());
			return;
		} else {
			// println("Colour 1: " + cubieFace1 + "\tColour 2: " + cubieFace2);
			// println("Edge " + edges.indexOf(c) + "\t" + colToString(cubieFace1Colour) + "\t" + colToString(cubieFace2Colour));
			paused = false;
		}
	}
	
	// for (color c : colours) {
	//   red += c == cube.getCubie(0).red ? 1 : 0;
	//   orange += c == cube.getCubie(0).orange ? 1 : 0;
	//   white += c == cube.getCubie(0).white ? 1 : 0;
	//   yellow += c == cube.getCubie(0).yellow ? 1 : 0;
	//   blue += c == cube.getCubie(0).blue ? 1 : 0;
	//   green += c == cube.getCubie(0).green ? 1 : 0;
	// }
	
	// int[] faceColours = {red, orange, white, yellow, blue, green};
	// counter = 0;
	// for(int i : faceColours)  {
	//   if(i > qColours)  {
	//     paused = true;
	//     println("There are too many " + fColours[counter] + "s\t Should be: " + dim*dim + "\t Actually: " + i);
	//   } else if(i < qColours) {
	//     paused = true;
	//     println("There aren't enough " + fColours[counter] + "s\t Should be: " + dim*dim + "\t Actually: " + i);
	//     println("Red " + red);
	//   }
	//   counter++;
	// }
	// if(red > qColours)  {
	//   paused = true;
	//   println("There are too many reds: ");
	//   println(red + " reds");
	// } else if(red < qColours) {
	//   println("There are not enough reds: ");
	//   println(red + " reds");
	// }
	// if(orange > qColours)  {
	//   paused = true;
	//   print("There are too many oranges: ");
	//   println(orange + " oranges");
	// } else if(orange < qColours)  {
	//   print("There are not enough oranges: ");
	//   println(orange + " oranges");
	// }
	// if(white > qColours)  {
	//   paused = true;
	//   print("There are too many whites: ");
	//   println(white + " whites");
	// } else if(white < qColours) {
	//   print("There are not enough whites: ");
	//   println(white + " whites");
	// }
	// if(yellow > qColours)  {
	//   paused = true;
	//   print("There are too many yellows: ");
	//   println(yellow + " yellows");
	// } else if(yellow < qColours)  {
	//   print("There are not enough yellows: ");
	//   println(yellow + " yellows");
	// }
	// if(blue > qColours)  {
	//   paused = true;
	//   print("There are too many blues: ");
	//   println(blue + " blues");
	// } else if(blue < qColours)  {
	//   print("There are not enough blues: ");
	//   println(blue + " blues");
	// }
	// if(green > qColours)  {
	//   paused = true;
	//   print("There are too many greens: ");
	//   println(green + " greens");
	// } else if(green < qColours) {
	//   print("There are not enough greens: ");
	//   println(green + " greens");
	// }
}

void formatMoves()  {
	moveCounter = 1; 
	int lineLimit = 10;
	if (fMoves.size() > 100)  lineLimit = 15;
	for (int i = 0; i < fMoves.size(); i++)  {
		if (moveCounter % lineLimit == 0) {
			moves += fMoves.get(i) + "\n";
		} else if (moveCounter == fMoves.size()) {
			moves += fMoves.get(i) + ".\n";
		} else {
			if (fMoves.get(i).length() == 2) moves += fMoves.get(i) + " ";
			if (fMoves.get(i).length() == 1) moves += fMoves.get(i) + "  ";
		}
		moveCounter++;
	}
	fMoves.clear();
}


void debugMoves() {
	println("Generating Moves...");
	for (Move m : allMoves)  {
		println("Move : " + m.toString() + "\t" + m.currentAxis + "  " + m.index + "  " + m.dir);
	}
	println("Number of moves : " + allMoves.size());
}

// Always updating positions of every cubie to their respective lists.
void updateLists()  {
	for (int i = 0; i < cube.len; i++) {
		Cubie c = cube.getCubie(i);
		if (c.nCols == 1 && !centers.contains(c))  {
			centers.add(c);
		}
		if (c.nCols == 2 && !edges.contains(c))  {
			edges.add(c);
		}
		if (c.nCols == 3 && !corners.contains(c))  {
			corners.add(c);
		}
	}
}

void twoDimensionalView(float x, float y) {
	int numberOfFaces = 6;
	int numOfColours = dim * dim * dim * numberOfFaces;
	float panelWidth = displayWidth / 3;
	float panelHeight = displayHeight / 5;
	float ox = x;
	float oy = y;
	float bx = x - displayWidth / 10;
	float by = y - displayHeight / 25;
	fill(0);
	// if(mousePressed && (mouseButton == LEFT)) {
	//   bx = mouseX;
	//   by = mouseY;
	// }
	rect(bx, by, panelWidth, panelHeight);
	x = bx;
	y = by + panelHeight / 3.8;
	resetLists();
	populateLists();
	fill(255);
	
	drawSide(left, 1, x, y, panelWidth, panelHeight);// Left - 0
	x += panelWidth / 5.5;
	y += panelHeight / 3.4;
	drawSide(down, 3, x, y, panelWidth, panelHeight); // Down - 3
	y -= panelHeight / 3.4;
	drawSide(front, 4, x, y, panelWidth, panelHeight); // Front - 4
	y -= panelHeight / 3.4;
	drawSide(top, 2, x, y, panelWidth, panelHeight); // Top - 2
	x += panelWidth / 5.5;
	y += panelHeight / 3.4;
	drawSide(right, 0, x, y, panelWidth, panelHeight); // Right - 1
	x += panelWidth / 5.5;
	drawSide(back, 5, x, y, panelWidth, panelHeight); // Back - 5
	x += panelWidth / 3;
	y -= panelHeight / 4.75;
	drawPallette(x, y, panelWidth, panelHeight);
}

void drawSide(ArrayList<Cubie> cubies, int face, float xPos, float yPos, float panelWidth, float panelHeight) {
	float cubieSize = panelWidth / 20;
	float radius = panelHeight / 60;
	float nextCube = cubieSize + panelWidth / 125;
	float resetXPos = xPos;
	float px = mouseX;
	float py = mouseY;
	char currentFace = 'B';
	switch(face)  {
		case 0:
		currentFace = 'R';
		break;
		case 1:
		currentFace = 'L';
		break;
		case 2:
		currentFace = 'U';
		break;
		case 3:
		currentFace = 'D';
		break;
		case 4:
		currentFace = 'F';
		break;
	}
	
	noStroke();
	int cubieNo = 0;
	for (int  i = 0; i < cubies.size(); i++) {
		
		if (i % dim == 0)  {
			xPos = resetXPos;
			yPos = yPos + nextCube;
		}
		// Check if cubie has cursor over it / been clicked
		boolean hit = pointCubie(px, py, xPos, yPos, cubieSize);
		if (hit) {
			fill(filler);
			if (mousePressed && (mouseButton == LEFT)) {
				cubies.get(i).colours[face] = filler;
				cube.update();
				cube.show();
			}
		} else {
			fill(cubies.get(i).colours[face]);
		}
		
		// rect(mouseX-1,mouseY-10, 2, 20);
		// rect(mouseX-10,mouseY-1, 20, 2);
		xPos = xPos + nextCube;
		textSize(cubieSize / 1.5);
		rect(xPos, yPos, cubieSize, cubieSize, radius, radius, radius, radius);
		
		cubieNo++;
		if (cubieNo == ceil(cubies.size() / 2) + 1) {
			// println("Cubie " + cubieNo);
			fill(0);
			text(currentFace, xPos + cubieSize / 2 - radius, yPos + cubieSize / 2 + radius);
		}
	}
}

void drawPallette(float x, float y, float panelWidth, float panelHeight) {
	color[] colours = {red, orange, blue, green, white, yellow};
	float palletteWidth = panelWidth / 12;
	float palletteHeight = panelHeight * 0.9;
	float ox = x;
	float oy = y;
	float px = mouseX;
	float py = mouseY;
	float cubieSize = palletteWidth * 0.8;
	float radius = cubieSize / 5;
	
	fill(205);
	rect(ox, oy, palletteWidth, palletteHeight, radius, radius, radius, radius);
	x += palletteWidth / 10;
	y += palletteHeight / 30;
	for (color c : colours)  {
		boolean hit = pointCubie(px, py, x - cubieSize, y, cubieSize);
		if (hit) {
			fill(255,255,255, 125);
			if (mousePressed && (mouseButton == LEFT)) {
				println("Colour " + colToString(c));
				filler = c;
			}
		} else {
			fill(c);
		}
		rect(x, y, cubieSize, cubieSize, radius, radius, radius, radius);
		y += cubieSize + displayHeight / 120;
	}
	
}

boolean pointCubie(float px, float py, float x, float y, float cubieSize)  {
	
	// is the point inside the rectangle's bounds?
	if (px > x + cubieSize &&        // right of the left edge AND
		px < x + cubieSize * 2 &&   // left of the right edge AND
		py > y &&        // below the top AND
		py < y + cubieSize) {   // above the bottom
		return true;
	}
	return false;
}

void populateLists()  {
	ArrayList<Cubie> newBack = new ArrayList();
	ArrayList<Cubie> newFront = new ArrayList();
	ArrayList<Cubie> newLeft = new ArrayList();
	ArrayList<Cubie> newRight = new ArrayList();
	ArrayList<Cubie> newTop = new ArrayList();
	ArrayList<Cubie> newDown = new ArrayList();
	
	for (int i = 0; i < cube.len; i++) {
		Cubie c = cube.getCubie(i);
		if (c.z == - axis) newBack.add(c);
		if (c.z == axis) newFront.add(c);
		if (c.x == - axis) newLeft.add(c);
		if (c.x == axis) newRight.add(c);
		if (c.y == - axis) newTop.add(c);
		if (c.y == axis) newDown.add(c);
	}
	
	left = getOrderedList(newLeft, - 1, 'X');
	right = getOrderedList(newRight, 1, 'X');
	top = getOrderedList(newTop, - 1, 'Y');
	down = getOrderedList(newDown, 1, 'Y');
	front = getOrderedList(newFront, 1, 'Z');
	back = getOrderedList(newBack, - 1, 'Z');
}

// The order determines how each cubie is laid out in the 2D representation of the 3D cube
ArrayList<Cubie> getOrderedList(ArrayList<Cubie> cubies, int index, char cubeAxis) {
	Cubie[] newList = new Cubie[cubies.size()];
	for (int i = 0; i < cubies.size(); i++) {
		newList[i] = cubies.get(i);
	}
	
	if (dim < 3) {
		println("Fuck all we can do here");
		return cubies;
	}
	
	ArrayList<Cubie> list = new ArrayList();
	
	switch(cubeAxis)  {
		case 'X':
		for (Cubie c : cubies) {
			if (c.y == axis && c.z == - axis * index) {
				newList[8] = c;
				continue;
			}
			if (c.y == axis && c.z == middle) {
				newList[7] = c;
				continue;
			}
			if (c.y == axis && c.z == axis * index)  {
				newList[6] = c;
				continue;
			}
			if (c.y == middle && c.z == - axis * index)  {
				newList[5] = c;
				continue;
			}
			if (c.y == middle && c.z == middle)  {
				newList[4] = c;
				continue;
			}
			if (c.y == middle && c.z == axis * index) {  
				newList[3] = c;
				continue;
			}
			if (c.y == - axis && c.z == - axis * index)  {
				newList[2] = c;
				continue;
			}
			if (c.y == - axis && c.z == middle)  {
				newList[1] = c;
				continue;
			}
			if (c.y == - axis && c.z == axis * index) {
				newList[0] = c;
				continue;
			}
		}
		break;
		case 'Y':
		for (Cubie c : cubies) {
			if (c.x == axis && c.z == axis * index)  {
				newList[2] = c;
				continue;
			}
			if (c.x == axis && c.z == middle) {
				newList[5] = c;
				continue;
			}
			if (c.x == axis && c.z == - axis * index) {
				newList[8] = c;
				continue;
			}
			if (c.x == middle && c.z == axis * index) {  
				newList[1] = c;
				continue;
			}
			if (c.x == middle && c.z == middle)  {
				newList[4] = c;
				continue;
			}
			if (c.x == middle && c.z == - axis * index)  {
				newList[7] = c;
				continue;
			}
			if (c.x == - axis && c.z == axis * index) {
				newList[0] = c;
				continue;
			}
			if (c.x == - axis && c.z == middle)  {
				newList[3] = c;
				continue;
			}
			if (c.x == - axis && c.z == - axis * index)  {
				newList[6] = c;
				continue;
			}
		}
		break;
		case 'Z':
		for (Cubie c : cubies) {
			if (c.x == - axis * index && c.y == - axis)  {
				newList[0] = c;
				continue;
			}
			if (c.x == middle && c.y == - axis)  {
				newList[1] = c;
				continue;
			}
			if (c.x == axis * index && c.y == - axis) {
				newList[2] = c;
				continue;
			}
			if (c.x == middle && c.y == middle)  {
				newList[4] = c;
				continue;
			}
			if (c.x == axis * index && c.y == middle) {
				newList[5] = c;
				continue;
			}
			if (c.x == axis * index && c.y == axis)  {
				newList[8] = c;
				continue;
			}
			if (c.x == middle && c.y == axis) {  
				newList[7] = c;
				continue;
			}
			if (c.x == - axis * index && c.y == middle)  {
				newList[3] = c;
				continue;
			}
			if (c.x == - axis * index && c.y == axis) {
				newList[6] = c;
				continue;
			}
			break;
		}
	}
	for (Cubie c : newList)  {
		list.add(c);
	}
	return list;
}


void resetLists() {
	back.clear();
	front.clear();
	left.clear();
	right.clear();
	top.clear();
	down.clear();
}
