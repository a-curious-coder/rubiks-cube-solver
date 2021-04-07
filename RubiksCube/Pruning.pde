import java.nio.channels.FileChannel;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.nio.ByteOrder;
import java.lang.Object;
import java.util.HashMap;

// Korf's Pruning Tables
byte[] corners_p_corners_o_table = new byte[88179840];
byte[] edges_p_table = new byte[479001600];
byte[] edges_o_table = new byte[2048];
// Thistlethwaite tables
int[] eslice_table = new int[495];
int[] comb_to_index = new int[4096];
ArrayList<Integer> index_to_comb = new ArrayList();

int[] ms_slice_table = new int[495];
int[] ms_comb_to_index = new int[4096];
ArrayList<Integer> ms_index_to_comb = new ArrayList(); // Custom size

int[] tetrad_table;
int[] tetrad_comb_to_index;
ArrayList<Integer> tetrad_index_to_comb;

byte[] corners_o_table = new byte[2187];
byte[] corners_p_table = new byte[96];

int[] double_turn_table = new int[663552];

// Kociemba
byte[] es_co_table;
byte[] tetrad_ms_table;

int[] tableDepths = new int[3];

String directory = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";

// Load the pruning tables to the corresponding byte arrays
void loadPruningTables() {
    // Load file for each edge/corner permutation/orientation
    // If file is empty, create appropriate table and save to file
    // If file has contents, store them to appropriate array
    long start = System.currentTimeMillis();
    if (read_table_to_array("co", "corners_o.txt"))  {
        println("Loaded Corner Orientation Table");
    } else {
        println("Creating corners_o.txt");
        create_corners_o_table();
    }
    if (read_table_to_array("eo", "edges_o.txt"))    {
        println("Loaded edges_o.txt");
    } else {
        println("Creating edges_o.txt");
        create_edges_o_table();
    }
    
    if (read_table_to_array("cop", "corner_op.txt")) {
        println("Loaded corners_op.txt");
    } else {
        println("Creating corners_op.txt");
        create_corners_op_table();
    }
    
    if (read_table_to_array("ep", "edges_p.txt"))    {
        println("Loaded edges_p.txt");
    } else  {
        println("Creating edges_p.txt");
        create_edges_p_table();
    }

    if(read_table_to_array("es_co", "es_co_table.txt")) {
        println("Loaded es_co_table.txt");
    } else {
        println("Creating es_co_table.txt");
        create_es_co_table();
    }

    // Thistlethwaite's Pruning Tables
    create_e_slice_table();

    create_ms_slice_table();

    create_tetrad_table();

    long end = System.currentTimeMillis();
    float duration = (end - start) / 1000F;
    println("Took " + duration + "s to load all pruning tables");
    threadRunning = false;
}

// Creates the appropraite pruning tables and stores contents to the appropriate files
void create_corners_op_table()   {
    println("[*]\tCreating Permutation and Orientation Tables for: corners");
    Cube2 c = new Cube2();
    int depth = 0, h = 0;
    String[] movechars = {"U", "L", "F", "R", "B", "D"};
    
    println("Initialising corners p and corners o tables");
    for (int i = 0; i < corners_p_corners_o_table.length; i++)  {
        corners_p_corners_o_table[i] = - 1;
    }
    // Save moves it takes to get to solved state to index 0
    corners_p_corners_o_table[c.encode_corners_p_corners_o()] = 0;
    int newPositions = 1, totalPositions = 1;
    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"corners_p_corners_o_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s");
    while(newPositions != 0) { // While there are still new positions being discovered.
        newPositions = 0; // reset new pos total
        for (int pos = 0; pos < 88179840; pos++) { // for each element in the array 
            if (corners_p_corners_o_table[pos] != depth) continue;
            c.decode_corners_p_corners_o(pos);
            
            for (String move : movechars)    {
                for (int i = 0; i < 3; i++)    {
                    c.move(move);
                    h = c.encode_corners_p_corners_o();
                    if (corners_p_corners_o_table[h] == - 1)  {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        corners_p_corners_o_table[h] = bresult;
                        newPositions++;
                    }
                }
                if (move != "D")   c.move(move);
            }
        }
        depth++;
        totalPositions += newPositions;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newPositions + "\t" + totalPositions + "\t" + duration + "s");
    }
    tableDepths[1] = depth;
    try {
        FileOutputStream stream = new FileOutputStream(directory + "corners_op.txt");
        stream.write(corners_p_corners_o_table);
        println("Saved corners_op.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_edges_p_table() {
    println("[*]\tCreating Permutation Tables for: edges");
    Cube2 c = new Cube2();
    // Move chars we're looping through
    String[] movechars = {"U", "L", "F", "R", "B", "D"};
    // String[] movechars = {"U", "U2", "U'", 
                // "L", "L2", "L'", 
                // "F", "F2", "F'", 
                // "R", "R2", "R'", 
                // "B", "B2", "B'", 
                // "D", "D2", "D'"};
    int depth = 0, h = 0;
    
    // Initialise all array variables
    for (int i = 0; i < edges_p_table.length; i++)
        edges_p_table[i] = - 1;
    
    Cube2 tmp = new Cube2(c);
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s");
    edges_p_table[c.encode_edges_p()] = 0;
    int newPositions = 1, totalPositions = 1;
    int count = 0;
    long start = System.currentTimeMillis();
    while(newPositions != 0) {
        newPositions = 0;
        for (int pos = 0; pos < 479001600; pos++) {
            if (edges_p_table[pos] != depth) continue;
            c.decode_edges_p(pos);
            for (String move : movechars)    {
                // This is to loop through moves.
                for (int i = 0; i < 3; i++)    {
                    c.move(move);
                    // c.testAlgorithm(move);
                    h = c.encode_edges_p();
                    if (edges_p_table[h] == - 1)  {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        edges_p_table[h] = bresult;
                        newPositions++;
                    }
                }
                // Adds variation to the cube
                if (move != "D") c.move(move);
            }
        }
        // Increase value of depth of moves
        depth++;
        totalPositions += newPositions;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newPositions + "\t" + totalPositions + "\t" + duration + "s");
    }
    tableDepths[0] = depth;
    try {
        FileOutputStream stream = new FileOutputStream(directory + "edges_p.txt");
        stream.write(edges_p_table);
        println("Saved edges_p.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_edges_o_table()  {
    println("[*]\tCreating Orientation Tables for: edges");
    Cube2 c = new Cube2();
    int depth = 0;
    int h;
    // Set default orientation values to -1
    for (int i = 0; i < edges_o_table.length; i++)  {
        edges_o_table[i] = - 1;
    }
    edges_o_table[c.encode_edges_o()] = 0;
    int newPositions = 1, totalPositions = 1;
    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"edges_o_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s\n");
    while(newPositions != 0)    {
        newPositions = 0;
        for (int pos = 0; pos < 2048; pos++) {
            if (edges_o_table[pos] != depth)   continue;
            c.decode_edges_o(pos);
            // 6 moves
            String[] movechars = {"U", "L", "F", "R", "B", "D"};
            for (String move : movechars)    {
                for (int i = 0; i < 3; i++)    {
                    c.move(move);
                    h = c.encode_edges_o();
                    if (edges_o_table[h] == - 1)  {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        //if (moveCounter < 100)  println("Result: " + result + "\tByte Result: " + bresult);
                        edges_o_table[h] = bresult;
                        newPositions++;
                    }
                }
                if (move != "D") c.move(move);
                moveCounter++;
            }
        }
        depth++;
        totalPositions += newPositions;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newPositions + "\t" + totalPositions + "\t" + duration + "s");
    }
    tableDepths[2] = depth;
    
    // Append the information to a file here
    writeBytesToFile(directory + "edges_o.txt", edges_o_table);
}

void create_corners_o_table()   {
    println("[*]\tCreating Orientation Tables for: corners");
    Cube2 c = new Cube2();
    int depth = 0, h = 0;
    String[] movechars = {"U", "L", "F", "R", "B", "D"};
    
    println("Initialising corners o tables");
    for (int i = 0; i < corners_o_table.length; i++)  {
        corners_o_table[i] = - 1;
    }
    
    corners_o_table[c.encode_corners_o()] = 0;
    int newPositions = 1, totalPositions = 1;
    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"corners_o_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s");
    while(newPositions != 0) {
        newPositions = 0;
        for (int pos = 0; pos < 2187; pos++) {
            if (corners_o_table[pos] != depth) continue;
            c.decode_corners_o(pos);
            
            for (String move : movechars)    {
                for (int i = 0; i < 3; i++)    {
                    c.move(move);
                    h = c.encode_corners_o();
                    if (corners_o_table[h] == - 1)  {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        corners_o_table[h] = bresult;
                        newPositions++;
                    }
                }
                if (move != "D")   c.move(move);
            }
        }
        depth++;
        totalPositions += newPositions;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newPositions + "\t" + totalPositions + "\t" + duration + "s");
    }
    tableDepths[1] = depth;
    try {
        FileOutputStream stream = new FileOutputStream(directory + "corners_o.txt");
        stream.write(corners_o_table);
        println("Saved corners_o.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_e_slice_table()  {
    String[] moves = {"U", "U2", "U'", "L", "L2", "L'", "F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'"};
    int depth = 0, totalStates = 0, newStates = 1;
    Cube2 c = new Cube2();
    
    e_slice_tables(12, 4);
    
    // Inititialise table default values
    for (int i = 0; i < eslice_table.length; i++)  {
        eslice_table[i] = - 1;
    }
    
    // 000011110000 is e-slice - Integer val is 240 -> index 69
    eslice_table[comb_to_index[c.encode_eslice()]] = 0; 
    // solved state is 0 as no moves are required to reach the solved state.
    // Index value of 69
    println(comb_to_index[c.encode_eslice()]);
    // Keep going until no new states have been discovered at depth n
    while(newStates != 0)    {
        // Reset new positions
        newStates = 0;
        // For every i
        for (int i = 0; i < eslice_table.length; i++) {
            // If eslice_table has a value that's not equal to the depth then continue
            if (eslice_table[i] != depth) continue;
            for (String move : moves) {
                // Converts the cube's state according to the integer passed.
                c.decode_eslice(index_to_comb.get(i));
                // Apply move to cube.
                c.testAlgorithm(move);
                // Check if index returned is -1 (No state for this index val)
                if (comb_to_index[c.encode_eslice()] == - 1)    continue;
                // If this cube state has an invalid / default distance value
                if (eslice_table[comb_to_index[c.encode_eslice()]] == -1) {
                    // Set distance value
                    eslice_table[comb_to_index[c.encode_eslice()]] = depth + 1;
                    // Iterate the number of new states that have been found thus far
                    newStates++;
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
    }
    int counter = 0;
    for (int i = 0; i < eslice_table.length; i++)   {
        if (eslice_table[i] != - 1)   {
            c.decode_eslice(i);
            println("[" + i + "] " + eslice_table[i] + "\t" + c.encode_eslice());
            counter++;
        }
    }
    println(counter + " eslice unique states");
}

// Thistle G2 -> G3
void create_ms_slice_table()    {
    String[] moves = {
        "U", "U2", "U'", 
        "L2", "F2", "R2", "B2", 
        "D", "D2", "D'"};
    
    int depth = 0, totalStates = 0, newStates = 1;
    Cube2 c = new Cube2();
    ms_slice_tables(12, 4);
    
    // Initialise table default values
    for (int i = 0; i < eslice_table.length; i++)  {
        ms_slice_table[i] = - 1;
    }
    // 010100000101 - solved state ms slice
    println("Index: " + ms_comb_to_index[c.encode_ms_slice()] + "\tStore: " + c.encode_ms_slice());
    ms_slice_table[ms_comb_to_index[c.encode_ms_slice()]] = 0;
    while(newStates != 0)    {
        newStates = 0;

        for (int i = 0; i < ms_slice_table.length;i++)   {

            if (ms_slice_table[i] != depth)  continue;

            for (String move : moves)    {

                c.decode_ms_slice(ms_index_to_comb.get(i));

                c.testAlgorithm(move);
                if (ms_comb_to_index[c.encode_ms_slice()] == - 1)    continue;
                if (ms_slice_table[ms_comb_to_index[c.encode_ms_slice()]] == - 1)   {
                    // Set distance val
                    ms_slice_table[ms_comb_to_index[c.encode_ms_slice()]] = depth + 1;
                    newStates++;
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
    }
    int counter = 0; 
    // For debugging purposes.
    for (int i = 0; i < ms_slice_table.length; i++)   {
        if (ms_slice_table[i] != - 1)   {
            // c.decode_ms_slice(i);
            counter++;
            // println("[" + i + "] " + ms_slice_table[i] + "\t" + c.encode_ms_slice());
        }
    }
    println(counter + " M/S Slice Unique States");
    
}
// Thistle G2 -> G3
void create_tetrad_table()  {
    tetrad_table = new int[40320];
    String[] moves = {
        "U", "U2", "U'", 
        "L2", "F2", "R2", "B2", 
        "D", "D2", "D'"};
    
    int depth = 0, totalStates = 0, newStates = 1;
    Cube2 c = new Cube2();
    tetrad_tables(8, 4);
    // Inititialise table default values
    for (int i = 0; i < tetrad_table.length; i++)  {
        tetrad_table[i] = - 1;
    }

    // println(tetrad_comb_to_index[c.encode_tetrad()]);
    long start = System.currentTimeMillis();
    tetrad_table[tetrad_comb_to_index[c.encode_tetrad()]] = 0;
    println("Generating complete pruning table \"tetrad_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");
    while(newStates != 0)   {
        newStates = 0;

        for (int i = 0; i < tetrad_table.length; i++)    {

            if (tetrad_table[i] != depth) continue;

            for (String move : moves)    {
                
                c.decode_tetrad(tetrad_index_to_comb.get(i));

                c.testAlgorithm(move);

                if (tetrad_comb_to_index[c.encode_tetrad()] == -1) continue;
                
                if (tetrad_table[tetrad_comb_to_index[c.encode_tetrad()]] == - 1)   {
                    tetrad_table[tetrad_comb_to_index[c.encode_tetrad()]] = depth + 1;
                    newStates++; 
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newStates + "\t" + totalStates + "\t" + duration + "s");
    }
    int counter = 0;
    // For debugging purposes.
    for (int i = 0; i < tetrad_table.length; i++)   {
        if (tetrad_table[i] != - 1)   {
            counter++;
        }
    }
    println(counter + " unique states");
}
// Thistle G3 -> G4 (663,552	(4!^5/12))
// void create_double_turn_table() {
//     String[] moves = {"U2", "L2", "F2", "R2", "B2", "D2"};
//     int depth = 0, totalStates = 0, newStates = 1;
//     Cube2 c = new Cube2();
//     double_turn_table = new int[663552];
//     for(int i = 0; i < double_turn_table.length; i++)   {
//         double_turn_table[i] = -1;
//     }

//     double_turn_table[0] = 0;
//     while(newStates != 0)   {
//         newStates = 0;
//         for(int i = 0; i < double_turn_table.length; i++)   {
//             if(double_turn_table[i] != depth) continue;
//             for(String move : moves)    {
                
//                 if(double_turn_table[] == -1)   continue;

//             }
//         }
//     }

// }

// Thistle G1 -> G2
void create_es_co_table()   {
    es_co_table = new byte[2187*495];
    int depth = 0, totalStates = 0, newStates = 1;
    String[] moves = {"U", "U2", "U'", "L", "L2", "L'", "F2", "R", "R2", "R'", "B2", "D", "D2", "D'"};
    for(int i = 0; i < es_co_table.length; i++) {
        es_co_table[i] = -1;
    }
    // Fresh cube
    Cube2 c = new Cube2();
    // create_e_slice_table();
    e_slice_tables(12, 4);
    // e slice index
    int eslice_index = comb_to_index[c.encode_eslice()];
    // corner orientation index
    int corner_o_index = c.encode_corners_o();
    
    es_co_table[eslice_index * 2187 + corner_o_index] = 0;

    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"es_co_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");
    println(es_co_table.length);
    while(newStates != 0)    {
        // Reset new states
        newStates = 0;
        for(int i = 0; i < 2187; i++)  {
            for(int j = 0; j < 495; j++)    {
                // println(i, j);
                // println("Checking " + i, j);
                if(es_co_table[j * 2187 + i] != depth)   continue;
                // print(j, index_to_comb.size() ,index_to_comb.get(j));
                for(String move : moves)    {
                    // Convert index to new cube e slice sub state
                    c.decode_eslice(index_to_comb.get(j));
                    // Convert index to new cube corner orientation sub state
                    c.decode_corners_o(i);
                    // Test move on new cube state
                    c.testAlgorithm(move);
                    // The lexi index values corresponding to substate
                    eslice_index = comb_to_index[c.encode_eslice()];
                    corner_o_index = c.encode_corners_o();

                    int combined_index = eslice_index * 2187 + corner_o_index;
                    // If pruning table has an invalid entry, replace with depth value
                    if(es_co_table[combined_index] == -1) {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        es_co_table[combined_index] = bresult;
                        newStates++;
                    }
                    // Reset cube
                    c = new Cube2();
                }
            }
        }
        depth++;
        totalStates += newStates;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newStates + "\t" + totalStates + "\t" + duration + "s");
    }
    // Count valid entries that aren't -1
    // int counter = 0;
    // for(int i = 0; i < es_co_table.length; i++)  {
    //     if(es_co_table[i] != -1) {
    //         counter++;
    //     }
    // }
    // print("es_co_table: " + counter);
    try {
        FileOutputStream stream = new FileOutputStream(directory + "es_co_table.txt");
        stream.write(es_co_table);
        println("Saved es_co_table.txt");
    } catch(Exception e) {
        print(e);
    }
}

// Thistle G2 -> G3
void create_tetrad_ms_table()   {
    // 40320 - tetrad
    // 70 - ms slice 8C4
    tetrad_ms_table = new byte[40320*70];
    int depth = 0, totalStates = 0, newStates = 1;
    String[] moves = {"U", "U2", "U'", "L2", "F2", "R2", "B2", "D", "D2", "D'"};
    for(int i = 0; i < tetrad_ms_table.length; i++) {
        tetrad_ms_table[i] = -1;
    }
    // Initialises comb to index and index to comb arrays to retrieve lexi indexes.
    create_ms_slice_table();
    // Fresh cube
    Cube2 c = new Cube2();
    int tetrad_index = c.encode_corners_p();
    int ms_slice_index = ms_comb_to_index[c.encode_ms_slice()];
    tetrad_ms_table[tetrad_index * 70 + ms_slice_index] = 0;

    for(int i = 0; i < ms_slice_table.length; i++) {
        if(i != -1) {
            println(i, ms_slice_table[i]);
        }
    }
    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"tetrad_ms_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");

    while(newStates != 0)   {
        newStates = 0;
        for(int i = 0; i < 70; i++)  {
            for(int j = 0; j < 40320; j++)  {
                if(tetrad_ms_table[j * 70 + i] != depth)    continue;
                // println("Got one");
                for(String move : moves)    {

                    c.decode_ms_slice(ms_index_to_comb.get(i));
                    c.decode_corners_p(j);

                    c.testAlgorithm(move);

                    ms_slice_index = c.encode_ms_slice();
                    if(ms_slice_index == -1)    
                        ms_slice_index = 0;
                    tetrad_index = c.encode_corners_p();
                    // println(tetrad_index + " * 70 + " + ms_slice_index + "\t" + (tetrad_index * 70 + ms_slice_index));
                    int combined_index = tetrad_index * 70 + ms_slice_index;

                    if(tetrad_ms_table[combined_index] == -1)   {
                        int result = depth+1;
                        byte bresult = (byte)result;
                        tetrad_ms_table[combined_index] = bresult;
                        newStates++;
                    }
                    c = new Cube2();
                }
            }
        }
        depth++;
        totalStates += newStates;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newStates + "\t" + totalStates + "\t" + duration + "s");
    }
    try {
        FileOutputStream stream = new FileOutputStream(directory + "tetrad_ms_table.txt");
        stream.write(tetrad_ms_table);
        println("Saved tetrad_ms_table.txt");
    } catch(Exception e) {
        print(e);
    }
}

// Primarily for kociemba's but can be used for thistlethwaite's
void e_slice_tables(int n, int k)    {
    // 2**n
    // Calculate size of array
    int size = 2;

    for (int i = 0; i < n - 1; i++)
        // println(i, size);
        size *= 2;
    // Initialise Arrays
    comb_to_index = new int[size];
    index_to_comb = new ArrayList(); // Custom size
    
    int j = 0;
    // For every index position in the array
    for (int i = 0; i < size; i++)  {
        // Check if the integer in bit format has k '1' bits
        //  (If there are 4 e slice edges in either s/e slices then save it)
        if (bitcount(i) == k)  { // if edge_count has four 1s, save the index, save the combination.
            comb_to_index[i] = j;
            index_to_comb.add(i);
            j++;
        } else {
            comb_to_index[i] = - 1;
        }
    }
    j = 0;
}

void ms_slice_tables(int n, int k)   {
    int size = 2;

    for (int i = 0; i < n - 1; i++)
        size *= 2;
    
    ms_comb_to_index = new int[size];
    ms_index_to_comb = new ArrayList(); // Custom size

    int j = 0;
    for (int i = 0; i < size; i++)   {
        if (bitcount(i) == k) { // if edge_count has four 1s, save the index, save the combination.
            ms_comb_to_index[i] = j;
            ms_index_to_comb.add(i);
            j++;
        } else {
            ms_comb_to_index[i] = -1;
        }
    }
    
}


void tetrad_tables(int n, int k) {
    int size = 2;
    for (int i = 0; i < n - 1; i++)
        size *= 2;
    
    tetrad_comb_to_index = new int[size];
    tetrad_index_to_comb = new ArrayList(); // Custom size
    int j = 0;
    for (int i = 0; i < size; i++)   {
        if (bitcount(i) == k) { // if edge_count has four 1s, save the index, save the combination.
            tetrad_comb_to_index[i] = j;
            tetrad_index_to_comb.add(i);
            j++;
        } else {
            tetrad_comb_to_index[i] = - 1;
        }
    }
}

// Returns bits of number passed in
int bitcount(int state)    {
    return java.lang.Integer.bitCount(state);
}

/**
* Prune Search Tree
* @param    c       Cube we're analysing
* @param    depth   Depth of the search
* @return   boolean Boolean determining...
*/
boolean prune(Cube2 c, int depth)   {
    if (edges_p_table[c.encode_edges_p()] > depth) return true;
    if (corners_p_corners_o_table[c.encode_corners_p_corners_o()] > depth) return true;
    if (edges_o_table[c.encode_edges_o()] > depth) return true;
    return false;
}

/**
* Prune Search Tree for Thistlethwaite's Algorithm
* @param    c       Cube we're analysing
* @param    depth   Depth of the search
* @param    stage   stage we're pruning
* @return   boolean Boolean determining...
*/
boolean prune(int method, Cube2 c, int depth, int stage)  {
    // Methods
    // 1 - Thistlethwaites
    // 2 - Kociembas
    switch(method)  {
        // Thistlethwaites
        case 1:
            switch(stage)   {
                case 1:
                    if (edges_o_table[c.encode_edges_o()] > depth)
                        return true;
                    break;
                case 2:
                    // if (corners_o_table[c.encode_corners_o()] > depth || eslice_table[comb_to_index[c.encode_eslice()]] > depth)
                    if(es_co_table[comb_to_index[c.encode_eslice()] * 2187 + c.encode_corners_o()] > depth)
                        return true;
                    break;
                case 3:
                // M/S slice - 70
                // Tetrad - 40,320
                    if (ms_slice_table[ms_comb_to_index[c.encode_ms_slice()]] > depth || 
                    tetrad_table[tetrad_comb_to_index[c.encode_tetrad()]] > depth)   
                        return true;
                    break;
                case 4:
                    if(edges_p_table[c.encode_edges_p()] > depth ||
                        corners_p_table[c.encode_corners_p()] > depth)
                    // if (prune(c, depth))
                        return true;
                    break;
            }
            break;
        // Kociembas
        case 2:
            switch(stage)   {
                case 1:
                    if(edges_o_table[c.encode_edges_o()] > depth ||
                        corners_o_table[c.encode_corners_o()] > depth || eslice_table[comb_to_index[c.encode_eslice()]] > depth
                        )
                        return true;
                    break;
                case 2:
                    // print("idk yet ngl");
                    if (prune(c, depth)) 
                        return true;
                        // return false;
                    break;
            }
        break;
    }
    return false;
}

/**
* Kociemba's Pruning Function
* ""
* ""
* ""
* ""
*/
// boolean prune(Cube2 c, int depth, int stage)    {

// }

/**
* Reads specified pruning table to appropriate array.
* @param    pieceType   The pieces we're collecting data for
* @param    filename    The file we're reading from
* @return   param       If the file has been read, return true
*/
boolean read_table_to_array(String pieceType, String filename) {
    byte[] tmp;
    switch(pieceType)  {
        case "eo":
        File edges_o_file = new File(directory + "edges_o.txt");
        tmp = readBytesToArray(edges_o_file);
        if (tmp.length == 0) {
            return false;
        } else {
            edges_o_table = tmp;
        }
        break;
        case "ep":
        File edges_p_file = new File(directory + "edges_p.txt");
        tmp = readBytesToArray(edges_p_file);
        if (tmp.length == 0) {
            return false;
        } else {
            edges_p_table = tmp;
        }
        break;
        case "cop":
        File corners_op_file = new File(directory + "corners_op.txt");
        tmp = readBytesToArray(corners_op_file);
        if (tmp.length == 0) {
            return false;
        } else {
            corners_p_corners_o_table = tmp;
        }
        break;
        case "co":
            File corners_o_file = new File(directory + "corners_o.txt");
            tmp = readBytesToArray(corners_o_file);
            if (tmp.length == 0) {
                return false;
            } else {
                corners_o_table = tmp;
            }
        break;
        case "es_co":
            File es_co_file = new File(directory + "es_co_table.txt");
            tmp = readBytesToArray(es_co_file);
            if (tmp.length == 0) {
                return false;
            } else {
                es_co_table = tmp;
            }
    }
    return true;
}

/**
* Writes the byte values to a file
* @param    fileOutput
* @param    bytes
*/
void writeBytesToFile(String fileOutput, byte[] bytes)  {
    try {
        FileOutputStream fos = new FileOutputStream(fileOutput);
        fos.write(bytes);
    } catch(IOException e) {
        print("didn't save: " + e);
    }
}

/**
* https://howtodoinjava.com/java/io/read-file-content-into-byte-array/
* Reads file contents to the appropriate array.
* @param    file    
* @return   byte[]  
*/
byte[] readBytesToArray(File file)  {
    FileInputStream fileInputStream = null;
    byte[] bFile = new byte[(int) file.length()];
    try
    {
        //convert file into array of bytes
        fileInputStream = new FileInputStream(file);
        fileInputStream.read(bFile);
        fileInputStream.close();
    }
    catch(Exception e)
    {
        e.printStackTrace();
        return new byte[0];
    }
    return bFile;
}
