class Weapon {
  String name;
  boolean onCooldown; // can the weapon be fired
  PImage weaponView;
  //PVector orientation;
  float angle;
  
  Weapon(){
    name = "default";
    onCooldown = false;
    weaponView = loadImage("weapon.png");
    //orientation = new PVector(0,0,-1); //default camera orientation
    angle = 90; //default camera orientation is -90 of posX
  }
  
  void Draw(){
    cam.beginHUD();
    image(weaponView, width-431, height-256);
    cam.endHUD();
    
    // old crosshair
    
    //pushMatrix();
    //  translate(orientation.x,orientation.y,orientation.z);
    //  //println(orientation.x + ", " + orientation.y + ", " + orientation.z);
    //  sphere(0.005);
    //popMatrix();
    
    //new crosshair
    fill(255,0,0);
    noStroke();
    pushMatrix();
      rotateY(radians(angle));
      translate(1,0,0);
      sphere(0.005);
    popMatrix();
  }
  
  void Rotate(float _angle){ //in degrees
    //float x = orientation.x;
    //float z = orientation.z;
    //orientation.x = cos(radians(_angle)) * x - sin(radians(_angle)) * z;
    //orientation.z = sin(radians(_angle)) * x + cos(radians(_angle)) * z;
    
    angle += _angle;
    if (angle < 0){
      angle += 360; //no negatives
    }
    else if (angle > 360){
      angle -= 360; //keep it with 0-360
    }
  }
  
  float getAngle(){ // used for minimap orientation
    return angle;
  }
  
  void setAngle(float _angle){
    angle = _angle;
  }
  
  Bullet Fire(){
    Bullet shot = new Bullet(angle);
    return shot;
  }
  
}
