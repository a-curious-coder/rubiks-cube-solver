class Button  {
    int rectX, rectY;      // Position of square button
    int rectWidth = 0;
    int rectHeight = 0;
    float radius = 5;
    color rectColor, baseColor;
    color rectHighlight;
    boolean pressed = false;
    boolean clicked = false;
    boolean clickedOnce = false;
    boolean rectOver = false;
    String text = "";

    Button(){
        rectColor = color(0);
        rectHighlight = color(51);
        baseColor = color(102);
        radius = 5;
    };

    Button(float x, float y, int w, int h, String t)    {
        text = t;
        rectColor = color(0);
        rectHighlight = color(51);
        baseColor = color(102);
        rectHeight = h;
        rectWidth = w;
        rectX = (int)x;
        rectY = (int)y;
    }

    void render()   {
        if (rectOver) {
            fill(rectHighlight);
        } else {
            fill(rectColor);
        }
        rect(rectX, rectY, rectWidth, rectHeight, radius, radius, radius, radius);
        stroke(51);
        fill(255);
        textAlign(CENTER, CENTER);
        text(text, rectX+(rectWidth/2), rectY+(rectHeight/2));
    }

    // update(mouseX, mouseY);
    // background(currentColor);
   void update(int x, int y) {
        clicked = false;
        pressed = false;
       if(overRect(rectX, rectY, rectWidth, rectHeight))    {
            rectOver = true;
        } else {
            rectOver = false;
        }
       
    }

    boolean mouseClicked()  {
        clicked = false;
        if(overRect(rectX, rectY, rectWidth, rectHeight) && mousePressed && mouseButton == LEFT && !clickedOnce)   {
            clickedOnce = true;
            clicked = true;
        } else if(!mousePressed)    {
            clickedOnce = false;
        }
        return clicked;
    }
    boolean overRect(int x, int y, int width, int height)  {
        if (mouseX >= x && mouseX <= x+width && 
            mouseY >= y && mouseY <= y+height) {
            return true;
        } else {
            return false;
        }
    }
}