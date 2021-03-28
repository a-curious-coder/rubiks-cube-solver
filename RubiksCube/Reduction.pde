class Reduction{

    Cube cube;
    int stage = 0;
    int completedCorners = 0;
    int completedEdges = 0;
    int turnsDone = 0;
    int rowStage = 0;
    int mid = 0; // remove this later
    String[] allFaces = {"White", "Yellow", "Red", "Blue", "Orange", "Green"};
    
    Reduction(Cube cube)    {
        this.cube = cube;
        // Collect corners
        // Collect edges
        // Collect centers
        // Store to a cheaper cube object, maybe?
    }

    void solve()    {
        println("starting reduction method...");
        // Assuming the cube is odd / 5x5x5
        // positionFace(white, "D", "X");
        switch(stage)   {
            // Solve centers
            case 1:
            // Position White face to D face
                if (!(getFaceColour('D') == white)) {
                    positionFace(white, 'D', 'X');
                    return;
                }
                for(int i = 0; i < 6; i++)  {
                    solveCenter(i);
                    println("Solved \"" + allFaces[i] + "\" face apparently.");
                }
                
                // return;
                break;
        }
    }

    /**
    * Solves a specified center
    * @param center the center we're solving
    */
    void solveCenter(int center)    {
        // Could have some check here for if the cube is even/odd number of cubies.
        // Even numbered cube
        switch(center)  {
            // Center 1
            case 1:
            //White
                for(int i = 1; i < dim-1; i++)  {
                    if(!rowFinished('D', i, white)) {
                        solveCenterRow(center, i);
                    }
                }
                
                if (!rowFinished('D', mid, white)) {
                    solveCenterRow(1, mid); 
                    return;
                } else if (rowStage == 3) {
                    rowStage = 0;
                }
                for (int i = 1; i < dim-1; i++) {
                    if (i == mid)    continue;
                    if (!rowFinished('D', i, white)) {
                        solveCenterRow(1, i); 
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
    /**
    * Solves the a row in the center for even numbered cubes
    * @param center
    * @param row
    */
    void solveCenterRow(int center, int row)    {
        switch(rowStage)    {
            // White face
            case 1:
                MoveOs.add(new MoveO(0, row, false));
                rowStage++;
                return;
            case 2:
                println("case 2");
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
        
        // Cubie[][] faceCubies = cube.getFace(face+"");
        // for(int i = 1; i < dim-1; i++)    {
        //     if(!faceCubies[index][i].matchesColours(col))   {
        //         return false;
        //     }
        // }
        return true;
    }

    /**
    * ...
    * @param    targetFace
    * @param    cubieColour
    * @param    xIndex
    * @param    yIndex
    * @param    axis
    * @param    rowNo
    * @param    faceNo
    */
    // void fillFaceGap(char targetFace, color cubieColour, int xIndex, int yIndex, int axis, int rowNo, int faceNo) {
    //     boolean found = false;
    //     char faceChar = 'N';
    //     String faces = "LRB";
    //     ArrayList<MoveO> adds = new ArrayList();
    //     // Storing everything on left side.
    //     if (faceNo == 3) faces = "RB";
    //     if (faceNo == 4)    faces = "R";
    //     for (int i = 0; i< faces.length(); i++) { 
    //         Cubie[][] face = cube.getFace(faces.charAt(i));
    //         faceChar = faces.charAt(i); 
    //         int xRel = xIndex;
    //         int yRel = yIndex;
    //         int xMatrix = mid+xRel;
    //         int yMatrix = mid-yRel;
    //         for (int j = 0; j < 4; j++) {
    //             if (face[xMatrix][yMatrix].matchesColors(pieceColor)) {
    //                 for (int k = 0; k<j; k++) {
    //                     MoveOs.add(charToMoveO(faceChar, false));
    //                 } 
    //                 found = true;
    //                 break;
    //             }
    //             int temp = xRel;
    //             xRel = yRel;
    //             yRel = -temp ;
    //             xMatrix = mid+xRel;
    //             yMatrix = mid-yRel;
    //         }

    //         if (found) {
    //             adds.addAll(getMoveObjects(faceChar, targetFace, mid-yIndex, axis));
    //             MoveOs.addAll(adds);

    //             if (faceNo == 3) {
    //                 if (mid - yIndex < n-1-rowNo) { //if gonna fuck up previously done stuff
    //                     //println(mid, yIndex, n, rowNo);
    //                     MoveOs.add(charToMoveO('F', false));//get the thing back into its row 
    //                     while (adds.size() >0) {            //reverse the movements
    //                         MoveOs.add(adds.remove(adds.size()-1).getReverse());
    //                     }
    //                     MoveOs.add(charToMoveO('F', true));//get the thing back into its row
    //                 }
    //             }

    //             if (faceNo == 4) {
    //                 if (mid - yIndex == n-1-rowNo) { //need to turn other way
    //                     MoveOs.add(charToMoveO('F', true));//get the thing back into its row
    //                 } else {
    //                     MoveOs.add(charToMoveO('F', false));//get the thing back into its row
    //                 }
    //                 while (adds.size() >0) {//reverse the movements
    //                     MoveOs.add(adds.remove(adds.size()-1).getReverse());
    //                 }
    //                 if (mid - yIndex == n-1-rowNo) { //need to turn other way
    //                     MoveOs.add(charToMoveO('F', false));//get the thing back into its row
    //                 } else {
    //                     MoveOs.add(charToMoveO('F', true));//get the thing back into its row
    //                 }
    //             }
    //             return;
    //         }
    //     }
    //     getToLRB(targetFace, pieceColor, xIndex, yIndex, axis, rowNo, faceNo);
    // }

    // /**
    // * ...
    // * @param    targetFace
    // * @param    pieceColour
    // * @param    xIndex
    // * @param    yIndex
    // * @param    axis
    // * @param    rowNo
    // * @param    faceNo
    // */
    // void getToLRB(char targetFace, color pieceColor, int xIndex, int yIndex, int axis, int rowNo, int faceNo) {

    //     String faces = "DFU";
    //     ArrayList<MoveO> adds = new ArrayList();
    //     char faceChar = 'N';
    //     int x = 0;
    //     int y =0;
    //     boolean found = false;

    //     if (faceNo ==3) faces = "FL";
    //     if (faceNo == 4) faces = "FB";
        
    //     for (int i = 0; i< faces.length(); i++) { 
    //         Cubie[][] face = cube.getFace(faces.charAt(i));
    //         faceChar = faces.charAt(i); 

    //         int xRel = xIndex;
    //         int yRel = yIndex;
    //         int xMatrix = mid+xRel;
    //         int yMatrix = mid-yRel;

    //         for (int j = 0; j < 4; j++) {
    //             if (face[xMatrix][yMatrix].matchesColors(pieceColor)) {
    //                 if (faceChar != 'L' || n-1-rowNo<= yMatrix) {
    //                     if (faceChar == 'D') {
    //                     if (!rowFinished('D', xMatrix, pieceColor)) {
    //                         found = true;
    //                         break;
    //                     } else {
    //                         int temp = xRel;
    //                         xRel = yRel;
    //                         yRel = -temp ;
    //                         xMatrix = mid+xRel;
    //                         yMatrix = mid-yRel;
    //                         continue;
    //                     }
    //                     }
    //                     if (faceChar != 'F' || xMatrix!=rowNo) {
    //                     found = true;
    //                     break;
    //                     }
    //                 }
    //             }
    //             int temp = xRel;
    //             xRel = yRel;
    //             yRel = -temp ;
    //             xMatrix = mid+xRel;
    //             yMatrix = mid-yRel;
    //         }
    //         if (faceNo == 4) {
    //             switch(faceChar) {
    //                 case 'F':
    //                     adds.add(charToMoveO('F', true));
    //                     int temp = xRel;
    //                     xRel = yRel;
    //                     yRel = -temp ;
    //                     xMatrix = mid+xRel;
    //                     yMatrix = mid-yRel;
    //                     adds.add(new MoveO(1, yMatrix, false));
    //                     adds.add(charToMoveO('R', false));
    //                     if (yMatrix != mid)  adds.add(charToMoveO('R', false));
    //                     adds.add(new MoveO(1, yMatrix, true));
    //                     adds.add(charToMoveO('F', false));
    //                     MoveOs.addAll(adds);
    //                     return;
    //                 case 'B':
    //                     adds.add(new MoveO(1, yMatrix, true));
    //                     adds.add(charToMoveO('R', false));
    //                     if (yMatrix != mid)  adds.add(charToMoveO('R', false));
    //                     adds.add(new MoveO(1, yMatrix, false));
    //                     MoveOs.addAll(adds);
    //                     return;
    //             }
    //         }
    //         else if (faceNo ==3) {
    //             switch(faceChar) {
    //             case 'F':
    //                 adds.add(charToMoveO('F', true));
    //                 int temp = xRel;
    //                 xRel = yRel;
    //                 yRel = -temp ;
    //                 xMatrix = mid+xRel;
    //                 yMatrix = mid-yRel;
    //                 adds.add(new MoveO(1, yMatrix, false));
    //                 adds.add(charToMoveO('R', false));
    //                 if (yMatrix != mid)  adds.add(charToMoveO('R', false));
    //                 adds.add(new MoveO(1, yMatrix, true));
    //                 adds.add(charToMoveO('F', false));
    //                 MoveOs.addAll(adds);
    //                 return;
    //             case 'L':
    //                 if (yRel == yIndex && xRel == xIndex) {
    //                     adds.add(new MoveO(1, yMatrix, false));
    //                 } else {
    //                     adds.add(new MoveO(1, yMatrix, true));
    //                     adds.add(charToMoveO('B', false));
    //                     if (yMatrix!=mid)    adds.add(charToMoveO('B', false));
    //                     adds.add(new MoveO(1, yMatrix, false));
    //                 }
    //                 MoveOs.addAll(adds);
    //                 return;
    //             }
    //         } else if (found) {
    //             switch(faceChar) {
    //             case 'F':
    //                 adds.add(charToMoveO('F', true));
    //                 int temp = xRel;
    //                 xRel = yRel;
    //                 yRel = -temp ;
    //                 xMatrix = mid+xRel;
    //                 yMatrix = mid-yRel;
    //                 adds.add(new MoveO(1, yMatrix, true));
    //                 adds.add(charToMoveO('F', false));
    //                 MoveOs.addAll(adds);
    //                 return;
    //             case 'U':
    //                 if (faceNo ==2) {
    //                     adds.add(charToMoveO('U', true));
    //                     temp = xRel;
    //                     xRel = yRel;
    //                     yRel = -temp ;
    //                     xMatrix = mid+xRel;
    //                     yMatrix = mid-yRel;
    //                 }
    //                 adds.add(new MoveO(2, yMatrix, true));
    //                 adds.add(charToMoveO('L', true));
    //                 adds.add(charToMoveO('L', true));
    //                 adds.add(new MoveO(2, yMatrix, false));
    //                 if (faceNo ==2) {
    //                     adds.add(charToMoveO('U', false));
    //                 }
    //                 MoveOs.addAll(adds);
    //                 return;
    //             case 'D':
    //                 //println("<--------------------------------------------its down boi");
    //                 //cube.rotationSpeed = PI/50.0;
    //                 adds.add(charToMoveO('D', true));
    //                 //adds.add(charToMoveO('L', true));
    //                 temp = xRel;
    //                 xRel = yRel;
    //                 yRel = -temp ;
    //                 xMatrix = mid+xRel;
    //                 yMatrix = mid-yRel;
    //                 //adds.add(charToMoveO('L', true));
    //                 adds.add(new MoveO(2, n-1- yMatrix, false));
    //                 adds.add(charToMoveO('D', false));
    //                 MoveOs.addAll(adds);
    //                 return;
    //             }
    //         }
    //     }
    // }

    // MoveO charToMoveO(char c, boolean clockwise) {
    //     //println(c);
    //     float axis =0;
    //     int index = 0;
    //     switch(c) {
    //     case 'D':
    //         axis = 1;
    //         index = n-1;
    //         clockwise = !clockwise;
    //         break;
    //     case 'U':
    //             axis = 1;
    //             break;
    //     case 'L':
    //         break;    
    //     case 'R':
    //         index = n-1;
    //         clockwise = !clockwise;
    //         break;
    //     case 'F':
    //         axis = 2;
    //         index = n-1;
    //         clockwise = !clockwise;
    //         break;    
    //     case 'B':
    //         axis = 2;
    //         break;
    //     }

    //     return new MoveO(axis, index, clockwise);
    // }
}