class Reduction{


    Reduction(Cube cube)    {
        // Collect corners
        // Collect edges
        // Collect centers
        // Store to a cheaper cube object, maybe?
    }

    void reduction()    {
        println("starting reduction method...");
        // Assuming the cube is odd / 5x5x5
        // positionFace(white, "D", "X");
        switch(stage)   {
            case 1:
                if (!(getFaceColour('D') == white)) {
                    positionFace(white, 'D', 'X');
                    return;
                }
                solveCenter(stage);
                break;
            case 2:
                solveCenter(stage);
                break;
            case 3:
                solveCenter(stage);
                break;
            case 4:
                solveCenter(stage);
                break;
        }
    }

    void solveCenter(int center)    {
        switch(center)  {
            // Cemter 1
            case 1:
                if (!rowFinished('D', middle, white)) {
                    solveWhiteRow(middle); 
                    return;
                } else if (rowStage == 3) {
                    rowStage = 0;
                }
                for (int i = 1; i < dim-1; i++) {
                    if (i == middle)    continue;
                    if (!rowFinished('D', i, white)) {
                        solveWhiteRow(i); 
                        return;
                    } else if (rowStage == 3) {
                        rowStage = 0;
                    }
                }
                rowStage = 0;
                stage++;
            break;
        }
    }

    void solveWhiteRow(int x)   {
        switch(rowStage) {
            case 0:
                turnOs.add(new TurnO(0, x, false));
                rowStage++;
                return;
            case 1:
                for (int i = middle-1; i> -middle; i--) {
                    if (!cube.blocks[x][middle-i][n-1].matchesColors(green)) {
                    fillFaceGap('F', green, x-middle, i, 1, x);
                    }
                    if (turnOs.size() >0 || turns.length()>0) {
                    return;
                    }
                }
                rowStage++;
                return;
            case 2:
                turnOs.add(new TurnO(0, x, true));
                rowStage++;
                return;
            }
    }
    /**
    * Checks if a single row of edges is finished.
    * @param    face    The face the edge is on
    * @param    index   The index of the edges
    * @param    col     The colour the edges should be on that face
    * @return   boolean If the row is finished, return true, else false
    */
    boolean rowFinished(char face, int index, color col)    {
        Cubie[][] faceCubies = cube.getFace(face);
        for(int i = 1; i < dim-1; i++)    {
            if(!faceCubies[index][i].matchesColours(col))   {
                return false;
            }
        }
        return true;
    }
}