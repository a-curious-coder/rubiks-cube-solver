import java.lang.Long;
import java.util.Arrays;
import java.util.Collections;

// We can represent each colour from each face as a number.
enum colour{
    O,  // 0
    R,  // 1
    Y,  // 2
    W,  // 3
    G,  // 4
    B   // 5
};

/**
* This class is a computationally cheaper way of representing a Rubik's Cube
* I've created this to speed up testing a bunch of algorithms on copies of a scrambled cube
* This means I am able to solve the cube quicker.
* Only caters for 3x3x3 cube
*
* TODO: Cater this class for various cube sizes...(Ambitious at this stage)
*/
class FastCube  {
    
    Integer[][] corners = new Integer[8][3];
    Integer[][] edges = new Integer[12][2];
    boolean debug = false;
    // These 64 bit integers will hold 8 faces in binary
    Integer[] orange =  new Integer[8];
    Integer[] red =     new Integer[8];
    Integer[] yellow =  new Integer[8];
    Integer[] white =   new Integer[8];
    Integer[] green =   new Integer[8];
    Integer[] blue =    new Integer[8];
    
    FastCube()  {
        // Populate each face with 8 appropriate colours
        Integer[] orange =  {0, 0, 0, 0, 0, 0, 0, 0};
        Integer[] red =     {1, 1, 1, 1, 1, 1, 1, 1};
        Integer[] yellow =  {2, 2, 2, 2, 2, 2, 2, 2};
        Integer[] white =   {3, 3, 3, 3, 3, 3, 3, 3};
        Integer[] green =   {4, 4, 4, 4, 4, 4, 4, 4};
        Integer[] blue =    {5, 5, 5, 5, 5, 5, 5, 5};
        this.orange = orange;
        this.red = red;
        this.yellow = yellow;
        this.white = white;
        this.green = green;
        this.blue = blue;
    }

    /**
    * Clone constructor
    *
    * @param    c   The cube we're copying to this Fastcube object
    */
    FastCube(Cube c)    {
        this.orange =   getFace("orange",  c);
        this.red =      getFace("red",  c);
        this.yellow =   getFace("yellow",  c);
        this.white =    getFace("white",  c);
        this.green =    getFace("green",  c);
        this.blue =     getFace("blue",  c);
        // printCube();
    }

    /**
    * Clone constructor
    *
    * @param    f   The fastcube object we're cloning
    */
    FastCube(FastCube f)    {
        this.orange = f.orange;
        this.red = f.red;
        this.green = f.green;
        this.blue = f.blue;
        this.yellow = f.yellow;
        this.white = f.white;
    }

    /**
    * Prints the cube in console - Mainly used for debugging purposes as there's a 2D representation on GUI
    */
    void printCube()    {
        println();
        println(printFace(yellow, 0, true));
        println(printFirstRow(red, 1) + printFirstRow(green, 2) + printFirstRow(orange, 3) + printFirstRow(blue, 4));
        println(printSecondRow(red, 1) + printSecondRow(green, 2) + printSecondRow(orange, 3) + printSecondRow(blue, 4));
        println(printThirdRow(red, 1) + printThirdRow(green, 2) + printThirdRow(orange, 3) + printThirdRow(blue, 4));
        println(printFace(white, 1, true));
        // println(printFirstRow(orange, 1));
        // println(printSecondRow(orange, 1));
        // println(printThirdRow(orange, 1));
    }
    
    /**
    * Prints the first row of a cube's face.
    *
    * @param    f           The face of the cube represented by a long
    * @param    whichFace   The face we're writing to a string
    * @return   s           The top row of colours we're storing and returning for printing to console.
    */
    String printFirstRow(Integer[] f, int whichFace) {
        // 1 - Red, 2 - Green, 3 - Orange, 4 - Blue
        String s = "";
        if(this.debug)  {
            switch(whichFace)   {
                case 1: // If red
                    s += (2 + " " + 3 + " " + 4 + "\t");
                    break;
                case 2: // if green
                    s += (2 + " " + 3 + " " + 4 + "\t");
                    break;
                case 3: // if orange
                    s += (4 + " " + 3 + " " + 2 + "\t");
                    break;
                case 4: // if blue
                    s += (4 + " " + 3 + " " + 2 + "\t");
                    break;
            }
            return s;
        }
        switch(whichFace)   {
            case 1: // If red
                s += (colour.values()[f[2]] + " " + colour.values()[f[3]] + " " + colour.values()[f[4]]+ "\t");
                break;
            case 2: // if green
                s += (colour.values()[f[2]] + " " + colour.values()[f[3]] + " " + colour.values()[f[4]]+ "\t");
                break;
            case 3: // if orange
                s += (colour.values()[f[4]] + " " + colour.values()[f[3]] + " " + colour.values()[f[2]]+ "\t");
                break;
            case 4: // if blue
                s += (colour.values()[f[4]] + " " + colour.values()[f[3]] + " " + colour.values()[f[2]]+ "\t");
                break;
        }

        return s;
    };

    /**
    * Prints the second row of a cube's face.
    *
    * @param    f           The face of the cube represented by a long
    * @param    whichFace   The face we're writing to a string
    * @return   s           The top row of colours we're storing and returning for printing to console.
    */
    String printSecondRow(Integer[] f, int whichFace) {
        // 1 - Red, 2 - Green, 3 - Orange, 4 - Blue
        String c = "B";
        String s = "";
        switch(whichFace)   {
            case 1:
                c = "R";
                break;
            case 2:
                c = "G";
                break;
            case 3:
                c = "O";
                break;
        }
        if(this.debug)  {
            switch(whichFace)   {
                case 1:
                    s += (1 + " " + c + " " + 5 + "\t");
                    break;
                case 2:
                    s += (1 + " " + c + " " + 5 + "\t");
                    break;
                case 3:
                    s += (5 + " " + c + " " + 1 + "\t");
                    break;
                case 4:
                    s += (5 + " " + c + " " + 1 + "\t");
                    break;
            }
            return s;
        }
        switch(whichFace)   {
            case 1:
                s += (colour.values()[f[1]] + " " + c + " " + colour.values()[f[5]] + "\t");
            break;
            case 2:
                s += (colour.values()[f[1]] + " " + c + " " + colour.values()[f[5]] + "\t");
            break;
            case 3:
                s += (colour.values()[f[5]] + " " + c + " " + colour.values()[f[1]] + "\t");
            break;
            case 4:
                s += (colour.values()[f[5]] + " " + c + " " + colour.values()[f[1]] + "\t");
            break;
        }

        return s;
    };

    /**
    * Prints the third row of a cube's face.
    *
    * @param    f           The face of the cube represented by a long
    * @param    whichFace   The face we're writing to a string
    * @return   s           The top row of colours we're storing and returning for printing to console.
    */
    String printThirdRow(Integer[] f, int whichFace) {
        // 1 - Red, 2 - Green, 3 - Orange, 4 - Blue
        String s = "";
        if(this.debug)  {
            switch(whichFace)   {
                case 1:
                    s += (0 + " " + 7 + " " + 6 + "\t");
                    break;
                case 2:
                    s += (0 + " " + 7 + " " + 6 + "\t");
                    break;
                case 3:
                    s += (6 + " " + 7 + " " + 0 + "\t");
                    break;
                case 4:
                    s += (6 + " " + 7 + " " + 0 + "\t");
                    break;
            }
            return s;
        }
        switch(whichFace)   {
            case 1:
                s += (colour.values()[f[0]] + " " + colour.values()[f[7]] + " " + colour.values()[f[6]] + " \t");
                break;
            case 2:
                s += (colour.values()[f[0]] + " " + colour.values()[f[7]] + " " + colour.values()[f[6]] + " \t");
                break;
            case 3:
                s += (colour.values()[f[6]] + " " + colour.values()[f[7]] + " " + colour.values()[f[0]] + " \t");
                break;
            case 4:
                s += (colour.values()[f[6]] + " " + colour.values()[f[7]] + " " + colour.values()[f[0]] + " \t");
                break;
        }
        return s;
    };

    /**
    * Prints the entire cube
    *
    * @param    f           The face of the cube represented by a long
    * @param    y           If the cube is the top or bottom face (Needs extra spacing)
    * @return   s           The top row of colours we're storing and returning for printing to console.
    */
    String printFace(Integer[] f, int whichFace, boolean y)   {
        // 0 - Yellow   1 - White
        String s = "";
        String c = whichFace == 0 ? "Y" : "W";
        String face = "";
        String spacer = y ? "\t" : "";
        for(int i : f) { face += i; }

        if(this.debug)  {
            s += "\n";
            if(whichFace == 1)  { // White
                s += (spacer + 0 + " " +    7   +  " "  + 6 + "\n");
                s += (spacer + 1 + " " +    c   +  " "  + 5 + "\n");
                s += (spacer + 2 + " " +    3   +  " "  + 4);
            } else {             // Yellow
                s += (spacer + 2 + " " +    3   +  " "  + 4 + "\n");
                s += (spacer + 1 + " " +    c   +  " "  + 5 + "\n");
                s += (spacer + 0 + " " +    7   +  " "  + 6 + "\n");
            } 
            return s;
        }
        s += "\n";
        if(whichFace == 1)  { // White
            s += (spacer + colour.values()[f[0]] + " " + colour.values()[f[7]] + " " + colour.values()[f[6]] + "\n");
            s += (spacer + colour.values()[f[1]] + " " +                        c   +  " "  + colour.values()[f[5]]+ "\n");
            s += (spacer + colour.values()[f[2]] + " " + colour.values()[f[3]] + " " + colour.values()[f[4]]);
        } else {             // Yellow
            s += (spacer + colour.values()[f[2]] + " " + colour.values()[f[3]] + " " + colour.values()[f[4]] + "\n");
            s += (spacer + colour.values()[f[1]] + " " +                        c   +  " "  + colour.values()[f[5]]+ "\n");
            s += (spacer + colour.values()[f[0]] + " " + colour.values()[f[7]] + " " + colour.values()[f[6]] + "\n");
        }
        return s;
    }

    
    /**
    * Gets the face from the cube ready for the fastcube
    *
    * @param    f       The face we're getting (The colour in string format)
    * @param    c       The cube object we're retrieving the face from
    * @return   nums    The n umber representations of each colour of the specified face
    */
    Integer[] getFace(String f, Cube c)  {
        // long thisFace = 0;
        Integer[] nums = new Integer[8];
        String face = c.getFace(f);
        for(int i = 0; i < face.length(); i++)  {
            String a = face.charAt(i) + "";
            nums[i] = colour.valueOf(a).ordinal();
        }
        // println(f + "\t" + Arrays.toString(nums));
        return nums;
    }

    //******************************************
    /**
    * Tests a specified algorithm on this FastCube object. Computationally cheaper to test on this than Cube object.
    * 
    * @param    algorithm   The algorithm we're testing on this object
    * @return   this        The FastCube in its new state after applying the algorithm
    */
    FastCube testAlgorithm(String algorithm)   {
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
    /**
    * Applies the specified move to FastCube object
    *
    * @param    move    The move being applied to the
    */
    void move(String move)    {
        Integer temp;
        int dir = 1;
        if(move.length() > 1) {
            if(move.charAt(1) == '2')   {
                dir = 2;
            } else if (move.charAt(1) == '\'')  {
                dir = -1;
            }
        }
        move = move.charAt(0) +"";
        switch(move)    {
            case "R": // Orange  Affects: White, Yellow, Blue, Green
                if(dir == -1)   {
                    Collections.rotate(Arrays.asList(this.orange), 2);
                    for(int i = 4; i < 7; i++) {
                        temp = this.yellow[i];
                        this.yellow[i] = this.blue[10-i];
                        this.blue[10-i] = this.white[10-i];
                        this.white[10-i] = this.green[i];
                        this.green[i] = temp;
                    }
                } else {
                    // Rotation requires 2 int to move.
				    // println("Before\t" + Arrays.toString(this.orange));
				    Collections.rotate(Arrays.asList(this.orange), 6);
				    // println("After\t" + Arrays.toString(this.orange));
                    // Swap all rows from faces next to orange.
                    for(int i = 4; i < 7; i++) {
                        temp = this.yellow[i];
                        this.yellow[i] = this.green[i];
                        this.green[i] = this.white[10-i];
                        this.white[10-i] = this.blue[10-i];
                        this.blue[10-i] = temp;
                    }
				}
				break;
            case "L": // Red    Affects: White, Yellow, Blue, Green
                if( dir == -1)  {
                    Collections.rotate(Arrays.asList(this.red), 6);
                    for(int i = 0; i < 3; i++) {
                        temp = this.yellow[2-i];
                        this.yellow[2-i] = this.green[2-i];
                        this.green[2-i] = this.white[i];
                        this.white[i] = this.blue[i];
                        this.blue[i] = temp;
                    } 
                } else  {
                    Collections.rotate(Arrays.asList(this.red), 2);
                    for(int i = 0; i < 3; i++) {
                        temp = this.green[i];
                        this.green[i] = this.yellow[i];
                        this.yellow[i] = this.blue[2-i];
                        this.blue[2-i] = this.white[2-i];
                        this.white[2-i] = temp;
                    }
                }
                break;
            case "U": // Yellow Affects: Red, Green, Blue, Orange
                if(dir == -1)   {
                    Collections.rotate(Arrays.asList(this.yellow), 6);
                    for(int i = 4; i > 1; i--)  {
                        temp = this.green[i];
                        this.green[i] = this.red[i];
                        this.red[i] = this.blue[6-i];
                        this.blue[6-i] = this.orange[6-i];
                        this.orange[6-i] = temp;
                        // println("Orange\tBlue\tRed\tGreen\n" + i + "\t" + i + "\t" + (6-i) + "\t" + greens[(4-i)]);
                    }
                }   else    {
                    Collections.rotate(Arrays.asList(this.yellow), 2);
                    int[] greens = {0, 3, 4};
                    for(int i = 4; i > 1; i--)  {
                        temp = this.orange[i];
                        this.orange[i] = this.blue[i];
                        this.blue[i] = this.red[6-i];
                        this.red[6-i] = this.green[greens[4-i]];
                        this.green[greens[4-i]] = temp;
                        // println("Orange\tBlue\tRed\tGreen\n" + i + "\t" + i + "\t" + (6-i) + "\t" + greens[(4-i)]);
                    }
                }
                break;
            case "D": // White  Affects: Red, Green, Blue, Orange
                if(dir == -1)   {
                    Collections.rotate(Arrays.asList(this.white), 2);
                    int[] oranges = {6, 7, 0};
                    int[] blues = {6, 7, 0};
                    int[] reds = {0, 7, 6};
                    int[] greens = {2, 7, 6};
                    for(int i = 0; i < 3; i++)  {
                        temp = this.blue[blues[i]];
                        this.blue[blues[i]] = this.red[reds[i]];
                        this.red[reds[i]] = this.green[greens[i]];
                        this.green[greens[i]] = this.orange[oranges[i]];
                        this.orange[oranges[i]] = temp;
                        // println("Orange\tBlue\tRed\tGreen\n" + oranges[i] + "\t" + blues[i] + "\t" + reds[i] + "\t" + greens[i]);
                    }
                }   else    {
                    Collections.rotate(Arrays.asList(this.white), 6);
                    int[] oranges = {6, 7, 0};
                    int[] blues = {6, 7, 0};
                    int[] reds = {0, 7, 6};
                    int[] greens = {2, 7, 6};
                    for(int i = 0; i < 3; i++)  {
                        temp = this.orange[oranges[i]];
                        this.orange[oranges[i]] = this.green[greens[i]];
                        this.green[greens[i]] = this.red[reds[i]];
                        this.red[reds[i]] = this.blue[blues[i]];
                        this.blue[blues[i]] = temp;
                        // println("Orange\tBlue\tRed\tGreen\n" + oranges[i] + "\t" + blues[i] + "\t" + reds[i] + "\t" + greens[i]);
                    }
                }
                
                // println("Orange\tBlue\tRed\tGreen\n" + 6 + "\t" + 6 + "\t" + 0 + "\t" + 2);
                // println("Orange\tBlue\tRed\tGreen\n" + 7 + "\t" + 7 + "\t" + 7 + "\t" + 7);
                // println("Orange\tBlue\tRed\tGreen\n" + 0 + "\t" + 0 + "\t" + 6 + "\t" + 6);

                break;
            case "F": // Green  Affects: Red, Yellow, Orange, White
                if(dir == -1)   {
                    Collections.rotate(Arrays.asList(this.green), 6);
                    // Collections.rotate(Arrays.asList(nGreen), 6);
                    // println(Arrays.toString(nGreen));
                    int[] yellows = {0,7,6};
                    int[] oranges = {4,5,6};
                    int[] whites = {6,7,0};
                    int[] reds = {6,5,4};
                    for(int i = 0; i < 3; i++)  {
                        temp = this.yellow[yellows[i]];
                        this.yellow[yellows[i]] = this.orange[oranges[i]];
                        this.orange[oranges[i]] = this.white[whites[i]];
                        this.white[whites[i]] = this.red[reds[i]];
                        this.red[reds[i]] = temp;
                    }
                } else {
                    Collections.rotate(Arrays.asList(this.green), 2);
                    int[] yellows = {0,7,6};
                    int[] oranges = {4,5,6};
                    int[] whites = {6,7,0};
                    int[] reds = {6,5,4};
                    for(int i = 0; i < 3; i++)  {
                        temp = this.red[reds[i]];
                        this.red[reds[i]] = this.white[whites[i]];
                        this.white[whites[i]] = this.orange[oranges[i]];
                        this.orange[oranges[i]] = this.yellow[yellows[i]];
                        this.yellow[yellows[i]] = temp;
                    }
                }
                break;
            case "B": // Blue   Affects: Red, Yellow, Orange, White
                if(dir == 1)   {
                    Collections.rotate(Arrays.asList(this.blue), 6);
                    for(int i = 4; i > 1; i--)  {
                        temp = this.white[6-i];
                        this.white[6-i] = this.red[floor(i-2)];
                        this.red[floor(i-2)] = this.yellow[i];
                        this.yellow[i] = this.orange[4-i];
                        this.orange[4-i] = temp;
                        // println("Orange\tYellow\tRed\tWhite\n" + (4-i) + "\t" + i + "\t" + round(i-2) + "\t" + (6-i));
                    }
                } else {
                    Collections.rotate(Arrays.asList(this.blue), 2);
                    for(int i = 4; i > 1; i--)  {
                        temp = this.orange[4-i];
                        this.orange[4-i] = this.yellow[i];
                        this.yellow[i] = this.red[floor(i-2)];
                        this.red[floor(i-2)] = this.white[6-i];
                        this.white[6-i] = temp;
                        // println("Orange\tYellow\tRed\tWhite\n" + (4-i) + "\t" + i + "\t" + round(i-2) + "\t" + (6-i));
                    }
                }
                // R, Y, O, W
                break;
        }
    }

    void initCubies()    {
        Integer[][] newCorners = {{this.green[0], this.red[6], this.white[0]}, 
                        {this.green[2], this.red[4], this.yellow[0]},
                        {this.green[4], this.yellow[6], this.orange[4]}, 
                        {this.green[6], this.orange[6], this.white[6]},
                        {this.blue[0], this.red[0], this.white[2]}, 
                        {this.blue[2], this.yellow[2], this.red[2]},
                        {this.blue[4], this.orange[2], this.yellow[4]}, 
                        {this.blue[6], this.orange[0], this.white[4]}};
        for(int i = 0; i < newCorners.length; i++)    {
            for(int j = 0; j < newCorners[i].length; j++)   {
                this.corners[i][j] = newCorners[i][j];
            }
        }

        Integer[][] newEdges =   {{this.green[1], this.red[5]}, 
                        {this.green[3], this.yellow[7]}, 
                        {this.green[5], this.orange[5]}, 
                        {this.green[7], this.white[7]}, 
                        {this.yellow[1], this.red[3]}, 
                        {this.yellow[5], this.orange[3]},
                        {this.white[1], this.red[7]}, 
                        {this.white[5], this.orange[7]}, 
                        {this.blue[1], this.red[1]},
                        {this.blue[3], this.yellow[3]}, 
                        {this.blue[5], this.orange[1]}, 
                        {this.blue[7], this.white[3]}};
        for(int i = 0; i < newEdges.length; i++)    {
            for(int j = 0; j < newEdges[i].length; j++)   {
                this.edges[i][j] = newEdges[i][j];
            }
        }
    }

    float scoreCube(FastCube f)   {
        FastCube complete = new FastCube();
        if(this.equals(complete))   {
            return 0;
        }
        float o = scoreFace(this.orange, "orange");
        float r = scoreFace(this.red, "red");
        float b = scoreFace(this.blue, "blue");
        float g = scoreFace(this.green, "green");
        float w = scoreFace(this.white, "white");
        float y = scoreFace(this.yellow, "yellow");

        return o+r+b+g+w+y;
    }
    
    float scoreMiddleEdges()    {
        // 0, 2, 8, 10
        // GR, GO, BR, BO
        FastCube c = new FastCube();
        float score = 0;
        Integer[] orangeFace =  {c.orange[0], c.orange[1], c.orange[2],
                                c.orange[3],             c.orange[4], 
                                c.orange[5], c.orange[6], c.orange[7]};
        Integer[] redFace =     {c.red[0], c.red[1], c.red[2],
                                c.red[3],            c.red[4], 
                                c.red[5], c.red[6], c.red[7]};
        score = 4;
        for(int i = 3; i < 5; i++)  {
            if(this.red[i] == 0 ||this.red[i] == 1)  {
                score -= 1;
            }
        }
        for(int i = 3; i < 5; i++)  {
            if(this.orange[i] == 0 ||this.orange[i] == 1)  {
                score -= 1;
            }
        }

        return score;
    }


    float scoreUD(String face)   {
        FastCube c = new FastCube();

        Integer[] whiteFace = {c.white[0], c.white[1], c.white[2],
                               c.white[3],             c.white[4], 
                               c.white[5], c.white[6], c.white[7]};
        Integer[] yellowFace = {c.yellow[0], c.yellow[1], c.yellow[2],
                                c.yellow[3],              c.yellow[4], 
                                c.yellow[5], c.yellow[6], c.yellow[7]};
        
        float wScore = 0;
        float yScore = 0;
        if(face == "white") {
            for(int i = 0; i < this.white.length; i++)    {
                if(this.white[i] != c.white[i] && this.white[i] != c.yellow[i])  {
                    wScore += 1;
                }
            }
            // println("White score: " + wScore);
        } else if (face == "yellow")    {
            for(int i = 0; i < this.yellow.length; i++)    {
                if(this.yellow[i] != c.yellow[i] && this.yellow[i] != c.white[i])  {
                    yScore += 1;
                }
            }
            // println("Yellow score: " + yScore);
        } else {
            println("Idk what face you want. You entered: " + face);
            return 0;
        }
        
        float score = wScore + yScore;
        // println("Returning " + score);
        return score;
    }

    /**
    * TODO: Re-evaluate function to compare the correct face against completed correct face.
    * Stops the score iterating unecessarily past 0
    */
    float scoreFace(Integer[] face, String faceColour)    {
        FastCube c = new FastCube();
        Integer[] completeFace = new Integer[8];

        switch(faceColour)  {
            case "red":
                Integer[] redFace = {c.red[0], c.red[1], c.red[2],
                                c.red[3],           c.red[4], 
                                c.red[5], c.red[6], c.red[7]};
                completeFace = redFace;
                break;
            case "orange":
                Integer[] orangeFace = {c.orange[0], c.orange[1], c.orange[2],
                                c.orange[3],              c.orange[4], 
                                c.orange[5], c.orange[6], c.orange[7]};
                completeFace = orangeFace;
                break;
            case "blue":
                Integer[] blueFace = {c.blue[0], c.blue[1], c.blue[2],
                                c.blue[3],            c.blue[4],
                                c.blue[5], c.blue[6], c.blue[7]};
                completeFace = blueFace;
                break;
            case "green":
                Integer[] greenFace = {c.green[0], c.green[1], c.green[2],
                                c.green[3],             c.green[4], 
                                c.green[5], c.green[6], c.green[7]};
                completeFace = greenFace;
                break;
            case "white":
                Integer[] whiteFace = {c.white[0], c.white[1], c.white[2],
                                c.white[3],             c.white[4], 
                                c.white[5], c.white[6], c.white[7]};
                completeFace = whiteFace;
                break;
            case "yellow":
                Integer[] yellowFace = {c.yellow[0], c.yellow[1], c.yellow[2],
                                c.yellow[3],              c.yellow[4], 
                                c.yellow[5], c.yellow[6], c.yellow[7]};
                completeFace = yellowFace;
                break;
        }
        
        float score = 0;
        for(int i = 0; i < face.length; i++)    {
            if(completeFace[i] != face[i])  {
                score += 1;
            }
        }
        
        return score;
    }

    float scoreFace(String faceColour)   {
        FastCube f = new FastCube();
        Integer[][] completeCubieEdges = new Integer[4][2];
        Integer[][] completeCubieCorners = new Integer[4][3];
        Integer[][] cubieEdges = new Integer[4][2];
        Integer[][] cubieCorners = new Integer[4][3];
        int score = 0;
        f.initCubies();
        this.initCubies();
        switch(faceColour)  {
            case "red":
                // Integer[][] cEdges = {f.edges[0], f.edges[4], f.edges[6], f.edges[8]};
                // Integer[][] cCorners = {f.corners[0],f.corners[1],f.corners[4],f.corners[5]};
                // Integer[][] edges = {this.edges[0], this.edges[4], this.edges[6], this.edges[8]};
                // Integer[][] corners = {this.corners[0], this.corners[1], this.corners[4], this.corners[5]};
                // completeCubieEdges = cEdges;
                // completeCubieCorners = cCorners;
                // cubieEdges = edges;
                // cubieCorners = corners;
                break;
            case "orange":
                // Integer[][] completeCubieEdges = {{f.edges[2]}, {f.edges[5]}, {f.edges[7]}, {f.edges[10]}};
                // Integer[][] completeCubieCorners = {{f.corners[2]},{f.corners[3]},{f.corners[6]},{f.corners[7]}};
                // Integer[][] cubieEdges = {{this.edges[2]}, {this.edges[5]}, {this.edges[7]}, {this.edges[10]}};
                // Integer[][] cubieCorners = {{this.corners[2]},{this.corners[3]},{this.corners[6]},{this.corners[7]}};
                break;
            case "blue":
                Integer[] blueFace = {f.blue[0], f.blue[1], f.blue[2],
                                        f.blue[3],            f.blue[4],
                                        f.blue[5], f.blue[6], f.blue[7]};
                break;
            case "green":
                Integer[] greenFace = {f.green[0], f.green[1], f.green[2],
                                        f.green[3],             f.green[4], 
                                        f.green[5], f.green[6], f.green[7]};
                break;
            case "white":
                Integer[][] cEdges = {f.edges[3], f.edges[6], f.edges[7], f.edges[11]};
                Integer[][] cCorners = {f.corners[0],f.corners[3],f.corners[4],f.corners[7]};
                Integer[][] edges = {this.edges[3], this.edges[6], this.edges[7], this.edges[11]};
                Integer[][] corners = {this.corners[0],this.corners[3],this.corners[4],this.corners[7]};
                completeCubieEdges = cEdges;
                completeCubieCorners = cCorners;
                cubieEdges = edges;
                cubieCorners = corners;
                break;
            case "yellow":
                Integer[] yellowFace = {f.yellow[0], f.yellow[1], f.yellow[2],
                                        f.yellow[3],             f.yellow[4], 
                                        f.yellow[5], f.yellow[6], f.yellow[7]};
                break;
        }

        boolean edgeOrientedCorrectly = false;
        boolean edgeFound = false;
        for(int i = 0; i < 4; i++)  {
            edgeFound = false;
            edgeOrientedCorrectly = false;
            int counter = 0;
            for(int j = 0; j < 2; j++)  {
                if(completeCubieEdges[i][j] == cubieEdges[i][j])  {
                    counter++;
                }
                if(counter == 2)    {
                    edgeFound = true;
                }
            }
            if(!edgeFound)   score += 1;
            // if(edgeFound && !edgeOrientedCorrectly) score += 0.5;
        }

        boolean cornerFound = false;
        boolean cornerOrientedCorrectly = false;
        for(int i = 0; i < 4; i++)  {
            cornerFound = false;
            cornerOrientedCorrectly = false;
            int counter = 0;
            for(int j = 0; j < 3; j++)  {
                if(completeCubieCorners[i][j] == cubieCorners[i][j])  {
                    counter++;
                }
                if(counter == 3)    {
                    // println("Comparing " + Arrays.toString(completeCubieCorners[i]) + " with " + Arrays.toString(cubieCorners[j]));
                    cornerFound = true;
                }
            }
            if(!cornerFound)    score += 1;
        }
        return score;
    }
    // float scoreFace(FastCube f, String faceColour)    {
    //     FastCube c = new FastCube();
    //     Integer[] completeFace = new Integer[8];
    //     Integer[] face = new Integer[8];

        // switch(faceColour)  {
        //     case "red":
        //         Integer[] redFace = {c.red[0], c.red[1], c.red[2],
        //                              c.red[3],           c.red[4], 
        //                              c.red[5], c.red[6], c.red[7]};
        //         Integer[] tredFace = {f.red[0], f.red[1], f.red[2],
        //                               f.red[3],           f.red[4], 
        //                               f.red[5], f.red[6], f.red[7]};
        //         completeFace = redFace;
        //         face = tredFace;
        //         break;
        //     case "orange":
        //         Integer[] orangeFace = {c.orange[0], c.orange[1], c.orange[2],
        //                         c.orange[3],              c.orange[4], 
        //                         c.orange[5], c.orange[6], c.orange[7]};
        //         completeFace = orangeFace;
        //         break;
        //     case "blue":
        //         Integer[] blueFace = {c.blue[0], c.blue[1], c.blue[2],
        //                         c.blue[3],            c.blue[4],
        //                         c.blue[5], c.blue[6], c.blue[7]};
        //         completeFace = blueFace;
        //         break;
        //     case "green":
        //         Integer[] greenFace = {c.green[0], c.green[1], c.green[2],
        //                         c.green[3],             c.green[4], 
        //                         c.green[5], c.green[6], c.green[7]};
        //         completeFace = greenFace;
        //         break;
        //     case "white":
        //         Integer[] whiteFace = {c.white[0], c.white[1], c.white[2],
        //                                c.white[3],             c.white[4], 
        //                                c.white[5], c.white[6], c.white[7]};
        //         Integer[] twhiteFace = {f.white[0], f.white[1], f.white[2],
        //                                 f.white[3],             f.white[4], 
        //                                 f.white[5], f.white[6], f.white[7]};
        //         completeFace = whiteFace;
        //         face = twhiteFace;
        //         break;
        //     case "yellow":
        //         Integer[] yellowFace = {c.yellow[0], c.yellow[1], c.yellow[2],
        //                         c.yellow[3],              c.yellow[4], 
        //                         c.yellow[5], c.yellow[6], c.yellow[7]};
        //         completeFace = yellowFace;
        //         break;
        // }
        
    //     float score = 0;
    //     // println(face.length);
    //     for(int i = 0; i < face.length; i++)    {
    //         if(completeFace[i] != face[i])  {
    //             // println(completeFace[i] + " not same as " + face[i]);
    //             score += 1;
    //         }
    //     }
        
    //     return score;
    // }

    boolean equals(FastCube f)  {
        if(f.orange == this.orange &&
            f.red == this.red &&
            f.blue == this.blue &&
            f.green == this.green &&
            f.white == this.white &&
            f.yellow == this.yellow)    {
                return true;
            }
        return false;
    }

    boolean equals(Integer[] c, Integer[] f) {
        for(int i = 0; i < f.length; i++)   {
            if(f[i] != c[i]) {
                return false;
            }
        }
        return true;
    }
}

/**
*   References
*   64 bit int manipulation - https://www.vojtechruzicka.com/bit-manipulation-java-bitwise-bit-shift-operations/
*
*/