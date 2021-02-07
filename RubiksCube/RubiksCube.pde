import peasy.*;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.Writer;

PeasyCam cam;
char keyPress = 'a';
int displayWidth = 750;
int displayHeight = 750;
int dim = 3;
int counter;
int moveCounter;
int numberOfMoves;
float middle;
float axis;
float speed;
float pSmallestScore;
float percentTilNextMove;
String moves = "";
String turns = "";
boolean colouring = false;
boolean paused;
boolean scramble;
boolean scrambling;
boolean sequenceRunning = true;
boolean hAlgorithmRunning = false;
boolean hSolve;
boolean lsSolve;
boolean twoxtwosolve;
boolean smallIsSolved;
boolean smallSolver;
boolean reverse;
boolean hud;
boolean counterReset;
boolean display2D;
boolean choosing;
boolean threadRunning = false;
boolean clickedOnce = false;
boolean testing = false;
boolean headers;
boolean ksolveRunning;
boolean debugMode;
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
FastCube fCube;
Cube cube;
Cube completeCube;
Move currentMove;
color filler = color(255,192,203);
Button verifyCubeState;
// TextBox t = new TextBox();

// Sets up the Rubik's Cube emulator
void setup() {
	size(displayWidth, displayHeight, P3D);
	//fullScreen(P3D);
	frameRate(60);
	setupCamera();
	// background = loadImage("C:\\Users\\callu\\Desktop\\Processing\\rubiks-cube-solver\\RubiksCube\\bg.png");
	// background.resize(displayHeight, displayWidth);
	debugMode = false;
	counter = 0;
	moveCounter = 0;
	numberOfMoves = 25;
	axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
	middle = (axis) + (-axis);
	speed = 10;
	scramble = false;
	hSolve = false;
	lsSolve = false;
	twoxtwosolve = false;
	smallIsSolved = false;
	reverse = false;
	paused = false;
	counterReset = false;
	choosing = false;

	headers = true;
	hud = true;
	display2D = true;
	// Region: Cubie Arrays for 2D View
		corners = new ArrayList<Cubie>();
		edges = new ArrayList<Cubie>();
		centers = new ArrayList<Cubie>();
	// End Region: Cubie Arrays for 2D View
	// Region: Arrays for moves
		sequence = new ArrayList<Move>(); // Stores a sequence of moves to apply to the cube
		allMoves = new ArrayList<Move>(); // Stores each possible move for each cube size.
		fMoves = new ArrayList<String>();
	// End Region: Arrays for moves
	// Region: Cube objects
		cube = new Cube();		// Graphical Cube object to apply solutions to.
		fCube = new FastCube();	// Cube object that's supposed to be faster when searching for a solution.
		completeCube = new Cube(); // Solved cube for reference point
	// End Region: Cube objects
	
	// Region: Buttons
		verifyCubeState = new Button();
	// End Region: Buttons
	// smooth(8);
	updateLists();
	if (dim > 1)  InitialiseMoves();
	currentMove = new Move('X', 0, 0);
}

// Draws everything within the Rubik's Cube emulator
void draw() {
	background(220,220,220);
	// background(background);
	rotateX(- 0.3);
	rotateY(0.6);
	
	updateCam();
	if (!paused)  {
		if (!cube.animating) {
			printScrambleInfo();
			if (counter <= sequence.size() - 1)	{
				sequenceRunning = true;
				Move move = sequence.get(counter);
				if(counter == 0)	{
					if(sequence.size() == 1 && !headers)	{
						headers = true;
						if(move.index <= axis)	{
							if(debugMode)	{
								println("Move\tAxis\tIndex\tDir");
								println(move + "\t" + move.currentAxis + "\t" + move.index + "\t" + move.dir);
							}
						}
					}
				} else {
					if(debugMode) println(move + "\t" + move.currentAxis + "\t" + move.index + "\t" + move.dir);
				}
				
				if (move.index > axis)  {
					cube.turnWholeCube(move.currentAxis, move.dir);
				} else {
					cube.turn(move.currentAxis, move.index, move.dir);
				}
				counter++;
			} else if(sequence.size() > 0 && counter == sequence.size()) {
				sequence.clear();
				counter = 0;
				headers = false;
				scrambling = false;
			}
		}
		if(sequence.size() == 0 && !cube.animating)	sequenceRunning = false;

		// If we want to solve with human algorithm...
		if (hSolve) {
			if (turns.length() == 0 && !cube.animating)  {
				if (counterReset)  {
					counter = 0;
					counterReset = false;
				}
				cube.hAlgorithm.solve();
			}
		}
		// If we want to solve with search algorithm...
		if (lsSolve) {
			if (turns.length() == 0 && !cube.animating)  {
				if (counterReset)  {
					counter = 0;
					counterReset = false;
				}
				cube.lsAlgorithm.solve();
				// if(!threadRunning)	{
				// 	threadRunning = true;
				// 	// thread("startSearchAlgorithm");
				// }
			}
		}

		if(twoxtwosolve)	{
			if(!threadRunning)	{
				thread("solveSmallCube");
				threadRunning = true;
			}
		}
		cube.update();
	}
	scale(50);
	cube.show();
	// When cube has finished animating with moves left
	if (!cube.animating && turns.length() > 0) {
		// If we're not scrambling...
		if (!scramble) {
			if (sequence.size() > 0) sequence.clear();
			if (turns.length() > 0) {
				doTurn(cube);
			}
		}
	}
	// If we've solved the cube via the human algorithm...
	if (cube.hAlgorithm.solved)  formatMoves();
	updateLists();
	// HUD - contains relevant information
	if (hud)  {
		cam.beginHUD();
		float tSize = 12;
		float x = 0;
		float y = tSize;
		textSize(tSize);
		fill(0);
		x += 20;
		y += 20;
		String ctr = "Moves : \t" + str(counter);
		text(ctr, x, y);
		y += 20;
		String fps = "FPS : " + nf(frameRate, 1, 1);
		text(fps, x, y);
		y += 20;
		text("Speed : \t" + nf((speed*10), 1, 2), x, y);
		// y += 20;
		// text("Cube : \t" + dim + "x" + dim + "x" + dim, x, y);
		if(lsSolve)	{
			y += 20; 
			text("Current score of cube: " + (int)cube.lsAlgorithm.cubeScore + " / " + (dim*dim*6), x, y);
			y += 20;
			text("Heuristic Search Algorithm Active", x ,y);
			y += 20;
			text(nfc(percentTilNextMove, 2) + "%", x, y);
			x += 45;
			text(" complete 'til next algorithm",x ,y);
		}
		if(hSolve)	{
			y += 20;
			text("Human Algorithm Active", x, y);
		}
		if(twoxtwosolve)	{
			y+= 20;
			text("2x2x2 Solver Active" , x, y);
		}
		if(paused)	{
			y += 20;
			text("Paused", x, y);
		}
		y+= 30;
		if(verifyCubeState.rectX == 0)	{
			verifyCubeState.rectX = (int)x;
			verifyCubeState.rectY = (int)y;
			verifyCubeState.rectWidth = 100;
			verifyCubeState.rectHeight = 30;
			verifyCubeState.text = "Verify Cube";
		}
		// verifyCubeState.render();
		// verifyCubeState.update(mouseX, mouseY);
		// if(verifyCubeState.mouseClicked() && dim == 3)	{
		// 	if(verifyCube())	{
		// 		println("Cube state is valid");
		// 	} else {
		// 		println("Cube state is invalid");
		// 		paused = true;
		// 	}
		// }
		y += 20;
		// y += 20;
		// float nCombinations = dim == 2 ? fact(7) * pow(3, 6) : 1;
		// nCombinations = dim == 3 ? ((0.5) * (fact(8) * pow(3, 7)) * fact((dim*dim*dim) - 15) * pow(2, (dim*dim*dim)-16)) : nCombinations;
		// text("Total number of combinations:\t" + nfc(nCombinations, 0), x, y);
		// y += 20;
		if(twoxtwosolve) y-= 20;
		if(moves != "")	{
			float mw = textWidth(moves);
			fill(255);
			x -= 5;
			rect(x, displayHeight-y, mw+10, 100);
			x += 5;
			y -= 15;
			fill(0);
			text(moves, x, displayHeight-y);
			y += 20;
		}
		// text(mouseX + ", " + mouseY, x, y);
		// y += 20;
		// text(keyPress, x, y);
		// t.draw();
		if (display2D) twoDimensionalView(displayWidth * 0.75, displayHeight / 20);
		cam.endHUD();
	}
}

void startSearchAlgorithm()	{
	cube.lsAlgorithm.solve();
	return;
}

void solveSmallCube()	{
	cube.twoxtwoSolver.solve();
	return;
}

// Info dialogue window
void aboutForm()	{
	// This will be a separate dialogue window containing:
	// 1. What the program is
	// 2. How the program works
	// 3. Who the program is by
	}
// Sets the camera view for the program
void setupCamera() {
	//hint(ENABLE_STROKE_PERSPECTIVE);
	float fov      = PI / 3;  // field of view
	float nearClip = 1;
	float farClip  = 100000;
	float aspect   = float(width) / float(height);  
	perspective(fov, aspect, nearClip, farClip);  
	cam = new PeasyCam(this, 100 * (dim));
	}
// Updates the camera view
void updateCam() {
	//----- perspective -----
	float fov      = PI / 3;  // field of view
	float nearClip = 1;
	float farClip  = 100000;
	float aspect   = float(width) / float(height);  
	perspective(fov, aspect, nearClip, farClip);
	//println(cam.getDistance());
	}
/**
* Extracts a single turn from the turns string and applies it to the cube via cube's function, 'turn'
*
* @param	cube The cube that's having a move applied to it
*/
void doTurn(Cube cube) {
	// Return if no moves are left.
	if (turns.length() == 0) return;
	// Store first move from array
	char turn = turns.charAt(0);
	// Initial direction is clockwise
	int dir = 1;
	// Deletes element at index 0
	turns = turns.substring(1, turns.length());
	if (turns.length() > 0)	{
		// If characters are invalid / unrelated to move notation
		if (turns.charAt(0) == '(' || turns.charAt(0) == ')' || turns.charAt(0) == ' ')  {
			// Eliminate irrelevant element from array
			turns = turns.substring(1, turns.length());
			// Recall function
			doTurn(cube);
			return;
		}
		
		// If the first element in the turns array is prime
		if (turns.charAt(0) == '\'') {
			// prime indicates a counter-clockwise move
			dir = - 1;
			// Eliminate prime from first index of turns array
			turns = turns.substring(1, turns.length());
			// If the next two moves are prime and the same as turn then replace these three moves with a clockwise move
			if (turns.length() >= 4) {      
				if (turns.substring(0, 4).equals("" + turn  + "\'" + turn + "\'")) {
					dir = 1;
					turns = turns.substring(4, turns.length());
				}
			}
		// If the first element in turns is 2, this indicates the move requires two rotations.
		} else if (turns.charAt(0) == '2') {
			dir = 2;
			turns = turns.substring(1, turns.length());
		} else {
			// Else if there are two moves left in turns and they're the same as turn, replace it with an anticlockwise version of the original move.
			if (turns.length() >= 2) {
				if (turns.charAt(0) == turn && turns.charAt(1) == turn) {
					dir = - 1;
					turns = turns.substring(2, turns.length());
				}
			}
		}
	}
	
	// Appends move notation to arraylist that's called to print moves to screen.
	if (dir == 1)  fMoves.add(turn + "");
	if (dir == - 1) fMoves.add(turn + "\'");
	if (dir == 2) fMoves.add(turn + "2");
	
	switch(turn) {
		case 'R':
			cube.turn('X', 1, dir);
			break;
		case 'L':
			cube.turn('X', -1, dir);
			break;
		case 'U':
			cube.turn('Y', -1, dir);
			break;
		case 'D':
			cube.turn('Y', 1, dir);
			break;
		case 'F':
			cube.turn('Z', 1, dir);
			break;
		case 'B':
			cube.turn('Z', - 1, dir);
			break;
		case 'X':
			cube.turnWholeCube('X', dir);
			break;
		case 'Y':
			cube.turnWholeCube('Y', dir);
			break;
		case 'Z':
			cube.turnWholeCube('Z', dir);
			break;
	}
	counter++;
	}
// Resets the cube back to a solved state (Helpful when debugging)
void resetCube() {
	setup();
	}
// Prints each move being applied to the cube - Only works for cubes that are 3x3x3, 2x2x2 or 1
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
// Initialises all possible moves the cube can make
// Used for testing each and every move on any cube size when debugging.
void InitialiseMoves() {
	allMoves.clear();
	for (float i = -axis; i <= axis; i++) {
		// This is here to prevent middle slice moves...
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
	// Region: Whole Cube Rotations
		// allMoves.add(new Move('X', 1));
		// allMoves.add(new Move('X', - 1));
		// allMoves.add(new Move('Y', 1));
		// allMoves.add(new Move('Y', - 1));
		// allMoves.add(new Move('Z', 1));
		// allMoves.add(new Move('Z', - 1));
	// End Region: Whole Cube Rotations
	}
// Checks for valid quantities of each colour of the cube - E.g. 3x3x3 cube would have 9 of each colour. No more, no less.
boolean verifyCube() {
	boolean cubeValid = true;
	// Quantity of each colour on the cube. 
	int nColours = dim * dim;
	color[] cubeColours = new color[6 * dim * dim * dim];
	color[] colours = {
		color(255, 140, 0),
  		color(255, 0, 0),
		color(255),
		color(255, 255, 0),
		color(0, 255, 0),
		color(0, 0, 255)
	};
	String[] colourNames = cube.getEachColourName();
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

	// STEP 1: Collect the colours of every single cubie from the cube
	int counter = 0;
	// For every cubie in cube
	for (int j = 0; j < cube.len; j++) {
		// For every face on cubie (Only ever 6 faces)
		for (int i = 0; i < 6; i++) {
			// Store every colour of every cubie to colours array
			cubeColours[counter] = cube.getCubie(j).colours[i];
			counter++;
		}
	}

	// STEP 2: Check if the centers have valid colours in the correct quantities, definitely a concern for larger cubes.
	// TODO: Cater checking centers for all cube sizes.
	// Checks centers
	boolean colFound = false;
	color[] centerColours = new color[6 * (dim-2) * (dim-2)];
	int centerCounter = 0;
	for (Cubie c : centers)  {
		colFound = false;
		// For RGBWYB
		// For every colour on this center cubie
		for (color centerColour : c.colours)  {
			// If the colour is black OR colour has been found, skip this loop.
			if(centerColour == color(0) || colFound) continue;
			for(color eachColour : colours)	{
				if (centerColour == eachColour)  {
					centerColours[centerCounter] = centerColour;
					centerCounter++;
					colFound = true;
				}
			}
		}
		// If no center colour found...
		if(!colFound)	cubeValid = false;
	}
	// If center colour is repeated...
	for(int i = 0; i < centerColours.length-1; i++)	{
		if(!cubeValid) continue;
		for(int j = 0; j < centerColours.length; j++)	{
			if(i == j)	continue;
			if(centerColours[i] == centerColours[j])	{
				cubeValid = false;
				println("Sort out your centers.");
			}
		}
	}
	if(!cubeValid) return cubeValid;
	// Check if edges are valid
	for (Cubie c : edges)  {		
		if (c.y == -this.axis && c.z == this.axis) thisEdge = 0;
		if (c.x == this.axis && c.z == this.axis)  thisEdge = 1;
		if (c.y == this.axis && c.z == this.axis)  thisEdge = 2;
		if (c.x == -this.axis && c.z == this.axis) thisEdge = 3;
		
		if (c.y == -this.axis && c.x == -this.axis)thisEdge = 4;
		if (c.y == -this.axis && c.x == this.axis) thisEdge = 5;
		if (c.y == this.axis && c.x == -this.axis) thisEdge = 6;
		if (c.y == this.axis && c.x == this.axis)  thisEdge = 7;
		
		if (c.y == -this.axis && c.z == -this.axis)thisEdge = 8;
		if (c.x == this.axis && c.z == -this.axis) thisEdge = 9;
		if (c.y == this.axis && c.z == -this.axis) thisEdge = 10;
		if (c.x == -this.axis && c.z == -this.axis)thisEdge = 11;
		// For every edge
		// TODO: Get it to check which faces of each edge are visible then check those faces of the edge for colours. 
		// If colours are anything but red, orange, blue, green, white or yellow -> it's shit.
		cubieFace1 = false;
		cubieFace2 = false;
		// if(c.colours[(int)colCombos[thisEdge][0]] == color(0) || c.colours[(int)colCombos[thisEdge][1]] == color(0))  continue;
		
		// For every colour that can be on a cubie
		for (color cCol : colours)  {
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
		if (cubieFace1 && cubieFace2)	{	
			invalidEdge = false;
		}	else if (cubieFace1Colour == color(0) || cubieFace2Colour == color(0))	{
			invalidEdge = true;
		}
		// if cubieface1 and 2 have colours and they're the same
		if ((cubieFace1 && cubieFace2) && (cubieFace1Colour == cubieFace2Colour))  {
			invalidEdge = true;
			println("Apparently " + colToString(cubieFace1Colour) + " is the same as "  + colToString(cubieFace2Colour));
		}
		if (invalidEdge) {
			cubeValid = false;
			println("This cubie edge shouldn't exist");
			println("Edge " + edges.indexOf(c) + "\nDetails : " + c.details());
		}
	}

	return cubeValid;
	}
// Formats and appends moves from the fMoves arraylist to a string called 'moves'
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
// Prints the debug information for each and every move for any sized cube.// 
void debugMoves() {
	println("Generating Moves...");
	for (Move m : allMoves)  {
		println("Move : " + m.toString() + "\t" + m.currentAxis + "  " + m.index + "  " + m.dir);
	}
	println("Number of moves : " + allMoves.size());
	}

// Called in draw, this updates the positions of every cubie within the cube to their respective lists.
// E.g. Center cubies go to center, Edge cubies go to edges, Corner cubies go to corners
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

/**
* Two dimensional view of the entire cube - optimised for 3x3x3 atm
* TODO: Optimise this for smaller and larger cube sizes
*
* @param	x The x coordinate of where the 2D view is going to appear on the screen
* @param	y The y coordinate ""
*/
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

/**
* Draws a face of the cube in 2D format
* References the 3D cube
*
* @param	cubies		The cubies that we're drawing on this face
* @param	face		The face of the cube we're drawing
* @param	xPos		The x coordinate of this face
* @param	yPos		The y coordinate of this face
* @param	panelWidth	The width of the entire panel holding the 2D view
* @param	panelHeight	The height of the entire panel holding the 2D view
*/
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
	boolean clickedOnce = false;
	for (int  i = 0; i < cubies.size(); i++) {
		if (i % dim == 0)  {
			xPos = resetXPos;
			yPos = yPos + nextCube;
		}
		// Check if cubie has cursor over it / been clicked
		boolean hit = pointCubie(px, py, xPos, yPos, cubieSize);
		if (hit) {
			fill(filler);
			if (mousePressed && (mouseButton == LEFT) && !clickedOnce) {
				clickedOnce = true;
				cubies.get(i).colours[face] = filler;
				// print("DEBUG" + cubies.get(i).details());
				cube.update();
				cube.show();
			} else if(!mousePressed)	{
				clickedOnce = false;
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

/**
* Draws the "pallette" containing the 6 cube colours.
* This is for the user to select colours from when changing the Rubik's Cubie colours
*
* @param	x			The x coordinate
* @param	y			The y coordinate
* @param	panelWidth	The width of the entire panel
* @param	panelHeight	The height of the entire panel holding the 2D view
*/
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
			if (mousePressed && (mouseButton == LEFT) && !clickedOnce) {
				clickedOnce = true;
				println("Colour " + colToString(c));
				filler = c;
			} else if(!mousePressed)	{
				clickedOnce = false;
			}
		} else {
			fill(c);
		}
		rect(x, y, cubieSize, cubieSize, radius, radius, radius, radius);
		y += cubieSize + displayHeight / 120;
	}
	
	}

/**
* Detects whether the mouse is within a 2D cubie's space
* @param	px
* @param	py
* @param	x
* @param	y
* @param	cubieSize
* @return	boolean	if mouse is in space, return true
*/
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
// Populates the lists the 2D view uses for reference of the current cube state
// This is so it updates with the 3D cube as it changes states
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

/**
* The order determines how each cubie is laid out in the 2D representation of the 3D cube
*
* @param	cubies	Cubies we're returning, ordered.
* @param	index	index of clockwise rotation cubie array
* @param	cubeAxis Axis of the cube these cubies are from
*/
ArrayList<Cubie> getOrderedList(ArrayList<Cubie> cubies, int index, char cubeAxis) {
	Cubie[] newList = new Cubie[cubies.size()];
	for (int i = 0; i < cubies.size(); i++) {
		newList[i] = cubies.get(i);
	}
	
	if (dim < 3) {
		// println("Fuck all we can do here");
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
// Reset the lists the 2D view uses to reference the 3D cube
void resetLists() {
	back.clear();
	front.clear();
	left.clear();
	right.clear();
	top.clear();
	down.clear();
	}
// Scramble & solves cube x amount of times adhering to various requirements / conditions
void testDFSSolver()	{
	Random r = new Random();
    String directory = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";
    Writer output;
	String headers = "method,moves,time,memconsum\n";
	// Appending headers to file
		try {
			output =  new BufferedWriter(new FileWriter(directory+"TestResults.txt", true));
		} catch (FileNotFoundException e) {
			println(e);
			return;
		} catch (IOException e)	{
			println(e);
			return;
		}
		try {
			output.append(headers);
			output.close();
		} catch(IOException e)	{
			println("Err >> " + e + "\nAborting file appending");
			return;
		}
	// Appended headers to file
	int tests = 0;
    loadPruningTables(); // Load pruning tables
	String out = "";
	String method = "DFS";
    while(tests < 50) {
		numberOfMoves = 13;

		for(int i = 0; i < 3; i++)  {
			out = "";
			try {
				output =  new BufferedWriter(new FileWriter(directory+"TestResults.txt", true));
			} catch (FileNotFoundException e) {
				println(e);
				return;
			} catch (IOException e)	{
				println(e);
				return;
			}
			cube.scrambleCube(); // Scramble cube with x amount of moves
			while(scrambling)	{
				delay(200);
			}
			// While scramble is not done... wait.
			cube.iksolve(); // Get current cube state to solver
			long start = System.currentTimeMillis();
			cube.ksolve.solve();
			long end = System.currentTimeMillis();
            float duration = (end - start) / 1000F;
			while(ksolveRunning)	{
				delay(200);
			}
			while(sequence.size() > 0 || sequenceRunning)	{
				delay(200);
			}
			println("Test " + (i+1));
			// delay(5000);
			// Once cube is solved
			//   Append scramble and solution
			int memconsum = 1;
			out += method + "," + cube.ksolve.solutionMoves + "," + duration + "," + memconsum + "\n";
			try {
				output.append(out);
				output.close();
			} catch(IOException e)	{
				println("Err >> " + e + "\nAborting file appending");
				return;
			}
			resetCube();
			tests += 1;
		}
    numberOfMoves++;
    }
	testing = false;
	}

void testHumanAlgorithmSolver()	{
	println("Testing human");
	Random r = new Random();
    String directory = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";
    Writer output;
	String headers = "method,moves,time,memconsum\n";
	// Appending headers to file
		try {
			output =  new BufferedWriter(new FileWriter(directory+"TestResults.txt", false));
		} catch (FileNotFoundException e) {
			println(e);
			return;
		} catch (IOException e)	{
			println(e);
			return;
		}
		try {
			output.append(headers);
			output.close();
		} catch(IOException e)	{
			println("Err >> " + e + "\nAborting file appending");
			return;
		}
	// Appended headers to file
	int tests = 0;
	String out = "";
	String method = "Human algorithm";
	numberOfMoves = 10;
    while(tests < 50) {
		numberOfMoves += r.nextInt(2);
		out = "";
		for(int i = 0; i < 3; i++)  {
			println("Test " + tests);
			try {
				output =  new BufferedWriter(new FileWriter(directory+"TestResults.txt", true));
			} catch (FileNotFoundException e) {
				println(e);
				return;
			} catch (IOException e)	{
				println(e);
				return;
			}
			cube.scrambleCube(); // Scramble cube with specified num of moves
			while(scrambling)	{
				delay(200);
			}
			long start = System.currentTimeMillis();
			hSolve = true;
			while(hSolve)	{
				delay(200);
			}
			long end = System.currentTimeMillis();
            float duration = (end - start) / 1000F;
			// If human algorithm is running, sequence has moves left or sequence has moves being performed.
			while(hAlgorithmRunning || sequence.size() > 0 || sequenceRunning)	{
				delay(200);
			}
			// println("Test " + i + " completed. Solution: " + cube.hAlgorithm.solution);

			float memconsum = 1;
			out += method + "," + cube.hAlgorithm.solutionMoves + "," + duration + "," + memconsum + "\n";
			try {
				output.append(out);
				output.close();
			} catch(IOException e)	{
				println("Err >> " + e + "\nAborting file appending");
				return;
			}
			resetCube();
			tests += 1;
		}
    numberOfMoves++;
    }
	testing = false;
	}
/**
* Returns factorial result starting from num
* @param	num	number factorial starts at.
* @return	result 	factorial result
*/
long fact(int num) {
		long result = 1;
		
		for (int factor = 2; factor <= num; factor++) {
			result *= factor;
		}
		
		return result;
	}
