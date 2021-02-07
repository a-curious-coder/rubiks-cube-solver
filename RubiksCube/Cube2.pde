class Cube2 {
    int[] corners_p = new int[8];
    int[] edges_p = new int[12];
    int[] corners_o = new int[8];
    int[] edges_o = new int[12];
    Cubie[] corners;
    Cubie[] edges;
    Cube2() {
        reset();
    }

    Cube2(Cube cube) {
        corners = new Cubie[8];
        edges = new Cubie[12];
        ic(cube);
        ipce(cube);
        ioe(cube);
        ioc(cube);
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
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red) && contains(c.colours, c.green))     corners_p[ctr] = 1;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red) && contains(c.colours, c.blue))      corners_p[ctr] = 2;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.orange) && contains(c.colours, c.blue))   corners_p[ctr] = 3;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.orange) && contains(c.colours, c.green))  corners_p[ctr] = 4;
            if(contains(c.colours, c.white) && contains(c.colours, c.red) && contains(c.colours, c.blue))       corners_p[ctr] = 5;
            if(contains(c.colours, c.white) && contains(c.colours, c.red) && contains(c.colours, c.green))      corners_p[ctr] = 6;
            if(contains(c.colours, c.white) && contains(c.colours, c.orange) && contains(c.colours, c.green))   corners_p[ctr] = 7;
            if(contains(c.colours, c.white) && contains(c.colours, c.orange) && contains(c.colours, c.blue))    corners_p[ctr] = 8;
            ctr++;
        }

        ctr = 0;
        // Edge permutations
        for(Cubie c : edges)    {
            if(contains(c.colours, c.yellow) && contains(c.colours, c.green)) edges_p[ctr] = 1;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red)) edges_p[ctr] = 2;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.blue)) edges_p[ctr] = 3;
            if(contains(c.colours, c.yellow) && contains(c.colours, c.orange)) edges_p[ctr] = 4;

            if(contains(c.colours, c.orange) && contains(c.colours, c.green)) edges_p[ctr] = 7;
            if(contains(c.colours, c.red) && contains(c.colours, c.green)) edges_p[ctr] = 6;
            if(contains(c.colours, c.red) && contains(c.colours, c.blue)) edges_p[ctr] = 5;
            if(contains(c.colours, c.orange) && contains(c.colours, c.blue)) edges_p[ctr] = 8;

            if(contains(c.colours, c.white) && contains(c.colours, c.blue)) edges_p[ctr] = 9;
            if(contains(c.colours, c.white) && contains(c.colours, c.orange)) edges_p[ctr] = 12;
            if(contains(c.colours, c.white) && contains(c.colours, c.green)) edges_p[ctr] = 11;
            if(contains(c.colours, c.white) && contains(c.colours, c.red)) edges_p[ctr] = 10;
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
        Arrays.fill(edges_o, -1); // Fill edges array with -1 values
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
            edges_o[i] = 0;
            // If Red Orange are on U/D faces, it's badly oriented
            if(up == red || up == orange || down == red || down == orange)  {
                edges_o[i] = 1;
                continue;
            }
            // If green/blue, look at side of edge.
            if(up == green || up == blue || down == green || down == blue)  {
                // If side of edge is yellow or white, it's bad.
                if(contains(c.colours, c.white) || contains(c.colours, c.yellow))   {
                    edges_o[i] = 1;
                    continue;
                }
            }
            // Look at green / blue faces of E slice
            if(front == blue || front == green) {
                // Look at sides of edges.
                if(right == white || left == white || left == yellow || right == yellow)    {
                    edges_o[i] = 1;
                    continue;
                }
            }
            if(back == blue || back == green) {
                if(right == white || left == white || left == yellow || right == yellow)   {
                    edges_o[i] = 1;
                    continue;
                }
            }
            // If red or orange on Front or Back faces, it's bad
                if((front == red || front == orange|| back == red || back == orange) && (left != black || right != black))   {
                    edges_o[i] = 1;
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
                    if(left != black)   corners_o[0] = 0;
                    if(right != black)  corners_o[3] = 0;
                }
                else if(left != black) {
                    if(front == white || front == yellow)   corners_o[0] = 1;
                    if(left == white || left == yellow)     corners_o[0] = 2;
                }
                else if(right != black) {
                    if(right == white || right == yellow)   corners_o[3] = 1;
                    if(front == white || front == yellow)   corners_o[3] = 2;
                }
            }
        // Analyses UBR, UBL
            if(back != black && up != black)    {
                if( up == white || up == yellow)  {
                    if(left != black)   corners_o[1] = 0;
                    if(right != black) corners_o[2] = 0;
                }   else if(left != black) {
                    if(left == white || left == yellow) corners_o[1] = 1;
                    if(back == white || back == yellow) corners_o[1] = 2;
                }   else if(right != black) {
                    if(back == white || back == yellow)     corners_o[2] = 1;
                    if(right == white || right == yellow)   corners_o[2] = 2;
                }
            }
        // Analyses DFL, DFR
            if(front != black && down != black)    {
                if(down == white || down == yellow)  {
                    if(left != black)   corners_o[i] = 0;
                    if(right != black)  corners_o[i] = 0;
                }   else if(left != black) {
                    if( left == white || left == yellow)    corners_o[i] = 1;
                    if( front == white || front == yellow)  corners_o[i] = 2;
                }   else if(right != black) {
                    if( front == white || front == yellow)  corners_o[i] = 1;
                    if( right == white || right == yellow)  corners_o[i] = 2;
                }  
            }
        // Analyses DBL, DBR
            if(back != black && down != black)    {
                if(down == white || down == yellow)  {
                        if(right != black) {
                            corners_o[i] = 0;
                        } else if(left != black) {
                            corners_o[i] = 0;
                        }
                }   else if(right != black) {
                    if( right == white || right == yellow)  corners_o[i] = 1;
                    if( back == white || back == yellow)    corners_o[i] = 2;
                }   else if(left != black)  {
                    if( back == white || back == yellow)    corners_o[i] = 1;
                    if( left == white || left == yellow)    corners_o[i] = 2;
                }
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
    * Tests a specified algorithm on this FastCube object. Computationally cheaper to test on this than Cube object.
    * 
    * @param    algorithm   The algorithm we're testing on this object
    * @return   this        The FastCube in its new state after applying the algorithm
    */
    Cube2 testAlgorithm(String algorithm)   {
        for (int i = 0; i < algorithm.length(); i++) {
			// Initially direction of each move is 1
			int dir = 1;
			String move = algorithm.charAt(i) + "";
			// print(move);
			// If there are moves in algorithm and the next char is a prime: '
			if(i+1 < algorithm.length())	{
				if (algorithm.charAt(i+1) == '\'' || algorithm.charAt(i+1) == '’' || algorithm.charAt(i+1) == '2') {
					char next = algorithm.charAt(i+1);
					// Set the direction of the move to anticlockwise
					if(next == '\'' || next == '’')	{
						move += "\'";
					}	else	{
						dir = 2;
					}
					i++;
				}
			} 
            move(move);
        }
        return this;
    }
    
    boolean solved()     {
        
        for(int i = 0; i < 8; i++)  {
            if(corners_p[i] != i+1) {
                // println("cshould be: " + ctr + "\t actually: " + corners_p[i]);
                // delay(5000);
                return false;
            }
        }
        for(int i = 0; i < 12; i++)    {
            if(edges_p[i] != i+1)
                // println("eshould be: " + i + "\t actually: " + edges_p[i]);
                // delay(5000);
                return false;
        }
        for(int i = 0; i < 8; i++)  {
            if(corners_o[i] != 0)
                return false;
        }
        for(int i = 0; i < 12; i++)    {
            if(edges_o[i] != 0)    
                return false;
        }
        return true;
    }

    // Return a score to add 'luck' factor
    byte score() {
        byte score = 0;
        int[] tmpcorners_p = {1,2,3,4,5,6,7,8};
        int[] tmpcorners_o = {1,2,3,4,5,6,7,8};
        for(int i = 0; i < corners_p.length; i++)  {
            if(tmpcorners_p[i] != corners_p[i])   {
                score += 1;
            }
            if(tmpcorners_o[i] != corners_o[i])   {
                score += 2;
            }
        }
        int[] tmpedges_p = {1,2,3,4,5,6,7,8,9,10,11,12};
        int[] tmpedges_o = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
        for(int i = 0; i < edges_o.length; i++)  {
            if(tmpedges_p[i] != edges_p[i]) {
                score += 1;
            }
            if(tmpedges_o[i] != edges_o[i]) {
                score += 2;
            }
        }
        return score;
    }

    String state()    {
        String state = "Scramble\n";
        state += "corners\n";
        for(int i : corners_p)  state += String.valueOf(i) + " ";
        state += "\n";
        for(int i : corners_o)  state += String.valueOf(i) + " ";
        state += "\nedges\n";
        for(int i : edges_p)  state += String.valueOf(i) + " ";
        state += "\n";
        for(int i : edges_o)  state += String.valueOf(i) + " ";
        state += "\nEnd";
        println(state);
        return state;
    }
    // Resets this cube object to a solved state.
    void reset()    {
        Arrays.fill(corners_p, 0);
        Arrays.fill(corners_o, 0);
        Arrays.fill(edges_p, 0);
        Arrays.fill(edges_o, 0);
        //print("cp\tco\tep\teo\n" + corners_p.length + "\t" + corners_o.length + "\t" + edges_p.length + "\t" + edges_o.length);
    }

    /**
    * Prepare move to be applied to this cube object.
    * @param    move    move we're deconstructing to values
    */
    void move(String move) {
        int x = 0;
        switch(move)    {
            case "U":
                x = corners_p[0];
                corners_p[0] = corners_p[3];
                corners_p[3] = corners_p[2];
                corners_p[2] = corners_p[1];
                corners_p[1] = x;
                x = corners_o[0];
                corners_o[0] = corners_o[3];
                corners_o[3] = corners_o[2];
                corners_o[2] = corners_o[1];
                corners_o[1] = x;
                x = edges_p[0];
                edges_p[0] = edges_p[3];
                edges_p[3] = edges_p[2];
                edges_p[2] = edges_p[1];
                edges_p[1] = x;
                x = edges_o[0];
                edges_o[0] = edges_o[3];
                edges_o[3] = edges_o[2];
                edges_o[2] = edges_o[1];
                edges_o[1] = x;
                break;            
            case "D":
                x = corners_p[4];
                corners_p[4] = corners_p[7];
                corners_p[7] = corners_p[6];
                corners_p[6] = corners_p[5];
                corners_p[5] = x;
                x = corners_o[4];
                corners_o[4] = corners_o[7];
                corners_o[7] = corners_o[6];
                corners_o[6] = corners_o[5];
                corners_o[5] = x;
                x = edges_p[8];
                edges_p[8] = edges_p[11];
                edges_p[11] = edges_p[10];
                edges_p[10] = edges_p[9];
                edges_p[9] = x;
                x = edges_o[8];
                edges_o[8] = edges_o[11];
                edges_o[11] = edges_o[10];
                edges_o[10] = edges_o[9];
                edges_o[9] = x;
                break;
            case "F":
                x = corners_p[0];
                corners_p[0] = corners_p[5];
                corners_p[5] = corners_p[6];
                corners_p[6] = corners_p[3];
                corners_p[3] = x;
                x = corners_o[0];
                corners_o[0] = (corners_o[5]+2)%3;
                corners_o[5] = (corners_o[6]+1)%3;
                corners_o[6] = (corners_o[3]+2)%3;
                corners_o[3] = (x+1)%3;
                x = edges_p[0];
                edges_p[0] = edges_p[5];
                edges_p[5] = edges_p[10];
                edges_p[10] = edges_p[6];
                edges_p[6] = x;
                x = edges_o[0];
                edges_o[0] = (edges_o[5]+1)%2;
                edges_o[5] = (edges_o[10]+1)%2;
                edges_o[10] = (edges_o[6]+1)%2;
                edges_o[6] = (x+1)%2;
                break;
            case "B":
                x = corners_p[1];
                corners_p[1] = corners_p[2];
                corners_p[2] = corners_p[7];
                corners_p[7] = corners_p[4];
                corners_p[4] = x;
                x = corners_o[1];
                corners_o[1] = (corners_o[2]+1)%3;
                corners_o[2] = (corners_o[7]+2)%3;
                corners_o[7] = (corners_o[4]+1)%3;
                corners_o[4] = (x+2)%3;
                x = edges_p[2];
                edges_p[2] = edges_p[7];
                edges_p[7] = edges_p[8];
                edges_p[8] = edges_p[4];
                edges_p[4] = x;
                x = edges_o[2];
                edges_o[2] = (edges_o[7]+1)%2;
                edges_o[7] = (edges_o[8]+1)%2;
                edges_o[8] = (edges_o[4]+1)%2;
                edges_o[4] = (x+1)%2;
                break;
            case "R":
                x = corners_p[2];
                corners_p[2] = corners_p[3];
                corners_p[3] = corners_p[6];
                corners_p[6] = corners_p[7];
                corners_p[7] = x;
                x = corners_o[2];
                corners_o[2] = (corners_o[3]+1)%3;
                corners_o[3] = (corners_o[6]+2)%3;
                corners_o[6] = (corners_o[7]+1)%3;
                corners_o[7] = (x+2)%3;
                x = edges_p[3];
                edges_p[3] = edges_p[6];
                edges_p[6] = edges_p[11];
                edges_p[11] = edges_p[7];
                edges_p[7] = x;
                x = edges_o[3];
                edges_o[3] = edges_o[6];
                edges_o[6] = edges_o[11];
                edges_o[11] = edges_o[7];
                edges_o[7] = x;
                break;
            case "L":
                x = corners_p[0];
                corners_p[0] = corners_p[1];
                corners_p[1] = corners_p[4];
                corners_p[4] = corners_p[5];
                corners_p[5] = x;
                x = corners_o[0];
                corners_o[0] = (corners_o[1]+1)%3;
                corners_o[1] = (corners_o[4]+2)%3;
                corners_o[4] = (corners_o[5]+1)%3;
                corners_o[5] = (x+2)%3;
                x = edges_p[1];
                edges_p[1] = edges_p[4];
                edges_p[4] = edges_p[9];
                edges_p[9] = edges_p[5];
                edges_p[5] = x;
                x = edges_o[1];
                edges_o[1] = edges_o[4];
                edges_o[4] = edges_o[9];
                edges_o[9] = edges_o[5];
                edges_o[5] = x;
                break;
        }
        }

    /**
    *   Don't fully understand this yet - have taken inspiration from
    *   https://www.jaapsch.net/puzzles/compindx.htm
    */
    int encode_corners_p(){
        int t = 0;
        for(int i=0; i<7; i++){
            t *= 8-i;
            for(int j=i+1; j<8; j++){
                if(corners_p[i] > corners_p[j]) t++;
            }
        }
        return t;
    }

    void decode_corners_p(int t){
        corners_p[7] = 1;
        for(int i=6; i>=0; i--){
            corners_p[i] = 1+t%(8-i);
            t /= 8-i;
            for(int j=i+1; j<8; j++){
                if(corners_p[j] >= corners_p[i]) corners_p[j]++;
            }
        }
    }

    int encode_corners_o(){
        int t = 0;
        for(int i = 0; i < 7; i++){
            t = 3 * t + corners_o[i];
        }
        return t;
    }

    void decode_corners_o(int t){
        char s = 0;
        for(int i=6; i>=0; i--){
            corners_o[i] = t%3;
            s += 3 - corners_o[i];
            t /= 3;
        }
        corners_o[7] = s % 3;
    }

    int encode_edges_p(){
        int t = 0;
        for(int i=0; i<11; i++){
            t *= 12-i;
            for(int j=i+1; j<12; j++){
                if(edges_p[i] > edges_p[j]) t++;
            }
        }
        return t;
    }

    void decode_edges_p(int t){
        edges_p[11] = 1;
        for(int i=10; i>=0; i--){
            edges_p[i] = 1+t%(12-i);
            t /= 12-i;
            for(int j=i+1; j<12; j++){
                if(edges_p[j] >= edges_p[i]) edges_p[j]++;
            }
        }
    }

    int encode_edges_o(){
        int t = 0;
        for(int i=0; i<11; i++){
            t = 2*t + edges_o[i];
        }
        return t;
    }

    void decode_edges_o(int t){
        char s = 0;
        for(int i=10; i>=0; i--){
            edges_o[i] = t%2;
            s += 2 - edges_o[i];
            t /= 2;
        }
        edges_o[11] = s % 2;
    }

    int encode_corners_p_corners_o(){
        return encode_corners_p() + 40320*(encode_corners_o());
    }

    void decode_corners_p_corners_o(int t){
        decode_corners_p(t%40320);
        t /= 40320;
        decode_corners_o(t);
    }

    void set_corners_p(int[] v){
        for(int i=0; i<8; i++){
            corners_p[i] = v[i];
        }
    }
    
    void set_corners_o(int[] v){
        for(int i=0; i<8; i++){
            corners_o[i] = v[i];
        }
    }
    
    void set_edges_p(int[] v){
        for(int i=0; i<12; i++){
            edges_p[i] = v[i];
        }
    }
    
    void set_edges_o(int[] v){
        for(int i=0; i<12; i++){
            edges_o[i] = v[i];
        }
    }

    
}