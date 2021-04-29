class Korfs {
    
    long nodes = 0; // Needs to be a long data type because node count gets bigger than the max value an int can hold.
    int currentDepth = 0;
    int numSolutions = 0;
    int moveCount = 0;
    Stack<Integer> soln = new Stack<Integer>();
    Cubie[] corners;
    Cubie[] edges;
    Cube2 cube;
    Cube2[] fittest; // Idea that the program should track, say, the top 1% of solutions that get close to a solve {determined by an evaluation function to score the cube's state after applying solutions}, and append all combinations of 2-3 moves on top of them to see if the program can 'get lucky' and get a solution that way.
    String t = "    ";
    String solution = "";
    String directory = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";
    String[] printableMoveNames = {"U", "U2", "U'", "L", "L2", "L'", "F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'"};
    Korfs(Cube cube) {
        // Corners will always be 8, regardless of cube size.
        corners = new Cubie[8];
        // Edges are dependant on cube size.
        edges   = new Cubie[(dim-2)*12];
        this.cube = new Cube2(cube);
    }

    String solution()   {
        return solution;
        }

    // Solves the cube using Korf's Algorithm
    void solve()    {
        outputBox.append("Korf's Algorithm\n");
        ksolveRunning = true;
        if(cube.solved())   {
            println("Cube is already solved?");
            return;
        }

        boolean solved = false;
        int slackCounter = 1;

        // Region: Check cube for invalid cubies
            if(edges_p_table[cube.encode_edges_p()] == -1){
                println("Found unsolvable piece set: edges_p\n");
                return;
            }

            if(corners_p_corners_o_table[cube.encode_corners_p_corners_o()] == -1){
                println("Found unsolvable combination of piece sets: corners_p, corners_o\n");
                return;
            }

            if(edges_o_table[cube.encode_edges_o()] == -1){
                println("Found unsolvable piece set: edges_o\n");
                return;
            }
        // End Region: Check cube for invalid cubies

        println("\nDepth\tNodes\tTime");
        outputBox.append("Depth" + t + "Nodes" + t + "Time\n");
        long start = System.currentTimeMillis(); // Start timer
        for(int i = 1 ; i <= 20 ;i++ ){
            currentDepth = i;
            if(solved && slackCounter == 1) break;
            if(solved) slackCounter++;
            // To track mem consumption when testing
            memConsumptionArray.add(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory());
            print(i + "\t");
            outputBox.append(i + t);
            if(search(i))   {
                long end = System.currentTimeMillis();
                float duration = (end - start) / 1000F;
                println("Solved in " + convertTime((int)duration) + "s");
                solved = true;
            }
            long e = System.currentTimeMillis();
            float d = (e - start) / 1000F;
            start = System.currentTimeMillis();
            print(nodes + "\t" + d + "s\n");
            outputBox.append(nodes + t + d + "s\n");
        }
        ksolveRunning = false;
        solving = false;
        }
    /**
    * Search function that searches for solution at a specific depth
    * @param depth  The length of the combinations we're searching.
    * @return   boolean If depth has been fully searched or solution found, return true;
    */
    boolean search(int depth)   {
        if(prune(cube, depth))  return false;
        String[] moves = {"U", "L", "F", "R", "B", "D"};
        boolean s = false;
        int counter = 0;

        for(String move : moves)    {
            // The 3 represents each variation of 'move'. E.g. F, F', F2
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                counter++;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
            cube.move(move);
        }
        return s;
        }
    /**
    * Switch case for searching each move at the specified depth.
    * @param    move    The move we're searching
    * @param    nDepth  The depth we're searching (depth representing the number of moves of each combination we check)
    * @return   boolean returns true if solution is found or all permutations/combinations have been checked in accordance to pruning table for the specified depth.
    */
    boolean search(String move, int nDepth) {
        switch(move)    {
            case "U":
                if(searchU(nDepth)) return true;
                return false;
            case "D":
                if(searchD(nDepth)) return true;
                return false;
            case "L":
                if(searchL(nDepth)) return true;
                return false;
            case "R":
                if(searchR(nDepth)) return true;
                return false;
            case "F":
                if(searchF(nDepth)) return true;
                return false;
            case "B":
                if(searchB(nDepth)) return true;
                return false;
        }
        return false;
        }
    // Search specific moves at the specified depth. Returns true if the solution has been found or all permutations/combinations have been checked in accordance to pruning table for the specified depth.
    boolean searchU(int depth) {
        if(numSolutions == 1)   return true;
        if(depth == 0)  return solved();
        if(prune(cube, depth)) return false;
        // If num solutions == max solutions -> true
        // If depth is 0 then check if cube is solved
        // if the puzzle has been pruned at a certain depth -> false
        String[] moves = {"L", "F", "R", "B"};
        boolean s = false;
        int counter = 3;
        for(String move : moves)    {
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                counter++;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
            cube.move(move); // Puts the cube back to its original position.
        }
        return s;
        }

    boolean searchD(int depth) {
        if(numSolutions == 1)   return true;
        if(depth == 0)  return solved();
        if(prune(cube, depth)) return false;
        String[] moves = {"U", "L", "F", "R", "B"};
        boolean s = false;
        int counter = 0;
        for(String move : moves)    {
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                counter++;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
        cube.move(move);
        }
        return s;
        }
    boolean searchL(int depth) {
        if(numSolutions == 1)   return true;
        if(depth == 0)  return solved();
        if(prune(cube, depth)) return false;
        String[] moves = {"U", "F", "B", "D"};
        boolean s = false;
        int counter = 0;
        for(String move : moves)    {
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                if(counter == 2 || counter == 8)    counter += 4;
                else counter += 1;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
        cube.move(move);
        }
        return s;
        }
    boolean searchR(int depth) {
        if(numSolutions == 1)   return true;
        if(depth == 0)  return solved();
        if(prune(cube, depth)) return false;
        String[] moves = {"U", "L", "F", "B", "D"};
        boolean s = false;
        int counter = 0;
        for(String move : moves)    {
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                counter += counter == 8 ? 4 : 1;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
        cube.move(move);
        }
        return s;
        }
    boolean searchF(int depth) {
        if(numSolutions == 1)   return true;
        if(depth == 0)  return solved();
        if(prune(cube, depth)) return false;
        String[] moves = {"U", "L", "R", "D"};
        boolean s = false;
        int counter = 0;
        for(String move : moves)    {
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                if(counter == 5 || counter == 11)    counter += 4;
                else counter += 1;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
        cube.move(move);
        }
        return s;
        }
    boolean searchB(int depth) {
        if(numSolutions == 1)   return true;
        if(depth == 0)  return solved();
        if(prune(cube, depth)) return false;

        String[] moves = {"U", "L", "F", "R", "D"};
        boolean s = false;
        int counter = 0;
        for(String move : moves)    {
            for(int i = 0; i < 3; i++)  {
                cube.move(move);
                soln.push(counter);
                counter += counter == 11 ? 4 : 1;
                nodes++;
                if(search(move, depth-1))   s = true;
                try {
                    soln.pop();
                } catch(EmptyStackException e) {
                    return false;
                }
            }
        cube.move(move);
        }
        return s;
        }
    
    
    /**
    * Checks if the cube is solved and appends solution (if there is one) to solution string.
    * @return   boolean if cube is solved, return true
    */
    boolean solved()    {
        if(cube.solved())   {
            if(soln.size() == 0) return true;
            Stack<Integer> soln2 = soln;
            solution = printableMoveNames[soln2.peek()];
            moveCount += 1;
            soln2.pop();
            while(!soln2.empty())   {
                solution = printableMoveNames[soln2.peek()] + " " + solution;
                moveCount += 1;
                soln2.pop();
            }
            println("\nSolution: " + solution);
            outputBox.append("\nSolution: " + solution);
            returnSolution(solution); // Returns solution to main thread so it can be executed on the scrambled graphical cube.
            numSolutions++;
            return true;
        }
        return false;
        }

    /**
    * Returns the solution to the main thread to be applied to the graphical cube object
    * @param solution   The solution to solving the cube.
    */
    void returnSolution(String solution)   {
        // println(solution);
        moves = solution;
        for(int i = 0; i < solution.length(); i++)    {
            String move = solution.charAt(i) + "";
            if(i+1 < solution.length())  {
                if(solution.charAt(i+1) == '\'' || solution.charAt(i+1) == '2') {
                    move += solution.charAt(i+1) + "";
                    i++;
                }
            }
            if(move != "")  {
                addMoveToSequence(move);
            }
        }
    }
    /**
    * Matches a cubie's position with hardcoded position
    * @param    a   Cubie's position/permutation on cube
    * @param    x   x coord
    * @param    y   y coord
    * @param    z   z coord
    * @return   boolean If vector matches x,y,z coords, position matches
    */
    boolean positionMatch(PVector a, float x, float y, float z)    {
        return a.x == x && a.y == y && a.z == z;
        }

    /**
    * If colour array contains colour c
    * @param array  Array of colours
    * @param c      A colour
    * @return boolean   If colour c is in array, return true
    */
    boolean contains(color[] array, color c) {
        boolean result = false;
        for(color i : array){
            if(i == c){
                result = true;
                break;
            }
        }
        return result;
        }
    
    /**
    * Converts seconds to hours/minutes/seconds format.
    * @param secs   seconds value
    * @return   String  Seconds value, reformatted to hours/minutes/seconds format as string datatype
    */
    String convertTime(int secs) {
        int hours = secs / 3600;
        int minutes = (secs % 3600) / 60;
        int seconds = secs % 60;
        String timeString = "";
        if(hours > 0)   {
            if(hours  == 1) {
                timeString = String.format("%02d Hour %02d Minutes %02d Seconds ", hours, minutes, seconds);
            } else {
                timeString = String.format("%02d Hours %02d Minutes %02d Seconds ", hours, minutes, seconds);
            }
        } else if (hours == 0 && minutes > 0)   {
            if(minutes == 1)    {
                timeString = String.format("%02d Minute %02d Seconds ", minutes, seconds);
            } else {
                timeString = String.format("%02d Minutes %02d Seconds ", minutes, seconds);
            }
        } else {
            timeString = String.format("%02d Seconds ", seconds);
        }
        return timeString;
    }
}
