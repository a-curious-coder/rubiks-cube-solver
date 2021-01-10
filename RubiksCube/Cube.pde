class Cube {
	
	char currentAxis;
	int len;
	int currentDirection;
	int dimensions;
	float rotationAngle;
	float rotatingIndex;
	boolean rotatingCubie = false;
	boolean animating = false;
	boolean clockwise = true; 
	boolean turningWholeCube = false;
	Cubie[] cubies;
	ArrayList<Cubie> rotatingCubies;
	ArrayList<ArrayList<Cubie>> cubieLists;
	HumanAlgorithm hAlgorithm;
	LocalSearch lsAlgorithm;
	solve2x2 twoxtwoSolver;
	
	Cube() {
		dimensions = dim;
		// Instantiates the number of cubies within the cube based on the cubes size. (Eliminates storing inner cubies)
		cubies = dim == 1 ? new Cubie[1] : new Cubie[(int)(pow(dim, 3) - pow(dim - 2, 3))];
		cubieLists = new ArrayList();
		rotatingCubies = new ArrayList();
		len = cubies.length;
		currentDirection = 0;
		rotationAngle = 0;
		rotatingIndex = 0;
		int index = 0;
		
		for (float x = 0; x < dim; x++) {
			for (float y = 0; y < dim; y++) {
				for (float z = 0; z < dim; z++) {
					// If cubie is within the cube, it's not created/stored
					if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
					PMatrix3D matrix = new PMatrix3D();
					matrix.translate(x - axis, y - axis, z - axis);
					cubies[index] = new Cubie(matrix, x - axis, y - axis, z - axis);
					index++;
				}
			}
		}
		hAlgorithm = new HumanAlgorithm(this);
		lsAlgorithm = new LocalSearch(this);
	}

	/**
	* Constructor used for cloning a cube object
	*
	* @param	c The cube we're cloning
	*/
	Cube(Cube c)	{
		
		cubies = dim == 1 ? new Cubie[1] : new Cubie[(int)(pow(dim, 3) - pow(dim - 2, 3))];
		cubieLists = new ArrayList();
		rotatingCubies = new ArrayList();
		len = cubies.length;
		currentDirection = 0;
		rotationAngle = 0;
		rotatingIndex = 0;
		
		// For every cubie in the cube
		for(int i = 0; i < c.len; i++)	{
			// This object's cubie becomes a clone of original cube's cubie
			this.cubies[i] = new Cubie(c.cubies[i]);
			// If locations between cubies do NOT match
			if(this.cubies[i].x != c.cubies[i].x || this.cubies[i].y != c.cubies[i].y || this.cubies[i].z != c.cubies[i].z)	{
				println("Location does not match");
			}

			boolean coloursMatch = true;
			// If colours do NOT match between original and cloned cubie, coloursMatch = false.
			if(!(Arrays.equals(this.cubies[i].colours, c.cubies[i].colours)))	{
				int colcounter = 0;
				coloursMatch = false;
				for(color col : this.cubies[i].colours)	{
					print(colToString(col) + "\t" + colToString(c.cubies[i].colours[colcounter]));
					colcounter++;
				}
			}
		}
	}
	

	void iSmallSolver()	{
		twoxtwoSolver = new solve2x2(this);
	}
	/**
	* Shows the cube on ~reen
	*/
	void show() {
		int angleMultiplier = currentDirection;
		
		int i = 0;
		for (float x = 0; x < dim; x++) {
			for (float y = 0; y < dim; y++) {
				for (float z = 0; z < dim; z++) {
					if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
					push();
					if (animating && (turningWholeCube || rotatingCubies.contains(cubies[i]))) {
						switch(currentAxis) {
							case 'X' : 
							if (rotatingIndex == - axis)  {
								rotateX(angleMultiplier * - rotationAngle);
							} else {
								rotateX(angleMultiplier * rotationAngle);
							}
							break;
							case 'Y':
							rotateY(angleMultiplier * - rotationAngle);
							break;
							case 'Z':
							if (rotatingIndex == - axis)  {
								rotateZ(angleMultiplier * - rotationAngle);
							} else {
								rotateZ(angleMultiplier * rotationAngle);
							}
							break;
						}
					}
					// Show cubie
					cubies[i].show();
					pop();
					i++;
				}
			}
		}
	}
	
	/**
	* Updates the cubes' state
	*/
	void update() {
		if (animating) {
			if (rotationAngle < HALF_PI) {
				float scrambleMultiplier = 1;
				if (scramble) {
					scrambleMultiplier = 5;
				} 
				int turningEaseCoeff = 2;
				if (rotationAngle < HALF_PI / 4) {
					rotationAngle += scrambleMultiplier * speed / map(rotationAngle, 0, HALF_PI / 4, turningEaseCoeff, 1);
				} else if (rotationAngle > HALF_PI - HALF_PI / 4) {
					rotationAngle += scrambleMultiplier * speed / map(rotationAngle, HALF_PI - HALF_PI / 4, HALF_PI, 1, turningEaseCoeff);
				} else {
					rotationAngle += scrambleMultiplier * speed;
				}
			}
			if (rotationAngle >= HALF_PI) {
				rotationAngle = 0;
				animating = false;
				int dir = clockwise ? 1 : - 1;
				if (turningWholeCube) {
					finishTurningWholeCube(currentAxis, currentDirection);
				} else {
					finaliseTurn(currentAxis, rotatingIndex, currentDirection);
				}
			}
		}
	}
	
	/**
	* Turns the face of the cube
	*
	* @param	axisFace	The axis the face we're turning is on
	* @param 	index		The index of the face we're turning
	* @param	dir			The direction we're turning. E.g. clockwise / anti-clockwise / 2 rotations
	*/
	void turn(char axisFace, float index, int dir) {
		if (animating) {
			rotationAngle = 0;
			finaliseTurn(currentAxis, rotatingIndex, currentDirection);
		}
		// TODO: Temporary fix here... 
		// Unsure why the D face won't behave accordingly to it's given direction. Needs inverting.
		if(axisFace == 'Y' && index == axis && dir != 2)	dir = -dir;
		currentAxis = axisFace;
		currentDirection = dir;
		rotatingIndex = index;
		animating = true;
		cubieLists = getAllCubiesToRotate(currentAxis, index);
		
		rotatingCubies.clear();
		
		for (int i = 0; i < cubieLists.size(); i++) {
			rotatingCubies.addAll(cubieLists.get(i)); 
		}
	}
	
	/**
	* Turns the entire cube along the specified axis
	*
	* @param	axis	The axis we're turning the cube along
	* @param	dir		The direction of the rotation we're making. E.g. clockwise / anticlockwise
	*/
	void turnWholeCube(char axis, int dir) {
		if (animating) return;
		
		animating = true;
		turningWholeCube = true;
		currentAxis = axis;
		currentDirection = dir;
		rotatingIndex = 0;
	}
	
	/**
	* Finalises a turn on the cube - doesn't cater for whole cube turns.
	*
	* @param	axisFace	The axis of the face we're turning
	* @param	index		The index of the face we're turning
	* @param	dir			The direction the face is turning
	*/
	void finaliseTurn(char axisFace, float index, int dir) {
		animating = false; 
		if (axisFace == 'X' && index > - axis && dir != 2)  dir = -currentDirection;
		if (axisFace == 'Z' && index == - axis && dir != 2) dir = -currentDirection;
		
		for (Cubie c : rotatingCubies) { 
			c.turn(axisFace, dir); 
		}
		
		for (int j = 0; j < cubieLists.size(); j++) {
			ArrayList<Cubie> temp = cubieLists.get(j);
			ArrayList<Cubie> newCubies = new ArrayList(temp);
			for (int i = 0; i < dim - 1 - j * 2; i++) { 
				if (dir == - 1) {
					//remove from end and add to start
					temp.add(0, temp.remove(temp.size() - 1));
				} else {
					//remove from front and add to the end
					if (dir == 2)	{
						temp.add(temp.remove(0));
					}
					temp.add(temp.remove(0));
				}
			}
			returnListToCube(newCubies, temp, axisFace, index, j);
		}
	}
	
	/**
	* Finalises turning the entire cube
	*
	* @param	axisFace	The axis of the face we're turning
	* @param	dir			The direction we're turning
	*/
	void finishTurningWholeCube(char axisFace, int dir) {
		dir = axisFace == 'X' ? - currentDirection : currentDirection;
		animating = false;
		turningWholeCube = false;
		int i = 0;
		for (Cubie c : cubies) {
			c.turn(axisFace, dir); 
		}
		
		for (float index = - axis; index <= axis; index++) {
			cubieLists = getAllCubiesToRotate(axisFace, index);
			for (int j = 0; j < cubieLists.size(); j++) {
				ArrayList<Cubie> temp = cubieLists.get(j);
				ArrayList<Cubie> newCubies = new ArrayList(temp);
				for (int k = 0; k < dim - 1 - j * 2; k++) {
					if (dir == - 1) {
						temp.add(0, temp.remove(temp.size() - 1)); 
					} else {
						temp.add(temp.remove(0));
					}
				}
				returnListToCube(newCubies, temp, axisFace, index, j);
			}
		}
	}
	
	/**
	* Collects cubies from an axis at specified index ready for rotation
	*
	* @param	axisFace	The axis of the face we're collecting cubies from
	* @param	index		The index of the face we're collecting cubies from
	*/
	ArrayList<ArrayList<Cubie>> getAllCubiesToRotate(char axisFace, float index) {
		ArrayList<ArrayList<Cubie>>  temp = new ArrayList();   
		if (index == - axis || index == axis) {
			for (int i  = 0; i < floor((dim + 1) / 2); i++) {
				temp.add(getList(axisFace, index, i));
			}
		} else {
			temp.add(getList(axisFace, index, 0));
		}
		return temp;
	}
	
	/**
	* Return list of cubies to the cube object
	*
	* @param	oldList
	* @param	list
	* @param	axisFace
	* @param	index
	* @param	listNumber
	*/
	void returnListToCube(ArrayList<Cubie> oldList, ArrayList<Cubie> list, char axisFace, float index, int listNumber) {
		int size = dim - listNumber * 2;
		for (int i = 0; i < list.size(); i++)  {
			boolean found = false;
			if (found) continue;
			for (Cubie c : cubies) {
				if (list.get(i).x == c.x && list.get(i).y == c.y && list.get(i).z == c.z) {
					c.colours = oldList.remove(0).copy().colours;
					found = true;
				}
			}
		}
		// Updates the cube with new colours - reevaluates each cubies position.
		int i = 0;
		for (int x = 0; x < dim; x++) { 
			for (int y = 0; y < dim; y++) { 
				for (int z = 0; z < dim; z++) { 
					if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
					PMatrix3D matrix = new PMatrix3D();
					matrix.translate(x - axis, y - axis, z - axis);
					cubies[i].matrix = matrix;
					cubies[i].x = x - axis;
					cubies[i].y = y - axis;
					cubies[i].z = z - axis;
					i++;
				}
			}
		}
	}
	
	/**
	* Scrambles the cube
	*/
	void scrambleCube() {
		scramble = true;
		sequence.clear();
		moves = "";
		fMoves.clear();
		counter = 0;
		Move copy = new Move();
		boolean isDifferent = true;
		
		for (int i = 0; i < numberOfMoves; i++) {
			int r = int(random(allMoves.size()));
			Move m = allMoves.get(r).copy();
			
			if (m.currentAxis == copy.currentAxis) {
				do{
					r = int(random(allMoves.size()));
					if (allMoves.get(r).currentAxis != copy.currentAxis && allMoves.get(r).index != copy.index) {
						m = allMoves.get(r).copy();
						isDifferent = false;
					}
				} while(isDifferent);
			}
			
			if (m.index > axis || m.index < - axis) i--;
			if (m.dir == 2)  i++;
			copy = new Move(m.currentAxis, m.index, m.dir);
			sequence.add(m);
		}
		
		print("Scramble prepared\n");
		for (Move m : sequence) { 
			fMoves.add(m.toString()); 
		}
		formatMoves();
	}
	
	/**
	* Scrambles the cube with my specified combination of moves
	* Used for debugging as I know the end result of the moves
	*/
	void hardcodedScrambleCube()  {
		println("[*]  Hardcoded scramble");
		scramble = true;
		sequence.clear();
		moves = "";
		fMoves.clear();
		counter = 0;
		Move copy = new Move();
		
		// String[] hardMoves = {"F", "U", "F'", "U", "R", "L", "D", "U'", "B", "B", "L", "R"};
		String[] hardMoves = {"B2", "D2", "R", "U2", "F'", "F'", "U'", "F'", "U", "F", "D2", "R", "R'", "U'", "R'", "D", "B", "D" , "R\'", "B2"};
		numberOfMoves = hardMoves.length;
	
		for (String m : hardMoves) {
			boolean found = false;
			for (Move move : allMoves)  {
				if (found) continue;
				if (move.toString().equals(m))  {
					found = true;
					sequence.add(move);
				}
			}
			fMoves.add(m);
		}
		formatMoves();
	}
	
	/** 
	* Tests all possible moves along specified axis regardless of cube size
	*
	* @param	axisFace	Specifies which axis the moves are being made along
	*/
	void testMoves(char axisFace) {
		scramble = true;
		sequence.clear();
		moves = "";
		fMoves.clear();
		counter = 0;
		
		int numberOfZMoves = 0;
		ArrayList<Move> allZMoves = new ArrayList();
		
		for (Move m : allMoves)  {
			if (m.currentAxis == axisFace)  allZMoves.add(m);
		}
		
		for (Move m : allZMoves) {
			sequence.add(m.copy());
		}
		
		ArrayList <Move> doubleMoves = new ArrayList();
		ArrayList <Move> primeMoves = new ArrayList();
		ArrayList <Move> normalMoves = new ArrayList();
		ArrayList <Move> wholeMoves = new ArrayList();
		
		for (int i = 0; i < sequence.size(); i++)  {
			if (sequence.get(i).index > axis || sequence.get(i).index < - axis)  {
				wholeMoves.add(sequence.get(i));
			} else if (sequence.get(i).dir == 2)  {
				doubleMoves.add(sequence.get(i));
			} else if (sequence.get(i).dir == - 1)  {
				primeMoves.add(sequence.get(i));
			} else if (sequence.get(i).dir == 1) {
				normalMoves.add(sequence.get(i));
			}
		}
		sequence.clear();
		sequence.addAll(normalMoves);
		sequence.addAll(primeMoves);
		sequence.addAll(doubleMoves);
		sequence.addAll(wholeMoves);
		
		for (Move m : sequence) {
			fMoves.add(m.toString());
		}
		formatMoves();
	}

	/**
	* Tests algorithm on this cube object
	*
	* @param	algorithm	The algorithm of moves tested on this cube object
	* @return	this		This new cube state is returned after the algorithm is applied
	*/
	Cube testAlgorithm(String algorithm) {
		// println("\nTesting: " + algorithm + "\tNumber of chars: " + algorithm.length()+"\n");
		for (int i = 0; i < algorithm.length(); i++) {
			// Initially direction of each move is 1
			int dir = 1;
			char move = algorithm.charAt(i);
			// print(move);
			// If there are moves in algorithm and the next char is a prime: '
			if(i+1 < algorithm.length())	{
				if (algorithm.charAt(i+1) == '\'' || algorithm.charAt(i+1) == '’' || algorithm.charAt(i+1) == '2') {
					char next = algorithm.charAt(i+1);
					// Set the direction of the move to anticlockwise
					if(next == '\'' || next == '’')	{
						dir = - 1;
					}	else	{
						dir = 2;
					}
					i++;
				}
			} 
			// Call a turn on the cube according to the move we have here.
			switch(move) {
				case 'L':
					this.turn('X', axis, dir);
				break;
				case 'R':
					this.turn('X', - axis, dir);
				break;
				case 'U':
					this.turn('Y', -axis, dir);
				break;
				case 'D':
					this.turn('Y', axis, -dir);
				break;
				case 'F':
					this.turn('Z', axis, dir);
				break;
				case 'B':
					this.turn('Z', - axis, dir);
				break;
			}
		}
		return this;
	}
	
	
	/**
	* Reverses all moves made by the scramble function - illusion of solve
	*/
	void rScrambleCube() {
		counter = 0;
		ArrayList<Move> reverseSequence = new ArrayList<Move>();
		if (sequence.size() == 0) return;
		for (Move m : sequence) {
			reverseSequence.add(m);
		}
		sequence.clear();
		
		for (int i = reverseSequence.size() - 1; i >= 0; i--) {
			Move m = reverseSequence.get(i);
			if (m.dir != 2)  m.reverse();
			if (dim <= 3)  fMoves.add(m.toString());
			sequence.add(m);
		}
		
		if (moves != "")
			print(numberOfMoves + " moves were taken to unscramble the cube " + "\n" + moves);
		else
			print("Solving cube...");
	}
	
	/**
	* Generates a list of cubies from specified index in axis
	*
	* @param	axisFace	Axis of which the face of cubies is located
	* @param	index		Index of which row/column of the axis in the cube is to be chosen
	* @param	listNumber	List number plays part in how far into the cube we go to retrieve cubies.
	*/
	ArrayList<Cubie> getList(char axisFace, float index, int listNumber) {
		
		int size = dim - listNumber * 2;
		ArrayList<Cubie> list = new ArrayList();
		
		ArrayList<Cubie> leftRow = new ArrayList();
		ArrayList<Cubie> topRow = new ArrayList();
		ArrayList<Cubie> rightRow = new ArrayList();
		ArrayList<Cubie> bottomRow = new ArrayList();
		ArrayList<Cubie> temp = new ArrayList();
		int leftSize = 0;
		int indexOfCubie = 0;
		
		switch(axisFace) {
			case 'X':
			// Order cubies are stored: left, top, right, bottom - clockwise
			// Left row
			for (Cubie c : cubies) {
				for (float i = 0; i < size; i++)  {
					if (c.x == index && c.y == (i - axis + listNumber) && c.z == (- axis + listNumber)) {
						if (leftRow.contains(c)) continue;
						leftRow.add(c.copy());
					}
				}
				//Top row
				for (float i = 1; i < size; i++) {
					if (c.x == index && c.y == (- axis + listNumber) && c.z > (- axis + listNumber) && c.z <= (axis - listNumber)  && topRow.size() != size)  {
						if (topRow.contains(c)) {
							continue;
						} else {
							topRow.add(c.copy());
						}
					}
				}
				//Right row
				for (float i = 1; i < size; i++) {
					if (c.x == index && c.y > (- axis + listNumber) && c.z == (axis - listNumber)) {
						if (rightRow.contains(c)) {
							continue;
						} else {
							if (c.y <= (axis - listNumber))  rightRow.add(c.copy());
						}
					}
				}
				
				//Bottom row
				for (float i = 2; i < size; i++)  {
					if (c.x == index && c.y == (axis - listNumber) && c.z <= axis - 0.5 - listNumber && c.z >= - axis + 0.5 + listNumber)  {
						if (bottomRow.contains(c))  {
							continue;
						} else {
							bottomRow.add(c.copy());
						} 
					}
				}
				indexOfCubie++;
			}
			temp = new ArrayList();
			leftSize = leftRow.size();
			for (int i = 0; i < leftSize; i++) {
				temp.add(leftRow.remove(leftRow.size() - 1));
			}
			leftRow.addAll(temp);
			break;
			
			case 'Y':
			for (Cubie c : cubies) {
				for (float i = 0; i < size; i++)  {
					if (c.x == (- axis + listNumber) &&  c.y == index &&  c.z == (i - axis + listNumber)) {
						if (leftRow.contains(c)) continue;
						leftRow.add(c.copy());
					}
				}
				for (float i = 1; i < size; i++) {
					if (c.x > (- axis + listNumber) && c.x <= (axis - listNumber) &&  c.y == index &&  c.z == (- axis + listNumber)  && topRow.size() != size)  {
						if (topRow.contains(c)) continue;
						topRow.add(c.copy());
					}
				}
				for (float i = 1; i < size; i++) {
					if (c.x == (axis - listNumber) &&  c.y == index &&  c.z > (- axis + listNumber)) {
						if (rightRow.contains(c)) {
							continue;
						} else {
							if (c.z <= (axis - listNumber))  rightRow.add(c.copy());
						}
					}
				}
				for (float i = 2; i < size; i++)  {
					if (c.x <= (axis - 0.5 - listNumber) && c.x >= (- axis + 0.5 + listNumber) &&  c.y == index &&  c.z == (axis - listNumber))  {
						if (bottomRow.contains(c)) continue;
						bottomRow.add(c.copy());
					}
				}
				indexOfCubie++;
			}
			temp = new ArrayList();
			leftSize = leftRow.size();
			for (int i = 0; i < leftSize; i++) {
				temp.add(leftRow.remove(leftRow.size() - 1));
			}
			leftRow.addAll(temp);
			
			break;
			case 'Z':
			
			for (Cubie c : cubies) {
				for (float i = 0; i < size; i++)  {
					if (c.x == (- axis + listNumber)  && c.y == (i - axis + listNumber) && c.z == index) {
						if (leftRow.contains(c)) continue;
						leftRow.add(c.copy());
					}
				}
				for (float i = 1; i < size; i++) {
					if (c.x > (- axis + listNumber) && c.x <= (axis - listNumber) && c.y == (- axis + listNumber) &&  c.z == index && topRow.size() != size)  {
						if (topRow.contains(c)) continue;
						topRow.add(c.copy());
					}
				}
				for (float i = 1; i < size; i++) {
					if (c.x == (axis - listNumber) && c.y > (- axis + listNumber)  &&   c.z == index) {
						if (rightRow.contains(c))  continue;
						if (c.y <= (axis - listNumber))  rightRow.add(c.copy());
					}
				}
				for (float i = 2; i < size; i++)  {
					if (c.x <= axis - 0.5 - listNumber && c.x >= - axis + 0.5 + listNumber && c.y == (axis - listNumber) && c.z == index)  {
						if (bottomRow.contains(c)) continue;
						bottomRow.add(c.copy());
					}
				}
				indexOfCubie++;
			}
			
			temp = new ArrayList();
			leftSize = leftRow.size();
			for (int i = 0; i < leftSize; i++) {
				temp.add(leftRow.remove(leftRow.size() - 1));
			}
			leftRow.addAll(temp);
			break;
		}
		list.addAll(leftRow);
		list.addAll(topRow);
		list.addAll(rightRow);
		list.addAll(bottomRow);
		return list;
	}
	
	/**
	* Gets specified cubie from this cube object
	*
	* @param	i			Index of the cubie within the cube object
	* @return	cubies[i]	The cubie object from index i
	*/
	Cubie getCubie(int i) {
		return cubies[i];
	}

	Cubie[] getCubies()	{
		Cubie[] allCubies = new Cubie[(int)(pow(dim, 3) - pow(dim - 2, 3))];
		for(int i = 0; i < cubies.length; i++)	{
			allCubies[i] = cubies[i];
		}
		return allCubies;
	}
	
	/**
	* Gets every unique colour from the cube
	*
	* @return	cubies[0].getEachColour()	Each possible colour that can be on a cubie object
	*/
	color[] getEachColour()	{
		return cubies[0].getEachColour();
	}

	/**
	* Gets the name of every colour from the cubie object
	*
	* @return	cubies[0].getEachColourName()	Each name for each colour that can be applied to a cubie
	*/
	String[] getEachColourName() {
    	return cubies[0].getEachColourName();
  	}

	/**
	* Counts the number of each colour that's on the cube
	*
	* @return	boolean	If true, the cube is in a valid state, else false, it's not
	*/
	boolean evaluateCube() {
		int oCounter = 0;
		int rCounter = 0;
		int wCounter = 0;
		int yCounter = 0;
		int gCounter = 0;
		int bCounter = 0;
		
		int index = 0;
		for (float x = 0; x < dim; x++) {
			for (float y = 0; y < dim; y++) {
				for (float z = 0; z < dim; z++) {
					if (x > 0 && x < dim - 1 && y > 0 && y < dim - 1 && z > 0 && z < dim - 1) continue;
					Cubie c = cubies[index];
					if (c.getRight() == orange) oCounter++;
					if (c.getLeft() == red)  	rCounter++;
					if (c.getTop() == yellow) 	yCounter++;
					if (c.getDown() == white) 	wCounter++;
					if (c.getFront() == green) 	gCounter++;
					if (c.getBack() == blue) 	bCounter++;
					index++;
				}
			}
		}
		int numFaces = dim * dim;
		if (oCounter == numFaces &&
			rCounter == numFaces &&
			yCounter == numFaces &&
			wCounter == numFaces &&
			gCounter == numFaces &&
			bCounter == numFaces) return true;
		return false;
	}

	String getFace(String s)	{
		int cIndex;
		ArrayList<Cubie> cubies = new ArrayList();
		// Find index for the colours of a specific face.
		switch(s)	{
			case "orange":
				cIndex = 0;
				cubies = getList('X', axis, 0);
				// print("cubies size: " + cubies.size());
			break;
			case "red":
				cIndex = 1;
				cubies = getList('X', -axis, 0);
			break;
			case "yellow":
				cIndex = 2;
				cubies = getList('Y', -axis, 0);
				break;
			case "white":
				cIndex = 3;
				cubies = getList('Y', axis, 0);
				break;
			case "green":
				cIndex = 4;
				cubies = getList('Z', axis, 0);
				break;
			case "blue":
				cIndex = 5;
				cubies = getList('Z', -axis, 0);
				break;
			default:
				cIndex = 0;
				break;
		}
		String face = "";
		for(Cubie c : cubies)	{
			if(c.colours[cIndex] != color(0))	{
				// print(colourToChar(c.colours[cIndex]) + ", ");
				face += colourToChar(c.colours[cIndex]);
			}
		}
		// println("1\t" + face);
		return face;
	}

	char colourToChar(color c)	{
		String col = colToString(c);
		return col.charAt(0);
	}
}