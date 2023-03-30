class EndScreen extends Menu{
  int result; //0 = lose; 1 == win
  
  EndScreen(int _result){
    buttons = new String[]{"Exit to Menu", "Play Again"};
    hover = 0;
    result = _result; 
  }
  
  void setResult(int _result){ //again a security risk lol
    result = _result;
  }
  
  void Exit(){
    music.stop();
    game = null;
    menuSelect.play();
  }
  
  void PlayAgain(){
    music.stop();
    game = new Game(game.getDifficulty());
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
      text(result == 0 ? "You Lose!" : "You Win!", 0,-100);
    cam.endHUD();
    drawButtons();
  }
}
