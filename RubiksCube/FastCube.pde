import java.lang.Long;
// We can represent each colour from each face as a number.
enum colour{
    O,
    R,
    Y,
    W,
    G,
    B
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

    long orange;
    long red;
    long yellow;
    long white;
    long green;
    long blue;
    
    FastCube()  {
        // Populate each face with 8 appropriate colours
        this.orange = 00000000;
        this.red = 11111111;
        this.yellow = 22222222;
        this.white = 33333333;
        this.green = 44444444;
        this.blue = 55555555;
    }

    FastCube(Cube c)    {
        this.orange = getFace("orange",  c);
        this.red = getFace("red",  c);
        this.yellow = getFace("yellow",  c);
        this.white = getFace("white",  c);
        this.green = getFace("green",  c);
        this.blue = getFace("blue",  c);
        printCube();
    }

    FastCube testAlgorithm(String algorithm) {
		// println("\nTesting: " + algorithm + "\tNumber of chars: " + algorithm.length()+"\n");
		for (int i = 0; i < algorithm.length(); i++) {
			// Initially direction of each move is 1
			int dir = 1;
			char move = algorithm.charAt(i);
			// print(move);
			// If there are moves in algorithm and the next char is a prime: '
			if(i+1 < algorithm.length())	{
				if (algorithm.charAt(i+1) == '\'' || algorithm.charAt(i+1) == '’' || algorithm.charAt(i+1) == '2') {
					char next = algorithm.charAt(i+1);
					// Set the direction of the move to anticlockwise
					if(next == '\'' || next == '’')	{
						dir = - 1;
					}	else	{
						dir = 2;
					}
					i++;
				}
			} 
			// Call a turn on the cube according to the move we have here.
			// switch(move) {
			// 	case 'L':
			// 		this.turn('X', axis, dir);
			// 	break;
			// 	case 'R':
			// 		this.turn('X', - axis, dir);
			// 	break;
			// 	case 'U':
			// 		this.turn('Y', -axis, dir);
			// 	break;
			// 	case 'D':
			// 		this.turn('Y', axis, -dir);
			// 	break;
			// 	case 'F':
			// 		this.turn('Z', axis, dir);
			// 	break;
			// 	case 'B':
			// 		this.turn('Z', - axis, dir);
			// 	break;
			// }
		}
		return this;
	}

    /**
    * Prints the cube in console
    * Mainly used for debugging purposes as there's a 2D representation on gui
    */
    void printCube()    {
        println();
        // println(printFace(yellow, true));
        // println(printFirstRow(red) + printFirstRow(green) + printFirstRow(orange) + printFirstRow(blue));
        // println(printSecondRow(red) + printSecondRow(green) + printSecondRow(orange) + printSecondRow(blue));
        // println(printThirdRow(red) + printThirdRow(green) + printThirdRow(orange) + printThirdRow(blue));
        // println(printFace(white, true));
        println(printFirstRow(red, 1));
        println(printSecondRow(red, 1));
        println(printThirdRow(red, 1));
    }
    
    String printFirstRow(long f, int whichFace) {
        // 1 - Red, 2 - Green, 3 - Orange, 4 - Blue
        String s = "";
        if(f == 0)  {
            s += ("O" + " " + "O" + " " + "O"+ " ");
            return s;
        }
        String face = Long.toString(f);
        if(face.length() < 8) {
            int count = 8 - face.length();
            for(int i = 0; i < count; i++)  {
                face += "0";
            }
        }

        int f0 = Character.getNumericValue(face.charAt(0));
        int f1 = Character.getNumericValue(face.charAt(1));
        int f2 = Character.getNumericValue(face.charAt(2));
        int f3 = Character.getNumericValue(face.charAt(3));
        int f4 = Character.getNumericValue(face.charAt(4));
        int f5 = Character.getNumericValue(face.charAt(5));
        int f6 = Character.getNumericValue(face.charAt(6));
        int f7 = Character.getNumericValue(face.charAt(7));

        switch(whichFace)   {
            case 1:
                s += (colour.values()[f5] + " " + colour.values()[f3] + " " + colour.values()[f2]+ " ");
                break;
            case 2:
                s += (colour.values()[f0] + " " + colour.values()[f3] + " " + colour.values()[f5]+ " ");
                break;
            case 3:
                s += (colour.values()[f0] + " " + colour.values()[f3] + " " + colour.values()[f5]+ " ");
                break;
            case 4:
                s += (colour.values()[f0] + " " + colour.values()[f3] + " " + colour.values()[f5]+ " ");
                break;
        }
        return s;
    };

    String printSecondRow(long f, int whichFace) {
        // 1 - Red, 2 - Green, 3 - Orange, 4 - Blue
        String s = "";
        if(f == 0)  {
            s += ("O" + " " + "-" + " " + "O"+ " ");
            return s;
        }
        String face = Long.toString(f);
        if(face.length() < 8) {
            int count = 8 - face.length();
            for(int i = 0; i < count; i++)  {
                face += "0";
            }
        }

        int f0 = Character.getNumericValue(face.charAt(0));
        int f1 = Character.getNumericValue(face.charAt(1));
        int f2 = Character.getNumericValue(face.charAt(2));
        int f3 = Character.getNumericValue(face.charAt(3));
        int f4 = Character.getNumericValue(face.charAt(4));
        int f5 = Character.getNumericValue(face.charAt(5));
        int f6 = Character.getNumericValue(face.charAt(6));
        int f7 = Character.getNumericValue(face.charAt(7));
        switch(whichFace)   {
            case 1:
                s += (colour.values()[f6] + " - " + colour.values()[f4] + " ");
            break;
            case 2:
                s += (colour.values()[f1] + " - " + colour.values()[f6] + " ");
            break;
            case 3:
                s += (colour.values()[f1] + " - " + colour.values()[f6] + " ");
            break;
            case 4:
                s += (colour.values()[f1] + " - " + colour.values()[f6] + " ");
            break;
        }

        return s;
    };

    String printThirdRow(long f, int whichFace) {
        // 1 - Red, 2 - Green, 3 - Orange, 4 - Blue
        String s = "";
        if(f == 0)  {
            s += ("O" + " " + "O" + " " + "O"+ " ");
            return s;
        }
        String face = Long.toString(f);
        if(face.length() < 8) {
            int count = 8 - face.length();
            for(int i = 0; i < count; i++)  {
                face += "0";
            }
        }
        int f0 = Character.getNumericValue(face.charAt(0));
        int f1 = Character.getNumericValue(face.charAt(1));
        int f2 = Character.getNumericValue(face.charAt(2));
        int f3 = Character.getNumericValue(face.charAt(3));
        int f4 = Character.getNumericValue(face.charAt(4));
        int f5 = Character.getNumericValue(face.charAt(5));
        int f6 = Character.getNumericValue(face.charAt(6));
        int f7 = Character.getNumericValue(face.charAt(7));

        switch(whichFace)   {
            case 1:
                s += (colour.values()[f0] + " " + colour.values()[f1] + " " + colour.values()[f7] + " ");
            break;
            case 2:
                s += (colour.values()[f2] + " " + colour.values()[f4] + " " + colour.values()[f7] + " ");
            break;
            case 3:
                s += (colour.values()[f2] + " " + colour.values()[f4] + " " + colour.values()[f7] + " ");
            break;
            case 4:
                s += (colour.values()[f2] + " " + colour.values()[f4] + " " + colour.values()[f7] + " ");
            break;
        }
        return s;
    };

    String printFace(long f, boolean y)   {
        String face = Long.toString(f);
        String s = "";
        if(f == 0 && y)  {
            s += ("      " + "O" + " " + "O" + " " + "O" + "\n");
            s += ("      " + "O" +      " - "      + "O" + "\n");
            s += ("      " + "O" + " " + "O" + " " + "O");
            return s;
        } else if (f == 0 && !y)    {
            s += ("O" + " " + "O" + " " + "O" + "\n");
            s += ("O" +      " - "      + "O" + "\n");
            s += ("O" + " " + "O" + " " + "O");
            return s;
        }
        int f0 = Character.getNumericValue(face.charAt(0));
        int f1 = Character.getNumericValue(face.charAt(1));
        int f2 = Character.getNumericValue(face.charAt(2));
        int f3 = Character.getNumericValue(face.charAt(3));
        int f4 = Character.getNumericValue(face.charAt(4));
        int f5 = Character.getNumericValue(face.charAt(5));
        int f6 = Character.getNumericValue(face.charAt(6));
        int f7 = Character.getNumericValue(face.charAt(7));

        if(y)   {
            s += ("      " + colour.values()[f0] + " " + colour.values()[f3] + " " + colour.values()[f5] + "\n");
            s += ("      " + colour.values()[f1] +          " - "                  + colour.values()[f6]+ "\n");
            s += ("      " + colour.values()[f2] + " " + colour.values()[f4] + " " + colour.values()[f7]);
        } else {
            s += (colour.values()[f0] + " " + colour.values()[f3] + " " + colour.values()[f5] + "\n");
            s += (colour.values()[f1] +          " - "                  + colour.values()[f6]+ "\n");
            s += (colour.values()[f2] + " " + colour.values()[f4] + " " + colour.values()[f7]);
        }

        return s;
    }

    long getFace(String f, Cube c)   {
        long thisFace;
        String s = "";
        String face = c.getFace(f);
        for(int i = 0; i < face.length(); i++)    {
            if(i == 4) continue;
            String a = face.charAt(i) + "";
            s += colour.valueOf(a).ordinal();
        }
        thisFace = Integer.parseInt(s);
        println(f + "\t" + thisFace);
        return thisFace;
    }

    /**
    * Splits a 64 bit integer into eight 8 bit integers
    */
    // void split(long i64)    {
    //     String numbers = Long.toString(i64);
    //     for(int i = 0; i < 8; i++) {
    //         System.out.printf("%s octet: %s\n", (i+1), i64.substring(i*8, (i+1)*8));
    //     }
    // }

    void rotate(String face)   {
        String num = toBinary(face);
        num = num.substring(8) + num.substring(0,8);
        int newNum = Integer.parseInt(num, 2);
        println(newNum);
        // return (int) num;
    }

    String toBinary(String s)    {
        String newS = "";
        for(int i = 1; i < s.length()+1; i++)   {
            newS += s.charAt(i-1);
            if(i % 8 == 0)  {
                newS +=" ";
            }
        }
        newS += "\n";
        return newS;
    }
}

/**
*   References
*   64 bit int manipulation - https://www.vojtechruzicka.com/bit-manipulation-java-bitwise-bit-shift-operations/
*
*/