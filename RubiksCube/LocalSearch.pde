class LocalSearch   {
	
	Cube cube;
	int stage = 0;
	float[] faceScores = new float[6];
	ArrayList<Float> allScores = new ArrayList();
	char closestSolved = 'a';
	ArrayList<String> algorithms = new ArrayList();
	boolean generateAlgorithms = false;
	
	boolean whiteFaceSolved = false;
	boolean[] middleLayersSolved = new boolean[dim - 2];
	boolean yellowFaceSolved = false;
	
	LocalSearch(Cube cube)  {
		this.cube = cube;
	}
	
	void solveCube()    {
		// println("Local search");
		switch(stage)   { //<>//
			// Generate / Prepare algorithms for use.
			case 0:
			initialiseAlgorithms();
			// println("Stage " + stage);
			// Finds the face that's closest to being solved...
			// closestSolved = checkIfSolved(cube);
			stage++;
			break;
			case 1:
			// println("Stage " + stage + " : "+ colToString(white));
			// Attempted to solve the face chosen in the previous stage.
			// Score corners on white face //<>//
			// println("White face score : " + scoreFace(cube, white));
			// paused = true;
			solveCube(cube);
			// checkCube(cube);
			break;
			case 10:
			println("Solved apparently");
			lsSolve = false;
			break;
		}
	}
	
	void checkCube(Cube cube)    {
		// Score edges on white face
		ArrayList<Boolean> correctCubies = new ArrayList();
		boolean cubeComplete = true;
		// for every cubie
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
						println(" and correctly oriented");
						correctCubies.add(true);
						foundMatch = true;
					} else {
						println(" but not correctly oriented.\n" + referenceCubie.details() + "\n" + c.details());
						correctCubies.add(false);
					}
				}
			}
			if (!foundMatch) println("Incorrectly positioned");
		}
		for (boolean b : correctCubies)  {
			cubeComplete = b == false ? false : true;
		}
		
		if (cubeComplete)    println("Cube completed.");
		// println("pausing");
		// delay(20000);
	}
	
	
	void solveCube(Cube cube)   {
		
		// is it correctly positioned
		// is it correctly oriented
		
		// Score corners on white face //<>//
		if (!(getFaceColour('D') == white))  {
			positionFace(white, 'D', 'X');
			return;
		}
		if (!(getFaceColour('F') == green))  {
			positionFace(green, 'F', 'Y');
			return;
		}
		
		
		turns += bestScoringCombination();
		
		if (scoreFace(cube, white) == 0)  {
			println("White face solved");
			delay(2000);
		} else if (scoreFace(cube, white) < 5)  {
			println("close...with a score of : " + scoreFace(cube, white));
			if (turns.length() == 0)   paused = true;
		}   else    {
			println("White face : " + scoreFace(cube, white));
		}
		
		char whiteFace = 'R';
		String faces = "LUDBF";
		for (int i = 0; i < faces.length(); i++) {
			if (getFaceColour(faces.charAt(i)) == white) whiteFace = faces.charAt(i);
		}
		
		if (scoreFace(cube, whiteFace) == 0)  {
			println(colToString(white) + " face solved.");
			delay(2000);
			stage++;
			return;
		}
		// Check if any of the edges on the top face are in the correct position but not the correct orientation...
	}
	
	void initialiseAlgorithms() {
		if (generateAlgorithms)  {
			generateAlgorithms();
			println("Generated Algorithms : " + algorithms.size());
			return;
		} else {
			println("Hardcoding Mode");
			hardcodeAlgorithms();
			regenAlgorithms();
			println("Hardedcoded Algorithms : " + algorithms.size());
		}
	}
	
	void generateAlgorithms()    {
		String[] allMoves = {"F", "B", "L", "R", "U", "D", "F\'", "B\'", "L\'", "R\'", "U\'", "D\'"};
		ArrayList<String> depth1 = new ArrayList();
		ArrayList<String> depth2 = new ArrayList();
		ArrayList<String> depth3 = new ArrayList();
		ArrayList<String> depth4 = new ArrayList();
		ArrayList<String> depth5 = new ArrayList();
		algorithms.clear();
		
		
		for (int i = 0; i < allMoves.length; i++) {
			depth1.add(allMoves[i]);
			for (int j = 0; j < allMoves.length; j++)    {
				depth2.add(allMoves[i] + allMoves[j]);
				for (int k = 0; k < allMoves.length; k++)    {
					depth3.add(allMoves[i] + allMoves[j] + allMoves[k]);
					for (int l = 0; l < allMoves.length; l++)    {
						depth4.add(allMoves[i] + allMoves[j] + allMoves[k] + allMoves[l]);
						for (int h = 0; h < allMoves.length; h++)    {
							depth5.add(allMoves[i] + allMoves[j] + allMoves[k] + allMoves[l] + allMoves[h]);
						}
					}
				}
			}
		}
		println("Generating algorithms to a depth of 5");
		for (String s : depth1)  {
			algorithms.add(s);
		}
		for (String s : depth2)  {
			algorithms.add(s);
		}
		for (String s : depth3)  {
			algorithms.add(s);
		}
		for (String s : depth4)  {
			algorithms.add(s);
		}
		for (String s : depth5)  {
			algorithms.add(s);
		}
		// for(String s : algorithms)  {
		//     println(s);
		// }
		println(algorithms.size());
		println("finished");
		// delay(20000);
		
		
	}
	
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
		// algorithms.add("U R U' R' U' F' U F");
		// algorithms.add("U' L' U L U F U' F'");
		// algorithms.add("F R U R' U' F'");
		// algorithms.add("R U R' U R U U R'");
		// algorithms.add("U R U' L' U R' U' L");
		// algorithms.add("R' D' R D");
	}
	
	void regenAlgorithms()  {
		// println("GENERATING YOUR SHITTY ALGORITHMS");
		// println("algorithms size: " + algorithms.size());
		
		int numAlgorithms = algorithms.size();
		println("numAlgorithms : " + numAlgorithms);
		for (int i = 0; i < numAlgorithms; i++)  {
			try{
				println("Iteration : " + (i + 1));
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
	
	String bestScoringCombination()   {
		Cube copy = cube.clone();
		allScores = new ArrayList();
		// println("algorithms size: " + algorithms.size());
		int index = 0;
		
		for (String moves : algorithms)   {
			allScores.add(scoreCube(copy.testMoves(moves, copy)));
		}
		
		float smallestScore = allScores.get(0);
		for (float f : allScores)  {
			if (f < smallestScore)   {
				smallestScore = f;
			}
		}
		println("Best score : \t\"" + algorithms.get(allScores.indexOf(smallestScore)) + "\"\t score : " + smallestScore);
		// Return the algorithm that gets the cube closest to a solve.
		return algorithms.get(allScores.indexOf(smallestScore));
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
	
	/* Checks if cube is solved
	*  Scores each face of the cube to check if the cube is solved.
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
	* @param    cube    Rubik's cube for reference
	* @param    c       colour of the face we want to score
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
		println("White face is on " + face);
		return scoreFace(cube, face);
	}
	
	/**
	* Evaluates a 'score' for the given face which represents how 'solved' that face is.
	* The closer the score it to 0, the better.
	* @param    face    the face being evaluated
	* TODO: Cater for even numbered cubes with no center.
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
	// TODO: Evaluate location of cubie
	// TODO: Evaluate orientation of cubie
	float scoreCubie(Cubie c, color faceColour)    {
		Cubie referenceCubie = new Cubie();
		float cubieScore = 0;
		boolean foundCubie = false;
		for (int i = 0; i < completeCube.len; i++)    {
			referenceCubie = completeCube.getCubie(i);
			// Looks for cubie in the same position as referenceCubie.
			if (foundCubie)	continue;
			
			if (referenceCubie.x == c.x && referenceCubie.y == c.y && referenceCubie.z == c.z)	{
				
				boolean sameColours = true;
				for (color c1 : referenceCubie.colours)	{
					foundCubie = false;
					for (color c2 : c.colours)	{
						if (c1 == c2)	{
							foundCubie = true;
						}
					}
					if (!foundCubie)	{
						sameColours = false;
						break;
					}
				}
				
				if (sameColours)	{
					if (!referenceCubie.sameColoursAs(c))	{
						cubieScore += 0.5;
					}
				} else {
					// Checks if the cubie belongs on the face of the cube.
					for (color col : c.colours)	{
					//	println("\tComparing " + colToString(col) + " with " + colToString(faceColour));
					if	(col == faceColour)	{
							cubieScore += 0.25;
							foundCubie = true;
						}
					}
				}
			}
			// println("Comparing " + rC.details() + " with " + c.details());
			
		}
		if (!foundCubie)cubieScore = 1;
		return cubieScore;
	}
}
