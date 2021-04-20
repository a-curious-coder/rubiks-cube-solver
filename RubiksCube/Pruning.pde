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

int[] ms_slice_table = new int[70];
int[] ms_comb_to_index = new int[4096];
ArrayList<Integer> ms_index_to_comb = new ArrayList(); // Custom size

int[] half_turn_table;
int[] half_turn_comb_to_index;
ArrayList<Integer> half_turn_index_to_comb;

byte[] corner_p_g3_table;
byte[] corners_o_table = new byte[2187];
byte[] corners_p_table = new byte[96];

int[] double_turn_table = new int[663552];

// Kociemba
byte[] es_co_table = new byte[2187*495];
byte[] es_eo_table = new byte[495*2048];
byte[] eo_co_table = new byte[2187*2048];
byte[] es_eo_co_table;
byte[] corner_p_ms_table = new byte[40320*70];

int[] tableDepths = new int[3];

String directory = System.getProperty("user.dir");

// Load the pruning tables to the corresponding byte arrays
void loadPruningTables() {
    println(System.getProperty("user.dir"));
    String path = "\\pruningtables\\";
    File dir = new File(path);
    if(!dir.exists())   {
        if(dir.mkdir())   {
            println("Directory \"" + path + "\" created successfully.");
        } else {
            println("Directory \"" + path + "\" NOT created successfully.");
        }
    } else {
        println("Pruning table folder: \"" + path + "\" already exists");
    }
    println(directory);
    String oldDir = directory;
    directory += path;
    println(directory);
    // Load file for each edge/corner permutation/orientation
    // If file is empty, create appropriate table and save to file
    // If file has contents, store them to appropriate array

    long start = System.currentTimeMillis();
    int count = 0;
    for(int i = 0; i < checkbox.getItems().size(); i++) {
        if(checkbox.getItem(i).getState())  {
            count++;
        }
    }

    if(count == 0)  {
        checkbox.activateAll();
    }
    
    if(checkbox.getItem(0).getState())    {
        if(edges_o_table[0] == 0)    { // If table is already loaded, no need to load it again.
            if (read_table_to_array("eo"))    {
                gPrint("Loaded edges_o.txt");
                outputBox.setLabel("Loaded edges_o.txt");
            } else {
                gPrint("Creating edges_o.txt");
                outputBox.setLabel("Creating edges_o.txt");
                create_edges_o_table();
            }
        }
    } else {
        // Resets pruning table values to defaults - becoming useless. (For when we don't want to use certain tables)
        if(edges_o_table[0] != 0)  { 
            gPrint("Unloading edoptioges_o pruning table.");
            for(byte b : edges_o_table) {
                b = 0;
            }
        }
    }

    if(checkbox.getItem(1).getState())    {
        if(edges_p_table[0] == 0)    { 
            if (read_table_to_array("ep"))    {
                gPrint("Loaded edges_p.txt");
            } else  {
                gPrint("Creating edges_p.txt");
                create_edges_p_table();
            }
        }
    } else {
        if(edges_p_table[0] != 0)    {
            gPrint("Unloading edges_p pruning table.");
            for(byte b : edges_p_table) {
                b = 0;
            }
        }
    }

    if(checkbox.getItem(2).getState())    {
        if(corners_o_table[0] == 0)    { 
            if (read_table_to_array("co"))  {
                gPrint("Loaded Corner Orientation Table");
            } else {
                gPrint("Creating corners_o.txt");
                create_corners_o_table();
            }
        }
    } else {
        if(corners_o_table[0] != 0)    {
            gPrint("Unloading corners_o pruning table.");
            for(byte b : corners_o_table) {
                b = 0;
            }
        }
    }
    
    if(checkbox.getItem(3).getState())    {
        if(corners_p_corners_o_table[0] == 0)    { 
            if (read_table_to_array("cop")) {
                gPrint("Loaded corners_op.txt");
            } else {
                gPrint("Creating corners_op.txt");
                create_corners_op_table();
            }
        }
    } else {
        if(corners_p_corners_o_table[0] != 0)    { 
            gPrint("Unloading corners_p_corners_o_table pruning table.");
            for(byte b : corners_p_corners_o_table) {
                b = 0;
            }
        }
    }
    
    if(checkbox.getItem(4).getState())    {
        if(es_co_table[0] == 0)    { 
            if(read_table_to_array("es_co")) {
                gPrint("Loaded es_co_table.txt");
            } else {
                gPrint("Creating es_co_table.txt");
                create_es_co_table();
            }
        }
    } else {
        if(es_co_table[0] != 0)    { 
            gPrint("Unloading  es_co_table pruning table.");
            for(byte b : es_co_table) {
                b = 0;
            }
        }
    }

    if(checkbox.getItem(5).getState())    {
        if(corner_p_ms_table[0] == 0)    { 
            if(read_table_to_array("cp_ms")) {
                gPrint("Loaded corner_p_ms_table.txt");
            } else {
                gPrint("Creating corner_p_ms_table.txt");
                create_corner_p_ms_table();
            }
        }
    } else {
        // gPrint(corner_p_ms_table[0] + "");
        if(corner_p_ms_table[0] != 0)    { 
            gPrint("Unloading  corner_p_ms_table pruning table.");
            for(byte b : corner_p_ms_table) {
                b = 0;
            }
        }
    }

    if(checkbox.getItem(6).getState())    {
        create_e_slice_table();
        gPrint("Generated E Slice Table");
    }

    if(checkbox.getItem(7).getState())    {
        create_ms_slice_table();
        gPrint("Generated MS Slice Table");
    }

    if(checkbox.getItem(8).getState())    {
        if(es_eo_table[0] == 0)    { 
            if(read_table_to_array("es_eo")) {
                gPrint("Loaded es_eo_table.txt");
            } else {
                gPrint("Creating es_eo_table.txt");
                create_es_eo_table();
            }
        }
    } else {
        // gPrint(es_eo_table[0] + "");
        if(es_eo_table[0] != 0)    { 
            gPrint("Unloading  es_eo_table pruning table.");
            for(byte b : es_eo_table) {
                b = 0;
            }
        }
    }

    if(checkbox.getItem(9).getState())    {
        if(eo_co_table[0] == 0)    { 
            if(read_table_to_array("eo_co")) {
                gPrint("Loaded eo_co_table.txt");
            } else {
                gPrint("Creating eo_co_table.txt");
                create_eo_co_table();
            }
        }
    } else {
        // gPrint(es_eo_table[0] + "");
        if(eo_co_table[0] != 0)    { 
            gPrint("Unloading  eo_co_table pruning table.");
            for(byte b : eo_co_table) {
                b = 0;
            }
        }
    }

    // create_K1_table(); // Limited by array size - have to incorporate wrangling later
    // create_half_turn_table();
    // create_double_turn_table();
    long end = System.currentTimeMillis();
    float duration = (end - start) / 1000F;
    gPrint("Took " + duration + "s to load all pruning tables");
    threadRunning = false;
    if(count == 0)  {
        checkbox.deactivateAll();
    }

    directory = oldDir;
}

// Creates the appropraite pruning tables and stores contents to the appropriate files
void create_corners_op_table()   {
    gPrint("[*]\tCreating Permutation and Orientation Tables for: corners");
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
    writeBytesToFile(directory + "corners_op.txt", corners_p_corners_o_table);
}

void create_edges_p_table() {
    gPrint("[*]\tCreating Permutation Tables for: edges");
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
        gPrint("Saved edges_p.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_edges_o_table()  {
    gPrint("[*]\tCreating Orientation Tables for: edges");
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
    
    // Write the information to a file here
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

    writeBytesToFile(directory + "corners_o.txt", corners_o_table);
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
}

// Thistle G2 -> G3 INEFFICIENT
void create_ms_slice_table()    {
    String[] moves = {
        "U", "U2", "U'", 
        "L2", "F2", "R2", "B2", 
        "D", "D2", "D'"};
    
    int depth = 0, totalStates = 0, newStates = 1;
    Cube2 c = new Cube2();
    ms_slice_tables(8, 4);
    
    // Initialise table default values
    for (int i = 0; i < ms_slice_table.length; i++)  {
        ms_slice_table[i] = - 1;
    }
    // 010100000101 - solved state ms slice
    println("Index: " + ms_comb_to_index[c.encode_ms_slice()] + "\tStore: " + c.encode_ms_slice());
    ms_slice_table[ms_comb_to_index[c.encode_ms_slice()]] = 0;

    while(newStates != 0)    {
        newStates = 0;

        for (int i = 0; i < ms_slice_table.length; i++)   {
            if (ms_slice_table[i] != depth)  continue;

            for (String move : moves)    {
                c.decode_ms_slice(ms_index_to_comb.get(i));
                c.testAlgorithm(move);
                int ms_index = ms_comb_to_index[c.encode_ms_slice()];

                if (ms_slice_table[ms_index] == - 1)   {
                    // println(ms_index, "\t", ms_index_to_comb.get(i));
                    // Set distance val
                    ms_slice_table[ms_index] = depth + 1;
                    newStates++;
                }
                c = new Cube2();
            }
        }
        depth++;
        totalStates += newStates;
    }
    // int counter = 0; 
    // // For debugging purposes.
    // for (int i = 0; i < ms_slice_table.length; i++)   {
    //     if (ms_slice_table[i] != - 1)   {
    //         // c.decode_ms_slice(i);
    //         counter++;
    //         // println("[" + i + "] " + ms_slice_table[i] + "\t" + c.encode_ms_slice());
    //     }
    // }
    // println(counter + " M/S Slice Unique States");
}

// Thistle G2 -> G3 OLD
void create_half_turn_table()  {
    half_turn_table = new int[40320];

    // half_turn_comb_to_index = new int[40320];
    // half_turn_index_to_comb = new ArrayList();

    String[] moves = { "U2", "L2", "F2", "R2", "B2", "D2"};
    
    int depth = 0, totalStates = 0, newStates = 1, ctr = 0;
    Cube2 c = new Cube2();
    // Inititialise table default values
    for (int i = 0; i < half_turn_table.length; i++)  {
        half_turn_table[i] = - 1;
    }

    half_turn_table[c.encode_corners_p()] = 0;
    // half_turn_index_to_comb.add(c.encode_corners_p());
    // half_turn_comb_to_index[half_turn_index_to_comb.get(ctr)] = 0;
    // ctr++;
    // half_turn_table[half_turn_comb_to_index[c.encode_corners_p()]] = 0;
    // println(half_turn_comb_to_index[c.encode_corners_p()] + "\t" + 0);

    println("Generating complete pruning table \"half_turn_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");

    long start = System.currentTimeMillis();
    while(newStates != 0)   {
        newStates = 0;

        for (int i = 0; i < half_turn_table.length; i++)    {
            if (half_turn_table[i] != depth) continue;
            for (String move : moves)    {
                // Get corner sub state correlating with index i for the cube.
                c.decode_corners_p(i);
                c.testAlgorithm(move); // Apply move to this cube state
                int half_turn_index = c.encode_corners_p();
                // If the specified element of the table has a default value, replace it with a valid distance value.
                if (half_turn_table[half_turn_index] == - 1)   {
                    half_turn_table[half_turn_index] = depth + 1;
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
    // int counter = 0;
    // // For debugging purposes.
    // for (int i = 0; i < half_turn_table.length; i++)   {
    //     if (half_turn_table[i] != - 1)   {
    //         println(counter + "\t[" + i + "]\t" + half_turn_table[i]);
    //         counter++;
    //     }
    // }
    // println(counter + " unique states");
}

void create_es_eo_table()   {
    // es_eo_table = new byte[495*2048];
    int depth = 0, totalStates = 0, newStates = 1;
    String[] moves = {"U", "U2", "U'", "L", "L2", "L'","F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'"};
    for(int i = 0; i < es_eo_table.length; i++) {
        es_eo_table[i] = -1;
    }
    // Fresh cube
    Cube2 c = new Cube2();
    // create_e_slice_table();
    e_slice_tables(12, 4);

    // e slice index
    int eslice_index = comb_to_index[c.encode_eslice()];
    // corner orientation index
    int edge_o_index = c.encode_edges_o();
    
    es_co_table[eslice_index * 2048 + edge_o_index] = 0;

    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"es_eo_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");
    println(es_eo_table.length);
    while(newStates != 0)    {
        // Reset new states
        newStates = 0;
        for(int i = 0; i < 495; i++)  {
            for(int j = 0; j < 2048; j++)    {

                if(es_co_table[i * 2048 + j] != depth)   continue;
                // println("Found 1 ");
                // print(j, index_to_comb.size() ,index_to_comb.get(j));
                for(String move : moves)    {
                    // Convert index to new cube e slice sub state
                    c.decode_eslice(index_to_comb.get(i));
                    // Convert index to new cube corner orientation sub state
                    c.decode_edges_o(j);
                    // Test move on new cube state
                    c.testAlgorithm(move);
                    // The lexi index values corresponding to substate
                    eslice_index = comb_to_index[c.encode_eslice()];
                    edge_o_index = c.encode_edges_o();

                    int combined_index = eslice_index * 2048 + edge_o_index;
                    // println(i, " ", j, " ", combined_index);
                    // If pruning table has an invalid entry, replace with depth value
                    if(es_eo_table[combined_index] == -1) {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        es_eo_table[combined_index] = bresult;
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
    try {
        FileOutputStream stream = new FileOutputStream(directory + "es_eo_table.txt");
        stream.write(es_eo_table);
        println("Saved es_eo_table.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_eo_co_table()   {
    // eo_co_table = new byte[2187*2048];
    int depth = 0, totalStates = 0, newStates = 1;
    String[] moves = {"U", "U2", "U'", "L", "L2", "L'","F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'"};
    for(int i = 0; i < eo_co_table.length; i++) {
        eo_co_table[i] = -1;
    }
    // Fresh cube
    Cube2 c = new Cube2();
    // create_e_slice_table();
    // e_slice_tables(12, 4);

    int corner_o_index = c.encode_corners_o();
    // corner orientation index
    int edge_o_index = c.encode_edges_o();
    
    eo_co_table[corner_o_index * 2048 + edge_o_index] = 0;

    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"eo_co_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");
    println(eo_co_table.length);
    while(newStates != 0)    {
        // Reset new states
        newStates = 0;
        for(int i = 0; i < 2187; i++)  {
            for(int j = 0; j < 2048; j++)    {

                if(eo_co_table[i * 2048 + j] != depth)   continue;
                // println("Found 1 ");
                // print(j, index_to_comb.size() ,index_to_comb.get(j));
                for(String move : moves)    {
                    // Convert index to new cube e slice sub state
                    c.decode_corners_o(i);
                    // Convert index to new cube corner orientation sub state
                    c.decode_edges_o(j);
                    // Test move on new cube state
                    c.testAlgorithm(move);
                    // The lexi index values corresponding to substate
                    corner_o_index = c.encode_corners_o();
                    edge_o_index = c.encode_edges_o();

                    int combined_index = corner_o_index * 2048 + edge_o_index;
                    // println(i, " ", j, " ", combined_index);
                    // If pruning table has an invalid entry, replace with depth value
                    if(eo_co_table[combined_index] == -1) {
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        eo_co_table[combined_index] = bresult;
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
    try {
        FileOutputStream stream = new FileOutputStream(directory + "eo_co_table.txt");
        stream.write(eo_co_table);
        println("Saved eo_co_table.txt");
    } catch(Exception e) {
        print(e);
    }
}
// Thistle G1 -> G2
void create_es_co_table()   {
    // es_co_table = new byte[2187*495];
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
    try {
        FileOutputStream stream = new FileOutputStream(directory + "es_co_table.txt");
        stream.write(es_co_table);
        println("Saved es_co_table.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_K1_table()  {
    // Eslice * EO * CO
    es_eo_co_table = new byte[495*2048*2187];
    int depth = 0, totalStates = 0, newStates = 1;
    String[] moves = {"U", "U2", "U'", "L", "L2", "L'", "F2", "R", "R2", "R'", "B2", "D", "D2", "D'"};
    for(int i = 0; i < es_eo_co_table.length; i++) {
        es_eo_co_table[i] = -1;
    }
    // Fresh cube
    Cube2 c = new Cube2();
    // create_e_slice_table();
    e_slice_tables(12, 4);
    // e slice index
    int eslice_index = comb_to_index[c.encode_eslice()];
    // corner orientation index
    int corner_o_index = c.encode_corners_o();
    int eo_index = c.encode_edges_o();

    // es_index * (2048*2187) + (co_index * 2048 + eo_index)
    // k * (2048*2187) + (i*2048+j)
    es_eo_co_table[eslice_index * (2048*2187)  + (corner_o_index * 2048 + eo_index)] = 0;

    long start = System.currentTimeMillis();
    println("Generating complete pruning table \"es_eo_co_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");
    println(es_eo_co_table.length);
    while(newStates != 0)    {
        // Reset new states
        newStates = 0;
        for(int i = 0; i < 2187; i++)  { // Corners
            for(int j = 0; j < 2048; j++)    { // Edges
                for(int k = 0; k < 495; k++)    { // ES

                    if(es_eo_co_table[k * (2048*2187) + (i*2048+j)] != depth)   continue;

                    for(String move : moves)    {
                        c.decode_corners_o(i);
                        c.decode_edges_o(j);
                        c.decode_eslice(index_to_comb.get(j));

                        // Test move on new cube state
                        c.testAlgorithm(move);

                        // The lexi index values corresponding to substate
                        eslice_index = comb_to_index[c.encode_eslice()];
                        corner_o_index = c.encode_corners_o();
                        eo_index = c.encode_edges_o();

                        int combined_index = eslice_index * (2048*2187)  + (corner_o_index * 2048 + eo_index);
                        // If pruning table has an invalid entry, replace with depth value
                        if(es_eo_co_table[combined_index] == -1) {
                            int result = depth + 1;
                            byte bresult = (byte) result;
                            es_eo_co_table[combined_index] = bresult;
                            newStates++;
                        }
                        // Reset cube
                        c = new Cube2();
                    }
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
        FileOutputStream stream = new FileOutputStream(directory + "es_eo_co_table.txt");
        stream.write(es_eo_co_table);
        println("Saved es_eo_co_table.txt");
    } catch(Exception e) {
        print(e);
    }
}

void create_corner_p_g3_table() {
     // 40320 - tetrad
    // 70 - ms slice 8C4
    byte[] corner_p_g3_table = new byte[40320];
    int depth = 0, totalStates = 0, newStates = 0, count = 0;
    String[] moves = {"U", "U2", "U'", "L2", "F2", "R2", "B2", "D", "D2", "D'"};

    // Initialise pruning table with -1's (Invalid but default values)
    for(int i = 0; i <corner_p_g3_table.length; i++) {
        corner_p_g3_table[i] = -1;
    }
    // Generates all corner perms using only double turns.
    create_half_turn_table();
    // Fresh cube
    Cube2 c = new Cube2();

    // Assign the 96 double turn corner permutations a distance of 0
    for(int i = 0; i < half_turn_table.length; i++)    {
        if(half_turn_table[i] == -1)   continue;
        c.decode_corners_p(i);
        corner_p_g3_table[c.encode_corners_p()] = 0;
        newStates++;
    }
    totalStates += newStates;

    long start = System.currentTimeMillis();
    println("Generating pruning table \"corner_p_g3_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t" + newStates + "\t" + totalStates + "\tN/A");

    while(newStates != 0)   {
        newStates = 0;
        for(int j = 0; j < 40320; j++)  { // corners
            // If distance value isn't equal to the depth value, skip.
            if(corner_p_g3_table[j] != depth)    continue;

            for(String move : moves)    {
                // Get corner perms from j
                c.decode_corners_p(j);
                // Test move on resulting cube state
                c.testAlgorithm(move);

                // Calculate index values
                int corner_p_index = c.encode_corners_p();
                

                // If distance value is default : -1 then set it to depth+1
                if(corner_p_g3_table[corner_p_index] == -1)   {
                    // Create distance value
                    int result = depth+1;
                    // Convert distance value to byte datatype
                    byte bresult = (byte)result;
                    // Add the byte distance value to the pruning table
                    corner_p_g3_table[corner_p_index] = bresult;
                    // Iterate new states value as we just appended a new corner state to the pruning table
                    newStates++;
                }
                // Reset the cube to a solved state
                c = new Cube2();
            }
        }
        // Increase depth
        depth++;
        totalStates += newStates;
        // Stop timer and calculate duration it took to find the previous depth's distance values
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        // Start timer again
        start = System.currentTimeMillis();
        // Print stats to console
        println((int)depth + "\t" + newStates + "\t" + totalStates + "\t" + duration + "s");
    }
    count = 0;
    for(byte i : corner_p_g3_table) {
        if(i != -1) count++;
    }
    println(count, " unique states");
}

// Thistle G2 -> G3
void create_corner_p_ms_table()   {
    // 40320 - tetrad
    // 70 - ms slice 8C4
    // corner_p_ms_table = new byte[40320*70];
    int depth = 0, totalStates = 0, newStates = 0;
    String[] moves = {"U", "U2", "U'", "L2", "F2", "R2", "B2", "D", "D2", "D'"};
    for(int i = 0; i < corner_p_ms_table.length; i++) {
        corner_p_ms_table[i] = -1;
    }
    // Initialises comb to index and index to comb arrays to retrieve lexi indexes.
    create_ms_slice_table();
    // create_corner_p_g3_table();
    create_half_turn_table();
    // Fresh cube
    Cube2 c = new Cube2();

    // Half turn table is populated with 96 unique corner perms
    // Assign the 96 corner permutations a distance of 0
    for(int i = 0; i < half_turn_table.length; i++)    {
        if(half_turn_table[i] == -1)   continue;
        // Index to corner sub-state
        c.decode_corners_p(i);
        for(int j = 0; j < 70; j++) {
            c.decode_ms_slice(ms_index_to_comb.get(j));
            corner_p_ms_table[c.encode_corners_p() * 70 + ms_comb_to_index[c.encode_ms_slice()]] = 0;
            newStates++;
        }
    }
    // corner_p_ms_table[c.encode_corners_p() * 70 + ms_comb_to_index[c.encode_ms_slice()]] = 0;
    // newStates++;
    totalStates += newStates;
    // String[] wank = new String[300];
    long start = System.currentTimeMillis();
    println("Generating pruning table \"corner_p_ms_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t" + newStates + "\t" + totalStates + "\tN/A");

    int count = 0;
    while(newStates != 0)   {
        newStates = 0;
        for(int i = 0; i < 70; i++)  { // ms-slice
            for(int j = 0; j < 40320; j++)  { // corners
                if(corner_p_ms_table[j * 70 + i] != depth)    continue;
                for(String move : moves)    {
                    
                    // Get ms-slice state from i
                    c.decode_ms_slice(ms_index_to_comb.get(i));
                    // Get corner perms from j
                    c.decode_corners_p(j);
                    int reEncodeJ = c.encode_corners_p();
                    // Test move on resulting cube state
                    c.testAlgorithm(move);

                    // Calculate index values
                    int ms_slice_index = ms_comb_to_index[c.encode_ms_slice()];
                    int corner_p_index = c.encode_corners_p();
                    
                    // println(move , "\t", corner_p_index);
                    // c.imageState();

                    // Combine index
                    String perms= "";
                    int combined_index = corner_p_index * 70 +  ms_slice_index;
                    // If distance value is default : -1 then set it to depth+1
                    if(corner_p_ms_table[combined_index] == -1)   {
                        for(int p : c.corners_p)  {
                            perms += p + ", ";
                        }
                        // wank[count] = count + "\t" + i + "\t" + j + "\t" + reEncodeJ + "\t" + move + "\t" + ms_slice_index + "\t" + corner_p_index + "\t\t" + perms;
                        perms = "";
                        count++;
                        // println(count, "\t", move, " ", ms_slice_index, ",  ", j);
                        int result = depth+1;
                        byte bresult = (byte)result;
                        corner_p_ms_table[combined_index] = bresult;
                        newStates++;
                    }
                    c = new Cube2();
                }
            }
        }
        // try {
        //     BufferedWriter outputWriter = null;
        //     outputWriter = new BufferedWriter(new FileWriter(directory+"wank.txt"));
        //     for (int i = 0; i < wank.length; i++) {
        //         if(i == 0)  wank[i] = "State\ti\tj\tre_j\tmove\tmsindex\tcornerpindex\tcorner_perms\n" + wank[i];
        //         // Maybe:
        //         outputWriter.write(wank[i]+"");
        //         outputWriter.newLine();
        //     }
        //     outputWriter.flush();  
        //     outputWriter.close(); 
        // } catch(Exception e) {
        //     print(e);
        // }
        // delay(200000);
        depth++;
        totalStates += newStates;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        println((int)depth + "\t" + newStates + "\t" + totalStates + "\t" + duration + "s");
    }
    writeBytesToFile(directory + "corner_p_ms_table.txt", corner_p_ms_table);
}

// Thistle G3 -> G4
void create_double_turn_table() {
    // Initialising the moveset
    String[] moves = {"U2", "L2", "F2", "R2", "B2", "D2"};
    // Initialising depth, total number of cube states and newly found states values.
    int depth = 0, totalStates = 0, newStates = 1;
    // Initialise blank complete cube
    Cube2 c = new Cube2();
    // Initialise the pruning table at a predetermined size according to: 96 * 6912 (Corner perms * even edge perms)
    double_turn_table = new int[96*6912];

    // Initialise all array index values to -1 acting a placeholders.
    for(int i = 0; i < double_turn_table.length; i++)   {
        double_turn_table[i] = -1;
    }

    // Store distance value 0 for the current complete cube state.
    double_turn_table[c.encode_edges_p() * 96 + c.encode_corners_p()] = 0;

    long start = System.currentTimeMillis();
    println("Generating pruning table \"create_double_turn_table\"\n");
    println("Depth\tNew\tTotal\tTime\n0\t1\t1\tN/A");

    // While there are cube sub-states left to be discovered
    while(newStates != 0)   {
        // Reset new states found to 0
        newStates = 0;
        // For each possible set of corner permutations
        for(int i = 0; i < 96; i++) {
            // For each set of edge perms (bit confused where this num came from?) my guess is the number of perms for the m and s slice arrangements within their own slices?
            for(int j = 0; j < 6912; j++)   {
                // if the table at the specified index is NOT equal to the current depth we're searching, skip this loop.
                if(double_turn_table[j * 96 + i] != depth)  continue;
                // For each available move
                for(String move : moves)    {
                    // Converts cube corner permutations to the corresponding sub state according to the provided lexicographical index
                    c.decode_corners_p(i);
                    // Converts cube edge permutations to the corresponding sub state according to the provided lexicographical index
                    c.decode_edges_p(j);

                    c.testAlgorithm(move);
                    // Calculate the combined index of these substates.
                    println(c.encode_edges_p()," * ", 96, " + ",c.encode_corners_p(), " = ", c.encode_edges_p() * 96 + c.encode_corners_p());
                    int combined_index = c.encode_edges_p() * 96 + c.encode_corners_p();
                    // If the pruning table does not have a valid distance value
                    if(double_turn_table[combined_index] == -1) {
                        // Initialise distance value as byte datatype for cheaper storage
                        int result = depth + 1;
                        byte bresult = (byte) result;
                        // Store the distance value at the combined_index in the pruning table
                        double_turn_table[combined_index] = bresult;
                        // Iterate new states discovered by 1
                        newStates++;
                    }
                    // Reset cube state
                    c = new Cube2();
                }
            }
        }
        // Iterate depth for next stage of search
        depth++;
        // Append number of new states discovered to total states found
        totalStates += newStates;
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        start = System.currentTimeMillis();
        // Print some stats for debugging and visualisation of numbers of pruning table generation...
        println((int)depth + "\t" + newStates + "\t" + totalStates + "\t" + duration + "s");
    }
    // Intentions here would be to save the pruning table array to a file which can be read in to a byte array via other functions I've made.
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
    println("Size: " + size);
    ms_comb_to_index = new int[size];
    ms_index_to_comb = new ArrayList(); // Custom size

    int j = 0;
    for (int i = 0; i < size; i++)   {
        if (bitcount(i) == k) { // if edge_count has four 1s, save the index, save the combination.
            // Save 
            ms_comb_to_index[i] = j;
            ms_index_to_comb.add(i);
            j++;
        } else {
            ms_comb_to_index[i] = -1;
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
                    if (corner_p_ms_table[c.encode_corners_p() * 70 + ms_comb_to_index[c.encode_ms_slice()]] > depth)
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
                    if(es_co_table[comb_to_index[c.encode_eslice()] * 2187 + c.encode_corners_o()] > depth || 
                        eo_co_table[c.encode_corners_o() * 2048 + c.encode_edges_o()] > depth )
                        return true;
                    break;
                case 2:
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
* Reads specified pruning table to appropriate array.
* @param    pieceType   The pieces we're collecting data for
* @param    filename    The file we're reading from
* @return   param       If the file has been read, return true
*/
boolean read_table_to_array(String pieceType) {
    byte[] tmp;
    switch(pieceType)  {
        case "es_eo":
            try{
                File es_eo_file = new File(directory + "es_eo_table.txt");
                tmp = readBytesToArray(es_eo_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    es_eo_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
        case "eo":
            try{
                File edges_o_file = new File(directory + "edges_o.txt");
                tmp = readBytesToArray(edges_o_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    edges_o_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
            break;
        case "ep":
            try{
                File edges_p_file = new File(directory + "edges_p.txt");
                tmp = readBytesToArray(edges_p_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    edges_p_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
            break;
        case "cop":
            try{
                File corners_op_file = new File(directory + "corners_op.txt");
                tmp = readBytesToArray(corners_op_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    corners_p_corners_o_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
            break;
        case "co":
            try{
                File corners_o_file = new File(directory + "corners_o.txt");
                tmp = readBytesToArray(corners_o_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    corners_o_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
            break;
        case "es_co":
            try{
                File es_co_file = new File(directory + "es_co_table.txt");
                tmp = readBytesToArray(es_co_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    es_co_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
            
            break;
        case "cp_ms":
            try{
                File corner_p_ms_file = new File(directory + "corner_p_ms_table.txt");
                tmp = readBytesToArray(corner_p_ms_file);
                if (tmp.length == 0) {
                    return false;
                } else {
                    corner_p_ms_table = tmp;
                }
            } catch(Exception e)    {
                println("Pruning table doesn't exist... Must create one.");
            }
            break;
        case "eo_co":
            try{
                    File eo_co_file = new File(directory + "eo_co_table.txt");
                    tmp = readBytesToArray(eo_co_file);
                    if (tmp.length == 0) {
                        return false;
                    } else {
                        eo_co_table = tmp;
                    }
                } catch(Exception e)    {
                    println("Pruning table doesn't exist... Must create one.");
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
