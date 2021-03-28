import java.nio.channels.FileChannel;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.nio.ByteOrder;
import java.lang.Object;
import java.util.HashMap;

byte[] corners_p_corners_o_table = new byte[88179840];
byte[] edges_p_table = new byte[479001600];
byte[] edges_o_table = new byte[2048];
int[]  eslice_table = new int[495];
int[] comb_to_index = new int[4096];
ArrayList<Integer> index_to_comb = new ArrayList();

int[] ms_slice_table = new int[495];
int[] ms_comb_to_index = new int[4096];
ArrayList<Integer> ms_index_to_comb = new ArrayList(); // Custom size

int[] tetrad_table;
int[] tetrad_comb_to_index;
ArrayList<Integer> tetrad_index_to_comb;
// For thistle
byte[] corners_o_table = new byte[2187];
byte[] corners_p_table = new byte[96];
byte[] slice_table = new byte[1000000];
//Cube2[] thistlethwaite = new byte[];
int[] tableDepths = new int[3];
HashMap<Cube2, Integer> corner_o_hashmap = new HashMap<Cube2, Integer>();
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
    eslice_table[comb_to_index[c.esliceState()]] = 0; // solved state has distance 0
    // Index value of 69.
    println(comb_to_index[c.esliceState()]);
    // Keep going until no new states have been discovered at depth n
    while(newStates != 0)    {
        // Reset new positions
        newStates = 0;
        
        for (int i = 0; i < eslice_table.length; i++) {
            // 
            if (eslice_table[i] != depth) continue;
            
            for (String move : moves) {
                // Converts the cube's state according to the integer passed.
                c.eSliceIndexToState(index_to_comb.get(i));
                // Apply move to cube.
                c.testAlgorithm(move);
                // Check if index returned is -1 (No state for this index val)
                if (comb_to_index[c.esliceState()] == - 1)    continue;
                // If this cube state has no distance value
                if (eslice_table[comb_to_index[c.esliceState()]] == - 1) {
                    // Set distance value
                    eslice_table[comb_to_index[c.esliceState()]] = depth + 1;
                    newStates++;
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
    }
    // For debugging purposes.
    // for(int i = 0; i < eslice_table.length; i++)   {
    //     if(eslice_table[i] != -1)   {
    //         c.eSliceIndexToState(i);
    //         println("[" + i + "] " + eslice_table[i] + "\t" + c.esliceState());
    //     }
// }
    // int counter = 0; 
    // for(int i : eslice_table)   {
    //     if(i != -1) counter++;
// }
    // println(counter + " unique states");
}

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
    println("Index: " + ms_comb_to_index[c.msSliceState()] + "\tStore: " + c.msSliceState());
    ms_slice_table[ms_comb_to_index[c.msSliceState()]] = 0;
    while(newStates != 0)    {
        newStates = 0;
        for (int i = 0; i < ms_slice_table.length;i++)   {
            if (ms_slice_table[i] != depth)  continue;
            for (String move : moves)    {
                c.msSliceIndexToState(ms_index_to_comb.get(i));
                c.testAlgorithm(move);
                if (ms_comb_to_index[c.msSliceState()] == - 1) continue;
                if (ms_slice_table[ms_comb_to_index[c.msSliceState()]] == - 1)   {
                    // Set distance val
                    ms_slice_table[ms_comb_to_index[c.msSliceState()]] = depth + 1;
                    newStates++;
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
    }
    // For debugging purposes.
    for (int i = 0; i < ms_slice_table.length; i++)   {
        if (ms_slice_table[i] != - 1)   {
            c.msSliceIndexToState(i);
            println("[" + i + "] " + ms_slice_table[i] + "\t" + c.msSliceState());
        }
    }
    int counter = 0; 
    for (int i : ms_slice_table)   {
        if (i != - 1) counter++;
    }
    println(counter + " unique states");
    
}

void create_tetrad_table()  {
    String[] moves = {
        "U", "U2", "U'", 
        "L2", "F2", "R2", "B2", 
        "D", "D2", "D'"};
    
    int depth = 0, totalStates = 0, newStates = 1;
    Cube2 c = new Cube2();
    tetrad_tables(8, 4);
    tetrad_table = new int[70];
    // Inititialise table default values
    for (int i = 0; i < tetrad_table.length; i++)  {
        tetrad_table[i] = - 1;
    }
    println(tetrad_comb_to_index[c.tetradState()]);
    tetrad_table[tetrad_comb_to_index[c.tetradState()]] = 0;
    while(newStates != 0)   {
        newStates = 0;
        for (int i = 0; i < tetrad_table.length; i++)    {
            if (tetrad_table[i] != depth) continue;
            for (String move : moves)    {
                c.tetradIndexToState(tetrad_index_to_comb.get(i));
                c.testAlgorithm(move);
                if (tetrad_comb_to_index[c.tetradState()] == - 1) continue;
                
                if (tetrad_table[tetrad_comb_to_index[c.tetradState()]] == - 1)   {
                    tetrad_table[tetrad_comb_to_index[c.tetradState()]] = depth + 1;
                    newStates++; 
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
    }
    // For debugging purposes.
    for (int i = 0; i < tetrad_table.length; i++)   {
        if (tetrad_table[i] != - 1)   {
            c.tetradIndexToState(i);
            println("[" + i + "] " + tetrad_table[i] + "\t" + c.tetradState());
        }
    }
    int counter = 0; 
    for (int i : tetrad_table)   {
        if (i != - 1) counter++;
    }
    println(counter + " unique states");
}

// Primarily for kociemba's but can be used for thistlethwaite's
void e_slice_tables(int n, int k)    {
    // 2**n
    int size = 2;
    for (int i = 0; i < n - 1; i++)
        size *= 2;
    
    comb_to_index = new int[size];
    index_to_comb = new ArrayList(); // Custom size
    
    int j = 0;
    for (int i = 0; i < size; i++)  { 
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
            ms_comb_to_index[i] = - 1;
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

void kocG1Table(int n, int k)   {

}

int bitcount(int edges)    {
    return java.lang.Integer.bitCount(edges);
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
                    if (corners_o_table[c.encode_corners_o()] > depth || eslice_table[comb_to_index[c.esliceState()]] > depth)   
                        return true;
                    break;
                case 3:
                    if (edges_o_table[c.encode_edges_o()] > depth || ms_slice_table[ms_comb_to_index[c.msSliceState()]] > depth || tetrad_table[tetrad_comb_to_index[c.tetradState()]] > depth)   
                        return true;
                    break;
                case 4:
                    if (prune(c, depth)) 
                        return true;
                    break;
            }
            break;
        // Kociembas
        case 2:
            switch(stage)   {
                case 1:
                    if(edges_o_table[c.encode_edges_o()] > depth ||
                        corners_o_table[c.encode_corners_o()] > depth || eslice_table[comb_to_index[c.esliceState()]] > depth
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
