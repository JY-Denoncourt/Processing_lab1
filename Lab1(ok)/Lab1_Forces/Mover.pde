class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  PVector size; 
  float topSpeed;
  float mass;
  
  
  
  //Constructeurs=======================================================================
  Mover () {
    
    this.location = new PVector (random (width), random (height));    
    this.velocity = new PVector (0, 0);
    this.acceleration = new PVector (0 , 0);
    this.size = new PVector (16, 16);
    
    this.mass = 1;
  }  
  
  Mover (PVector loc, PVector vel) {
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);
    this.size = new PVector (16, 16);
    this.topSpeed = 100;
  }
  
  Mover (float m, float x, float y) {
    mass = m;
    location = new PVector (x, y);
    
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    size = new PVector (16, 16);
  }
  //====================================================================================
  
  
  float getDia() {
    return (mass*16); 
  }
  
  //+++++++++++++++++++++++++++++++++
  void update () {
    velocity.add (acceleration);
    location.add (velocity);

    acceleration.mult (0);
  }
 //++++++++++++++++++++++++++++++++++
  void display () {
    stroke (0);
    fill (127, 127, 127, 127);
    
    ellipse (location.x, location.y, mass * size.x, mass * size.y); // Dimension à l'échelle de la masse
  }
  
 //++++++++++++++++++++++++++++++++++
  void checkEdges() {      
    if (location.x + getDia()/2 >= width) {
      location.x = width - getDia()/2;
      velocity.x *= -1;
    } else if (location.x - getDia()/2 <= 0) {
      location.x = getDia()/2;
      velocity.x *= -1;
    }
    
    if (location.y + getDia()/2 >= height) {
      velocity.y *= -0.9;
      location.y = height - getDia()/2;
    }
    else if (location.y - getDia()/2 <= 0) {
      location.y = getDia()/2;
      velocity.y *= -0.4;
      
    }
  }
  
//++++++++++++++++++++++++++++++++++ 
  void applyForce (PVector force) {
    PVector f = PVector.div (force, mass);
   
    this.acceleration.add(f);
  }
  
  Rectangle getRectangle() {
    Rectangle r = new Rectangle(location.x, location.y, size.x, size.y);
    
    return r;
  }
}
