class Button
{
 PVector pos = new PVector(0, 0);
 float Width = 0;
 float Height = 0;
 color Colour;
 String buttonText;
 Boolean pressed = false;
 Boolean clicked = false;
 
 //      x, y, width, height, text, red, green, blue;
 Button(int x, int y, int w, int h, String t, int r, int g, int b)  
 {
   pos.x = x;
   pos.y = y;
   Width = w;
   Height = h;
   buttonText = t;
   Colour = color(r, g, b);
 }
 
 // placed in draw to work
 void update()
 {
   if(mousePressed && mouseButton == LEFT && pressed == false)  
   {
     pressed = true;
     if(mouseX >= pos.x && mouseX <= pos.x + Width && mouseY >= pos.y && mouseY <= pos.y + Height)
     {
       clicked = true;
     }
   } else 
   {
      clicked = false; 
      pressed = false;
   }
 }
 
 // placed in draw to render button to screen.
 void render()
 {
   fill(Colour);
   rect(pos.x, pos.y, Width, Height);
   fill(0);
   text(buttonText, (pos.x + Width) * 2, (pos.y + Height) * 2 );
 }
 
 // Used in if statement to check if the button is clicked
 boolean isClicked()  
 {
  return clicked; 
 }
}
