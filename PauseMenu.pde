class PauseMenu extends Menu {
  
  PauseMenu(){
    buttons = new String[]{"Resume", "Exit to Menu"};
    hover = 0;
  }
  
  void Resume() {
    game.Pause();
    menuSelect.play();
  }
  
  void Exit(){
    music.stop();
    game = null;
    menuSelect.play();
  }
  
  void Draw(){
    cursor();
    cam.beginHUD();
      translate(width/2, height/2);
      fill(255,50); //white overlay
      noStroke();
      rect(0,0, 800,800);
      fill(255);
      textSize(128);
      textAlign(CENTER, CENTER); //just making sure
      text("Game Paused", 0,-100);
    cam.endHUD();
    
    drawButtons();
  }
}
