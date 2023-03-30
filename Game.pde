class Game {
  int round; //1-5
  ArrayList<Zombie> horde; //not to be confused with hoard
  ArrayList<Bullet> bullets;
  boolean hard;
  
  //states
  volatile boolean paused;
  int gameState; // 0 = in progress, 1 = lose, 2 = win
  
  Game(boolean difficulty){
    noCursor(); 
    round = 1;
    hard = difficulty;
    horde = new ArrayList<Zombie>();
    bullets = new ArrayList<Bullet>();
    RoundManager();
    paused = false;
    gameState = 0;
    music.stop(); //this doesn't do anything
    music.play();
    
    //weapon.setAngle(90); attempt to fix bug 1 creates much bigger problems. Look into rotating cam back to 90 degrees from wherever
  }
  
  void spawnZombie(){
    Zombie zomb = new Zombie(400, random(0,359));
    if (hard){
      zomb.setSpeed(0.7); //hard mode zombies move faster
    }
    horde.add(zomb);
    println("zombie spawned");
  }
  
  void addBullet(Bullet shot){
    bullets.add(shot);
  }
  
  ArrayList<Zombie> getHorde(){
    return horde;
  }
  
  boolean getDifficulty(){
    return hard;
  }
  
  int getRound(){
    return round;
  }
  
  void setRound(int _round){
    round = _round;
  }
  
  int getGameState(){
    return gameState;
  }
  
  void setGameState(int _state){ //this should definitely not be a public function if we seriously care about security. good thing we don't
    gameState = _state;
  }
    
  
  boolean isPaused(){
    return paused;
  }
  
  void Pause(){
    paused = !paused;
    if (paused){
      music.pause();
    } else {
      noCursor();
      music.play();
    }
    //if (paused){
    //  try{
    //    roundManager.wait();
    //  }
    //  catch(InterruptedException ie){
    //    Thread.currentThread().interrupt();
    //    println("Round Manager pause fail!");
    //  }
    //}
    //else{
    //    roundManager.notify();
    //}
  }
  
  void RoundManager(){ //works but WAY too hard past round 4
    
    Thread thread = new Thread(() -> { //gotta actually learn how lambda expressions work
      try {
        while(round < 6){
        for (int i = 0; i < 5; i++){
          
          for (int seconds = 0; seconds < 10; seconds++){ //sleep for 10 seconds but in a way where you can pause without it counting down all the way, making zombies always spawn at the end of a pause
            while (paused){ 
              //print("paused");
            }
            Thread.sleep(1000);
          }
          //println("not paused");
          for (int j = 0; j < round; j++){
            this.spawnZombie();
            Thread.sleep((long) random(0.5, 2) * 1000); // 1 second
            this.spawnZombie();
            int randy = (int) random(1,5);
            if (randy == 1){ //20% chance to spawn an extra zombie
              Thread.sleep(1000); // 1 second
              this.spawnZombie();
            }
            Thread.sleep((long) random(1.5, 3) * 1000);
          }
        }
        Thread.sleep(15000); //15 more seconds
        if (round < 6){
          round++;
        }
      }
      
      println("You win!");
      music.stop();
      gameState = 2;
      endScreen.setResult(1);
      paused = true;
      
      } catch(InterruptedException ie){
        Thread.currentThread().interrupt();
      }
    });
    thread.start();
    //return thread;
  }
            
  
  void Update(){
     for (int i = 0; i < horde.size(); i++){
       Zombie zomb = horde.get(i);
       zomb.Update();
       for (int j = 0; j < bullets.size(); j++){
         Bullet shot = bullets.get(j);
         //println("bullet angle: " + shot.getAngle()); //15 degrees can also be -345 degrees (abs doesnt help)
         //println("zombie angle: " + zomb.getAngle());
         if (!shot.canDestroy()){ //just in case
           if (abs(shot.getAngle() - zomb.getAngle()) < 1 + 300/zomb.getDistance()
               || abs(max(shot.getAngle(),zomb.getAngle()) - (360 + min(shot.getAngle(),zomb.getAngle()))) < 1 + 300/zomb.getDistance()){
             //checks if the difference in angles is < 5 degrees (OR is for overflow case like 358 and 1 being 3 degrees apart)
             //println("correct angle");
             //println("bullet distance: " + shot.getDistance());
             //println("zombie distance: " + zomb.getDistance());
             if (abs(shot.getDistance() - zomb.getDistance()) < 5){
               println("hit!");
               hit.play();
               shot.Destroy();
               zomb.Destroy();
             }
           }
         }
       }
       if (zomb.canDestroy()){
         horde.remove(i);
       }
     }
     
     for (int i = 0; i < bullets.size(); i++){
       bullets.get(i).Update();
       
       if (bullets.get(i).canDestroy()){
         bullets.remove(i);
       }
     }
  }
  void Draw(){
    for (int i = 0; i < horde.size(); i++){
      horde.get(i).Draw();
     }
     
     for (int i = 0; i < bullets.size(); i++){
       bullets.get(i).Draw();
     }
  }
}
