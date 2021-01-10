import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;

class LocalSearch   {
	
	Cube cube;
	FastCube fCube;
	Cube complete;
	int stage = 0;
	char closestSolved = 'a';
	float pSmallestScore = 1000;
	float cubeScore;
	String pAlgorithm = "";
	float[] faceScores = new float[6];
	int depth = 6;
	int globalCounter = 0;

	// Depth 5   271,452
	// Depth 6   3,257,436
	// Depth 7   39,089,244
	// Depth 8   469,070,940
	// Depth 9   5,628,851,292
	boolean generateAlgorithms = true;
	boolean whiteFaceSolved = false;
	boolean redFaceSolved = false;
	boolean stage1 = true;
	ArrayList<Float> allScores = new ArrayList();
	ArrayList<String> algorithms = new ArrayList();
	List<String> eachMove = Arrays.asList("F", "B", "L", "R", "U", "D", "F\'", "B\'", "L\'", "R\'", "U\'", "D\'", "F2", "B2", "L2", "R2", "U2", "D2");
	String previousAlgo;
	
	LocalSearch(Cube cube)  {
		this.cube = cube;
	}
	
	void solve()    {
		switch(stage)   { //<>//
			// Generate / Prepare algorithms for use.
			case 0:
				initialiseAlgorithms();
				stage++;
				threadRunning = false;
				break;
			case 1:
				if(stage1)	{
					fCube = new FastCube(cube);
					fCube.printCube();
					println("[*]\tBest algorithm\tG1 score\tTime taken (seconds)\t Edges score");
					stage1 = false;
				}
				
				println("Before");
				long start = System.currentTimeMillis();
				getG1();
				long end = System.currentTimeMillis();
				float duration = (end - start) / 1000F;
				println("End: " + duration);

				threadRunning = false;
				break;
			case 2:
				// solveMiddleLayer();
				// generateG1Algorithms();
				stage++;
				// paused = true;
				break;
			case 3:
				solveCubeG1();
				break;
			case 10:
				println("[*]\tWhole cube is solved apparently");
				lsSolve = false;
				threadRunning = false;
				break;
		}
	}
	// Score U/D faces that have U/D Stickers	Blue/Green

	boolean G1UD(FastCube f)	{
		// Green / Blue
		float w = f.scoreUD("white");
		float y = f.scoreUD("yellow");
		float m = f.scoreMiddleEdges();
		return (w + y + m) == 0 ? true : false;
	}

	/**
	* Initialises list of algorithms
	* could be hardcoded or generated - dictated by a boolean
	*/
	void initialiseAlgorithms() {
		if (generateAlgorithms)  {
			generateAlgorithms();
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
		long start = System.currentTimeMillis();
		algorithms.clear();
		int depth = this.depth;

		// algorithms.add("R'L'B'B'UD'L'R'U'FU'F'");
		for(int i = 1; i <= depth; i++)	{
			if(i % 2 == 0)	{
			algorithms.addAll(output(i, eachMove));
			println("Added all algorithms at depth: " + i + "\n" + algorithms.size() + " of them.");
			} else {
				println("Skipping " + i);
			}
		}

		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;
		println("[*]\tGenerated algorithms.\n");
		println("Depth\tNumber of algorithms\tDuration");
		println(depth + "\t" + algorithms.size() + "\t\t" + duration + "s");
	}

	void generateG1Algorithms()	{
		long start = System.currentTimeMillis();
		algorithms.clear();
		int depth = this.depth;
		List<String> eachMove = Arrays.asList("F", "B", "L2", "R2", "U2", "D2", "F\'", "B\'");

		for(int i = 1; i <= depth; i++)	{
			algorithms.addAll(output(i, eachMove));
			println("G1 algorithms at depth: " + i);
		}

		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;
		println("[*]\tGenerated G1 algorithms.\n");
		println("Depth\tAlgorithms\tDuration");
		println(depth + "\t" + algorithms.size() + "\t\t" + duration);
	}

	/**
	* Search algorithm
	*
	* @param	f	Computationally lighter representation of Cube we're solving
	* @param	d	Represents the length of the moves we're testing.
	* @param 	eachMove	List of each unique move
	*/
	void Treesearch(FastCube f, int d)	{
		if ((f.scoreUD("white") + f.scoreUD("yellow")) == 0)	{
			// Apply sequence of moves to main cube object.
			cube.testAlgorithm(previousAlgo);
			// Prints cube state after sequence of moves applied.
			f.printCube();
			println("Desired state reached!");
			return;
		} else if(d > 0)	{
			if(d != 1) {
				for(String prefix : eachMove) {
					Treesearch(f.testAlgorithm(prefix), d-1);
				}
			}
		}
	}

	/**
	* Generates the permutations for generateAlgorithms function (This just stores the algorithms to an arraylist)
	*
	* @param	count		The length of each algorithm permutation we're generating for the List
	* @param	eachMove	Each possible move that can be applied to a Rubik's Cube (18 of them)
	* @return	result		List of algorithms
	*/
	List<String> output(int count, List<String> eachMove) {
		ArrayList<String> result = new ArrayList();
		// float depthTotal = pow(count, eachMove.size());
		// println("Depth " + count + " : " + (int)depthTotal);
		char[] xAxis = {'R', 'L'};
		char[] yAxis = {'U', 'D'};
		char[] zAxis = {'F', 'B'};

		if(count == 1) {
			result.addAll(eachMove);
		} else {
			List<String> res = output(count-1, eachMove);
			int counter = 0;
			boolean pointlessMove = false;

			for(String item : res) {
				// pointlessMove = false;
				for(String prefix : eachMove) {
					counter++;
					if(movePointless(item, prefix)) continue;
					result.add(prefix + item);
					println(result.get(result.size()-1));
					if(counter % 10000000 == 0)	{
						println("10 mil");
					}
				}
			}
		}
		return result;
	}
	
	/**
	* Checks if next move appended to 'prefix' is valid
	* Rules:
	* If next move is the invert of this move - 2 if statements
	* If this move and last move are the same, skip - 2 if statements
	* 
	*/
	boolean movePointless(String item, String prefix)	{
		boolean pointlessMove = false;
		// If move is clockwise and prefix has 1 or more moves
		if(item.length() == 1 && prefix.length() >= 1)	{
			// If the previous move is counterclockwise version of this move
			if(prefix.charAt(prefix.length()-1) == '\'' && 
				prefix.charAt(prefix.length()-2) == item.charAt(item.length()-1))	{
				pointlessMove = true;
				return pointlessMove;
			} else if(item.charAt(item.length()-1) == prefix.charAt(prefix.length()-2))	{
				
			}	else if(item.charAt(item.length()-1) == prefix.charAt(prefix.length()-1))	{
				pointlessMove = true;
				return pointlessMove;
			}
		// If this move is counterclockwise or double
		} else if(item.length() > 1 && prefix.length() > 1)	{
			// If move is counterclockwise and prefix has clockwise variant of this move
			if(item.charAt(item.length()-1) == '\'' &&
				item.charAt(item.length()-2) == prefix.charAt(prefix.length()-1))	{
				pointlessMove = true;
				return pointlessMove;
			}
			// If previous move is same as this move
			if(item.charAt(item.length()-2) == prefix.charAt(prefix.length()-2) &&
				item.charAt(item.length()-1) == prefix.charAt(prefix.length()-1))	{
				pointlessMove = true;
				return pointlessMove;
			}
			// If previous 3 clockwise moves are the same as this move, pointless.
				if(prefix.charAt(prefix.length()-1) == prefix.charAt(prefix.length()-2) && 
					prefix.charAt(prefix.length()-2) == prefix.charAt(prefix.length()-3) && 
					prefix.charAt(prefix.length()-3) == item.charAt(item.length()-1))	{
					pointlessMove = true;
					return pointlessMove;
					// If previous 2 prime moves are same face as this double move
					// If the previous 2 moves are the same face as this double move
				} 
				else if(prefix.charAt(prefix.length()-1) == '\'' && prefix.charAt(prefix.length()-3) == '\'' && 
				(prefix.charAt(prefix.length()-2) == prefix.charAt(prefix.length()-4) || 
				prefix.charAt(prefix.length()-1) == prefix.charAt(prefix.length()-2)) && 
				prefix.charAt(prefix.length()-2) == item.charAt(item.length()-2) && item.charAt(item.length()-1) == '2')	{
					pointlessMove = true;
					return pointlessMove;
				}  else if (prefix.charAt(prefix.length()-2) == item.charAt(item.length()-2))	{
					pointlessMove = true;
					return pointlessMove;
				}
				// else if (item.charAt(item.length()-1) == prefix.charAt(prefix.length()-3))	{
				// TODO: Verify that no two moves are concurrently made that are on same axis
				// }
		}
		return pointlessMove;
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

	void getG1()	{
		if (!orientCube())	return;
		fCube = new FastCube(cube);

		if (G1UD(fCube))  {
			fCube.printCube();
			stage++;
			return;
		}
			// println("[*]\t\t\t" + (fCube.scoreUD("white")+fCube.scoreUD("yellow") + fCube.scoreMiddleEdges()));

		turns += bestG1Algorithm();
		// println("[*]\tApplying:\t" + turns);
	}

	String bestG1Algorithm()	{
		//  Create copy of cube in its current state
		FastCube copyCube = new FastCube(cube);
		FastCube copy = new FastCube(copyCube);
		cubeScore = copy.scoreCube(copy);
		// Initialise arraylist to hold every score for every algorithm
		allScores = new ArrayList();
		float score = 0;
		// Tests every algorithm from list of algorithms  
		long start = System.currentTimeMillis();
		int counter = 0;
		int algoSize = algorithms.size()/20;
		for(String algorithm : algorithms)	{
			counter++;
			percentTilNextMove = (((float)100000*counter/100000)/(float)algorithms.size()*(float)100);
			score = 0;
			copy = new FastCube(copyCube);

			copy.testAlgorithm(algorithm);
			score = (copy.scoreUD("white") + copy.scoreUD("yellow"));
			
			if(copy.scoreCube(copy) == 0 || score == 0)	{
				return algorithm;
			} else {
				allScores.add(score);
			}
		}

		// Stores the smallest score unique to this specific cube scramble
		float smallestScore = allScores.get(0);
		float smallestScoreIndex = 0;
		// For loop that retrieves the smallest score from the list of scores
		for (float f : allScores)  {
			if (f < smallestScore)   {
				smallestScore = f;
				smallestScoreIndex = allScores.indexOf(f);
			}
		}

		ArrayList<Float> lowScores = new ArrayList();
		ArrayList<Integer> lowScoreIndexes = new ArrayList();
		for(float f : allScores)	{
			if(f == smallestScore)	{
				lowScores.add(f);
				lowScoreIndexes.add(allScores.indexOf(f));
			}
		}
		
		int len = 10;
		String bestAlgo = "";
		for(Integer f : lowScoreIndexes)	{
			if(algorithms.get(f).length() < len)	{
				// Best algorithm retrieved in reference to lowest scoring algorithms' index in arraylist is returned and will be applied to the main cube
				bestAlgo = algorithms.get(f);
			}
		}

		// copy = new FastCube(copyCube);
		// copy.testAlgorithm(bestAlgo);
		// copy.printCube();
		// println("G1 Score: " + copy.scoreUD("white") + "\t" + copy.scoreUD("yellow"));
		// if(lowScores.size() == 1)	{
		// 	println("There's " + lowScores.size() + " algorithm with the score of " + smallestScore);
		// } else	{
		// 	println("There are " + lowScores.size() + " algorithms with the score of " + smallestScore);
		// }
		
		// println("Smallest score at: " + (int)smallestScoreIndex + " / " + allScores.size());
		pSmallestScore = smallestScore;
		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;
		if(bestAlgo.length() < 7)	{
			println("[*]\t" + bestAlgo + "\t\t" + smallestScore + "\t\t\t" + duration + "s" + "\t");
		} else if (bestAlgo.length() > 7 && bestAlgo.length() < 8){
			println("[*]\t" + bestAlgo + "\t\t" + smallestScore + "\t\t" + duration + "s" + "\t");
		} else {
			println("[*]\t" + bestAlgo + "\t" + smallestScore + "\t\t" + duration + "s" + "\t");
		}
		if(pAlgorithm == bestAlgo)	{

		}
		pAlgorithm = bestAlgo;
		// println("[*]\t" + bestAlgo + "\tWhite face score : " + smallestScore + "\tDetermined in " + duration + " seconds.");
		return bestAlgo;
	}

	String bestG1SolveAlg()	{
		FastCube copy = new FastCube(cube);
		
		allScores = new ArrayList();
		float score = 0;
		// Tests every algorithm from list of algorithms  
		long start = System.currentTimeMillis();
		// println(algorithms.size() + " algorithms to test");
		for(String algorithm : algorithms)	{
			score = 0;
			copy = new FastCube(cube);
			// Test algorithm on copy of the cube
			copy = copy.testAlgorithm(algorithm);
			if((copy.scoreUD("white") + copy.scoreUD("yellow") + copy.scoreMiddleEdges()) != 0)	{
				continue;
			}
			score = copy.scoreCube(copy);
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
		
		if(pSmallestScore < smallestScore)	{
			pSmallestScore = smallestScore;
		} else if(pSmallestScore == smallestScore)	{
			// TODO: Choose the score +1 of the previous smallest
			// smallestScore = allScores.get(int(random(allScores.size())));
		}	else	{
			pSmallestScore = smallestScore;
		}
		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;
		// Best algorithm retrieved in reference to lowest scoring algorithms' index in arraylist is returned and will be applied to the main cube
		String bestAlgo = algorithms.get(allScores.indexOf(smallestScore));
		println("[*]\tBest algorithm\tG1 score\tTime taken (seconds)\t Edges score");
		println("[*]\t" + bestAlgo + "\t\t" + smallestScore + "\t\t\t" + duration + "s" + "\t");
		// println("[*]\t" + bestAlgo + "\tWhite face score : " + smallestScore + "\tDetermined in " + duration + " seconds.");
		return bestAlgo;
	}

	void solveCubeG1()	{
		if (!orientCube())	return;
		fCube = new FastCube(cube);

		if (fCube.scoreCube(fCube) == 0)	{
			println("Solved");
			paused = true;
		} else {
			println("[*]\t Cube score: " + fCube.scoreCube(fCube));
		}

		turns += bestG1SolveAlg();
	}

	/**
	* Attempts to solve the white face of the cube
	* Will increase stage number when white face is done.
	*/ 
	void solveWhiteFace()	{
		if (!orientCube())	return;
		fCube = new FastCube(cube);
		
		// Check how solved the white face is before generating moves.
		if (fCube.scoreFace("white") == 0)  {
			// TODO: If white face is solved, keep it oriented on D face and use algorithms that do NOT affect the D face's current solve.
			println("[*]\tWhite face solved\tScore: " + fCube.scoreFace("white"));
			fCube.printCube();
			whiteFaceSolved = true;
			stage++;
			return;
		} else {
			println("[*]\t White face score: " + fCube.scoreFace("white"));
		}
		turns += bestWhiteFaceAlgorithm();
		// println("[*]\tApplying:\t" + turns);
		
		// paused = true;
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
	
	void solveMiddleLayer()	{
		orientCube();
		fCube = new FastCube(cube);
		// Check how solved the white face is before generating moves.
		if (fCube.scoreFace("red") == 0)  {
			// TODO: If white face is solved, keep it oriented on D face and use algorithms that do NOT affect the D face's current solve.
			println("[*]\tFirst two layers solved.");
			redFaceSolved = true;
			stage++;
			return;
		} else {
			println("[*]\t Red face score: " + fCube.scoreFace("red"));
			println("[*]\t\t White score: " + fCube.scoreFace("white"));
		}

		if (!redFaceSolved) turns += bestMiddleLayerAlgorithm();
		// println("[*]\tApplying:\t"+turns);
		// Assume red face is on left face
		char redFace = 'L';
		String faces = "RLUBF";
		for (int i = 0; i < faces.length(); i++) {
			// If face colour is white, assign the face to variable whiteFace
			if (getFaceColour(faces.charAt(i)) == red)	{
				redFace = faces.charAt(i);
			}
		}
	}

	/**
	* Orients cube to same position every time
	* White face on D face and Green face on F face
	*/
	boolean orientCube()	{
		if (!(getFaceColour('D') == white))  {
			positionFace(white, 'D', 'X');
			return false;
		}
		if (!(getFaceColour('F') == green))  {
			positionFace(green, 'F', 'Y');
			return false;
		}
		return true;
	}

	/**
	* Best algorithm for white face
	*
	* @return	bestAlgo	The algorithm that's closest to solving white face
	*/
	String bestWhiteFaceAlgorithm()	{
		//  Create copy of cube in its current state
		FastCube copy = new FastCube(cube);
		// Initialise arraylist to hold every score for every algorithm
		allScores = new ArrayList();
		
		float score;
		// Tests every algorithm from list of algorithms  
		long start = System.currentTimeMillis();
		// println(algorithms.size() + " algorithms to test");
		for(String algorithm : algorithms)	{
			score = 0;
			copy = new FastCube(cube);
			// Test algorithm on copy of the cube
			copy = copy.testAlgorithm(algorithm);
			score = copy.scoreFace("white");
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

		if(pSmallestScore < smallestScore)	{
			pSmallestScore = smallestScore;
		} else if(pSmallestScore == smallestScore)	{
			// TODO: Choose the score +1 of the previous smallest
			smallestScore = allScores.get(int(random(allScores.size())));
		}	else	{
			pSmallestScore = smallestScore;
		}
		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;
		// Best algorithm retrieved in reference to lowest scoring algorithms' index in arraylist is returned and will be applied to the main cube
		String bestAlgo = algorithms.get(allScores.indexOf(smallestScore));
		println("[*]\tBest algorithm\tWhite face score\tTime taken (seconds)");
		println("[*]\t" + bestAlgo + "\t\t" + smallestScore + "\t\t\t" + duration + "s");
		// println("[*]\t" + bestAlgo + "\tWhite face score : " + smallestScore + "\tDetermined in " + duration + " seconds.");
		return bestAlgo;
	}

	String bestMiddleLayerAlgorithm()	{
		//  Create copy of cube in its current state
		FastCube copy = new FastCube(cube);
		// Initialise arraylist to hold every score for every algorithm
		allScores = new ArrayList();
		
		float score;
		float whiteFaceScore;
		// Tests every algorithm from list of algorithms  
		long start = System.currentTimeMillis();
		println(algorithms.size() + " algorithms to test");
		for(String algorithm : algorithms)	{
			copy = new FastCube(cube);
			copy.testAlgorithm(moves);
			whiteFaceScore = copy.scoreFace("white");
			if(whiteFaceScore == 0)	{
				copy = copy.testAlgorithm(algorithm);
				score = copy.scoreFace(copy.red, "red");
				allScores.add(score);
				println("Algorithm : " + algorithm + "\t Score: " + score);
				if(score == 0)	{
					allScores.clear();
					return algorithm;
				}
			}
		}

		if(allScores.size() == 0)	{
			println("No algorithms found...");
			paused = true;
			return "";
		}
		// Stores the smallest score unique to this specific cube scramble
		float smallestScore = allScores.get(0);
		// For loop that retrieves the smallest score from the list of scores
		for (float f : allScores)  {
			if (f < smallestScore)   {
				smallestScore = f;
			}
		}
		if(pSmallestScore > smallestScore)	pSmallestScore = smallestScore;
		long end = System.currentTimeMillis();
		float duration = (end - start) / 1000F;
		// Best algorithm retrieved in reference to lowest scoring algorithms' index in arraylist is returned and will be applied to the main cube
		String bestAlgo = algorithms.get(allScores.indexOf(smallestScore));
		println("[*]\t" + bestAlgo + "\tRed face score : " + smallestScore + "\tDetermined in " + duration + " seconds.");
		return bestAlgo;
	}
	/**
	* Returns the algorithm better suited to pushing the Rubik's cube closer to a solved state
	*/ 
	// String bestAlgorithm()   {
	// 	//  Create copy of cube in its current state
	// 	Cube copy = new Cube(cube);
	// 	allScores = new ArrayList();

	// 	// Score the copy cube after an algorithm is applied to it
	// 	for (String moves : algorithms)   {
	// 		float combination = scoreCube(copy.testAlgorithm(moves));
	// 		allScores.add(combination);
	// 	}
		
	// 	float smallestScore = allScores.get(0);
	// 	for (float f : allScores)  {
	// 		if (f < smallestScore)   {
	// 			smallestScore = f;
	// 		}
	// 	}
	// 	pSmallestScore = smallestScore;
	// 	if(smallestScore > pSmallestScore)	{
	// 		println("[*]\tPrevious score: " + pSmallestScore + "\tThis smallest score: " + smallestScore);
	// 		println("[*]\tCould not find a better solution via the algorithms available");
	// 		paused = true;
	// 	}

	// 	// Best algorithm retrieved in reference to lowest scoring algorithm index in arraylist is returned to apply to the actual cube
	// 	String bestAlgo = "\"" + algorithms.get(allScores.indexOf(smallestScore)) + "\"";
	// 	println("[*]\tBest Scoring Algorithm : \t" + bestAlgo + "\t Score : " + smallestScore);
	// 	// String debugAlgo = "FFFFFFF";
	// 	return bestAlgo;
	// }

	String bestAlgorithm()   {
		//  Create copy of cube in its current state
		FastCube copy = new FastCube(cube);
		allScores = new ArrayList();
	
		// Score the copy cube after an algorithm is applied to it
		for (String moves : algorithms)   {
			if(whiteFaceSolved)	{
				copy.testAlgorithm(moves);
				float whiteFaceScore = copy.scoreFace("white");
				if(whiteFaceScore != 0)	continue;
				float combination = copy.scoreCube(copy.testAlgorithm(moves));
				allScores.add(combination);
			} else {
				float combination = copy.scoreCube(copy.testAlgorithm(moves));
				allScores.add(combination);
			}
		}

		if(allScores.size() == 0)	{
			println("No algorithms could be found for this cube.");
			return "";
		}

		float smallestScore = allScores.get(0);
		for (float f : allScores)  {
			if (f < smallestScore)   {
				smallestScore = f;
			}
		}

		
		if(smallestScore > pSmallestScore)	{
			println("[*]\tPrevious score: " + pSmallestScore + "\tThis smallest score: " + smallestScore);
			println("[*]\tCould not find a better solution via the algorithms available");
			paused = true;
		} else	{
			pSmallestScore = smallestScore;
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
