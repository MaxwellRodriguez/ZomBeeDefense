//Minimap draws the display in the top left that tracks enemy locations and player orientation
class Minimap{
  PGraphics minimap;
  
  Minimap(){
    minimap = createGraphics(250, 250, P2D);
  }
  
  void Draw(){ //draws the minimap
    cam.beginHUD();
    
    //background
    fill(0,255,0,50);
    noStroke();
    ellipse(minimap.width*0.5, minimap.height*0.5,200,200);
    
    //player
    stroke(255);
    strokeWeight(4);
    pushMatrix();
      translate(minimap.width*0.5, minimap.height*0.5);
      rotate(-1 * radians(weapon.getAngle() + 90)); //make sure it rotates the right way/starts vertically
      //line(0,0, 0, 10);
      line(0,10,-10,-10);
      line(0,10, 10,-10);
      line(10,-10, 0,0);
      line(-10,-10, 0,0);
    popMatrix();
    
    //draw zombies
    stroke(255,0,0);
    strokeWeight(10);
      for (int i = 0; i < game.getHorde().size(); i++){
        Zombie zomb = game.getHorde().get(i);
        pushMatrix();
          translate(minimap.width*0.5, minimap.height*0.5);
          rotate(-1 * radians(zomb.getAngle() +90));
          translate(0,zomb.getDistance()/4);
          point(0,0);
        popMatrix();
      }
      
    pushMatrix();
      translate(125,250);
      fill(255);
      ellipse(255,255,0,0);
      textAlign(CENTER);
      textSize(36);
      text("Round " + game.getRound(),0,0);
    popMatrix();
    
    cam.endHUD();
  }
}
