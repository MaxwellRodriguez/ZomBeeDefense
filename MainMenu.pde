//handles the Main Menu
class MainMenu extends Menu {
  
  MainMenu(){
    buttons = new String[]{"Normal", "Hard"};
    hover = 0;
  }
  
  void Normal(){
    game = new Game(false);
    menuSelect.play();
  }
  
  void Hard(){
    game = new Game(true);
    menuSelect.play();
  }
  
  void Draw (){
    cursor();
    cam.beginHUD();
      translate(width/2, height/2); //middle of screen regardless of size, 400,400
      image(logo,-logo.width/2, -300);
    cam.endHUD();
    drawButtons();
  }
}
