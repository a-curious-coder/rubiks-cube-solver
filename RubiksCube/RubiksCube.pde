import peasy.*;
import controlP5.*;
import processing.opengl.*;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.Writer;
import java.lang.management.OperatingSystemMXBean;
import java.awt.Toolkit; // Clipboard
import controlP5.BitFont;


PeasyCam cam;
ControlP5 cp5;
int currentScreen;

CheckBox checkbox;
Textfield enterMoves;
Textarea outputBox;
boolean outputLog;
Textarea statusBox;
Slider slider;
Button outputBoxOn;
Button scrambleTheCube;
Button solveTheCube;
Button exitButton;
Button helpButton;
Button aboutButton;
Button pauseButton;
Button resetButton;
Button increaseSize;
Button decreaseSize;
Button submitMoves;
Button loadPruneTables;
Button twodimView;
Button pruningChecklist;

ScrollableList dropdown;
String selected = ""; // Selected Algorithm
String enteredMoves = "";
PFont pfont;

char keyPress = 'a';
float pSmallestScore;
float percentTilNextMove;
boolean colouring;
boolean smallIsSolved;
boolean reverse;
boolean counterReset;
boolean choosing;
boolean clickedOnce;
boolean solving;
boolean solved;
boolean refreshText;
boolean loadedPruningTables;
boolean checklistOpen;

int lAxis;
int layers;
// Testing algorithm for csv data variables
String headers = "method,scramble,solve,time,memconsum";

// Mem consumption
long beforeFunctionIsCalled = Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory();
ArrayList<Long> memConsumptionArray = new ArrayList();
long duringFunctionExecution = 0;
long actualMemUsed = 0;

// Display
int displayWidth = 720;
int displayHeight = 450;

boolean graycube = false; // For illustrations
boolean cornersOnly = false;
boolean edgesOnly = false;
boolean centersOnly = false;
// Cube attributes
int dim = 3;
int method = 1;
int moveCounter;
int numberOfMoves;
int availableMoves = 0;
float middle;
float axis;
float speed;
String moves = "";
String turns = "";
boolean paused;
boolean scramble;
boolean scrambling;
boolean slowCube; // purely for show

// Algorithms/moves running
boolean sequenceRunning;
boolean hAlgorithmRunning;
boolean smallIDDFSRunning;
boolean ksolveRunning;
boolean thistlethwaiteRunning;
boolean kociembaRunning;

boolean thistlethwaiteSolving;
boolean hSolve;
boolean lsSolve;
boolean smallSolver;
boolean hud;
boolean display2D;
boolean threadRunning;
boolean testing;
boolean debugMode;

ArrayList<MoveO> MoveOs = new ArrayList(); // for reduction method
ArrayList<Cubie> corners;
ArrayList<Cubie> edges;
ArrayList<Cubie> centers;
ArrayList<Move> sequence;
ArrayList<Move> allMoves;
ArrayList<String> fMoves;

// Holds cubie colours values for each face.
ArrayList<Cubie> back;
ArrayList<Cubie> front;
ArrayList<Cubie> left;
ArrayList<Cubie> right;
ArrayList<Cubie> top;
ArrayList<Cubie> down;

Cube cube;
Move currentMove;
// Colours
color filler = #000000;
color black = #000000;
color orange = #FFA500;
color red = #FF0000;
color white = #FFFFFF;
color yellow = #FFFF00;
color green = #00FF00;
color blue  = #0000FF;
color grey = #808080;

// Sets up the Rubik's Cube simulator
void setup() {
	size(900, 600, P3D);
	// fullScreen(P3D);
	// surface.setResizable(true);
	// surface.setSize(displayWidth, displayHeight);
	// surface.setLocation(0,0);
	// registerMethod("pre", this);	
	surface.setTitle("Rubik's Cube Solver");
	frameRate(60);
	init();
}

// Draws everything within the Rubik's Cube emulator
void draw() {
	theCube();
	switch(currentScreen)	{
		case 0:
			gui();
			break;
		case 1:
			smallgui();
			break;
		case 2:
			// menu();
			break;
	}
}

void init()	{
	checklistOpen = false;
	outputLog = true;
	slowCube = false;
	back = new ArrayList();
	front = new ArrayList();
	left = new ArrayList();
	right = new ArrayList();
	top = new ArrayList();
	down = new ArrayList();
	pfont = createFont("BitFont", 14 ,true);
	currentScreen = 0;
	cp5 = new ControlP5(this);
	cp5.setAutoDraw(false);
	solved = false;
	sequenceRunning = true;
	hAlgorithmRunning = false;
	smallIDDFSRunning = false;
	ksolveRunning = false;
	thistlethwaiteRunning = false;
	kociembaRunning = false;
	thistlethwaiteSolving = false;
	colouring = false;
	clickedOnce = false;
	solving = false;
	refreshText = false;
	threadRunning = false;
	testing = false;
	debugMode = false;
	moveCounter = 0;
	numberOfMoves = 15;
	axis = dim % 2 == 0 ? floor(dim / 2) - 0.5 : floor(dim / 2);
	middle = (axis) + (-axis);
	speed = 50;
	scramble = false;
	hSolve = false;
	lsSolve = false;
	smallIsSolved = false;
	reverse = false;
	paused = false;
	counterReset = false;
	choosing = false;
	hud = true;
	display2D = false;
	loadedPruningTables = false;
	
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
		// fCube = new FastCube();	// Cube object that's supposed to be faster when searching for a solution.
		// completeCube = new Cube(); // Solved cube for reference point
	// End Region: Cube objects
	// smooth(8);
	// cam.reset();
	setupCamera();
	guiElements();
	updateLists();
	if (dim > 1)  InitialiseMoves();
	currentMove = new Move('X', 0, 0);
}

void theCube()	{
	background(102);
	// fill(255, 10); // semi-transparent white
	updateCam();
	
	if (!paused)  {
		if (!cube.animating) {
			printScrambleInfo();
			if (moveCounter <= sequence.size() - 1)	{
				sequenceRunning = true;
				Move move = sequence.get(moveCounter);
				if(debugMode)	{
					if(moveCounter == 0)	{
						if(sequence.size() == 1)	{
							if(move.index <= axis)	{
									println("Move\tAxis\tIndex\tDir");
									println(move + "\t" + move.currentAxis + "\t" + move.index + "\t" + move.dir);
							}
						}
					} else {
						println(move + "\t" + move.currentAxis + "\t" + move.index + "\t" + move.dir);
					}
				}
				
				if (move.index > axis)  {
					cube.turnWholeCube(move.currentAxis, move.dir);
				} else {
					cube.turn(move.currentAxis, move.index, move.dir);
				}
				moveCounter++;
			} else if(sequence.size() > 0 && moveCounter == sequence.size()) {
				sequence.clear();
				scrambling = false;
				moveCounter = 0;
			}
		}

		if(sequence.size() == 0 && !cube.animating)	sequenceRunning = false;

		if(hAlgorithmRunning)	{
			if (turns.length() == 0 && !cube.animating)  {
				if (counterReset)  {
					moveCounter = 0;
					counterReset = false;
				}
				cube.hAlgorithm.solve();
			}
		}
		
		// If we want to solve with search algorithm...
		if (lsSolve) {
			if (turns.length() == 0 && !cube.animating)  {
				if (counterReset)  {
					moveCounter = 0;
					counterReset = false;
				}
				cube.lsAlgorithm.solve();
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
	if (dropdown.isMouseOver() ||
		scrambleTheCube.isMouseOver() ||
		slider.isMouseOver() ||
		pauseButton.isMouseOver() ||
		solveTheCube.isMouseOver() ||
		outputBox.isMouseOver() ||
		enterMoves.isMouseOver() ||
		helpButton.isMouseOver() ||
		aboutButton.isMouseOver() ||
		increaseSize.isMouseOver() ||
		decreaseSize.isMouseOver() ||
		loadPruneTables.isMouseOver() ||
		twodimView.isMouseOver() ||
		pruningChecklist.isMouseOver() ||
		solveTheCube.isMouseOver() ||
		scrambleTheCube.isMouseOver()) {
		cam.setActive(false);
	} else {
		cam.setActive(true);
	}
	// If we've solved the cube via the human algorithm...
	if (cube.hAlgorithm.solved)  formatMoves();
	if(display2D)	updateLists(); // For 2D Display
}


void smallgui()	{
	textFont(pfont);
	String fps = "FPS : " + nf(frameRate, 1, 1);
    float x = 20;
    float y = 20;
	textFont(pfont);
	textSize(14);
	hint(DISABLE_DEPTH_TEST);
	cam.beginHUD();
		text(fps, x, y);
		if(paused)  {
			y += 20;
			text("Paused", x, y);
		}
		y = height-20;
		text("Hit \'x\' to show all controls", x, y);
	cam.endHUD();

	hint(ENABLE_DEPTH_TEST);
}

void gui() {
	textFont(pfont);
	fill(255);
	String ctr = "Moves : \t" + str(moveCounter);
	String fps = "FPS : " + nf(frameRate, 1, 1);
	String speed = "Speed : \t" + nf(this.speed, 1, 2);
	hint(DISABLE_DEPTH_TEST);
	noLights();
	cam.beginHUD();
		cp5.draw();
		float tSize = 12;
		float x = 0;
		float y = tSize;
		textSize(tSize);
		x += 20;
		y += 50;
		text(ctr, x, y);
		y += 20;
		text(fps, x, y);
		y += 20;
		text(speed, x, y);
		y += 20;
		if(ksolveRunning)  {
			text("Korf's Algorithm Active", x, y);
		} else if (thistlethwaiteRunning)  {
			text("Thistlethwaite's Algorithm Active", x, y);
		} else if (hAlgorithmRunning)  {
			text("Human Algorithm Active", x, y);
		} else if (smallIDDFSRunning)  {
			text("Small IDDFS Algorithm Active", x, y);
		}
		if(paused)  {
			y += 20;
			text("Paused", x, y);
		}
		if(!refreshText)	{
			refreshText = true;
			thread("statusBoxText");
		}
		if (display2D) twoDimensionalView();
	cam.endHUD();
	hint(ENABLE_DEPTH_TEST);
}

void guiElements()	{
	// x, y, width, height
	int textfieldHeight = height/40;
	// int fontSize = height/45;
	// ControlFont font = new ControlFont(pfont, fontSize);
	enterMoves = cp5.addTextfield("")
				.setPosition(20, height-45)
				.setSize(width-185, textfieldHeight)
				// .setFont(font)
				.setText("Enter scramble here")
				.setAutoClear(false)
				;
	submitMoves= cp5.addButton("Submit moves")
				.setPosition(width-150, height-45)
				.setSize(130, textfieldHeight)
				.setId(11)
				;
	slider = cp5.addSlider("speed")
				.setPosition(width-240, 20)
				.setSize(200, 20)
				.setRange(1, 100)
				.setValue(50)
				.setColorCaptionLabel(color(20,20,20))
				;
	scrambleTheCube = cp5.addButton("Scramble")
						.setPosition(width-135, 70)
						.setSize(95, 20)
						.setId(1)
						;
	pauseButton		= cp5.addButton("Click to pause")
						.setPosition(width-240, 45)
						.setSize(95, 20)
						.setId(5)
						;
	List l = Arrays.asList("Human Algorithm", 
							"Thistlethwaite's Algorithm", 
							"Kociemba's Algorithm",
							"Korf's Algorithm", 
							"God's Algorithm : Pocket Cube",
							"More Coming Soon")
							;
	dropdown = cp5.addScrollableList("dropdown")
						.setPosition(width-240, 95)
						.setSize(200, 200)
						.setBarHeight(20)
						.setItemHeight(20)
						.addItems(l)
						.setOpen(false)
						.setId(0)
						;
	solveTheCube 	= cp5.addButton("Solve")
						.setPosition(width-240, 70)
						.setSize(95, 20)
						.setId(2)
						;

		color background = color(8, 44, 92, 200);

		outputBox		= cp5.addTextarea("Output")
						.setPosition(width-240, height/3+20)
						.setSize(200, height/3-20)
						.setLineHeight(14)
						.setColorBackground(background)
						.setColorForeground(background)
						;
		if(!outputLog)	outputBox.setVisible(false);
		statusBox		= cp5.addTextarea("Status")
						.setPosition(width-240, height/3)
						.setSize(200, 20)
						.setFont(pfont)
						.setLineHeight(14)
						.setColorBackground(color(0, 0, 0, 125))
						.setColorForeground(color(0, 0, 0, 125))
						;

	loadPruneTables = cp5.addButton("Load Pruning Tables")
						.setPosition(width-135, 45)
						.setSize(95, 20)
						.setId(10)
						;
	exitButton		= cp5.addButton("Exit")
						.setPosition(20, 20)
						.setSize(30, 20)
						.setId(6);
	helpButton		= cp5.addButton("Help")
						.setPosition(60, 20)
						.setSize(30, 20)
						.setId(3)
						;
	aboutButton		= cp5.addButton("About")
						.setPosition(100, 20)
						.setSize(30, 20)
						.setId(4)
						;
	resetButton		= cp5.addButton("Reset")
						.setPosition(140, 20)
						.setSize(30, 20)
						.setId(7)
						;
	decreaseSize	= cp5.addButton("-")
						.setPosition(width-70, height-70)
						.setSize(20, 20)
						.setId(8)
						;
	increaseSize	= cp5.addButton("+")
						.setPosition(width-40, height-70)
						.setSize(20, 20)
						.setId(9)
						;
	twodimView		= cp5.addButton("2D View")
						.setPosition(width-150, height-70)
						.setSize(60, 20)
						.setId(12)
						;
	outputBoxOn		= cp5.addButton("Turn off log")
						.setPosition(width - 380, height -70)
						.setSize(60, 20)
						.setId(13)
						;
	
	checkbox		= cp5.addCheckBox("checkBox")
									.setSize(20, 20)
									.setItemsPerRow(1)
									.setSpacingColumn(10)
									.addItem("Edge Orientations", 0)
									.addItem("Edge Permutations", 0)
									.addItem("Corner Orientations", 0)
									.addItem("Corner Orientations and Corner Permutations", 50)
									.addItem("E-Slice and Corner Orientations Table", 100)
									.addItem("Corner Permutations and MS-Slice Table", 150)
									.addItem("E-Slice Table", 200)
									.addItem("MS-Slice Table", 255)
									.addItem("E-Slice and Edge Orientations", 300)
									.addItem("Edge Orientations and Corner Orientations", 350)
									;
	if(!checklistOpen)	checkbox.setVisible(false);
	int items = 0;
	for(Toggle i : checkbox.getItems())	{
		items += 20;
	}
	checkbox.setPosition(20, height-80-items);

	pruningChecklist=cp5.addButton("Open Pruning Checklist")
									.setPosition(20, height-70)
									.setSize(120, 20)
									.setId(14);
}

void statusBoxText()	{
	if(solving)	{
		if(statusBox.getText() == "Solving")	{
			statusBox.setText("Solving.");
		} else if(statusBox.getText() == "Solving.")	{
			statusBox.setText("Solving..");
		} else if(statusBox.getText() == "Solving..")	{
			statusBox.setText("Solving...");
		} else {
			statusBox.setText("Solving");
		}
	} else if(scrambling){
		statusBox.setText("Scrambling");
	} else if(solved)	{
		statusBox.setText("Solved");
	}
	delay(1000); // Refreshes text every second
	refreshText = false;
}

//ControlP5 callback - method name must be the same as the string parameter of cp5.addScrollableList()
void dropdown(int n) {
	try{
		selected = cp5.get(ScrollableList.class, "dropdown").getItem(n).get("name").toString();
	} catch(Exception e)	{
		println("Err >> " + e + "\nIndex: " + n);
	}
}

void controlEvent(ControlEvent theEvent) {
	if (theEvent.isFrom(checkbox)) {
		// print("got an event from "+checkbox.getName()+"\t\n");
		// checkbox uses arrayValue to store the state of 
		// individual checkbox-items. usage:
		// println(checkbox.getArrayValue());
		// int col = 0;
		// for (int i=0;i<checkbox.getArrayValue().length;i++) {
		// 	int n = (int)checkbox.getArrayValue()[i];
		// 	print(n);
		// }
		// println();
		return;
	}
	switch(theEvent.getController().getId())	{
		case 0:
			if(allMoves.size() > availableMoves)	{
				removeWholeCubeRotations();
			}
			switch(selected)	{
				case "Human Algorithm":
					method = 1;
					break;
				case "Thistlethwaite's Algorithm":
					method = 2;
					break;
				case "Kociemba's Algorithm":
					method = 3;
					break;
				case "Korf's Algorithm":
					method = 4;
					break;
				case "God's Algorithm : Pocket Cube":
					method = 5;
					initialiseWholeCubeRotations();
					break;
			}
			println("Method: " + method);
			break;
		case 1:
			numberOfMoves = 100;
			cube.scrambleCube();
			// cube.hardcodedScrambleCube();
			enterMoves.setValue(" " + moves);
			break;
		case 2:
			println(selected);
			switch(selected)	{
				case "Human Algorithm":
					outputBox.setText("");
					outputBox.append("Human Algorithm\n");
					thread("humanAlgorithm");
					solving = true;
					method = 1;
					break;

				case "Thistlethwaite's Algorithm":
					outputBox.setText("");
					outputBox.append("Thistlethwaite's Algorithm\n");
					threadRunning = true;
					thread("thistlethwaiteAlgorithm");
					threadRunning = false;
					solving = true;
					method = 2;
					break;

				case "Kociemba's Algorithm":
					outputBox.setText("");
					outputBox.append("Kociemba's Algorithm\n");
					threadRunning = true;
					thread("kociembaAlgorithm");
					threadRunning = false;
					solving = true;
					method = 3;
					break;

				case "Korf's Algorithm":
					outputBox.setText("");
					outputBox.append("Korf's Algorithm\n");
					threadRunning = true;
					thread("korfsAlgorithm");
					threadRunning = false;
					solving = true;
					method = 4;
					break;

				case "God's Algorithm : Pocket Cube":
					if(dim < 3)	{
						outputBox.setText("");
						outputBox.append("God's Algorithm : Pocket Cube\n");
						threadRunning = true;
						thread("pocketCubeGodAlgorithm");
						threadRunning = false;
						solving = true;
						method = 5;
						break;
					}
				default:
					outputBox.setText(selected + "\n");
			}
			break;
		case 3:
			thread("controlsWindow");
			break;
		case 4:
			thread("aboutWindow");
			break;
		case 5:
			paused = !paused;
			if(paused)	pauseButton.setLabel("Click to unpause");
			if(!paused)	pauseButton.setLabel("Click to pause");
			break;
		case 6:
			exit();
			break;
		case 7:
			init();
			break;
		case 8:
			dim--;
			init();
			break;
		case 9:
			dim++;
			init();
			break;
		case 10:
			// Load pruning tables based on ticked boxes in checkbox
			thread("loadPruningTables");
			break;
		case 11:
			cube.testAlgorithm(enterMoves.getText());
			break;
		case 12:
			display2D = !display2D;
			break;
		case 13:
			if(!outputLog)	{
				outputLog = true;
				outputBox.setVisible(true);
				outputBoxOn.setLabel("Turn Off Log");
			} else {
				outputLog = false;
				outputBox.setVisible(false);
				outputBoxOn.setLabel("Turn On Log");
			}
			break;
		case 14:
			if(checklistOpen)	{
				checklistOpen = false;
				checkbox.setVisible(false);
				pruningChecklist.setLabel("Open Pruning Checklist");
			} else {
				checklistOpen = true;
				checkbox.setVisible(true);
				pruningChecklist.setLabel("Close Pruning Checklist");
			}
	}
}

void startSearchAlgorithm()	{
	cube.lsAlgorithm.solve();
	return;
}

void threadKorfs()	{
	cube.ksolve.solve();
}

void solveSmallCube()	{
	cube.smallDFSSolver.solve();
	return;
}

// Info dialogue window
void aboutWindow()	{
	msgBox(about(), "About");
}

String about()	{
	String about = "Welcome to my Rubik\'s Cube Solver!\n\n";
	about += "You\'re able to solve the cube using the following methods:\n";
	about += "1. Human Algorithm (7 Step)\n";
	about += "2. Korf\'s Algorithm\n";
	about += "2a. IDDFS Solver for 2x2x2 - No tables\n";
	about += "3. Thistlethwaite\'s Algorithm\n\n";
	about += "I\'m currently working on further algorithms\nI\'m hoping to refine the pre-existing algorithms too. Enjoy.";
	return about;
}

void controlsWindow()	{
	msgBox(controls(), "Controls");
}

String controls()	{
	String controls = "How to use Rubik's Cube Solver\n";
	controls += "Control Description                                                           Key\n";
	controls += "Resets the Rubik's Cube On-Screen to a solved state.      1\n";
	controls += "Solves cube using Human Algorithm                         2\n";
	controls += "Solves cube using Korf's Algorithm\t3\n";
	controls += "Solves cube using Thistlethwaite's Algorithm\t4\n";
	controls += "Increase speed of turning animations on Rubik's Cube\t+\n";
	controls += "Reduce speed of turning animations on Rubik's Cube\t-\n";
	controls += "\nR, L, U, D, F, B - These rotate their respective faces clockwise (Hold shift for anti-clockwise rotation)";
	controls += "\nX, Y, Z - Rotate the entire cube along the specified axis (Hold shift for anti-clockwise rotation)";
	return controls;
}

// Sets the camera view for the program
void setupCamera() {
	hint(ENABLE_STROKE_PERSPECTIVE);
	float fov      = PI / 3;  // field of view
	float nearClip = 1;
	float farClip  = 100000;
	float aspect   = float(width) / float(height);  
	perspective(fov, aspect, nearClip, farClip);  
	cam = new PeasyCam(this, 100 * (dim));
}

// Updates the camera view
void updateCam() {
	rotateX(-0.4);
	rotateY(0.6);
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
	moveCounter++;
}

void resetCube() {
	init();
}
// Prints each move being applied to the cube - Only works for cubes that are 3x3x3, 2x2x2 or 1
void printScrambleInfo() {
	if (dim <= 3) {
		if (scramble) {
			scramble = false;
			if(debugMode) print(numberOfMoves + " moves were taken to scramble the cube " + "\n" + moves + "\n");
		} else if (reverse) {
			reverse = false;
			if(debugMode) print(numberOfMoves + " moves were taken to solve the cube " + "\n" + moves + "\n");
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
	availableMoves = allMoves.size();
	println("There are " + allMoves.size() + " available moves");
}

void initialiseWholeCubeRotations()	{
	// Region: Whole Cube Rotations
	// Required for pocket cube if you want to solve it
		allMoves.add(new Move('X', 1));
		allMoves.add(new Move('X', - 1));
		allMoves.add(new Move('Y', 1));
		allMoves.add(new Move('Y', - 1));
		allMoves.add(new Move('Z', 1));
		allMoves.add(new Move('Z', - 1));
	// End Region: Whole Cube Rotations
	println("There are " + allMoves.size() + " available moves");
}

void removeWholeCubeRotations()	{
	// Region: Whole Cube Rotations
	// Required for pocket cube if you want to solve it
	for(int i = 0; i < 6; i++)	{
		allMoves.remove(allMoves.size()-1);
	}
	println("There are " + allMoves.size() + " available moves");
	// End Region: Whole Cube Rotations
}

/**
* Generates a specified number of scrambles at a specified length saved to a file.
* @param	nScrambles
* @param	lengthScrambles
*/
void generateScrambles(int nScrambles, int lengthScrambles)	{
	String[] scrambles = new String[nScrambles];

	for (int  i = 0; i < nScrambles; i++)	{
		for(int  j = 0; j < lengthScrambles; j++)	{
			if(j == 0)	{
				scrambles[i] = allMoves.get(int(random(allMoves.size()))).toString() + " "; //Random Move.
			} else {
				scrambles[i] += allMoves.get(int(random(allMoves.size()))).toString() + " "; //Random Move.
			}
		}
		// println(scrambles[i]);
	}
	try{
		FileWriter writer = new FileWriter(directory + "/" + "scrambles.txt");
		for (int i = 0; i < scrambles.length; i++) {
			writer.write(scrambles[i] + "\n");
		}
		writer.close();
		println("Generated scrambles, saved as scrambles.txt");
	} catch(Exception e) {
        print(e);
    }
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
	int ctr = 1; 
	int lineLimit = 10;
	if (fMoves.size() > 100)  lineLimit = 15;
	for (int i = 0; i < fMoves.size(); i++)  {
		if (ctr % lineLimit == 0) {
			moves += fMoves.get(i) + "\n";
		} else if (ctr == fMoves.size()) {
			moves += fMoves.get(i) + ".\n";
		} else {
			if (fMoves.get(i).length() == 2) moves += fMoves.get(i) + " ";
			if (fMoves.get(i).length() == 1) moves += fMoves.get(i) + "  ";
		}
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

// Region: 2D View
	/**
	* Two dimensional view of the entire cube - optimised for 3x3x3 atm
	* TODO: Optimise this for smaller and larger cube sizes
	*
	* @param	x The x coordinate of where the 2D view is going to appear on the screen
	* @param	y The y coordinate ""
	*/
	void twoDimensionalView() {
		int numberOfFaces = 6;
		int numOfColours = dim * dim * dim * numberOfFaces;
		float pWidth = width-width/8;
		float pHeight = height-height/4;
		if(mouseX > (width/2-pWidth/2) && mouseX < (width/2+pWidth/2) &&
			mouseY > (height/2-pHeight/2) && mouseY < (height/2+pHeight/2))	{
			cam.setActive(false);
		}
		float fSize = pWidth/9; // Face size
		// println("fSize: " + fSize);
		if(dim == 4)	fSize = pWidth/12;
		float cSize = fSize/dim; // Cube sizes
		// println("cSize: " + cSize);
		float fSpacer = 0; // Space between faces
		fill(255);
		rectMode(CENTER);
		rect(width/2, height/2, pWidth, pHeight);
		fill(0);
		stroke(0);
		strokeWeight(cSize/15);
		text("2D View\nChange the Cube's Colours.", width/2, (height/2 - pHeight/2 +20));
		rectMode(CORNER);
		float x = pWidth/6;
		float y = pHeight/2;

		// Handles cubes
		resetLists();
		populateLists();
		
		drawSide(left, 'L', x, y, cSize);// Left - 0
		x += fSize + fSpacer;
		y += fSize + fSpacer;
		drawSide(down, 'D', x, y, cSize); // Down - 3
		y -= fSize + fSpacer;
		drawSide(front, 'F', x, y, cSize); // Front - 4
		y -= fSize + fSpacer;
		drawSide(top, 'U', x, y, cSize); // Top - 2
		x += fSize + fSpacer;
		y += fSize + fSpacer;
		drawSide(right, 'R', x, y, cSize); // Right - 1
		x += fSize + fSpacer;
		drawSide(back, 'B', x, y, cSize); // Back - 5
		x = pWidth - fSize;
		y = pHeight - 200;
		drawPallette(x, y, cSize*1.5);
		}

	/**
	* Draws a face of the cube in 2D format
	* References the 3D cube
	* @param	cubies		The cubies that we're drawing on this face
	* @param	face		The face of the cube we're drawing
	* @param	x		The x coordinate of this face
	* @param	y		The y coordinate of this face
	* @param    cSize	The cube size
	*/
	void drawSide(ArrayList<Cubie> cubies, 
					char currentFace, 
					float x, 
					float y,
					float cSize) {
		
		// float radius = cSize/10;
		float radius = 0;
		// float spacer = cSize/8;
		float spacer = 0;
		
		float nextCube = cSize + spacer;
		float resetXPos = x;
		int face = 0;

		rectMode(CORNER);
		// The face integer represents the index of the colour for that specific face.
		switch(currentFace)	{
			case 'L':
				face = 1;
				break;
			case 'U':
				face = 2;
				break;
			case 'D':
				face = 3;
				break;
			case 'F':
				face = 4;
				break;
			case 'B':
				face = 5;
				break;
		}

		int cubieNo = 0;
		boolean clickedOnce = false;
		// For each cubie on the current face
		for (int  i = 0; i < cubies.size(); i++) {
			Cubie c = cubies.get(i);
			// Initialise x and y
			x = i % dim == 0 ? resetXPos : x;
			y = i % dim == 0 ? y + nextCube : y;
			// Check if cubie has cursor over it and has been clicked
			if (pointCubie(x+spacer, y, cSize)) {
				fill(filler, 185);
				// If cubie has been clicked, replace the colour with selected colour
				if (mousePressed && mouseButton == LEFT && !clickedOnce) {
					clickedOnce = true;
					c.colours[face] = filler;
					cube.update();
					cube.show();
				} else {
					clickedOnce = false;
				}
			} else {
				fill(c.colours[face]);
			}
			
			x += nextCube;
			// rect(x, y, cSize, cSize, radius);
			square(x, y, cSize);
			cubieNo++;
			// Draw letter to center cubie
			if (!(cubies.size() % 2 == 0) && cubieNo == ceil(cubies.size() / 2) + 1) {
				fill(0);
				textSize(cSize * 0.5);
				text(currentFace, (x + (cSize-spacer) / 3.8),  y + (cSize-spacer) / 1.5);
			} else if(cubies.size() % 2 == 0 && cubieNo == dim*dim/2+dim/2+1) {
				fill(0);
				textSize(cSize * 0.5);
				text(currentFace, (x + (cSize-spacer) / 3.8),  y + (cSize-spacer) / 1.5);
			}
		}
		}
	/**
	* Draws the "pallette" containing the 6 cube colours.
	* This is for the user to select colours from when changing the Rubik's Cubie colours
	* @param	x			The x coordinate
	* @param	y			The y coordinate
	* @param	panelWidth	The width of the entire panel
	* @param	panelHeight	The height of the entire panel holding the 2D view
	*/
	void drawPallette(float x, float y, float cSize) {
		color[] colours = {red, orange, blue, green, white, yellow};
		float spacer = cSize/10; // Spacer between squares
		float pWidth = cSize * 1.2; // Pallette width
		float pHeight = (cSize * 6) + (spacer * 8); // "" height
		float radius = cSize / 5; // Radius of square corners
		rectMode(CENTER);
		fill(0);
		rect(x, y, pWidth, pHeight, radius);
		y += -(pHeight/2) + spacer;
		// stroke(0);
		rect(mouseX, mouseY, 30, 1);
		rect(mouseX, mouseY, 1, 30);
		rectMode(CORNER);
		x -= cSize/2;
		for (color c : colours)  {
			if (pointCubie(x-(cSize), y-spacer, cSize)) {
				fill(red(c), green(c), blue(c), 175);
				if (mousePressed && (mouseButton == LEFT) && !clickedOnce) {
					clickedOnce = true;
					filler = c;
				} else if(!mousePressed)	{
					clickedOnce = false;
				}
			} else {
				fill(c);
			}
			rect(x, y, cSize, cSize, radius);
			y += cSize + spacer;
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
	boolean pointCubie(float x, float y, float cubieSize)  {
		// is the point inside the rectangle's bounds?
		if (mouseX > x + cubieSize &&        // right of the left edge AND
			mouseX < x + cubieSize * 2 &&   // left of the right edge AND
			mouseY > y &&        // below the top AND
			mouseY < y + cubieSize) {   // above the bottom
			fill(255,0,0);
			rect(mouseX, mouseY, 1, 1);
			return true;
		}
		return false;
	}
	// Populates the lists for the 2D view
	void populateLists()  {
		left = 	getOrderedList(-1, 'X');
		right = getOrderedList(1, 'X');
		top = 	getOrderedList(-1, 'Y');
		down = 	getOrderedList(1, 'Y');
		front = getOrderedList(1, 'Z');
		back = 	getOrderedList(-1, 'Z');
	}

	/**
	* The order determines how each cubie is laid out in the 2D View
	* @param	index	index of the face on the cube
	* @param	cubeAxis Axis of the cube these cubies are from
	*/
	ArrayList<Cubie> getOrderedList(int index, char cubeAxis) {
		ArrayList<Cubie> faceCubies = new ArrayList();
		ArrayList<Cubie> orderedList = new ArrayList();
		Cubie[] allCubies = cube.getCubies();

		switch(cubeAxis)  {
			case 'X':
				for(Cubie c : allCubies)	{
					if(c.x == index*axis) faceCubies.add(c);
				}
				for(float y = -axis; y <= axis; y++)	{
					if(index == -axis)	{
						for(float z = -axis; z <= axis; z++)	{
							for(Cubie c : faceCubies)	{
								if(c.y == y && c.z == z)
									orderedList.add(c);
							}
						}
					} else {
						for(float z = axis; z >= -axis; z--)	{
							for(Cubie c : faceCubies)	{
								if(c.y == y && c.z == z)
									orderedList.add(c);
							}
						}
					}
				}
				break;
			case 'Y':
				for(Cubie c : allCubies)	{
					if(c.y == index*axis) faceCubies.add(c);
				}
				if(index == -axis)	{
				for(float z = -axis; z <= axis; z++)	{
						for(float x = -axis; x <= axis; x++)	{
							for(Cubie c : faceCubies)	{
								if(c.x == x && c.z == z)	
									orderedList.add(c);
							}
						}
					} 
				}	else	{
					for(float z = axis; z >= -axis; z--)	{
						for(float x = -axis; x <= axis; x++)	{
							for(Cubie c : faceCubies)	{
								if(c.x == x && c.z == z)	
									orderedList.add(c);
							}
						}
					}
				}
				break;
			case 'Z':
				for(Cubie c : allCubies)	{
					if(c.z == index*axis) faceCubies.add(c);
				}
				for(float y = -axis; y <= axis; y++)	{
					if(index == axis)	{
						for(float x = -axis; x <= axis; x++)	{
							for(Cubie c : faceCubies)	{
								if(c.y == y && c.x == x)	orderedList.add(c);
							}
						}
					} else {
						for(float x = axis; x >= -axis; x--)	{
							for(Cubie c : faceCubies)	{
								if(c.y == y && c.x == x)	orderedList.add(c);
							}
						}
					}
				}
				break;
		}
		return orderedList;
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
// End Region: 2D View

void testAlgorithm()	{
	String[] methodNames = {"Human Algorithm", "Thistlethwaite's Algorithm", "Kociemba's Algorithm", "Korf's Algorithm", "Pocket Cube God's Algorithm"};
	
	println(methodNames[method-1]);
    String directory = System.getProperty("user.dir");

    Writer output;
	boolean headersInFile = false;
	// Region: Read file and check for headers
		try {
			BufferedReader br = new BufferedReader(new FileReader(directory + "/TestResults.txt"));
			try {
				String line = "";
				while((line = br.readLine()) != null)
				{
					String[] words = line.split(" ");
					for (String word : words) {
						if (word.equals(headers)) {
							headersInFile = true;
						}
					}
				}
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	// End Region: Read file and check for headers
	// Region: If there aren't any headers in the csv file, append them.
		if(!headersInFile)	{
		// Appending headers to file
			try {
				output =  new BufferedWriter(new FileWriter(directory+"/TestResults.txt", false));
			} catch (FileNotFoundException e) {
				println(e);
				return;
			} catch (IOException e)	{
				println(e);
				return;
			}
			try {
				output.append(headers + "\n");
				output.close();
			} catch(IOException e)	{
				println("Err >> " + e + "\nAborting file appending");
				return;
			}
		}
	// End Region: If there aren't any headers in the csv file, append them.
	int lines = 0;
	ArrayList<String> moves = new ArrayList();
	try{
		FileReader fileReader = new FileReader(directory + "/scramble.txt");
		BufferedReader bufferedReader = new BufferedReader(fileReader);
		String line = null;
		while ((line = bufferedReader.readLine()) != null) {
			lines++;
			moves.add(line);
		}
		bufferedReader.close();
	} catch(Exception e)	{
		println(e);
	}

	int tests = 0;
	numberOfMoves = 100;
    while(tests < lines) {
		delay(10);
		String out = "";
		println("Test " + (tests+1) + " / " + lines);
		// Region: Prepare file for writing data.
			try {
				output =  new BufferedWriter(new FileWriter(directory+"/TestResults.txt", true));
			} catch (FileNotFoundException e) {
				println(e);
				return;
			} catch (IOException e)	{
				println(e);
				return;
			}
		// End Region: Prepare file for writing data.

		// Scramble cube with specified num of moves
		// cube.scrambleCube();
		cube.testAlgorithm(moves.get(tests));
		// Wait for cube to finish scrambling
		while(scrambling || sequence.size() != 0)	delay(200);
		println("Scrambled");
		// Start timer (to see how long solver takes)
		long start = System.currentTimeMillis();
		int moveCount = 0;
		println("Solving... " + method);
		switch(method)	{
			case 1:
				// Set human solve boolean to true - main loop should start solving cube
				hSolve = true;
				// While human solver is running, wait.
				while(hAlgorithmRunning || hSolve)	delay(200);
				moveCount = cube.hAlgorithm.moveCount;
				break;
			case 2:
				cube.tsolve();
				cube.thistlethwaite.solve();
				while(thistlethwaiteRunning)	delay(200);
				moveCount = cube.thistlethwaite.moveCount;
				break;
			case 3:
				// Initialise solving method
				cube.optimalSolver();
				cube.kociembaSolver.solve();
				while(kociembaRunning)	delay(200);
				moveCount = cube.kociembaSolver.moveCount;
				break;
			case 4:
				cube.ksolve.solve();
				while(ksolveRunning)	delay(200);
				moveCount = cube.ksolve.moveCount;
				break;
			case 5:
				cube.iSmallSolver();
				cube.smallDFSSolver.solve();
				moveCount = cube.smallDFSSolver.moveCount;
				break;
		}
		
		// Get average value from array of memory consumption data.
		for(long j : memConsumptionArray)	{
			duringFunctionExecution += j;
		}
		// Store average mem consumption for this solve to variable
		duringFunctionExecution = duringFunctionExecution/memConsumptionArray.size();
		// Clear the array for next solve.
		memConsumptionArray.clear();
		// Calculate memory used/total 
		if(duringFunctionExecution != 0)	actualMemUsed = duringFunctionExecution - beforeFunctionIsCalled;
		duringFunctionExecution = 0;
		// If algorithm is running, sequence has moves left or sequence has moves being performed.
		while(sequence.size() > 0 || sequenceRunning)	delay(200);

		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;

		long memconsum = actualMemUsed;
		out += method + "," + numberOfMoves + "," + moveCount + "," + duration + "," + memconsum + "\n";
		// Region: append data to file
			try {
				output.append(out);
				output.close();
			} catch(IOException e)	{
				println("Err >> " + e + "\nAborting file appending");
				return;
			}
		// Region: append data to file
		// resetCube();
		tests += 1;
    }
	testing = false;
}
// Testing Performance Data Functions
void nodesPerSecond()	{
	long nodes1 = 0;
	long nodes2 = 0;
	while(true)	{
		nodes1 = cube.ksolve.nodes;
		delay(1000);
		nodes2 = cube.ksolve.nodes;
		println("Number of nodes this second: " + (nodes2 - nodes1));
	}
}

// Saves performance stats of the solving algorithm every 10 seconds to a file.

void oneMinuteSearchStats()	{
	// Nodes traverse 
	// Depth
	// Solution Boolean
	// Pruning tables used?
	int second = 0;
	String stats = "Depth\tTime\n";
	long start = System.currentTimeMillis();
	int cDepth = 0;

	while(cDepth <21)	{
		delay(10);
		if(cube.ksolve.currentDepth > cDepth)	{
			cDepth = cube.ksolve.currentDepth;
			second++;
			long end = System.currentTimeMillis();
			long duration = end-start;
			stats += cube.ksolve.currentDepth + "\t" + duration + "\n";
			println("[" + second + "]\tTracked: " + cube.ksolve.currentDepth + "\t" + duration + "\n");
		}
		long e = System.currentTimeMillis();
		long d = e-start;
		if(d == 200000 % 20000)	println(d);	
		if(d >= 200000)	break;
	}
	println("Done");
	stringToFile(directory+"stats.txt", stats);
}
// End Testing Performance Data Functions

void humanAlgorithm()	{
	hAlgorithmRunning = true;
}

void thistlethwaiteAlgorithm()	{
	while(sequence.size() > 0 || sequenceRunning)	delay(200);
	cube.tsolve();
	cube.thistlethwaite.solve();
	}

void kociembaAlgorithm()	{
	cube.optimalSolver();
	cube.kociembaSolver.solve();
}

void korfsAlgorithm()	{
	cube.ksolve();
	cube.ksolve.solve();
	}

void pocketCubeGodAlgorithm()	{
	if(dim != 2)	return;
	cube.iSmallSolver();
	cube.smallDFSSolver.solve();
}
void lsSolve()	{
	cube.lsAlgorithm.solve();
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

void msgBox(String msg, String title){
  	// Messages
	try {
		javax.swing.JOptionPane.showMessageDialog(null, msg, title, javax.swing.JOptionPane.INFORMATION_MESSAGE);
	} catch (Exception e)	{
		javax.swing.JOptionPane.showMessageDialog(null, "Error occurred with this dialogue box 😬" + e);
	}
}
// Global Print - Prints string to console and outputbox in GUI
void gPrint(String s)	{
	println(s);
	outputBox.append(s + "\n");
}

void stringToFile(String destination,  String s)	{
	try {
		BufferedWriter outputWriter = null;
		outputWriter = new BufferedWriter(new FileWriter(destination));
		
		outputWriter.write(s);
		outputWriter.newLine();

		outputWriter.flush();  
		outputWriter.close(); 
	} catch(Exception e) {
		print(e);
	}
}
void pixBox(String title)	{
	String dir = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";
	try{
		java.awt.image.BufferedImage image = javax.imageio.ImageIO.read(new File(dir+"controls.png"));
		javax.swing.JLabel picLabel = new javax.swing.JLabel(new javax.swing.ImageIcon(image));
		javax.swing.JOptionPane.showMessageDialog(null, picLabel, title, javax.swing.JOptionPane.PLAIN_MESSAGE, null);
	} catch(Exception e)	{
		println("Didny work");
	}
}
void pixWindow()	{
	pixBox("Rubik's Cube Solver Controls");
}
