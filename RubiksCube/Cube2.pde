class Cube2 {

    int[] corners_p;
    int[] edges_p;
    int[] corners_o;
    int[] edges_o;
    byte[] edgeColours;
    byte[] cornerColours;
    Cubie[] corners;
    Cubie[] edges;

    Cube2() {
        reset();
    }
    // translate cube object to cube2 representation
    Cube2(Cube cube) {
        corners_o = new int[8];
        corners_p = new int[8];
        corners = new Cubie[8];
        cornerColours = new byte[24];
        edges_o = new int[(dim-2)*12];
        edges_p = new int[(dim-2)*12];
        edges = new Cubie[(dim-2)*12];
        edgeColours = new byte[((dim-2)*12)*2];
        ic(cube);
        getEdgeColours();
        getCornerColours();
        ipce();
        ioe();
        ioc();
    }
    // Clone cube2 object
    Cube2(Cube2 cube)   {
        corners = new Cubie[8];
        for(int i = 0; i < cube.corners.length; i++) {
            this.corners[i] = cube.corners[i];
        }
        edges = new Cubie[(dim-2)*12];
        for(int i = 0; i < cube.edges.length; i++) {
            this.edges[i] = cube.edges[i];
        }
        edgeColours = new byte[((dim-2)*12)*2];
        for(int i = 0; i < cube.edgeColours.length; i++)    {
            this.edgeColours[i] = cube.edgeColours[i];
        }
        cornerColours = new byte[24];
        for(int i = 0; i < cube.cornerColours.length; i++)    {
            this.cornerColours[i] = cube.cornerColours[i];
        }
        edges_p = new int[(dim-2)*12];
        for(int i = 0; i < cube.edges_p.length; i++) {
            this.edges_p[i] = cube.edges_p[i];
        }
        edges_o = new int[(dim-2)*12];
        for(int i = 0; i < cube.edges_o.length; i++) {
            this.edges_o[i] = cube.edges_o[i];
        }
        corners_p = new int[8];
        for(int i = 0; i < cube.corners_p.length; i++) {
            this.corners_p[i] = cube.corners_p[i];
        }
        corners_o = new int[8];
        for(int i = 0; i < cube.corners_o.length; i++) {
            this.corners_o[i] = cube.corners_o[i];
        }
    }
    
    void getEdgeColours()    {
        for(Cubie c : edges) {
            // RU, RF, RD, RB
            edgeColours[0] = (c.x == axis && c.y == -axis&& c.z == 0) ?       c2b('R', c.colours) : edgeColours[0];
            edgeColours[1] = (c.x == axis && c.y == 0    && c.z == axis) ?    c2b('R', c.colours) : edgeColours[1];
            edgeColours[2] = (c.x == axis && c.y == axis && c.z == 0) ?       c2b('R', c.colours) : edgeColours[2];
            edgeColours[3] = (c.x == axis && c.y == 0    && c.z == -axis) ?   c2b('R', c.colours) : edgeColours[3];
            // LU, LF, LD, LB
            edgeColours[4] = (c.x == -axis && c.y == -axis && c.z == 0) ?     c2b('L', c.colours) : edgeColours[4];
            edgeColours[5] = (c.x == -axis && c.y == 0     && c.z == axis) ?  c2b('L', c.colours) : edgeColours[5];
            edgeColours[6] = (c.x == -axis && c.y == axis && c.z == 0) ?      c2b('L', c.colours) : edgeColours[6];
            edgeColours[7] = (c.x == -axis && c.y == 0     && c.z == -axis) ? c2b('L', c.colours) : edgeColours[7];
            // UB, UR, UF, UL
            edgeColours[8] = (c.x == 0     && c.y == -axis && c.z == -axis) ?  c2b('U', c.colours) : edgeColours[8];
            edgeColours[9] = (c.x == axis && c.y == -axis && c.z == 0) ?       c2b('U', c.colours) : edgeColours[9];
            edgeColours[10] = (c.x == 0     && c.y == -axis && c.z == axis) ?  c2b('U', c.colours) : edgeColours[10];
            edgeColours[11] = (c.x == -axis  && c.y == -axis && c.z == 0 ) ?   c2b('U', c.colours) : edgeColours[11];
            // DF, DL, DB, DR
            edgeColours[12] = (c.x == 0    && c.y == axis && c.z == axis) ?   c2b('D', c.colours) : edgeColours[12];
            edgeColours[13] = (c.x == -axis&& c.y == axis && c.z == 0) ?      c2b('D', c.colours) : edgeColours[13];
            edgeColours[14] = (c.x == 0    && c.y == axis && c.z == -axis) ?  c2b('D', c.colours) : edgeColours[14];
            edgeColours[15] = (c.x == axis && c.y == axis && c.z == 0) ?      c2b('D', c.colours) : edgeColours[15];
            // FU, FL, FD, FR
            edgeColours[16] = (c.x == 0    && c.y == -axis && c.z == axis) ?  c2b('F', c.colours) : edgeColours[16];
            edgeColours[17] = (c.x == -axis&& c.y == 0     && c.z == axis) ?  c2b('F', c.colours) : edgeColours[17];
            edgeColours[18] = (c.x == 0    && c.y == axis  && c.z == axis) ?  c2b('F', c.colours) : edgeColours[18];
            edgeColours[19] = (c.x == axis && c.y == 0     && c.z == axis) ?  c2b('F', c.colours) : edgeColours[19];
            // BU, BL, BD, BR
            edgeColours[20] = (c.x == 0    && c.y == -axis&& c.z == -axis) ?  c2b('B', c.colours) : edgeColours[20];
            edgeColours[21] = (c.x == -axis&& c.y == 0    && c.z == -axis) ?  c2b('B', c.colours) : edgeColours[21];
            edgeColours[22] = (c.x == 0    && c.y == axis && c.z == -axis) ?  c2b('B', c.colours) : edgeColours[22];
            edgeColours[23] = (c.x == axis && c.y == 0    && c.z == -axis) ?  c2b('B', c.colours) : edgeColours[23];
        }
    }
    
    void getCornerColours() {
        for(int i = 0; i < corners.length; i++)  {
            Cubie c = corners[i];
            // UFL, UBL, UBR, UFR       0, 1, 2, 3
            // DFL, DBL, DBR, DFR       4, 5, 6, 7
            // FDL, FUL, FUR, FDR       8, 9, 10, 11
            // BDL, BUL, BUR, BDR       12, 13, 14, 15
            // RDF, RUF, RUB, RDB       16, 17, 18, 19
            // LDF, LUF LUB, LDB        20, 21, 22, 23
            // 0, 1, 2, 3
            cornerColours[0] = (c.x == -axis && c.y == -axis && c.z == axis)    ? c2b('U', c.colours) : cornerColours[0];
            cornerColours[1] = (c.x == -axis && c.y == -axis && c.z == -axis)    ? c2b('U', c.colours) : cornerColours[1];
            cornerColours[2] = (c.x == axis && c.y == -axis && c.z == -axis)    ? c2b('U', c.colours) : cornerColours[2];
            cornerColours[3] = (c.x == axis && c.y == -axis && c.z == axis)    ? c2b('U', c.colours) : cornerColours[3];
            // 4, 5, 6, 7
            cornerColours[4] = (c.x == -axis && c.y == axis && c.z == axis)    ? c2b('D', c.colours) : cornerColours[4];
            cornerColours[5] = (c.x == -axis && c.y == axis && c.z == -axis)    ? c2b('D', c.colours) : cornerColours[5];
            cornerColours[6] = (c.x == axis && c.y == axis && c.z == -axis)    ? c2b('D', c.colours) : cornerColours[6];
            cornerColours[7] = (c.x == axis && c.y == axis && c.z == axis)    ? c2b('D', c.colours) : cornerColours[7];
            // 8, 9, 10, 11
            cornerColours[8] = (c.x == -axis&& c.y == axis  && c.z == axis)    ? c2b('F', c.colours) : cornerColours[8];
            cornerColours[9] = (c.x == -axis&& c.y == -axis && c.z == axis)    ? c2b('F', c.colours) : cornerColours[9];
            cornerColours[10] = (c.x == axis && c.y == -axis && c.z == axis)    ? c2b('F', c.colours) : cornerColours[10];
            cornerColours[11] = (c.x == axis && c.y == axis  && c.z == axis)    ? c2b('F', c.colours) : cornerColours[11];
            // 12, 13, 14, 15 - B is from F perspective
            cornerColours[12] = (c.x == -axis&& c.y == axis  && c.z == -axis)    ? c2b('B', c.colours) : cornerColours[12];
            cornerColours[13] = (c.x == -axis&& c.y == -axis && c.z == -axis)    ? c2b('B', c.colours) : cornerColours[13];
            cornerColours[14] = (c.x == axis && c.y == -axis && c.z == -axis)    ? c2b('B', c.colours) : cornerColours[14];
            cornerColours[15] = (c.x == axis && c.y == axis  && c.z == -axis)    ? c2b('B', c.colours) : cornerColours[15];
            // 16, 17, 18, 19
            cornerColours[16] = (c.x == axis && c.y == axis && c.z == axis )    ? c2b('R', c.colours) : cornerColours[16];
            cornerColours[17] = (c.x == axis && c.y == -axis&& c.z == axis)    ? c2b('R', c.colours) : cornerColours[17];
            cornerColours[18] = (c.x == axis && c.y == -axis&& c.z == -axis)    ? c2b('R', c.colours) : cornerColours[18];
            cornerColours[19] = (c.x == axis && c.y == axis && c.z == -axis)    ? c2b('R', c.colours) : cornerColours[19];
            // 20, 21, 22, 23
            cornerColours[20] = (c.x == -axis && c.y == axis && c.z == axis )    ? c2b('L', c.colours) : cornerColours[20];
            cornerColours[21] = (c.x == -axis && c.y == -axis&& c.z == axis)    ? c2b('L', c.colours) : cornerColours[21];
            cornerColours[22] = (c.x == -axis && c.y == -axis&& c.z == -axis)    ? c2b('L', c.colours) : cornerColours[22];
            cornerColours[23] = (c.x == -axis && c.y == axis && c.z == -axis)    ? c2b('L', c.colours) : cornerColours[23];
        }
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
            // Top layer stored in clockwise fashion
            if(positionMatch(c.getPosition(),      0, -axis, axis))    edges[0] = c;  // Yellow, Green
            if(positionMatch(c.getPosition(),  -axis, -axis, 0))       edges[1] = c;  // Yellow, Red
            if(positionMatch(c.getPosition(),      0, -axis, -axis))   edges[2] = c;  // Yellow, Blue
            if(positionMatch(c.getPosition(),   axis, -axis, 0))       edges[3] = c;  // Yellow, Orange
            // Middle Layer edges stored anticlockwise
            if(positionMatch(c.getPosition(),  -axis, 0, -axis))       edges[4] = c;  // Blue, Red
            if(positionMatch(c.getPosition(),  -axis, 0, axis))        edges[5] = c;  // Green, Red
            if(positionMatch(c.getPosition(),   axis, 0, axis))        edges[6] = c;  // Green, Orange
            if(positionMatch(c.getPosition(),   axis, 0, -axis))       edges[7] = c;  // Blue Orange
            // Bottom (D) Layer stored anti clockwise
            if(positionMatch(c.getPosition(),      0, axis, -axis))    edges[8] = c; // White, Blue
            if(positionMatch(c.getPosition(),  -axis, axis, 0))        edges[9] = c; // White, Red
            if(positionMatch(c.getPosition(),      0, axis, axis))     edges[10] = c;  // White, Green
            if(positionMatch(c.getPosition(),   axis, axis, 0))        edges[11] = c;  // White, Orange
        }
        }
    // Intialise permutation of edges and corners of cube.
    void ipce()  {

        int index = 0;
        // Corner permutations
        for(int i = 0; i < corners.length; i++)    {
            Cubie c = corners[i];
            if(contains(c.colours, yellow) && contains(c.colours, red) && contains(c.colours, green))          corners_p[index] = 1;
            if(contains(c.colours, yellow) && contains(c.colours, red) && contains(c.colours, blue))            corners_p[index] = 2;
            if(contains(c.colours, yellow) && contains(c.colours, orange) && contains(c.colours, blue))      corners_p[index] = 3;
            if(contains(c.colours, yellow) && contains(c.colours, orange) && contains(c.colours, green))  corners_p[index] = 4;
            if(contains(c.colours, white) && contains(c.colours, red) && contains(c.colours, blue))       corners_p[index] = 5;
            if(contains(c.colours, white) && contains(c.colours, red) && contains(c.colours, green))      corners_p[index] = 6;
            if(contains(c.colours, white) && contains(c.colours, orange) && contains(c.colours, green))   corners_p[index] = 7;
            if(contains(c.colours, white) && contains(c.colours, orange) && contains(c.colours, blue))    corners_p[index] = 8;
            index++;
        }

        index = 0;
        // Edge permutations
        for(Cubie c : edges)    {
            if(contains(c.colours, yellow) && contains(c.colours, green)) edges_p[index] = 1;
            if(contains(c.colours, yellow) && contains(c.colours, red)) edges_p[index] = 2;
            if(contains(c.colours, yellow) && contains(c.colours, blue)) edges_p[index] = 3;
            if(contains(c.colours, yellow) && contains(c.colours, orange)) edges_p[index] = 4;

            if(contains(c.colours, red) && contains(c.colours, blue)) edges_p[index] = 5;
            if(contains(c.colours, red) && contains(c.colours, green)) edges_p[index] = 6;
            if(contains(c.colours, orange) && contains(c.colours, green)) edges_p[index] = 7;
            if(contains(c.colours, orange) && contains(c.colours, blue)) edges_p[index] = 8;

            if(contains(c.colours, white) && contains(c.colours, blue)) edges_p[index] = 9;
            if(contains(c.colours, white) && contains(c.colours, red)) edges_p[index] = 10;
            if(contains(c.colours, white) && contains(c.colours, green)) edges_p[index] = 11;
            if(contains(c.colours, white) && contains(c.colours, orange)) edges_p[index] = 12;
            index++;
        }
        }
    // Initialise orientation of edges - http://cube.rider.biz/zz.php?p=eoline#eo_detection
    void ioe()  {
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
                if(contains(c.colours, white) || contains(c.colours, yellow))   {
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
    void ioc() {
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
    
    void visualiseCube()    {
        // char[] facelets = new char[dim*dim*6];
        // int ctr = 0;
        // // U, F, L, B, R, D
        // for(int i = 0; i < corners_p.length; i++)  {
        //     // Corner o and p arrays are same size and relate to eachother
        //     int corner_p = corners_p[i];
        //     int corner_o = corners_o[i];
            
        //     switch(corner_p)   {
        //         case 1: // Yellow, Red, Green
        //             facelets[ctr] = 'Y';
        //             if(corner_o == 1)
        //                 facelets[ctr] = 'R';
        //             else if (corner_o == 2)
        //                 facelets[ctr] = 'G';
        //             break;
        //         case 2: // Yellow, Red, Blue
        //             facelets[ctr] = 'Y';
        //             if(corner_o == 1)

        //             else if(corner_o == 2)

        //             break;
        //         case 3: // Yellow, Orange, Blue
        //             facelets[ctr] = 'Y';
        //             if(corner_o == 1)

        //             else if(corner_o == 2)

        //             break;
        //         case 4: // Yellow, Orange, Green
        //             facelets[ctr] = 'Y';
        //             if(corner_o == 1)

        //             else if(corner_o == 2)

        //             break;
        //         case 5: // White, Red, Blue

        //             break;
        //         case 6: // White, Red, Green

        //             break;
        //         case 7: // White, Orange, Green

        //             break;
        //         case 8: // White, Orange, Blue

        //             break;
        //     }
        //     ctr++;
        // }
    }
    /**
    * If colour array contains colour c
    * @param array  Array of colours
    * @param c      A colour
    * @return boolean   If colour c is in array, return true
    */
    /**
    * Prepare move to be applied to this cube object.
    * @param    move    move we're deconstructing to values
    */
    void move(String move) {
        int x = 0;
        byte b = 0;
        switch(move)    {
            case "U":
                // Region: Colours
                    // Edge colours
                    b = edgeColours[8];
                    edgeColours[8] = edgeColours[9];
                    edgeColours[9] = edgeColours[10];
                    edgeColours[10] = edgeColours[11];
                    edgeColours[11] = b;
                    // BU -> RU -> FU -> LU
                    // 20 -> 0  -> 16 -> 4
                    b = edgeColours[20];
                    edgeColours[20] = edgeColours[4];
                    edgeColours[4] = edgeColours[16];
                    edgeColours[16] = edgeColours[0];
                    edgeColours[0] = b;

                    // Corner colours
                    b = cornerColours[0];
                    cornerColours[0] = cornerColours[3];
                    cornerColours[3] = cornerColours[2];
                    cornerColours[2] = cornerColours[1];
                    cornerColours[1] = b;
                    // FUL, FUR, LUB, LUF, BUL, BUR, RUF, RUB
                    // FUL -> LUB -> BUR -> RUF
                    //  9      22     14     17
                    b = cornerColours[9];
                    cornerColours[9] = cornerColours[17];
                    cornerColours[17] = cornerColours[14];
                    cornerColours[14] = cornerColours[22];
                    cornerColours[22] = b;
                    // FUR -> LUF -> BUL -> RUB
                    //               13
                    b = cornerColours[10];
                    cornerColours[10] = cornerColours[18];
                    cornerColours[18] = cornerColours[13];
                    cornerColours[13] = cornerColours[21];
                    cornerColours[21] = b;
                // Region: Colours
                // permutation and orientation array
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
                // Region: Colours
                    b = edgeColours[12];
                    edgeColours[12] = edgeColours[13];
                    edgeColours[13] = edgeColours[14];
                    edgeColours[14] = edgeColours[15];
                    edgeColours[15] = b;

                    b = edgeColours[18];
                    edgeColours[18] = edgeColours[6];
                    edgeColours[6] = edgeColours[22];
                    edgeColours[22] = edgeColours[2];
                    edgeColours[2] = b;

                    // DFL -> DBL -> DBR -> DFR
                    //  4      5      6      7
                    b = cornerColours[4];
                    cornerColours[4] = cornerColours[7];
                    cornerColours[7] = cornerColours[6];
                    cornerColours[6] = cornerColours[5];
                    cornerColours[5] = b;
                    // This is correct order -> BDL is from F perspective
                    // FDL, FDR, LDB, LDF, BDR, BDL, RDF, RDB
                    //  8   11    23   20  15   12   16   19
                    b = cornerColours[8];
                    cornerColours[8] = cornerColours[23];
                    cornerColours[23] = cornerColours[15];
                    cornerColours[15] = cornerColours[16];
                    cornerColours[16] = b;

                    b = cornerColours[11];
                    cornerColours[11] = cornerColours[20];
                    cornerColours[20] = cornerColours[12];
                    cornerColours[12] = cornerColours[19];
                    cornerColours[19] = b;
                // End Region: Colours
                // Perms/Oris
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
                // Region: Colours
                    b = edgeColours[16];
                    edgeColours[16] = edgeColours[17];
                    edgeColours[17] = edgeColours[18];
                    edgeColours[18] = edgeColours[19];
                    edgeColours[19] = b;
                    b = edgeColours[10];
                    edgeColours[10] = edgeColours[1];
                    edgeColours[1] = edgeColours[12];
                    edgeColours[12] = edgeColours[5];
                    edgeColours[5] = b;

                    // FDL -> FUL -> FUR -> FDR
                    // 8      9      10     11
                    b = cornerColours[8];
                    cornerColours[8] = cornerColours[11];
                    cornerColours[11] = cornerColours[10];
                    cornerColours[10] = cornerColours[9];
                    cornerColours[9] = b;
                    // UFL, UFR, RUF, RDF, DFR, DFL, LDF, LUF
                    //  0    3    17   16   7    4    20   21
                    b = cornerColours[0];
                    cornerColours[0] = cornerColours[20];
                    cornerColours[20] = cornerColours[7];
                    cornerColours[7] = cornerColours[17];
                    cornerColours[17] = b;

                    b = cornerColours[3];
                    cornerColours[3] = cornerColours[21];
                    cornerColours[21] = cornerColours[4];
                    cornerColours[4] = cornerColours[16];
                    cornerColours[16] = b;
                // End Region: Colours
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
                // Region: Colours
                    b = edgeColours[20];
                    edgeColours[20] = edgeColours[21];
                    edgeColours[21] = edgeColours[22];
                    edgeColours[22] = edgeColours[23];
                    edgeColours[23] = b;
                    b = edgeColours[8];
                    edgeColours[8] = edgeColours[3];
                    edgeColours[3] = edgeColours[14];
                    edgeColours[14] = edgeColours[7];
                    edgeColours[7] = b;

                    // BDL -> BUL -> BUR -> BDR
                    //  12     13    14      15
                    b = cornerColours[12];
                    cornerColours[12] = cornerColours[15];
                    cornerColours[15] = cornerColours[14];
                    cornerColours[14] = cornerColours[13];
                    cornerColours[13] = b;
                    // UBR, UBL, LUB, LDB, DBL, DBR, RDB, RUB
                    //  2    1    22   23   5    6    19   18
                    b = cornerColours[2];
                    cornerColours[2] = cornerColours[19];
                    cornerColours[19] = cornerColours[5];
                    cornerColours[5] = cornerColours[22];
                    cornerColours[22] = b;

                    b = cornerColours[1];
                    cornerColours[1] = cornerColours[18];
                    cornerColours[18] = cornerColours[6];
                    cornerColours[6] = cornerColours[23];
                    cornerColours[23] = b;
                // End Region: Colours
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
                // Region: Colours
                    b = edgeColours[0];
                    edgeColours[0] = edgeColours[1];
                    edgeColours[1] = edgeColours[2];
                    edgeColours[2] = edgeColours[3];
                    edgeColours[3] = b;
                    b = edgeColours[9];
                    edgeColours[9] = edgeColours[23];
                    edgeColours[23] = edgeColours[15];
                    edgeColours[15] = edgeColours[19];
                    edgeColours[19] = b;
                    // RDF -> RUF -> RUB -> RDB
                    //  16    17      18     19
                    b = cornerColours[16];
                    cornerColours[16] = cornerColours[19];
                    cornerColours[19] = cornerColours[18];
                    cornerColours[18] = cornerColours[17];
                    cornerColours[17] = b;
                    // UFR, UBR, BUR, BDR, DBR, DFR, FDR, FUR
                    //  3    2    14   15   6    7    11   10
                    b = cornerColours[3];
                    cornerColours[3] = cornerColours[11];
                    cornerColours[11] = cornerColours[6];
                    cornerColours[6] = cornerColours[14];
                    cornerColours[14] = b;

                    b = cornerColours[2];
                    cornerColours[2] = cornerColours[10];
                    cornerColours[10] = cornerColours[7];
                    cornerColours[7] = cornerColours[15];
                    cornerColours[15] = b;
                // End Region: Colours
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
                // Region: Colours
                    // LU -> LF -> LD -> LB
                    // 4     5      6     7
                    b = edgeColours[4];
                    edgeColours[4] = edgeColours[7];
                    edgeColours[7] = edgeColours[6];
                    edgeColours[6] = edgeColours[5];
                    edgeColours[5] = b;
                    b = edgeColours[11];
                    edgeColours[11] = edgeColours[21];
                    edgeColours[21] = edgeColours[13];
                    edgeColours[13] = edgeColours[17];
                    edgeColours[17] = b;
                    // LDF -> LUF -> LUB -> LDB
                    // 20      21     22     23
                    b = cornerColours[20];
                    cornerColours[20] = cornerColours[21];
                    cornerColours[21] = cornerColours[22];
                    cornerColours[22] = cornerColours[23];
                    cornerColours[23] = b;
                    // UFL, UBL, FDL, FUL, DBL, DFL, BUL, BDL
                    //  0    1    8    9    5    4   13   12
                    b = cornerColours[0];
                    cornerColours[0] = cornerColours[13];
                    cornerColours[13] = cornerColours[5];
                    cornerColours[5] = cornerColours[8];
                    cornerColours[8] = b;
                    // 
                    b = cornerColours[1];
                    cornerColours[1] = cornerColours[12];
                    cornerColours[12] = cornerColours[4];
                    cornerColours[4] = cornerColours[9];
                    cornerColours[9] = b;
                // End Region: Colours
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
    * Tests a specified algorithm on this FastCube object. Computationally cheaper to test on this than Cube object.
    * 
    * @param    algorithm   The algorithm we're testing on this object
    * @return   this        The FastCube in its new state after applying the algorithm
    */
    Cube2 applyAlgorithm(String algorithm)   {
        // Goes through each char of the algorithm string
        for (int i = 0; i < algorithm.length(); i++) {
            if(algorithm.charAt(i) + "" == " ")  continue;
			String move = algorithm.charAt(i) + "";
			// If there are chars left in algorithm string and the next char is a prime: ' or a 2
			if(i+1 < algorithm.length())	{
                // Call move function 2 times on top of default call to move to perform anticlockwise move
				if (algorithm.charAt(i+1) == '\'' || algorithm.charAt(i+1) == '’') {
                        move(move);
                        move(move);
                        i++;
					}	else if(algorithm.charAt(i+1) == '2')	{
                        move(move);
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
        // this.state();
        return true;
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

    void imageState() {
        byte[] ec = edgeColours;
        byte[] cc = cornerColours;

        // UP
        println("\n\t\t" + b2c(cc[1]) + " " + b2c(ec[8]) + " " + b2c(cc[2]));
        println("\t\t" + b2c(ec[11]) + " " +  b2c((byte)2) + " " + b2c(ec[9]));
        println("\t\t" + b2c(cc[0]) + " " + b2c(ec[10]) + " " + b2c(cc[3]) + "\n");
        // L, F, R, B
        // FIRST ROW
        print("\t" + b2c(cc[22]) + " " + b2c(ec[4]) + " " + b2c(cc[21]) + "\t"
        +            b2c(cc[9]) + " " + b2c(ec[16]) + " " + b2c(cc[10]) + "\t"
        +            b2c(cc[17]) + " " + b2c(ec[0]) + " " + b2c(cc[18]) + "\t"
        +            b2c(cc[14]) + " " + b2c(ec[20]) + " " + b2c(cc[13]) + "\n" );
        // Second ROW
        print("\t"  + b2c(ec[7]) + " " + b2c(byte(1)) + " " + b2c(ec[5]) + "\t"
                    + b2c(ec[17]) + " " + b2c(byte(4)) + " " + b2c(ec[19]) + "\t"
                    + b2c(ec[1]) + " " + b2c(byte(0)) + " " + b2c(ec[3]) + "\t"
                    + b2c(ec[23]) + " " + b2c(byte(5)) + " " + b2c(ec[21]) + "\n");
        // Third ROW
        print("\t" + b2c(cc[23]) + " " + b2c(ec[6]) + " " + b2c(cc[20]) + "\t"
        +            b2c(cc[8]) + " " + b2c(ec[18]) + " " + b2c(cc[11]) + "\t"
        +            b2c(cc[16]) + " " + b2c(ec[2]) + " " + b2c(cc[19]) + "\t"
        +            b2c(cc[15]) + " " + b2c(ec[22]) + " " + b2c(cc[12]) + "\n" );

        println("\n\t\t" + b2c(cc[4]) + " " + b2c(ec[12]) + " " + b2c(cc[7]));
        println("\t\t" + b2c(ec[13]) + " " +  b2c((byte)3) + " " + b2c(ec[15]));
        println("\t\t" + b2c(cc[5]) + " " + b2c(ec[14]) + " " + b2c(cc[6]) +        "\n");
    }
    
    String b2c(byte s)    {
        switch(s){
            case 0:
                return "O";
                // return "\u001b[31m" + "O";
            case 1:
                return "R";
                // return "\u001b[31;1m" + "R";
            case 2:
                return "Y";
                // return "\u001b[33m" + "Y";
            case 3:
                return "W";
                // return "\u001b[37m" + "W";
            case 4:
                return "G";
                // return "\u001b[32m" + "G";
            case 5:
                return "B";
                // return "\u001b[34m" + "B";
        }
        return "i";
    }

    byte c2b(char face, color[] colours)   {
        byte col = 0;
        switch(face)    {
                    case 'R':
                        if(colours[0] == red)       col = 1;
                        if(colours[0] == yellow)    col = 2;
                        if(colours[0] == white)     col = 3;
                        if(colours[0] == green)     col = 4;
                        if(colours[0] == blue)      col = 5;
                        return col;
                    case 'L':
                        if(colours[1] == red)       col = 1;
                        if(colours[1] == yellow)    col = 2;
                        if(colours[1] == white)     col = 3;
                        if(colours[1] == green)     col = 4;
                        if(colours[1] == blue)      col = 5;
                        return col;
                    case 'U':
                        if(colours[2] == red)       col = 1;
                        if(colours[2] == yellow)    col = 2;
                        if(colours[2] == white)     col = 3;
                        if(colours[2] == green)     col = 4;
                        if(colours[2] == blue)      col = 5;
                        return col;
                    case 'D':
                        if(colours[3] == red)       col = 1;
                        if(colours[3] == yellow)    col = 2;
                        if(colours[3] == white)     col = 3;
                        if(colours[3] == green)     col = 4;
                        if(colours[3] == blue)      col = 5;
                        return col;
                    case 'F':
                        if(colours[4] == red)       col = 1;
                        if(colours[4] == yellow)    col = 2;
                        if(colours[4] == white)     col = 3;
                        if(colours[4] == green)     col = 4;
                        if(colours[4] == blue)      col = 5;
                        return col;
                    case 'B':
                        if(colours[5] == red)       col = 1;
                        if(colours[5] == yellow)    col = 2;
                        if(colours[5] == white)     col = 3;
                        if(colours[5] == green)     col = 4;
                        if(colours[5] == blue)      col = 5;
                        return col;
        }
        return -1;
    }

    // Resets this cube object to a solved state.
    void reset()    {
        Cube cube = new Cube();
        corners_o = new int[8];
        corners_p = new int[8];
        corners = new Cubie[8];
        cornerColours = new byte[24];
        edges_o = new int[(dim-2)*12];
        edges_p = new int[(dim-2)*12];
        edges = new Cubie[(dim-2)*12];
        edgeColours = new byte[((dim-2)*12)*2];
        ic(cube);
        getEdgeColours();
        getCornerColours();
        ipce();
        ioe();
        ioc();
    }


    //encode state to index
    //decode index to state

    // Creates binary value representing tetrad
    int encode_tetrad()   {
        // 8 corners - 1, 3, 5, 7 and 2, 4, 6, 8
        String binaryRepresentation = "";
        for(int i = 0; i < corners_p.length; i++)    {
            if(i == 1 || i == 3 || i == 5 || i == 7)  {
                binaryRepresentation += "1";
            } else {
                binaryRepresentation += "0";
            }
        }
        // println(binaryRepresentation);
        return Integer.parseInt(binaryRepresentation, 2);
    }

    void decode_tetrad(int t)  {
        String binary = Integer.toBinaryString(t);
        String zeroes = "";
        for(int i = 0; i <= 8-binary.length()-1; i++)
            zeroes  += "0";
        
        binary = zeroes + binary;
        // Tetrad 1, 3, 5, 7
        // Tetrad 2, 4, 6, 8
        // Repeating corners - no checks
        for(int i = 0; i < binary.length(); i++)    {
        // for(int i = binary.length()-1; i >= 0; i--) {
            if(binary.charAt(i) == '0') {
                corners_p[i] = 1;
            } else {
                corners_p[i] = 2;
            }
        }
    }


    // Returns lexicographical index
    int encode_eslice()  {
        String binaryRepresentation = "";
        for(int i : edges_p)    {
            // println(i);
            // If edge has e slice permutation value
            // (If the edge belongs in e slice)
            if(i == 5 || i == 6 || i == 7 || i == 8)  {
                binaryRepresentation += "1";
            } else {
                binaryRepresentation += "0";
            }
        }
        // println(binaryRepresentation);
        // Return binary as base 2 number
        return Integer.parseInt(binaryRepresentation, 2);
    }

    // Converts int to binary
    // Replaces index positions of edges_p corresponding to index positions of 1s in the binary to a random e slice edge value.
    void decode_eslice(int t)   {
        String binary = Integer.toBinaryString(t);
        String zeroes = "";
        for(int i = 0; i <= 12-binary.length()-1; i++)
            zeroes  += "0";
        
        binary = zeroes + binary;

        int edge = 5;
        for(int i = binary.length()-1; i >= 0; i--) {
            if(binary.charAt(i) == '0') {
                try {
                    edges_p[i] = 0;
                } catch (Exception e)   {
                    println("error: " + binary);
                    println(binary.length());
                    println(e);
                }
                continue;
            }
            edges_p[i] = edge;
            edge++;
        }
    }


    // Label m slice as 0, s slice will be 1 - 
    // index 4,5,6,7 of binary are set e slice so will be ignored.
    int encode_ms_slice()  {
        String binaryRepresentation = "";
        for(int i = 0; i < edges_p.length; i++)    {
            if(i == 4 || i == 5 || i ==6 || i == 7) continue;
            //  S Slice
            if(edges_p[i] == 1 || edges_p[i] == 3 || edges_p[i] == 9 || edges_p[i] == 11)  {
                binaryRepresentation += "0";
            } else {
                binaryRepresentation += "1";
            }
        }
        // println();
        // println(binaryRepresentation);
        // Return binary as base 2 number
        // println(binaryRepresentation);
        return Integer.parseInt(binaryRepresentation, 2);
    }

    void decode_ms_slice(int index) {
        String binary = Integer.toBinaryString(index);
        String zeroes = "";
        for(int i = 0; i <= 8-binary.length()-1; i++)
            zeroes  += "0";
        binary = zeroes + binary;
        // println(index, binary);
        int m = 1; // 1, 3, 9, 11
        int s = 2; // 2, 4, 10, 12
        // No checks for invalid states so can just duplicate permutation values for the sake of generating a table
        // println(binary);
        int counter = 0;
        for(int i = 0; i < binary.length(); i++)    {
            // println(counter);
            if(binary.charAt(i) == '0') {
                edges_p[counter] = m;
            } else {
                edges_p[counter] = s;
            }
            // If counter is 3, add 4, else add 1
            counter += counter == 3 ? 5 : 1;
        }
        // println(counter);
        // for(int i : edges_p)    {
        //     print(i, ", ");
        // }
        // println();
    }

    void encode_eslice_perms()  {
        // Index from 0 to 23
        // For e-slice edges 1, 3, 9, 11
        String es_combo = edges_p[0] + "" + edges_p[2] + "" + edges_p[8] + "" + edges_p[10] + "";
        
        //println(es_combo);
    }

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

    // Return lexicographical index of edge orientations
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
