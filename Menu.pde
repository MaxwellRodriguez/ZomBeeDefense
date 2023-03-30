abstract class Menu {
  protected String[] buttons;
  protected int hover;
  
  int getNumButtons(){
    return buttons.length;
  }
  
  int getHover(){
    return hover;
  }
  
  void setHover(int _hover){ // replaced by moveHoverRight() and moveHoverLeft() for keyboard, still used for mouse
    hover = _hover;
  }
  
  void moveHoverRight(){
    hover = hover + 1 < this.getNumButtons() ? hover + 1 : this.getNumButtons() - 1; // fancy way of upper bound capping the hover
  }
  
  void moveHoverLeft(){
    hover =  hover - 1 >= 0 ? hover - 1 : 0; //fancy way of lower bound capping the button
  }
  
  void drawButtons(){
    cam.beginHUD();
      translate(width/2, height/2); //middle of screen regardless of size, 400,400
      fill(100,100,255);
      rectMode(CENTER);
      strokeWeight(3);
      stroke(40,40,255);
      if (hover == 0){
        rect(150,100, 250,100); //draw right THEN change stroke weight to bold
        strokeWeight(5);
        stroke(255);
      }
      rect(-150,100, 250,100);
      if (hover == 1){
        strokeWeight(5);
        stroke(255);
        rect(150,100, 250,100);
      }
      
      fill(255);
      textSize(48);
      textAlign(CENTER, CENTER);
      text(buttons[0], -150,90); //still wasn't aligned on the y
      text(buttons[1], 150,90);
    cam.endHUD();
  }
  
  public abstract void Draw();
}
    
