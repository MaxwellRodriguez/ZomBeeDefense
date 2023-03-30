class Zombie extends Entity{
  
  
  Zombie (float _d, float _a){
    distance = _d;
    angle = _a;
    speed = 0.5;
    destroy = false;
  }
  
  void Update(){
    distance -= speed; // gets closer
    if (distance < 10){ //warn: tweak this value
      //todo: game over
      println("ya lost gg");
      game.setGameState(1);
      endScreen.setResult(0);
      game.Pause(); // WARNING: uncommenting this will spawn zombies after game is over BUT the music will continue and will reset if you hit play again 
    }
  }
  
  void Draw(){
    noStroke();
    fill(0,255,0);
    pushMatrix();
      
      translate(distance * cos(radians(-angle)), 10, distance * sin(radians(-angle)));
      //println(distance * cos(radians(angle))+ ", " + distance * sin(radians(angle)));
      rotateY(radians(angle));
      rotateZ(radians(180)); // bee is upside down
      scale (10);
      shape(zombee);
      //sphere(8); //todo: better zombie model
    popMatrix();
  }
}
