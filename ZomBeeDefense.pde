/* KNOWN BUGS
      1. orientation doesn't reset on game quit from pause menu
      2. music doesn't reset on game quit from pause menu
      3. axes get thinner?? when game is paused (why???)
      4. pausing minorly affects the timing of zombie spawns (not a big deal)
      5. either game spawns zombies during end screen or music doesn't reset on play again (see Zombie line 17)
*/

import peasy.PeasyCam; //using a library to create a 2D interface on a 3D view
import processing.sound.*;

//UI elements
Minimap minimap;
Weapon weapon;
MainMenu mainMenu;
PauseMenu pauseMenu;
EndScreen endScreen;
PImage logo;

PShape zombee;

Game game;
boolean cheats;
String cheatsListener;

PeasyCam cam;

SoundFile weaponSFX;
SoundFile hit;
SoundFile menuHover;
SoundFile menuSelect;
SoundFile pauseSound;
SoundFile music;
SoundFile cheatsEnabled;

String[] keysHeld = new String[3]; // left right and shoot

//configurables
float camSens = 1; // higher -> faster turn speed


void setup() {
  size(800, 800, P3D);
  
  //HUD elements
  minimap = new Minimap();
  weapon = new Weapon();
  mainMenu = new MainMenu();
  pauseMenu = new PauseMenu();
  endScreen = new EndScreen(0); // default lose
  
  //models
  zombee = loadShape("Bee.obj");
  zombee.setFill(color(0,255,0));
  
  //camera
  perspective(radians(50.0f), width/(float)height, 0.1, 1000);
  cam = new PeasyCam(this, 400); //faces -z by default
  cam.setDistance(0); // first person
  cam.setActive(false);
  
  //sounds
  weaponSFX = new SoundFile(this, "slash_2.mp3");
  hit = new SoundFile(this, "Crash1.wav");
  menuHover = new SoundFile(this, "OptionScroll.wav");
  menuSelect = new SoundFile(this, "OptionSelect.wav");
  pauseSound = new SoundFile(this, "MenuOpen1.wav");
  music = new SoundFile(this, "Bioluminescence in the Marine Snow.mp3"); //had to compress to upload to GitHub. For some reason this lowers the pitch of the song despite the file sounding the same
  cheatsEnabled = new SoundFile(this, "PickupSpecial2.wav");
  
  //images
  logo = loadImage("ZomBeeDefense.png");
  
  //cheats
  cheats = false; //activate with the konami code
  cheatsListener = "XXXXXXXXXXX";
}

void draw() {
  background(0);
  
  //axis lines for testing

  
  
  //pushMatrix();
  //  translate(200,0,200);
  //  box(30);
  //popMatrix();
  
  //if (second()%5 == 0 && millis()%10 == 1){
  //  game.spawnZombie();
  //}
  if (game != null){
    //haven't decided if i'm getting rid of the axes. I kinda like them for orientation while the background is empty
    stroke(0,255,0);
    line(0,-1,-100, 0,-1,100); // z axis
    stroke(0,0,255);
    line(-100,-1,0, 100,-1,0); // x axis
    
    if (game.getGameState() != 0){ //game is over
      game.Draw();
      weapon.Draw();
      minimap.Draw();
      endScreen.Draw();
    }else if (game.isPaused()){
      
      game.Draw();
      weapon.Draw();
      minimap.Draw();
      
      pauseMenu.Draw();
      
    }
    else{
      game.Update();
      game.Draw();
      minimap.Draw();
      weapon.Draw();
    }
  }
  else{
    mainMenu.Draw();
  }
  
  
  InputManager();
  
}













void InputManager(){
  if (keysHeld[0] == "left"){
    if (game != null){
      if (game.getGameState() != 0){ //game is over
        endScreen.moveHoverLeft();
      }
      else{ // game in progress
        if (!game.isPaused()){ //not paused
          //rotate left
          cam.rotateY(radians(1 * camSens));
          weapon.Rotate(1 * camSens);
        } else { // game paused
          // move hover left
          pauseMenu.moveHoverLeft();
        }
      }
    } else { // main menu
      mainMenu.moveHoverLeft();
    }
  }
  if (keysHeld[2] == "right"){
    if (game != null){
      if (game.getGameState() != 0){
        endScreen.moveHoverRight();
      }
      else{ //game state is 0 or still in progress
        if (!game.isPaused()){ //not paused
          //rotate left
          cam.rotateY(radians(-1 * camSens));
          weapon.Rotate(-1 * camSens);
        } else { // game paused
          // move hover right
          //println("Pause menu options: " + pauseMenu.getNumButtons());
          //println("Current option: " + pauseMenu.getHover());
          pauseMenu.moveHoverRight();
        }
      }
    } else { // main menu
      mainMenu.moveHoverRight();
    }
  }
}

void keyPressed (){ //handles keyboard input and input sounds 
  if (key == 'a' || keyCode == LEFT){
    if (keysHeld[0] != "left")
      keysHeld[0] = "left";
      if (game == null){ 
        menuHover.play();
      } else{
        if (game.isPaused() || game.getGameState() != 0){
           menuHover.play();
        }
      }
  }
  if (key == 'd' || keyCode == RIGHT){
    if (keysHeld[2] != "right")
      keysHeld[2] = "right";
      if (game == null){ 
        menuHover.play();
      } else{
        if (game.isPaused() || game.getGameState() != 0){
           menuHover.play();
        }
      }
  }
  if (key == 'p'){
    if (game != null){
      if (game.getGameState() == 0){ //can only pause when game is not over
        if (!game.isPaused())
            pauseSound.play();
        game.Pause();
      }
    }
  }
  if (key == ' '){
    if (game != null){
      if (!game.isPaused() && game.getGameState() == 0){
        game.addBullet(weapon.Fire());
        weaponSFX.play();
      }
      else if (game.getGameState() == 0){ //game paused; pause menu select
        //todo: select pause menu option
        if(pauseMenu.getHover() == 0){ // Resume
          pauseMenu.Resume();
        }
        else{ //WARNING: assumes quit is the only other option
          pauseMenu.Exit();
        }
      }
      else { //game is over 
        if (endScreen.getHover() == 0){ //exit to menu selected
          endScreen.Exit();
        }
        else{ // WARNING: assumes replay is the only other option
          endScreen.PlayAgain();
        }
      }
    }else{ //game not started; main menu select
      //select difficulty and start game
       if (mainMenu.getHover() == 0){ // Normal
         mainMenu.Normal();
       } else{ //WARNING: if i ever add a new difficulty, this will assume it's just hard
         mainMenu.Hard();
       }
    }
  }
  
  //cheats stuff
  cheatsListener = cheatsListener.substring(1,11);
  
  if (keyCode == LEFT){
    cheatsListener += '<';
  } else if (keyCode == RIGHT){
    cheatsListener += '>';
  } else if (keyCode == UP){
    cheatsListener += '^';
  } else if (keyCode == DOWN){
    cheatsListener += '%'; // pretend this is a down arrow
  }else {
    cheatsListener += key;
  }
  
  if (cheatsListener.equals("^^%%<><>ba ") && !cheats){
    println("Cheats unlocked!!");
    cheatsEnabled.play();
    cheats = true;
  }
}

void keyReleased(){
  if (key == 'a' || keyCode == LEFT){
    if (keysHeld[0] == "left")
      keysHeld[0] = "";
  }
  if (key == 'd' || keyCode == RIGHT){
    if (keysHeld[2] == "right")
      keysHeld[2] = "";
  }
  if (key == ' '){ //todo: or left click
    keysHeld[1] = "";
  }
  if (key == '1' || key == '2'|| key == '3' || key == '4' || key =='5'){
    if (game != null && cheats){
      game.setRound(key - 48);
    }
  }
}

void mouseClicked(){
  //println("x: " + mouseX + " | y: " + mouseY);
  if (mouseY > 440 && mouseY < 550) {
    if (mouseX > 120 && mouseX < 380){ //left button
      //println("left");
      if (game == null){ //main menu
        mainMenu.setHover(0);
        mainMenu.Normal();
      }
      else{
        if (game.getGameState() != 0){
          endScreen.setHover(0);
          endScreen.Exit();
        }
        else if (game.isPaused()){
          pauseMenu.setHover(0);
          pauseMenu.Resume();
        }
      }
    } else if (mouseX > 420 && mouseX < 680){ //right button
      //println("right");
            if (game == null){ //main menu
        mainMenu.setHover(1);
        mainMenu.Hard();
      }
      else{
        if (game.getGameState() != 0){
          endScreen.setHover(1);
          endScreen.PlayAgain();
        }
        else if (game.isPaused()){
          pauseMenu.setHover(1);
          pauseMenu.Exit();
        }
      }
    }
  }
  
}
