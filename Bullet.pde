class Bullet extends Entity{ // I could make an abstract base class for bullets and zombies but that's a bit extra
  
  Bullet(float _a){
    distance = 1;
    angle = _a;
    speed = 4;
    destroy = false;
  }
  
    
  //updates bullet position and checks if needs deleting
  void Update(){
    distance += speed;
    if (distance > 420) { // a little over max zombie spawn distance
      destroy = true;
    }
  }
  
  void Draw(){
    noStroke();
    fill(140);
    //println("Bullet angle: " + angle);
    //println("Weapon angle: " + weapon.getAngle());
    pushMatrix();
      translate(distance * cos(radians(-angle)), 0, distance * sin(radians(-angle)));
      //println(distance * cos(radians(angle))+ ", " + distance * sin(radians(angle)));
      sphere(1);
    popMatrix();
  }
}
