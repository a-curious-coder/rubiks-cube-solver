class Kociemba{
    
    Cube2 cube;
    int stage, nodes, moveCount, currentDepth;
    boolean g1, g2;
    String g1Algorithm, g2Algorithm, solution;
    ArrayList<String> allMoves = new ArrayList<String>(
        Arrays.asList("U", "U2", "U'", "L", "L2", "L'", "F", "F2", "F'", "R", "R2", "R'", "B", "B2", "B'", "D", "D2", "D'")
    );

    Kociemba(Cube cube)    {
        this.cube = new Cube2(cube);
        stage = 0;
        g1 = false;
        g2 = false;
        g1Algorithm = "";
        g2Algorithm = "";
    }

    // Need pruning table. Two phases.
    void solve()    {
        kociembaRunning = true;
        stage++;
        // Phase 1
        // Orient corners, edges and permutate e slice edges to the e slice.
        if(!edgesOriented(cube) && !cornersOriented(cube) && !eSliceEdges(cube))
        {
            getGroup(stage);
            memConsumptionArray.add(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory());
        } else {
            println("Already achieved stage: " + stage);
        }

        List<String> list = Arrays.asList("F", "F'", "B", "B'", "R", "R'", "L", "L'");

        for (String s : list)   {
            allMoves.remove(allMoves.indexOf(s));
        }
        stage++;
        if(!cube.solved())   {
            getGroup(stage);
            memConsumptionArray.add(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory());
        } else {
            println("solved?");
        }
        // Phase 2
        // Solve cube.
        memConsumptionArray.add(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory());
        print("Finished running");
        kociembaRunning = false;
    }
    
    // IDA* - Iterative Deepening A*
    void search(String prefix, int depth)  {
        // Reset cube
        Cube2 tmp = new Cube2(cube);
        // Test solution
        tmp.testAlgorithm(prefix);
        // Test if cube is worth searching for solution at this depth.
        if (prune(2, tmp, depth, stage))  
            return;
        if (depth == 0)  {
            // Test if cube has a valid solution for this stage.
            if (stage(tmp))  
                appendSolution(prefix);
            return;
        } else {
            // One by one add all characters from set and recursively call for depth equals to depth-1
            for (String move : allMoves)   {
                if ((stage == 1 && g1) || (stage == 2 && g2))
                    return;
                search(prefix + move, depth - 1);
                nodes++;
            } 
        }
    }

    void searchAllAtDepth(int depth) {
        Cube2 tmp = new Cube2(cube); //<>//
        if (depth == 1)  {
            for (String s : allMoves)    {
                // Reset cube
                tmp = new Cube2(cube);
                //println(s);
                // Append moves
                tmp.testAlgorithm(s);
                //tmp.imageState();
                // Check if it's worth continuing the search at this depth
                if (prune(2, tmp, depth, stage)) continue; //<>//
                if (stage(tmp))  appendSolution(s);
                nodes++;
            }
        } else {
            search("", depth);
        } //<>//
        return;
    }

    void appendSolution(String prefix)    {
        println("Solution: " + prefix);
        switch(stage)   {
            case 1:
                g1Algorithm = prefix;
                cube.testAlgorithm(g1Algorithm); 
                returnSolution(g1Algorithm);
                cube.imageState();
                g1Algorithm = "";
                solution += prefix;
                break;
            case 2:
                g2Algorithm = prefix;
                cube.testAlgorithm(g2Algorithm); 
                returnSolution(g2Algorithm); 
                // g2Algorithm = "";
                solution += prefix;
                break;
        }
    }
    void returnSolution(String solution)   {
        // println(solution);
        moves = solution;
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
                moveCount += 1;
            }
        }
    }

    void getGroup(int x)    {
        int depth = 0;
        if (x == 1)  {
            cube.imageState();
            depth = 12;
            println("branching factor: " + allMoves.size());
        }
        if (x == 2)  {
            delay(5000);
            cube.imageState();
            depth = 18;
            println("branching factor: " + allMoves.size());
        }
        // Takes 1 - 7 moves to orient all edges to fulfil G1 requirements.
        println("\t\t\tDepth\tNodes\tTime");
        String t = "    ";
        outputBox.append("Depth" + t + "Nodes" + t + "Time\n");
        long start = System.currentTimeMillis();
        long end = System.currentTimeMillis();
        float duration = (end - start) / 1000F;
        for (int i = 1; i <= depth; i++) {
            start = System.currentTimeMillis();
            searchAllAtDepth(i);
            end = System.currentTimeMillis();
            duration = (end - start) / 1000F;
            println("\t\t\t" + i + "\t" + nodes + "\t" + duration + "s");
            outputBox.append(i + t + nodes + t + duration + "s\n");
            nodes = 0;
            if ((stage == 1 && g1) ||
                (stage == 2 && g2))  return;
        }
    }

    boolean stage(Cube2 tCube) { //<>//
        switch(stage)   {
            case 1:
                if (!g1) {
                    if (edgesOriented(tCube) && 
                        cornersOriented(tCube) && 
                        eSliceEdges(tCube))  {
                            g1 = true;
                            return true;
                    }
                }
                break;
            case 2:
                if (!g2) {
                    if (tCube.solved())    {
                        g2 = true;
                        return true;
                    }
                }
                break;  
        }
        return false;
    }
    
    boolean edgesOriented(Cube2 tmp)   {
        for (int i : tmp.edges_o)    {
            if (i != 0)  return false;
        }
        return true;
    }

    boolean cornersOriented(Cube2 tmp)  {
        for (int i : tmp.corners_o)  {
            if (i != 0)  return false;
        }
        return true;
    }

    boolean eSliceEdges(Cube2 tmp)  {
        // Check Edges that belong in E Slice
        if ((tmp.edges_p[4] != 5 && tmp.edges_p[4] != 6) && (tmp.edges_p[4] != 7 && tmp.edges_p[4] != 8)) 
            return false;
        if ((tmp.edges_p[5] != 5 && tmp.edges_p[5] != 6) && (tmp.edges_p[5] != 7 && tmp.edges_p[5] != 8)) 
            return false;
        if ((tmp.edges_p[6] != 5 && tmp.edges_p[6] != 6) && (tmp.edges_p[6] != 7 && tmp.edges_p[6] != 8)) 
            return false;
        if ((tmp.edges_p[7] != 5 && tmp.edges_p[7] != 6) && (tmp.edges_p[7] != 7 && tmp.edges_p[7] != 8)) 
            return false;
        return true;
    }
    
}