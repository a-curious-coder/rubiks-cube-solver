import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

class LocalSearch   {
	
	Cube cube;
	Cube complete;
	Cube copy;
	int stage = 0;
	char closestSolved = 'a';
	float pSmallestScore = 1000;
	float[] faceScores = new float[6];
	boolean generateAlgorithms = true;
	boolean whiteFaceSolved = false;
	boolean yellowFaceSolved = false;
	boolean[] middleLayersSolved = new boolean[dim - 2];
	ArrayList<Float> allScores = new ArrayList();
	ArrayList<String> algorithms = new ArrayList();
	
	LocalSearch(Cube cube)  {
		this.cube = cube;
	}
	
	/**
	* Responsible for managing the stage of the solving process
	*/
	void solve()    {
		// println("[*]\tLocal search");
		switch(stage)   { //<>//
			// Generate / Prepare algorithms for use.
			case 0:
			initialiseAlgorithms();
			// println("[*]\tStage " + stage);
			// Finds the face that's closest to being solved...
			// closestSolved = cubeSolved(cube);
			stage++;
			break;
			case 1:
			solveWhiteFace();
			break;
			case 2:
			print("Evaluate cube");
			paused = true;
			case 10:
			println("[*]\tWhole cube is solved apparently");
			lsSolve = false;
			break;
		}
	}
	
	/**
	* Initialises list of algorithms
	* could be hardcoded or generated - dictated by a boolean
	*/
	void initialiseAlgorithms() {
		if (generateAlgorithms)  {
			generateAlgorithms();
			println("[*]\tGenerated Algorithms : " + algorithms.size());
			return;
		} else {
			println("[*]\tHardcoding Mode");
			hardcodeAlgorithms();
			// regenAlgorithms();
			println("[*]\tHardedcoded Algorithms : " + algorithms.size());
		}
	}

	/**
	* Generates algorithms based on the 12 possible moves.
	*/
	void generateAlgorithms()    {
		algorithms.clear();
		int depth = 7;
		List<String> eachMove = Arrays.asList("F", "B", "L", "R", "U", "D", "F\'", "B\'", "L\'", "R\'", "U\'", "D\'");

		// Prints each move from the eachMove list
		print("[*]\tEach possible move: ");
		for(String initem : eachMove)	{
			if(eachMove.indexOf(initem) == eachMove.size()-1)	{
				print(initem + ".");
				println();
			} else {
				print(initem + ", ");
			}
		}

		List<String> outlist = new ArrayList();
		for(int i = depth; i >= 1; i--)	{
			algorithms.addAll(output(i, eachMove));
		}
		println("[*]\tGenerated algorithms to a depth of 5\t"+ algorithms.size() + " algorithms\n[*]");
	}

	/**
	* Generates the combinations for generateAlgorithms
	*
	* @param	count		
	* @param	eachMove	
	* @return	result		
	*/
	List<String> output(int count, List<String> eachMove) {
		ArrayList<String> result = new ArrayList();
		if(count == 1) {
			result.addAll(eachMove);
		} else {
			List<String> res = output(count-1, eachMove);
			for(String item : res) {
				for(String prefix : eachMove) {
					result.add(prefix + item);
				}
			}
		}
		return result;
	}
	
	/**
	* A place where I manually add algorithms to array of algorithms.
	* Helps when debugging
	*/
	void hardcodeAlgorithms()   {
		// Swaps opposing corners
		// algorithms.add("RRF'RRDDRRFRR");
		// // Swaps adjacent corners...
		// algorithms.add("UFU'F'R'F'R");
		// algorithms.add("U'F'UFRUR'");
		// algorithms.add("RU' R'U'F'UF");
		// algorithms.add("RU'R'F'U'FU");
		// algorithms.add("R'FRUFU'F'");
		// algorithms.add("R'FRFUF'U'");
		// algorithms.add("FUF'U'R'F'R");
		// algorithms.add("F'U'FURUR'");
		// // Swap opposite edges, top right and top left
		// algorithms.add("U(RUR'URUUR'U)YY(RUR'URUUR'U)");
		// // Swap adjacent edges, front and left.
		// algorithms.add("RUR'URUUR'U");
		// // Reorient edges
		// algorithms.add("UU RR U R' U' R' UU L F R F' L' R'");
		// // Reorient edge on top
		// algorithms.add("FU'RF'U'");
		
		// Most common algorithms
		algorithms.add("F'UL'U'");
		algorithms.add("DLD'L'");
		algorithms.add("D'R'DR");
		algorithms.add("R'L'B'B'UD'L'R'U'FU'F'");
		algorithms.add("U R U' R' U' F' U F");
		algorithms.add("U' L' U L U F U' F'");
		algorithms.add("F R U R' U' F'");
		algorithms.add("R U R' U R U U R'");
		algorithms.add("U R U' L' U R' U' L");
		algorithms.add("R' D' R D");
	}
	
	/**
	* Takes algorithms and applies them from all 24 positions - better optimises their application to cube.
	*/
	void regenAlgorithms()  {

		int numAlgorithms = algorithms.size();
		for (int i = 0; i < numAlgorithms; i++)  {
			try{
				algorithms.add("X" + algorithms.get(i));
				algorithms.add("XX" + algorithms.get(i));
				algorithms.add("XXX" + algorithms.get(i));
				
				algorithms.add("Y" + algorithms.get(i));
				algorithms.add("YX" + algorithms.get(i));
				algorithms.add("YXX" + algorithms.get(i));
				algorithms.add("YXXX" + algorithms.get(i));
				
				algorithms.add("Y'" + algorithms.get(i));
				algorithms.add("Y'X" + algorithms.get(i));
				algorithms.add("Y'XX" + algorithms.get(i));
				algorithms.add("Y'XXX" + algorithms.get(i));
				
				algorithms.add("YY" + algorithms.get(i));
				algorithms.add("YYX" + algorithms.get(i));
				algorithms.add("YYXX" + algorithms.get(i));
				algorithms.add("YYXXX" + algorithms.get(i));
				
				algorithms.add("Z" + algorithms.get(i));
				algorithms.add("ZX" + algorithms.get(i));
				algorithms.add("ZXX" + algorithms.get(i));
				algorithms.add("ZXXX" + algorithms.get(i));
				
				algorithms.add("Z'" + algorithms.get(i));
				algorithms.add("Z'X" + algorithms.get(i));
				algorithms.add("Z'XX" + algorithms.get(i));
				algorithms.add("Z'XXX" + algorithms.get(i));
			} catch(Exception e)    {
				println(e);
			}
		}
		int initialSize = algorithms.size();
		for (int i = 0; i < initialSize; i++)  {
			for (int j = 0; j < initialSize; j++)   {
				algorithms.add(algorithms.get(i) + algorithms.get(j));
				for (int k = 0; k < initialSize; k++)   {
					algorithms.add(algorithms.get(i) + algorithms.get(j) + algorithms.get(k));
				}
			}
		}
	}

	/**
	* Boolean function that checks if cube is solved
	*
	* @param cube	The Rubik's Cube we want evaluated
	* @return 	If cube is solved, return true, else return false
	*/
	boolean cubeSolved(Cube cube)    {
		// Score edges on white face
		ArrayList<Boolean> correctCubies = new ArrayList();
		boolean cubeComplete = true;
		// For every cubie
		for (int i = 0; i < cube.len; i++)    {  
			Cubie c = cube.getCubie(i);
			boolean foundMatch = false;
			for (int j = 0; j < completeCube.len; j++) {
				Cubie referenceCubie = completeCube.getCubie(j);
				if (foundMatch)  continue;
				// if position matches
				if (c.x == referenceCubie.x && c.y == referenceCubie.y && c.z == referenceCubie.z)   {
					print("Correctly positioned");
					// if colours match
					if (c.colours == referenceCubie.colours) {
						println("[*]\t and correctly oriented");
						correctCubies.add(true);
						foundMatch = true;
					} else {
						println("[*]\t but not correctly oriented.\n" + referenceCubie.details() + "\n" + c.details());
						correctCubies.add(false);
					}
				}
			}
			if (!foundMatch) println("[*]\tIncorrectly positioned");
		}
		for (boolean b : correctCubies)  {
			cubeComplete = b == false ? false : true;
		}
		
		if (cubeComplete)    println("[*]\tCube completed.");
		return cubeComplete;
	}
	
	/**
	* Attempts to solve the white face of the cube
	* Will increase stage number when white face is done.
	*/ 
	void solveWhiteFace()	{
		if (!(getFaceColour('D') == white))  {
			positionFace(white, 'D', 'X');
			return;
		}
		if (!(getFaceColour('F') == green))  {
			positionFace(green, 'F', 'Y');
			return;
		}
		
		// Check how solved the white face is before generating moves.
		if (scoreFace(cube, white) == 0)  {
			// TODO: If white face is solved, keep it oriented on D face and use algorithms that do NOT affect the D face's current solve.
			println("[*]\tWhite face solved.");
			whiteFaceSolved = true;
			stage++;
			return;
		} else {
			println("[*]\t White face score: " + scoreFace(cube, white));
		}
		
		if (!whiteFaceSolved) turns += bestWhiteFaceAlgorithm();
		
		// Assume white face is on down face
		char whiteFace = 'D';
		String faces = "RLUBF";
		for (int i = 0; i < faces.length(); i++) {
			// If face colour is white, assign the face to variable whiteFace
			if (getFaceColour(faces.charAt(i)) == white)	{
				whiteFace = faces.charAt(i);
			}
		}
		// Check if any of the edges on the top face are in the correct position but not the correct orientation...
	}
	
	/**
	* Best algorithm for white face
	*
	* @return	bestAlgo	The algorithm that's closest to solving white face
	*/
	String bestWhiteFaceAlgorithm()	{
		//  Create copy of cube in its current state
		Cube copy = new Cube(cube);
		float score;
		// Initialise arraylist to hold every score for every algorithm
		allScores = new ArrayList();
		boolean optimalSolutionFound = false;
		// Tests every algorithm from list of algorithms  
		for(String algorithm : algorithms)	{
			copy = new Cube(cube);
			score = 0;
			// Tests algorithm on copy of this cube.
			Cube cubeAfterAlgorithm = copy.testAlgorithm(algorithm);
			// Scores the cube's white face.
			score = scoreFace(cubeAfterAlgorithm, white);
			if(score == 0)	{
				allScores.clear();
				return algorithm;
			}
			allScores.add(score);
		}

		// Stores the smallest score unique to this specific cube scramble
		float smallestScore = allScores.get(0);
		// For loop that retrieves the smallest score from the list of scores
		for (float f : allScores)  {
			if (f < smallestScore)   {
				smallestScore = f;
			}
		}

		// If the smallest score for this particular scramble puts the cube in a worse state than it's in currently...
		// if(smallestScore > pSmallestScore)	{
		// 	println("[*]\tPrevious score: " + pSmallestScore + "\tThis smallest score: " + smallestScore);
		// 	println("[*]\tCould not find a better solution via the algorithms available");
		// 	// paused = true;
		// } else {
		// 	pSmallestScore = smallestScore;
		// }

		// Best algorithm retrieved in reference to lowest scoring algorithms' index in arraylist is returned and will be applied to the main cube
		String bestAlgo = algorithms.get(allScores.indexOf(smallestScore));
		println("[*]\tBest Algorithm toward solving the White face");
		println("[*]\t" + bestAlgo + "\n[*]\tScore : " + smallestScore);
		return bestAlgo;
	}

	/**
	* Returns the algorithm better suited to pushing the Rubik's cube closer to a solved state
	*/ 
	String bestAlgorithm()   {
		//  Create copy of cube in its current state
		Cube copy = new Cube(cube);
		allScores = new ArrayList();

		// Score the copy cube after an algorithm is applied to it
		for (String moves : algorithms)   {
			float combination = scoreCube(copy.testAlgorithm(moves));
			allScores.add(combination);
		}
		
		float smallestScore = allScores.get(0);
		for (float f : allScores)  {
			if (f < smallestScore)   {
				smallestScore = f;
			}
		}
		pSmallestScore = smallestScore;
		if(smallestScore > pSmallestScore)	{
			println("[*]\tPrevious score: " + pSmallestScore + "\tThis smallest score: " + smallestScore);
			println("[*]\tCould not find a better solution via the algorithms available");
			paused = true;
		}

		// Best algorithm retrieved in reference to lowest scoring algorithm index in arraylist is returned to apply to the actual cube
		String bestAlgo = "\"" + algorithms.get(allScores.indexOf(smallestScore)) + "\"";
		println("[*]\tBest Scoring Algorithm : \t" + bestAlgo + "\t Score : " + smallestScore);
		// String debugAlgo = "FFFFFFF";
		return bestAlgo;
	}
	
	/** 
	* Checks if cube is solved
	* Scores each face of the cube to check if the cube is solved.
	*/
	boolean cubeSolved()  {
		
		String faces =  "RLUDFB";
		
		int unsolvedFaces = 0;
		// For every face
		for (int i = 0; i < faces.length(); i++)  {
			// if a face is not solved
			if (scoreFace(cube, faces.charAt(i))  != 0) {
				unsolvedFaces++;
			}
			faceScores[i] = scoreFace(cube, faces.charAt(i));
		}
		// If cube is not solved
		if (unsolvedFaces > 0)    {
			return false;
		}
		
		return true;
	}
	
	/**
	* Scores the cube which represents how solved it is
	*	
	* @param	cube The cube that's going to be evaluated and scored
	* @return		 The score representingm how solved the cube is
	*/
	float scoreCube(Cube cube)    {
		
		if (cubeSolved())  {
			stage = 10;
			return stage;
		}
		
		float cubeScore = 0;
		for (float score : faceScores) {
			cubeScore += score;
		}
		
		return cubeScore;
	}
	
	/*
	* Calculates a score for a face using different parameters
	*
	* @param    cube Complete Rubik's Cube for reference
	* @param    c    Colour of the face we want to score
	*/
	float scoreFace(Cube cube, color c) {
		String faces =  "RLUDFB";
		char face = 'R';
		
		for (int i = 0; i < faces.length(); i++) {
			if (getFaceColour(faces.charAt(i)) == c)  {
				face = faces.charAt(i);
				break;
			}
		}
		return scoreFace(cube, face);
	}
	
	/**
	* Evaluates a 'score' for the given face which represents how 'solved' that face is.
	* The closer the score it to 0, the better.
	* TODO: Cater for even numbered cubes with no center.
	*
	* @param    face The face being evaluated
	* @return		 The score that's been evaluated for the face			
	*/
	float scoreFace(Cube cube, char face)    {
		int faceNum = 0;
		float score = 0;
		color faceColour = getFaceColour(face);
		String thisFaceColour = colToString(faceColour);

		// Collection of all cubies on the specified face.
		ArrayList<Cubie> currentFace = new ArrayList();
		
		// Accumulate appropriate cubies from given face to currentFace list.
		switch(face)    {
			case 'F':
			for (int i = 0; i < cube.len; i++) {
				Cubie c = cube.getCubie(i);
				if (c.z == axis)  {
					score += scoreCubie(c, faceColour);
				}
			}
			faceNum = 4;
			break;
			case 'B':
			for (int i = 0; i < cube.len; i++) {
				Cubie c = cube.getCubie(i);
				if (c.z == - axis)  {
					score += scoreCubie(c, faceColour);
				}
			}
			faceNum = 5;
			break;
			case 'U':
			for (int i = 0; i < cube.len; i++) {
				Cubie c = cube.getCubie(i);
				if (c.y == - axis)  {
					score += scoreCubie(c, faceColour);
				}
			}
			faceNum = 2;
			break;
			case 'D':
			for (int i = 0; i < cube.len; i++) {
				Cubie c = cube.getCubie(i);
				if (c.y == axis)  {
					
					// If cubie has been considered wrong position / orientation we need to check if it's on the right face...
					score += scoreCubie(c, faceColour);
					// println(c.details() + "\tscore : " + scoreCubie(c, faceColour));
				}
			}
			faceNum = 3;
			break;
			case 'R':
			for (int i = 0; i < cube.len; i++) {
				Cubie c = cube.getCubie(i);
				if (c.x == axis)  {
					score += scoreCubie(c, faceColour);
				}
			}
			faceNum = 0;
			break;
			case 'L':
			for (int i = 0; i < cube.len; i++) {
				Cubie c = cube.getCubie(i);
				if (c.x == - axis)  {
					score += scoreCubie(c, faceColour);
				}
			}
			faceNum = 1;
			break;
		} 
		return score;
	}

	/**
	* Goes through list of cubies to score and finds the correspondingly located cubie from the 'completeCube'
	* Scores cubie based on	matching colours, orientation.
	*
	* @param	c			The cubie we're evaluating
	* @param	faceColour	The colour of the face we're wanting the cubie to align with
	* @return	float		The score of the cube. If it's correct, return 0
	*/
	float scoreCubie(Cubie c, color faceColour)    {
		Cubie referenceCubie = new Cubie();
		float cubieScore = 0;
		boolean foundCubie = false;
		int counter = 0;
		for (int i = 0; i < completeCube.len; i++)    {
			referenceCubie = completeCube.getCubie(i);
			color[] cubieColours = new color[6];
			color[] referenceColours = new color[6];
			for(int j = 0; j < 6;j++)	{
				cubieColours[j] = c.colours[j];
				referenceColours[j] = referenceCubie.colours[j];
			}
			// If the colours are the same AND the location is wrong OR
			// If the location is wrong
			if ((Arrays.equals(cubieColours, referenceColours) && (referenceCubie.x != c.x || referenceCubie.y != c.y || referenceCubie.z != c.z)) || referenceCubie.x != c.x || referenceCubie.y != c.y || referenceCubie.z != c.z)	{
				continue;
			}

			// Found a cubie in the same location, check if colours are same.
			boolean sameColours = true;
			// For every colour on the cubie
			// If colours are the same check if orientation is the same.
			// If orientation is the same too, return 0
			if(Arrays.equals(cubieColours, referenceColours))	{
				// print("They have the same colours and are oriented correctly.");
				return 0;
			} else if (Arrays.equals(sort(cubieColours), sort(referenceCubie.colours)))	{
				// print("They share the same colours, not in the correct orientation.");
				return 0.5;
			}
		}
		return 1;
	}

	int indexOf(int[] arr, int value) {
		int index = - 1;
		for (int i = 0; i < arr.length; i++) {
			if (arr[i] == value) {
				index = i;
				break;
			}
		}
		return index;
	}
}
