// This class is for turning edge/center rows in cubes bigger than a 3x3x3 that don't have a set notation.
class MoveO {
    float axis = 0;
    int index = 0;
    boolean clockwise = true;

    MoveO(float a, int i, boolean c)    {
        axis = a;
        index = i;
        clockwise = c;
    }
    // 
    MoveO() {
        axis = floor(random(3));
        index = floor(random(dim));
        if (random(1) < 0.5) {
            clockwise = false;
        }
    }

    boolean matches(MoveO t) {
        return t.axis ==axis && t.index == index && clockwise == t.clockwise;
    }


    void printTurn(){
        println("axis: " + axis +", index " + index + ", isclockwise " +clockwise);  
    }

    MoveO getReverse(){
        MoveO reverse = new MoveO(axis,index,!clockwise);
        return reverse;
    }
}
