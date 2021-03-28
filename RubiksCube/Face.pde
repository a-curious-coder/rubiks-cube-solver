
class Face {
    float radius = 0.06;
    float faceWidth = 0.95;
    float faceHeight = 0.95;
    PVector normal;
    String value = "";
    int c;
    
    Face(PVector normal, int c) {
        this.normal = normal;
        this.c = c;
    }
    
    Face(Face f)  {
        normal = f.normal.copy();
        c = f.c;
    }
    
    Face() {};
    
    void turn(char axis, float angle) {
        PVector v = new PVector();
        switch(axis) {
            case 'x':
            v.x = round(normal.x);
            v.y = round(normal.y * cos(angle) - normal.z * sin(angle));
            v.z = round(normal.y * sin(angle) + normal.z * cos(angle));
            break;
            case 'y':
            v.x = round(normal.x * cos(angle) - normal.z * sin(angle));
            v.y = round(normal.y);
            v.z = round(normal.x * sin(angle) + normal.z * cos(angle));
            break;
            case 'z':
            v.x = round(normal.x * cos(angle) - normal.y * sin(angle));
            v.y = round(normal.x * sin(angle) + normal.y * cos(angle));
            v.z = round(normal.z);
            break;
        }
        normal = v;
    }
    
    void show() {
        if (c == black) return; // Colour is still stored to face, just doesn't draw it - saves memory
        push();
        stroke(black);
        rectMode(CENTER);
        translate(0.5 * normal.x, 0.5 * normal.y, 0.5 * normal.z);
        rotate(HALF_PI, normal.y, normal.x, normal.z);
        fill(c);
        if (slowCube)  {
            rect(0,0,faceWidth, faceHeight, radius);
        } else {
            square(0, 0, 1);
        }
        fill(0);
        textSize(0.5);
        text(value, 0, 0);
        if (value != "") println("DIFF");
        pop();
    }
    
    void setValue(String s) {
        println("hi");
        this.value = s;
    }
    
    //byte[][] vertices() {
    //  byte[][] vertices = new byte[4][2];
    //  vertices[0][0] = 0;
    //  vertices[0][1] = 0;
    //  vertices[1][0] = 1;
    //  vertices[1][1] = 0;
    //  vertices[2][0] = 1;
    //  vertices[2][1] = 1;
    //  vertices[3][0] = 0;
    //  vertices[3][1] = 1;
    //  return vertices;
// }
    
    color getColour() {
        return c;
    }
}
