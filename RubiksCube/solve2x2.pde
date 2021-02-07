import java.io.*; 
import java.util.*;
class solve2x2  {

    // Permutation value guide
    // UFL= 0, ULB = 1, UBR = 2, URF = 3, DLF = 4, DFR = 5, DRB = 6
    // Orientation value guide
    // Correctly Oriented = 0, Clockwise Rotated = 1, Anti-Clockwise Rotated = 2
    int[] p = new int[7];
    int[] o = new int[7];
    Cube cube;
    String solution;
    boolean oriented = false;
    Stack<Integer> path = new Stack<Integer>();
    int[][] movearr = {{0,3,2,1},{0,0,0,0},{0,4,5,3},{2,1,2,1},{2,3,5,6},{1,2,1,2}};

    solve2x2(Cube cube)  {
        this.cube = cube;
    }

    /**
    * Solve the cube
    */
    void solve()    {
        if(cube.dimensions == 2)    {
            println("Solving cube");
            // Start timer
            long start = System.currentTimeMillis();
            // Need to orient cube so White/Blue/Red cubie is DBL (Correctly permutated and oriented - locked in place)
            while(!oriented)    oriented = orientCube();
            // Initialises permutation/orientation values from cube object
            iPermutations();
            iOrientations();
            // println("Permutations");
            // printPermutations();
            // println("\nOrientations");
            // printOrientations();
            // println("\nDepth");
            for(int d = 0; d <= 11; d++)    {
                // print(d + " ");
                if(dfs(d, -1)) break;
            }
            long end = System.currentTimeMillis();
            float duration = (end - start) / 1000F;
            println("Duration\tNumMoves");
            print(duration + "s\t\t");
            if(solution != "") returnSolution(solution);
        } else {
            println("This solver is not compatible with " + cube.dimensions + " x " + cube.dimensions + " x " + cube.dimensions + " sized cubes.");
        }
        threadRunning = false;
        twoxtwosolve = false;
    }

    /**
    * Orient cube in a specific way for cube to be solveable through this method.
    * @return   boolean If cube is correctly oriented, return true
    */
    boolean orientCube()   {
        // If there're moves still needing to be applied to cube, return false.
        if(sequence.size() > 0) return false;
        // if(turns.length() > 0) return false;
        for(Cubie cubie : cube.getCubies())    {
            if(contains(cubie.colours, cubie.white) && contains(cubie.colours, cubie.blue) && contains(cubie.colours, cubie.red))   {
                // println("Found cubie");
                // While bottom colour is not white OR position is wrong
                if(cubie.colours[3] != white || !positionMatch(cubie.getPosition(), -axis, axis, -axis)) {
                    String move = "";
                    if(cubie.colours[0] == cubie.white || 
                        cubie.colours[1] == cubie.white ||
                        cubie.colours[2] == cubie.white)move += "Z";
                    if(cubie.colours[3] == cubie.white) move += "Y";
                    if(cubie.colours[4] == cubie.white) move += "X";
                    if(cubie.colours[5] == cubie.white) move += "X\'";
                    // println("adding " + move);
                    if(move != "")  addMoveToSequence(move);
                } else {
                    return true;
                }
            }
        }
        return false;
    }

    /**
    * Returns the solution to solving the 2x2x2 cube.
    * @param    solution    Solution returned by this class
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
        print(counter);
        println("\n" + solution);
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

    /**
    * Permutates permutation/orientation arrays according to what move is needed.
    * @param    a   an array of indexes corresponding to the move we're applying from movearr - permutations
    * @param    b   an array of indexes corresponding to the move we're applying from movearr - orientations
    */
    void perm(int[] a, int[] b) {
        // Store first element to x
        int x = p[a[0]];
        // Re-order rest of elements
        for(int i = 0; i < 3; i++)  {
            p[a[i]] = p[a[i+1]];
        }
        // Last element becomes x
        p[a[3]] = x;

        x = o[a[0]];
        for(int i = 0; i < 3; i++)  {
            o[a[i]] = (o[a[i+1]] + b[i]) % 3;
        }
        o[a[3]] = (x + b[3])%3;
    }

    /**
    * Applies move to the permutation and orientation arrays.
    * @param m move as represented by a number (The index of the move)
    */
    void move(int m)    {
        // Permutate cube using move array.
        perm(movearr[2*m], movearr[2*m+1]);
    }

    /**
    * Checks if dfs has reached a solved solution
    * @return boolean   If it's solved true else false
    */
    boolean solved()    {
        for(int i = 0; i < 7; i++)  {
            if(p[i] != i || o[i] != 0)   return false;
        }
        return true;
    }

    /**
    * Depth First Search - covers all possibilities.
    * @param    d Depth of moves.
    * @param    l
    * @return   boolean
    */
    boolean dfs(int d, int l)  {
        // If depth is 0
        if(d == 0)  {
            // If the cube is solved
            if(solved())    {
                // Create copy of path stack
                Stack<Integer> path2 = path;
                // String we're appending solution to
                String str = "";
                // All possible moves.
                String[] moves = {"U", "U2", "U\'", "F", "F2", "F\'", "R", "R2", "R\'"};
                // While the copy of the path stack is not empty
                while(!path2.empty())   {
                    // Add the top of the stack to the beginning of the string.
                    str = moves[path2.peek()] + " " + str;
                    // Pop this stack element.
                    path2.pop();
                }
                // Print solution.
                // println("\n" + str);
                solution = str;
                // Return true as cube can now be solved.
                return true;
            }
            // If cube is not solved, return false.
            return false;
        }

        // For each move, U, F, R
        for(int m = 0; m < 3; m++)  {
            if(m == l) continue;
            // For each variation of move 'm'.
            for(int p = 0; p < 3; p++)  {
                // Apply move
                move(m);
                path.push(3*m+p);
                if(dfs(d-1, m)) return true;
                path.pop();
            }
            move(m);
        }
        return false;
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
    * Initialises permutation values from cubies on cube
    */
    void iPermutations()  {
        Cubie[] allCubies = new Cubie[cube.getCubies().length-1];
        int counter = 0;
        for(Cubie c : cube.getCubies()) {
            if(positionMatch(c.getPosition(), -0.5, 0.5, -0.5))  continue;
            // Yellow, red, green
            if(positionMatch(c.getPosition(),-0.5, -0.5, 0.5)) allCubies[0] = c;
            // Yellow, red, blue
            if(positionMatch(c.getPosition(), -0.5, -0.5, -0.5))  allCubies[1] = c;
            // Yellow, orange, blue
            if(positionMatch(c.getPosition(), 0.5, -0.5, -0.5))allCubies[2] = c;
            // Yellow, orange, green
            if(positionMatch(c.getPosition(), 0.5, -0.5, 0.5))allCubies[3] = c;
            // White, red, green
            if(positionMatch(c.getPosition(), -0.5, 0.5, 0.5))allCubies[4] = c;
            // White, orange, green
            if(positionMatch(c.getPosition(), 0.5, 0.5, 0.5))allCubies[5] = c;
            // White, orange, blue
            if(positionMatch(c.getPosition(), 0.5, 0.5, -0.5))allCubies[6] = c;
            // allCubies[counter] = c;
            // counter++;
        }
        
        counter = 0;
        for(int i = 0; i < allCubies.length; i++)    {
            Cubie c = allCubies[i];
            if(contains(c.colours, c.yellow) && contains(c.colours, c.red) && contains(c.colours, c.blue))  {
                p[counter] = 1;
            }
            else if(contains(c.colours, c.yellow) && contains(c.colours, c.red) && contains(c.colours, c.green))  {
                p[counter] = 0;
            }
            else if(contains(c.colours, c.white) && contains(c.colours, c.orange) && contains(c.colours, c.green))  {
                p[counter] = 5; 
            }
            else if(contains(c.colours, c.white) && contains(c.colours, c.red) && contains(c.colours, c.green))  {
                p[counter] = 4;
            }
            else if(contains(c.colours, c.yellow) && contains(c.colours, c.orange) && contains(c.colours, c.blue))  {
                p[counter] = 2;
            }
            else if(contains(c.colours, c.yellow) && contains(c.colours, c.orange) && contains(c.colours, c.green))  {
                p[counter] = 3;
            }
            else if(contains(c.colours, c.white) && contains(c.colours, c.orange) && contains(c.colours, c.blue))  {
                p[counter] = 6;
            }
            else {
                println("Unsure...");
                println(c.details());
            }
            counter++;
        }
        // printPermutations();
    }

    /**
    * Initialises orientation values from cubies on cube
    */
    void iOrientations()  {
        for(int i = 0; i < 8; i++)  {
        // Analyses UFL, UFR - if front and top colours aren't black.
            if(cube.getCubie(i).colours[4] != color(0) &&
                cube.getCubie(i).colours[2] != color(0))    {
                // If U face on cubie has white/yellow
                if(cube.getCubie(i).colours[2] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[2] == cube.getCubie(i).yellow)  {
                        // If the right side of cubie is not black
                        if(cube.getCubie(i).colours[0] != color(0))  {
                            o[3] = 0;
                        }
                        // If the left side of cubie is not black
                        else if(cube.getCubie(i).colours[1] != color(0)) {
                            o[0] = 0;
                        }
                }
                // If left side of cubie is not black
                if(cube.getCubie(i).colours[1] != color(0)) {
                    // If F face of cubie is white or yellow
                    if(cube.getCubie(i).colours[4] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[4] == cube.getCubie(i).yellow)  {
                        o[0] = 1;
                    }
                    // If left side is white/yellow
                    if(cube.getCubie(i).colours[1] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[1] == cube.getCubie(i).yellow)  {
                        o[0] = 2;
                    }
                    continue;
                }
                // If Right side of cubie is not black - URF
                if(cube.getCubie(i).colours[0] != color(0)) {
                    // If right side of cubie is white/yellow
                    if(cube.getCubie(i).colours[0] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[0] == cube.getCubie(i).yellow) {
                        o[3] = 1;
                    }
                    // If F face is white/yellow
                    if(cube.getCubie(i).colours[4] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[4] == cube.getCubie(i).yellow)  {
                        o[3] = 2;
                    }
                    continue;
                }
            }
        // Analyses UBR, UBL - if top and back colours aren't black.
            if(cube.getCubie(i).colours[5] != color(0) &&
                cube.getCubie(i).colours[2] != color(0))    {
                    // If U face of cubie is white/yellow
                if( cube.getCubie(i).colours[2] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[2] == cube.getCubie(i).yellow)  {
                        // If Left face is not black
                        if(cube.getCubie(i).colours[1] != color(0)) {
                            o[1] = 0;
                        // If right face is not black
                        } else if(cube.getCubie(i).colours[0] != color(0)) {
                            o[2] = 0;
                        }
                }
                // If left face is not black
                if(cube.getCubie(i).colours[1] != color(0)) {
                    // If left face is white/yellow
                    if(cube.getCubie(i).colours[1] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[1] == cube.getCubie(i).yellow)  {
                        o[1] = 1;
                    }
                    // If B face is white/yellow
                    if(cube.getCubie(i).colours[5] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[5] == cube.getCubie(i).yellow)  {
                        o[1] = 2;
                    }
                    // println(i + ". ULB : " + o[1]);
                    continue;
                }
                // If right face is not black
                if(cube.getCubie(i).colours[0] != color(0)) {
                    // If 
                    if(cube.getCubie(i).colours[5] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[5] == cube.getCubie(i).yellow)  {
                        o[2] = 1;
                    }
                    if(cube.getCubie(i).colours[0] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[0] == cube.getCubie(i).yellow)  {
                        o[2] = 2;
                    }
                    // println(i + ". URB : " + o[2]);
                    continue;
                }
            }
        // Analyses DFR, DFL - if top and down colours aren't black.
            if(cube.getCubie(i).colours[4] != color(0) &&
                cube.getCubie(i).colours[3] != color(0))    {
                // If D face is white/yellow
                if( cube.getCubie(i).colours[3] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[3] == cube.getCubie(i).yellow)  {
                        // If left side is not black
                        if(cube.getCubie(i).colours[1] != color(0)) {
                            o[4] = 0;
                        // If right side is not black
                        } else if(cube.getCubie(i).colours[0] != color(0)) {
                            // println(cube.getCubie(i).details());
                            o[5] = 0;
                        }
                }
                // If left side is not black
                if(cube.getCubie(i).colours[1] != color(0)) {
                    // If left side is yellow or white
                    if( cube.getCubie(i).colours[1] == cube.getCubie(i).white ||
                        cube.getCubie(i).colours[1] == cube.getCubie(i).yellow)  {
                        o[4] = 1;
                    }
                    // If F is yellow or white
                    if( cube.getCubie(i).colours[4] == cube.getCubie(i).white ||
                        cube.getCubie(i).colours[4] == cube.getCubie(i).yellow)  {
                        o[4] = 2;
                    }
                    // println(i + ". DFL : " + o[4]);
                    continue;
                }

                // If right side is not black
                if(cube.getCubie(i).colours[0] != color(0)) {
                    // If front face is white/yellow
                    if( cube.getCubie(i).colours[4] == cube.getCubie(i).white ||
                        cube.getCubie(i).colours[4] == cube.getCubie(i).yellow)  {
                        o[5] = 1;
                    }
                    // If right side is white/yellow
                    if( cube.getCubie(i).colours[0] == cube.getCubie(i).white ||
                        cube.getCubie(i).colours[0] == cube.getCubie(i).yellow)  {
                        o[5] = 2;
                    }
                    // println(i + ". DFR : " + o[6]);
                    continue;
                }  
            }
        // Analyses DBR, DBL - if top and down colours aren't black.
            if(cube.getCubie(i).colours[5] != color(0) &&
                cube.getCubie(i).colours[3] != color(0))    {
                if( cube.getCubie(i).colours[3] == cube.getCubie(i).white ||
                    cube.getCubie(i).colours[3] == cube.getCubie(i).yellow)  {
                        if(cube.getCubie(i).colours[0] != color(0)) {
                            o[6] = 0;
                        } else if(cube.getCubie(i).colours[1] != color(0)) {
                            // o[7] = 0;
                        }
                }
                if(cube.getCubie(i).colours[0] != color(0)) {
                    if( cube.getCubie(i).colours[5] == cube.getCubie(i).white ||
                        cube.getCubie(i).colours[5] == cube.getCubie(i).yellow)  {
                        o[6] = 2;
                    }
                    if( cube.getCubie(i).colours[0] == cube.getCubie(i).white ||
                        cube.getCubie(i).colours[0] == cube.getCubie(i).yellow)  {
                        o[6] = 1;
                    }
                    // println(i + ". DBL : " + o[6]);
                    continue;
                }
            }
        }
    }

    /**
    * Print orientation values from cubies on cube
    */
    void printOrientations()    {
        for(int i = 0; i < 7; i++)  {
            print(o[i] + " ");
        }
    }

    /**
    * Print permutation values from cubies on cube
    */
    void printPermutations()    {
        for(int i = 0; i < 7; i++)  {
            print(p[i] + " ");
        }
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
}