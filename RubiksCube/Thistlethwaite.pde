// Time: Without tables, lord knows.
// Method: IDDFS (Iterative-Deepening Depth First Search)
//  TODO: Make use of pruning trees because some depths take too long to search like this in worst cases.
// Moves: 45-52 moves
// Groups: G1, G2, G3, G4

class Thistlethwaite  {
    
    Cube2 cube;
    Stack<Integer> soln = new Stack<Integer>();
    // Arraylist since we need to successively remove sets of move after each solving stage.
    ArrayList<String> allMoves = new ArrayList<String>(
        Arrays.asList("U", "U2", "U'", "L", "L2", "L'", "F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'")
    );
    int nodes = 0;
    int stage = 1;
    int moveCount = 0;
    String g1Algorithm = "";
    String g2Algorithm = "";
    String g3Algorithm = "";
    String g4Algorithm = "";
    String solution = "";
    boolean g1 = false;
    boolean g2 = false;
    boolean g3 = false;
    boolean g4 = false;
    
    
    Thistlethwaite(Cube cube) {
        this.cube = new Cube2(cube);
    }
    
    // Solves the cube using the Thistlethwaite's Algorithm.
    void solve()    {
        thistlethwaiteRunning = true;
        String t = "    ";
        String gts = "Group" + t + "Time(s)" + t + "Solution\n";
        outputBox.append(gts); // Appends to GUI
        println("Group\tTime(s)\tSolution");

        long start = System.currentTimeMillis();
        // Stage 1 Of Solve
        if (!edgesOriented(cube))    {
            getGroup(stage); // Orient all the edges on the cube according to these rules: 
        } else {
            g1 = true;
            println("Already achieved stage:" + stage);
        }
        removeRedundantMoves();
        stage++; // 2
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        println("G1\t" + duration + "s\t" + g1Algorithm + "\t" + moveCount);
        t = "           ";
        memConsumptionArray.add(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory()); // Appends memory usage to array when collecting stats.
        outputBox.append("G1" + t + duration + "s" + t + g1Algorithm + "\n");
        outputBox.append("\n");

        // Stage 2 Of Solve
        if (!cornersOriented(cube) && !eSliceEdges(cube))  {
            getGroup(stage); // Orient corners and place appropriate edges to E slice, between U and D, of cube.
        } else {
            g2 = true;
            println("Already achieved stage: " + stage);
        }
        removeRedundantMoves();
        outputBox.append("\n");
        stage++; // 3
        end = System.currentTimeMillis(); 
        duration = (end - start) / 1000F;
        println("G2\t" + duration + "s\t" + g2Algorithm + "\t" + moveCount);
        outputBox.append("G2" + t + duration + "s" + t + g2Algorithm + "\n");
        memConsumptionArray.add(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory());
        
        // Stage 3 Of Solve
        start = System.currentTimeMillis();
        if (!cornersPermutated(cube) && !allEdgesInCorrectSlice(cube)) {
            // println("Trying to get G3");
            getGroup(stage); // Permutate cubies until F/B colours are on F/B faces and U/D colours are on U/D faces. 
        } else {
            g3 = true;
            println("Already achieved stage: " + stage);
        }
        removeRedundantMoves();
        stage++;
        end = System.currentTimeMillis();
        duration = (end - start) / 1000F;
        println("G3\t" + duration + "s\t" + g3Algorithm + "\t" + moveCount);
        outputBox.append("G3" + t + duration + "s" + t + g3Algorithm + "\n");
        memConsumptionArray.add(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory());
        
        // Stage 4 Of Solve
        if (!cubeSolved(cube))    {
            // println("Trying to get G4");
            getGroup(stage); // Solve cube using only 180 moves.
            
        } else {
            println("Already achieved stage: " + stage);
        }
        println("G4\t" + duration + "s\t" + g4Algorithm + "\t" + moveCount);
        outputBox.append("G4" + t + duration + "s" + t + g4Algorithm + "\n");
        println("Complete Solution : " + solution + "\n");
        memConsumptionArray.add(Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory());
        
        testing = false;
        thistlethwaiteRunning = false;
        solving = false;
        solved = true;
        return;
    }

    /**
    * Keeps track of what requirements should be fulfilled for stage x
    * @param    tmp Cube we're evaluating requirements for each stage
    * @return   boolean If stage requirements are fulfilled for given cube, return true; else false.
    */
    boolean stage(Cube2 tCube) { 
        switch(stage)   {
            case 1:
            if (!g1) {
                if (edgesOriented(tCube))  {
                    g1 = true; 
                    return true;
                }
            }
            break; 
            case 2:
            if (!g2) {
                if (cornersOriented(tCube) && eSliceEdges(tCube))    {
                    g2 = true;
                    return true;
                }
            }
            break;
            case 3:
            if (!g3) {
                if (cornersPermutated(tCube) && allEdgesInCorrectSlice(tCube))    {
                    g3 = true; 
                    return true;
                }
            }
            break;
            case 4:
            if (!g4) {
                if (tCube.solved())    {
                    g4 = true;
                    return true;
                }
            }
            break;
        }
        return false;
    }
    
    /**
    *   Searches for solution to reach group x - iteratively make the cube easier to solve.
    *   @param  x   Group we want to solve the cube for
    */
    void getGroup(int x)    {
        int depth = 0;
        if (x == 1)  {
            depth = 7;
            // println("branching factor: " + allMoves.size());
        }
        if (x == 2)  {
            depth = 10;
            // println("branching factor: " + allMoves.size());
        }
        if (x == 3)  {
            depth = 13;
            // println("branching factor: " + allMoves.size());
        }
        if (x == 4)  {
            depth = 15;
            // println("branching factor: " + allMoves.size());
        }
        // Takes 1 - 7 moves to orient all edges to fulfil G1 requirements.
        // println("\t\t\tDepth\tNodes\tTime");
        String t = "    ";
        outputBox.append("Depth" + t + "Nodes" + t + "Time\n");
        long start = System.currentTimeMillis();
        
        for (int i = 1; i <= depth; i++) {
            start = System.currentTimeMillis();
            searchAllAtDepth(i);
            long end = System.currentTimeMillis();
            float duration = (end - start) / 1000F;
            // println("\t\t\t" + i + "\t" + nodes + "\t" + duration + "s");
            outputBox.append(i + t + nodes + t + duration + "s\n");
            nodes = 0;
            if (stage == 1 && g1 ||
                stage == 2 && g2 ||
                stage == 3 && g3 ||
                stage == 4 && g4)  return;
        }
    }
    
    /** 
    * Search all combinations at specified depth
    * @param    depth   Depth we're searching at for IDDFS
    */
    void searchAllAtDepth(int depth) {
        Cube2 tmp = new Cube2(cube); 
        if (depth == 1)  {
            for (String s : allMoves)    {
                // Reset cube
                tmp = new Cube2(cube);
                //println(s);
                // Append moves
                tmp.applyAlgorithm(s);
                //tmp.imageState();
                // Check if it's worth continuing the search at this depth
                if (prune(1, tmp, depth, stage)) continue; 
                if (stage(tmp))  appendSolution(s);
                nodes++;
            }
        } else {
            search("", depth);
        } 
        return;
    }
    
    /**
    * The main recursive method
    * @param  prefix  combination of moves we're testing / appending more moves to
    * @param  depth   depth we're searching.
    */
    void search(String prefix, int depth)  {
        if (stage == 1 && g1)    println("shouldn't be here");
        // Reset cube
        Cube2 tmp = new Cube2(cube);
        // Test solution
        tmp.applyAlgorithm(prefix);
        // Test if cube is worth searching for solution at this depth.
        if (prune(1, tmp, depth, stage)) return;
        if (depth == 0)  {
            // Test if cube has a valid solution for this stage.
            if (stage(tmp))  appendSolution(prefix);
            return;
        } else {
            // One by one add all characters from set and recursively call for depth equals to depth-1
            for (String move : allMoves)   {
                if ((stage == 1 && g1) || (stage == 2 && g2) || (stage == 3 && g3) || (stage == 4 && g4))
                    return;
                search(prefix + move + " ", depth - 1);
                nodes++;
            } 
        }
    }
    
    void appendSolution(String prefix)    {
        // println("Solution: " + prefix);
        switch(stage)   {
            case 1:
                g1Algorithm = prefix;
                cube.applyAlgorithm(g1Algorithm); 
                returnSolution(g1Algorithm);
                // g1Algorithm = "";
                solution += prefix;
                break;
            case 2:
                g2Algorithm = prefix;
                cube.applyAlgorithm(g2Algorithm); 
                returnSolution(g2Algorithm); 
                // g2Algorithm = "";
                solution += prefix;
                break;
            case 3:
                g3Algorithm = prefix;
                cube.applyAlgorithm(g3Algorithm); 
                returnSolution(g3Algorithm); 
                // g3Algorithm = "";
                solution += prefix;
                break;
            case 4:
                g4Algorithm = prefix;
                cube.applyAlgorithm(g4Algorithm); 
                returnSolution(g4Algorithm); 
                // g4Algorithm = "";
                solution += prefix;
                break;
        }
    }

    /**
* Returns the solution to the main thread to be applied to the graphical cube object
* @param solution   The solution to solving the cube.
*/
void returnSolution(String solution)   {
    // println(solution);
    moves = solution.replaceAll(" ", "");
    for(int i = 0; i < moves.length(); i++)    {
        String move = moves.charAt(i) + "";
        if(i+1 < moves.length())  {
            if(moves.charAt(i+1) == '\'' || moves.charAt(i+1) == '2') {
                move += moves.charAt(i+1) + "";
                i++;
            }
        }
        if(move != "")  {
            moveCount++;
            addMoveToSequence(move);
        }
    }
    // moveCounter = moveCount;
}

    /**
    * This function's right according to: https://observablehq.com/@onionhoney/how-to-model-a-rubiks-cube
    * Checks if edges are oriented
    * @param tmp    Cube we're checking
    * @return   boolean if edges are oriented, return true;
    */
    boolean edgesOriented(Cube2 tmp)   {
        for (int i : tmp.edges_o)    {
            if (i != 0)  return false;
        }
        return true;
    }
    
    /**
    * Checks if the edges that belong in the E slice of the cube are in the E slice.
    * @param    tmp Cube we're evaluating if edges are in e slice
    * @return   boolean if appropriate edges are in e slice, return true; else false.
    */
    boolean eSliceEdges(Cube2 tmp)  {
        // Check Edges that belong in E Slice
        if ((tmp.edges_p[4] != 5 && tmp.edges_p[4] != 6) && (tmp.edges_p[4] != 7 && tmp.edges_p[4] != 8)) 
            return false;
        if ((tmp.edges_p[5] != 5 && tmp.edges_p[5] != 6) && (tmp.edges_p[5] != 7 && tmp.edges_p[5] != 8)) 
            return false;
        if ((tmp.edges_p[6] != 5 && tmp.edges_p[6] != 6) && (tmp.edges_p[6] != 7 && tmp.edges_p[6] != 8)) 
            return false;
        if ((tmp.edges_p[7] != 5 && tmp.edges_p[7] != 6) && (tmp.edges_p[7] != 7 && tmp.edges_p[7] != 8)) 
            return false;
        return true;
    }
    
    /** 
    * Need to ensure that a Left / Right Colour is on the R/L faces for each corner.
    * This is how Thistlethwaite determines if a corner is 'oriented' for this stage.
    * @param tmp    Cube we're evaluating
    * @return boolean   If corners satisfy these conditions, return true; else false.
    */
    boolean cornersOriented(Cube2 tmp)  {
        for (int i : tmp.corners_o)  {
            if (i != 0)  return false;
        }
        return true;
    }
    
    /**
    * Checks if the corners of the cube are permutated in a specific way that suits G4 stage.
    * @param    tmp Cube we're evaluating
    * @return   boolean If corners are permutated the way we want, return true; else false.
    */
    boolean cornersPermutated(Cube2 tmp)    {
        //String[] tmpNames = {"UFL", "UBL", "UBR", "UFR",
                //"DFL", "DBL", "DBR", "DFR",
                //"FDL", "FUL", "FUR", "FDR",
                //"BDL", "BUL", "BUR", "BDR",
                //"RDF", "RUF", "RUB", "RDB",
                //"LDF", "LUF", "LUB", "LDB"};
        // Extract the colours of the corresponding facelets.
        // byte UFL = tmp.cornerColours[0];
        // byte LUF = tmp.cornerColours[21];
        int UFL = tmp.corners_p[0];
        int UBL = tmp.corners_p[1];
        int UBR = tmp.corners_p[2];
        int UFR = tmp.corners_p[3];

        int DFL = tmp.corners_p[4];
        int DBL = tmp.corners_p[5];
        int DBR = tmp.corners_p[6];
        int DFR = tmp.corners_p[7];
        if((UFL == 1 || UFL == 3 || UFL == 6 || UFL == 8) &&
            (UBL == 2 || UBL == 4 || UBL == 5 || UBL == 7) &&
            (UBR == 1 || UBR == 3 || UBR == 6 || UBR == 8) &&
            (UFR == 2 || UFR == 4 || UFR == 5 || UFR == 7) &&
            (DFL == 5 || DFL == 7 || DFL == 2 || DFL == 4) &&
            (DBL == 1 || DBL == 3 || DBL == 6 || DBL == 8) &&
            (DBR == 5 || DBR == 7 || DBR == 2 || DBR == 4) &&
            (DFR == 1 || DFR == 3 || DFR == 6 || DFR == 8)) return true;
        return false;
    }
    
    /**
    * Check if all the edges in the cube are in their designated slices.
    * @param    tmp Cube we're evaluating
    * @return   boolean If all edges are in their correct slices, return true; else false.
    */
    boolean allEdgesInCorrectSlice(Cube2 tmp)  {
        // Check S Slice - M slice falls itself into place as we already have E slice
        if (tmp.edges_p[1]   !=  2 && tmp.edges_p[1]  != 4 && tmp.edges_p[1] != 10 && tmp.edges_p[1] != 12)  return false;
        if (tmp.edges_p[3]   != 2 && tmp.edges_p[3]   != 4 && tmp.edges_p[3] != 10 && tmp.edges_p[3] != 12)  return false;
        if (tmp.edges_p[9]   != 2 && tmp.edges_p[9]   != 4 && tmp.edges_p[9] != 10 && tmp.edges_p[9] != 12)  return false;
        if (tmp.edges_p[11]  != 2 && tmp.edges_p[11]  != 4 && tmp.edges_p[11]!= 10 && tmp.edges_p[11]!= 12)  return false;
        
        return true;
    }
    
    /**
    * If corner and edge cubies are oriented correctly, return true; else false
    * @param    tmp Cube being evaluated
    * @return   if cubies aligned, return true;else false.
    */
    boolean cubiesAligned(Cube2 tmp) {
        for (int i : tmp.corners_o)  {
            if (i != 0) return false;
        }
        for (int i : tmp.edges_o)    {
            if (i != 0)  return false;
        }
        return true;
    }
    
    /**
    * Checks if the cube is solved using Cube2's solved() function
    * @param    tmp Cube we're evaluating
    * @return   boolean If cube is solved, return true; else false.
    */
    boolean cubeSolved(Cube2 tmp)    {
        if (tmp.solved())    {
            return true;
        }
        return false;
    }
    
    /**
    * Removes specified moves from the allMoves arraylist
    * @param    redundant   The moves we're removing from the arraylist the search function uses.
    */
    void removeRedundantMoves() {
        ArrayList<String> tmp = new ArrayList<String>();
        if (stage == 1)  {List<String> list = Arrays.asList("F", "F'", "B", "B'");tmp.addAll(list);}
        if (stage == 2)  {List<String> list = Arrays.asList("R", "R'", "L", "L'");tmp.addAll(list);}
        if (stage == 3)  {List<String> list = Arrays.asList("U", "U'", "D", "D'");tmp.addAll(list);}
        
        
        for (String s : tmp)   {
            allMoves.remove(allMoves.indexOf(s));
        }
    }
    
    /**
    * Given a byte value, this function decodes it to a colour.
    * @param    i   Byte we're evaluating
    * @return   char    The colour char the byte is representing
    */
    char decodeByte(byte i) {
        char col = 'O';
        if (i == 1)  col = 'R';
        if (i == 2)  col = 'Y';
        if (i == 3)  col = 'W';
        if (i == 4)  col = 'G';
        if (i == 5)  col = 'B';
        return col;
    }
    
    /**
    * Converts byte to colour's string
    * @param     a  byte we're evaluating
    * @return   String  colour in string format.
    */
    String byteToColour(byte a) {
        String colour = "black";
        if (a == 0) colour = "orange";
        if (a == 1) colour = "red";
        if (a == 2) colour = "yellow";
        if (a == 3) colour = "white";
        if (a == 4) colour = "green";
        if (a == 5) colour = "blue";
        
        return colour;
    }
    
    /**
    * If colour array contains colour c
    * @param array  Array of colours
    * @param c      A colour
    * @return boolean   If colour c is in array, return true
    */
    boolean contains(color[] array, color c) {
        for (color i : array) {
            if (i == c)  return true;
        }
        return false;
    }
}
