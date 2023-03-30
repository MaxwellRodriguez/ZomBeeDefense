abstract class Entity{
  protected float distance;
  protected float angle; // in degrees
  protected float speed;
  protected boolean destroy;
  
  float getAngle(){
    return angle;
  }
  
  float getDistance(){
    return distance;
  }
  
  void setSpeed(float _speed){
    speed = _speed;
  }
  
  boolean canDestroy(){ // we'll pretend everything is private and needs get methods
    return destroy;
  }
  
  void Destroy(){ //to use when collides with zombie
    destroy = true;
  }
  
  public abstract void Update();
  public abstract void Draw();
}
