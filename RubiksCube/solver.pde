class solver {
    
    int nodes = 0;
    int numSolutions = 0;
    int solutionMoves = 0;
    Stack<Integer> soln = new Stack<Integer>();
    // Minus inner cubies. Minus corners. Minus centers.
    int nEdges = 12;
    Cubie[] corners;
    Cubie[] edges;
    Cube mainCube;
    Cube2 cube;
    Cube2[] fittest;
    String solution = "";
    String directory = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";
    String[] printableMoveNames = {"U", "U2", "U'", "L", "L2", "L'", "F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'"};
    solver(Cube cube) {
        corners = new Cubie[8];
        edges   = new Cubie[nEdges];
        mainCube = cube;
        this.cube = new Cube2();
        initialiseCubes();
        // try {
        //     PrintWriter out = new PrintWriter(directory+"scramble.txt");
        //     out.println(this.cube.state());
        //     out.close();
        //     println("Saved scramble.txt");
        // } catch (FileNotFoundException e)   {

        // }
        
        // println("KSOLVER READY");
        // delay(2000);
    }

    String solution()   {
        return solution;
        }

    void solve()    {
        ksolveRunning = true;
        if(cube.solved())   {
            println("Cube is already solved?");
            return;
        } else {
        }

        numSolutions = 0;
        boolean solved = false;
        int slackCounter = 1;

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
        println("\nDepth\tNodes Visited\tTime");
        long start = System.currentTimeMillis(); // Start timer
        for(int i = 1 ; i <= 20 ;i++ ){
            if(solved && slackCounter == 1) break;
            if(solved) slackCounter++;
            print(i + "\t");
            // Instantiate fittest array with 1% of the node value
            if(search(i))   {
                long end = System.currentTimeMillis();
                float duration = (end - start) / 1000F;
                println("Solved in " + duration + "s");
                solved = true;
                // if(!solved()) println("NOT SOLVED");
            }
            long e = System.currentTimeMillis();
            float d = (e - start) / 1000F;
            start = System.currentTimeMillis();
            print(nodes + "\t" + d + "\n");
        }
        ksolveRunning = false;
        }

    boolean search(int depth)   {
        if(prune(cube, depth))  {
            return false;
        }
        String[] moves = {"U", "L", "F", "R", "B", "D"};
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

    boolean search(String move, int nDepth) {
        switch(move)    {
            case "U":
                if(searchU(nDepth)) return true;
                break;
            case "D":
                if(searchD(nDepth)) return true;
                break;
            case "L":
                if(searchL(nDepth)) return true;
                break;
            case "R":
                if(searchR(nDepth)) return true;
                break;
            case "F":
                if(searchF(nDepth)) return true;
                break;
            case "B":
                if(searchB(nDepth)) return true;
                break;
        }
        return false;
        }

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
            cube.move(move);
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
    
    boolean solved()    {
        if(cube.solved())   {
            if(soln.size() == 0) return true;
            Stack<Integer> soln2 = soln;
            solution = printableMoveNames[soln2.peek()];
            solutionMoves += 1;
            soln2.pop();
            while(!soln2.empty())   {
                solution = printableMoveNames[soln2.peek()] + " " + solution;
                solutionMoves += 1;
                soln2.pop();
            }
            println("\nSolution: " + solution);
            returnSolution(solution);
            initialiseCubes();
            numSolutions++;
            return true;
        }
        return false;
        }

    /**
    * Translates Cube state to Cube2
    * @param    cube    cube we're translating to lighter cube (Cube2)
    */
    void ic(Cube cube)  {
        int ctr = 1;
        // Collect all cubies from cube and store in specific order. (Clockwise)(Excluding centers)
        for(Cubie c : cube.getCubies()) {
            // Corners stored in clockwise fashion starting with FL corner on U face then D face.
            if(positionMatch(c.getPosition(),-axis, -axis, axis))   corners[0] = c;   // Yellow, red, green
            if(positionMatch(c.getPosition(), -axis, -axis, -axis)) corners[1] = c;    // Yellow, red, blue
            if(positionMatch(c.getPosition(), axis, -axis, -axis))  corners[2] = c;   // Yellow, orange, blue
            if(positionMatch(c.getPosition(), axis, -axis, axis))   corners[3] = c;    // Yellow, orange, green
            if(positionMatch(c.getPosition(), -axis, axis, -axis))  corners[4] = c;     // White, red, blue
            if(positionMatch(c.getPosition(), -axis, axis, axis))   corners[5] = c;    // White, red, green
            if(positionMatch(c.getPosition(), axis, axis, axis))    corners[6] = c;     // White, orange, green
            if(positionMatch(c.getPosition(), axis, axis, -axis))   corners[7] = c;    // White, orange, blue
            // Edges stored in clockwise fashion
            if(positionMatch(c.getPosition(),      0, -axis, axis))    edges[0] = c;  // Yellow, Green
            if(positionMatch(c.getPosition(),  -axis, -axis, 0))       edges[1] = c;  // Yellow, Red
            if(positionMatch(c.getPosition(),      0, -axis, -axis))   edges[2] = c;  // Yellow, Blue
            if(positionMatch(c.getPosition(),   axis, -axis, 0))       edges[3] = c;  // Yellow, Orange
            // Middle Layer
            if(positionMatch(c.getPosition(),   axis, 0, axis))        edges[6] = c;  // Green, Orange
            if(positionMatch(c.getPosition(),  -axis, 0, axis))        edges[5] = c;  // Green, Red
            if(positionMatch(c.getPosition(),  -axis, 0, -axis))       edges[4] = c;  // Blue, Red
            if(positionMatch(c.getPosition(),   axis, 0, -axis))       edges[7] = c;  // Blue Orange
            // Bottom (D) Layer
            if(positionMatch(c.getPosition(),      0, axis, -axis))    edges[8] = c; // White, Blue
            if(positionMatch(c.getPosition(),   axis, axis, 0))        edges[11] = c;  // White, Orange
            if(positionMatch(c.getPosition(),      0, axis, axis))     edges[10] = c;  // White, Green
            if(positionMatch(c.getPosition(),  -axis, axis, 0))        edges[9] = c; // White, Red
        }
        }
    // Intialise permutation of edges and corners of cube.
    void ipce(Cube hCube)  {

        int ctr = 0;
        // Corner permutations
        for(int i = 0; i < corners.length; i++)    {
            Cubie c = corners[i];
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red) && contains(c.colours, c.green))     this.cube.corners_p[ctr] = 1;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red) && contains(c.colours, c.blue))      this.cube.corners_p[ctr] = 2;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.orange) && contains(c.colours, c.blue))   this.cube.corners_p[ctr] = 3;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.orange) && contains(c.colours, c.green))  this.cube.corners_p[ctr] = 4;
            if(contains(c.colours, c.white) && contains(c.colours, c.red) && contains(c.colours, c.blue))       this.cube.corners_p[ctr] = 5;
            if(contains(c.colours, c.white) && contains(c.colours, c.red) && contains(c.colours, c.green))      this.cube.corners_p[ctr] = 6;
            if(contains(c.colours, c.white) && contains(c.colours, c.orange) && contains(c.colours, c.green))   this.cube.corners_p[ctr] = 7;
            if(contains(c.colours, c.white) && contains(c.colours, c.orange) && contains(c.colours, c.blue))    this.cube.corners_p[ctr] = 8;
            ctr++;
        }

        ctr = 0;
        // Edge permutations
        for(Cubie c : edges)    {
            if(contains(c.colours, c.yellow) && contains(c.colours, c.green)) this.cube.edges_p[ctr] = 1;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red)) this.cube.edges_p[ctr] = 2;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.blue)) this.cube.edges_p[ctr] = 3;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.orange)) this.cube.edges_p[ctr] = 4;

            if(contains(c.colours, c.orange) && contains(c.colours, c.green)) this.cube.edges_p[ctr] = 7;
            if(contains(c.colours, c.red) && contains(c.colours, c.green)) this.cube.edges_p[ctr] = 6;
            if(contains(c.colours, c.red) && contains(c.colours, c.blue)) this.cube.edges_p[ctr] = 5;
            if(contains(c.colours, c.orange) && contains(c.colours, c.blue)) this.cube.edges_p[ctr] = 8;

            if(contains(c.colours, c.white) && contains(c.colours, c.blue)) this.cube.edges_p[ctr] = 9;
            if(contains(c.colours, c.white) && contains(c.colours, c.orange)) this.cube.edges_p[ctr] = 12;
            if(contains(c.colours, c.white) && contains(c.colours, c.green)) this.cube.edges_p[ctr] = 11;
            if(contains(c.colours, c.white) && contains(c.colours, c.red)) this.cube.edges_p[ctr] = 10;
            ctr++;
        }
        }
    // Initialise orientation of edges - http://cube.rider.biz/zz.php?p=eoline#eo_detection
    void ioe(Cube hCube)  {
        // Region: colours
            color white = hCube.getCubie(0).white;
            color yellow = hCube.getCubie(0).yellow;
            color black = color(0);
        // End Region: colours
        // For every edge
        Arrays.fill(cube.edges_o, -1); // Fill edges array with -1 values
        for(int i = 0; i < edges.length; i++)    {
            Cubie c = edges[i];
            // Region: colours of each cubie's side.
                color right = c.colours[0];
                color left =  c.colours[1];
                color up =  c.colours[2];
                color down =  c.colours[3];
                color front =  c.colours[4];
                color back =  c.colours[5];
            // End Region: colours of each cubie's side
            cube.edges_o[i] = 0;
            // If Red Orange are on U/D faces, it's badly oriented
            if(up == red || up == orange || down == red || down == orange)  {
                cube.edges_o[i] = 1;
                continue;
            }
            // If green/blue, look at side of edge.
            if(up == green || up == blue || down == green || down == blue)  {
                // If side of edge is yellow or white, it's bad.
                if(contains(c.colours, c.white) || contains(c.colours, c.yellow))   {
                    cube.edges_o[i] = 1;
                    continue;
                }
            }
            // Look at green / blue faces of E slice
            if(front == blue || front == green) {
                // Look at sides of edges.
                if(right == white || left == white || left == yellow || right == yellow)    {
                    cube.edges_o[i] = 1;
                    continue;
                }
            }
            if(back == blue || back == green) {
                if(right == white || left == white || left == yellow || right == yellow)   {
                    cube.edges_o[i] = 1;
                    continue;
                }
            }
            // If red or orange on Front or Back faces, it's bad
                if((front == red || front == orange|| back == red || back == orange) && (left != black || right != black))   {
                    cube.edges_o[i] = 1;
                    continue;
                }
            
        }
        }
    // Initialise orientations of corners
    void ioc(Cube hCube) {
        // Region: colours
            color white = hCube.getCubie(0).white;
            color yellow = hCube.getCubie(0).yellow;
            color black = color(0);
        // End Region: colours
        for(int i = 0; i < corners.length; i++)  {
        // Region: colours of each cubie's side.
            color right = corners[i].colours[0];
            color left =  corners[i].colours[1];
            color up =  corners[i].colours[2];
            color down =  corners[i].colours[3];
            color front =  corners[i].colours[4];
            color back =  corners[i].colours[5];
        // End Region: colours of each cubie's side
        // Analyses UFL, UFR
            if(front != black && up != black)    {
                if(up == white || up == yellow)  {
                    if(left != black)   cube.corners_o[0] = 0;
                    if(right != black)  cube.corners_o[3] = 0;
                }
                else if(left != black) {
                    if(front == white || front == yellow)   cube.corners_o[0] = 1;
                    if(left == white || left == yellow)     cube.corners_o[0] = 2;
                }
                else if(right != black) {
                    if(right == white || right == yellow)   cube.corners_o[3] = 1;
                    if(front == white || front == yellow)   cube.corners_o[3] = 2;
                }
            }
        // Analyses UBR, UBL
            if(back != black && up != black)    {
                if( up == white || up == yellow)  {
                    if(left != black)   cube.corners_o[1] = 0;
                    if(right != black) cube.corners_o[2] = 0;
                }   else if(left != black) {
                    if(left == white || left == yellow) cube.corners_o[1] = 1;
                    if(back == white || back == yellow) cube.corners_o[1] = 2;
                }   else if(right != black) {
                    if(back == white || back == yellow)     cube.corners_o[2] = 1;
                    if(right == white || right == yellow)   cube.corners_o[2] = 2;
                }
            }
        // Analyses DFL, DFR
            if(front != black && down != black)    {
                if(down == white || down == yellow)  {
                    if(left != black)   cube.corners_o[i] = 0;
                    if(right != black)  cube.corners_o[i] = 0;
                }   else if(left != black) {
                    if( left == white || left == yellow)    cube.corners_o[i] = 1;
                    if( front == white || front == yellow)  cube.corners_o[i] = 2;
                }   else if(right != black) {
                    if( front == white || front == yellow)  cube.corners_o[i] = 1;
                    if( right == white || right == yellow)  cube.corners_o[i] = 2;
                }  
            }
        // Analyses DBL, DBR
            if(back != black && down != black)    {
                if(down == white || down == yellow)  {
                        if(right != black) {
                            cube.corners_o[i] = 0;
                        } else if(left != black) {
                            cube.corners_o[i] = 0;
                        }
                }   else if(right != black) {
                    if( right == white || right == yellow)  cube.corners_o[i] = 1;
                    if( back == white || back == yellow)    cube.corners_o[i] = 2;
                }   else if(left != black)  {
                    if( back == white || back == yellow)    cube.corners_o[i] = 1;
                    if( left == white || left == yellow)    cube.corners_o[i] = 2;
                }
            }
        }
        }
    // Initialises the Cube2 Object to be a cheaper representation of the cube object
    void initialiseCubes()  {
        ic(mainCube); // Initialise cube values to Cube2 object.
        // Convert cube object in its current state to Cube2 object.
        ipce(mainCube); // Initialise permutations of corners and edges
        ioe(mainCube);  // Initialise orientations of edges 
        ioc(mainCube);  // Initialise orientations of corners
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
        if(a.x == x && a.y == y && a.z == z)    return true;
        return false;
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
    * Returns the solution to the main thread to be applied to the graphical cube object
    * @param solution   The solution to solving the cube.
    */
    void returnSolution(String solution)   {
        // println(solution);
        moves = solution;
        int counter = 0;
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
                counter++;
            }
        }
        // print(counter);
        // println("\n" + solution);
    }

    /**
    * Adds move to sequence for applying to cube
    * @param move   Move being applied to cube
    */
    void addMoveToSequence(String move)  {
        // turns += move;
        boolean matchfound = false;
        for (Move m : allMoves)  {
            if (matchfound) continue;
            if (m.toString().equals(move))  {
                matchfound = true;
                sequence.add(m);
            }
        }
    }
}