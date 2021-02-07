import java.nio.channels.FileChannel;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.nio.ByteOrder;
import java.lang.Object;
byte[] corners_p_corners_o_table = new byte[88179840];
byte[] edges_p_table = new byte[479001600];
byte[] edges_o_table = new byte[2048];
int[] tableDepths = new int[3];
String directory = "/Users/callummclennan/Desktop/Sync-Folder/rubiks-cube-solver/RubiksCube/";

/**
* Load the pruning tables to the corresponding byte arrays
*/
void loadPruningTables() {
        // Load file for each edge/corner permutation/orientation
        // If file is empty, create appropriate table and save to file
        // If file has contents, store them to appropriate array
        long start = System.currentTimeMillis();
        if(read_table_to_array("eo", "edges_o.txt"))    {
            println("Loaded edges_o.txt");
        } else {
            println("Creating edges_o.txt");
            create_edges_o_table();
        }
            
        if(read_table_to_array("cop", "corner_op.txt")) {
            println("Loaded corners_op.txt");
        } else {
            println("Creating corners_op.txt");
            create_corners_op_table();
        }
        
        if(read_table_to_array("ep", "edges_p.txt"))    {
            println("Loaded edges_p.txt");
        } else  {
            println("Creating edges_p.txt");
            create_edges_p_table();
        }
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
        for(int i = 0; i < corners_p_corners_o_table.length; i++)  {
            corners_p_corners_o_table[i] = -1;
        }

        corners_p_corners_o_table[c.encode_corners_p_corners_o()] = 0;
        int newPositions = 1, totalPositions = 1;
        long start = System.currentTimeMillis();
        println("Generating complete pruning table \"corners_p_corners_o_table\"\n");
        println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s");
        while(newPositions != 0){
            newPositions = 0;
            for(int pos = 0; pos < 88179840; pos++){
                if(corners_p_corners_o_table[pos] != depth) continue;
                c.decode_corners_p_corners_o(pos);

                for(String move : movechars)    {
                    for(int i = 0; i < 3; i++)    {
                        c.move(move);
                        h = c.encode_corners_p_corners_o();
                        if(corners_p_corners_o_table[h] == -1)  {
                            int result = depth + 1;
                            byte bresult = (byte) result;
                            corners_p_corners_o_table[h] = bresult;
                            newPositions++;
                        }
                    }
                    if(move != "D")   c.move(move);
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
            FileOutputStream stream = new FileOutputStream(directory+"corners_op.txt");
            stream.write(corners_p_corners_o_table);
            println("Saved corners_op.txt");
        } catch (Exception e) {
            print(e);
        }
    }

void create_edges_p_table() {
        println("[*]\tCreating Permutation Tables for: edges");
        Cube2 c = new Cube2();
        String[] movechars = {"U", "L", "F", "R", "B", "D"};
        int depth = 0;
        int h = 0;
        // Initialise all array variables
        for(int i = 0; i < edges_p_table.length; i++)  {
            edges_p_table[i] = -1;
        }
        println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s");
        edges_p_table[c.encode_edges_p()] = 0;
        int newPositions = 1, totalPositions = 1;
        int count = 0;
        long start = System.currentTimeMillis();
        while(newPositions != 0){
            newPositions = 0;
            for(int pos = 0; pos < 479001600; pos++){
                if(edges_p_table[pos] != depth){
                    continue;
                }
                c.decode_edges_p(pos);
                count = 0;
                for(String move : movechars)    {
                    for(int i = 0; i < 3; i++)    {
                        c.move(move);
                        h = c.encode_edges_p();
                        if(edges_p_table[h] == -1)  {
                            int result = depth + 1;
                            byte bresult = (byte) result;
                            edges_p_table[h] = bresult;
                            newPositions++;
                        }
                    }
                    if(move != "D") c.move(move);
                    count++;
                }
            }
            depth++;
            totalPositions += newPositions;
            long end = System.currentTimeMillis();
            float duration = (end - start) / 1000F;
            start = System.currentTimeMillis();
            println((int)depth + "\t" + newPositions + "\t" + totalPositions + "\t" + duration + "s");
        }
        tableDepths[0] = depth;
        try {
            FileOutputStream stream = new FileOutputStream(directory+"edges_p.txt");
            stream.write(edges_p_table);
            println("Saved edges_p.txt");
        } catch (Exception e) {
            print(e);
        }
    }

void create_edges_o_table()  {
    println("[*]\tCreating Orientation Tables for: edges");
        Cube2 c = new Cube2();
        int depth = 0;
        int h;
        // Set default orientation values to -1
        for(int i = 0; i < edges_o_table.length; i++)  {
            edges_o_table[i] = -1;
        }
        edges_o_table[c.encode_edges_o()] = 0;
        int newPositions = 1, totalPositions = 1;
        long start = System.currentTimeMillis();
        println("Generating complete pruning table \"edges_o_table\"\n");
        println("Depth\tNew\tTotal\tTime\n0\t1\t1\t0.00s\n");
        while(newPositions != 0)    {
            newPositions = 0;
            for(int pos = 0; pos < 2048; pos++) {
                if(edges_o_table[pos] != depth)   continue;
                c.decode_edges_o(pos);
                // 6 moves
                String[] movechars = {"U", "L", "F", "R", "B", "D"};
                for(String move : movechars)    {
                    for(int i = 0; i < 3; i++)    {
                        c.move(move);
                        h = c.encode_edges_o();
                        if(edges_o_table[h] == -1)  {
                            int result = depth + 1;
                            byte bresult = (byte) result;
                            //if (counter < 100)  println("Result: " + result + "\tByte Result: " + bresult);
                            edges_o_table[h] = bresult;
                            newPositions++;
                        }
                    }
                    if(move != "D") c.move(move);
                    counter++;
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
        writeBytesToFile(directory+"edges_o.txt", edges_o_table);
        // try {
        //     FileOutputStream stream = new FileOutputStream(directory+"edges_o.txt");
        //     stream.write(edges_o_table);
        //     println("Saved edges_o.txt");
        // } catch (Exception e) {
        //     print(e);
        // }
    }

/**
* Prune Search Tree
* @param    c       Cube we're analysing
* @param    depth   Depth of the search
* @return   boolean Boolean determining...
*/
boolean prune(Cube2 c, int depth)   {
        if(edges_p_table[c.encode_edges_p()] > depth) return true;
        if(corners_p_corners_o_table[c.encode_corners_p_corners_o()] > depth) return true;
        if(edges_o_table[c.encode_edges_o()] > depth) return true;
        return false;
    }
/**
* Reads specified pruning table to appropriate array.
* @param    pieceType   The pieces we're collecting data for
* @param    filename    The file we're reading from
* @return   param       If the file has been read, return true
*/
boolean read_table_to_array(String pieceType, String filename) {
        byte[] tmp;
        switch (pieceType)  {
            case "eo":
                File edges_o_file = new File(directory+"edges_o.txt");
                tmp = readBytesToArray(edges_o_file);
                if(tmp.length == 0) {
                    return false;
                } else {
                    edges_o_table = tmp;
                }
                break;
            case "ep":
                File edges_p_file = new File(directory+"edges_p.txt");
                tmp = readBytesToArray(edges_p_file);
                if(tmp.length == 0) {
                    return false;
                } else {
                    edges_p_table = tmp;
                }
                break;
            case "cop":
                File corners_op_file = new File(directory+"corners_op.txt");
                tmp = readBytesToArray(corners_op_file);
                if(tmp.length == 0) {
                    return false;
                } else {
                    corners_p_corners_o_table = tmp;
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
        } catch (IOException e) {
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
    catch (Exception e)
    {
        e.printStackTrace();
        return new byte[0];
    }
    return bFile;
}