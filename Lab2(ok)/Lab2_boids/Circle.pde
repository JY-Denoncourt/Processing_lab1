class Circle extends GraphicObject {
  
  private float radius;
  private float diametre;
  
  
  //Constructor=======================================================
  Circle () {
    instanciate();
  }
  
  Circle (float x, float y, float radius) {
    instanciate();
    location.x = x;
    location.y = y;
    
    setRadius(radius);
  }
  
  
  
  //Methode==========================================================
  
  //Get-Set++++++++++++++++++++++++++++++++++++
  float getRadius() {
    return radius;
  }
  
  void setLocation(int x, int y){
    location.x = x;
    location.y = y;
  }
  
  void setRadius(float radius) {
    this.radius = radius;
    diametre = 2 * radius;
  }
 
  
  
  //Update and Display***************************
  void updateAround(float x, float y) {
    location.x = x;
    location.y = y;
  }
  
  void update(float deltaTime) {
    velocity.add(acceleration);
    location.add (velocity);
    
    acceleration.mult(0);
  }
  
  void display() {
    pushMatrix();
    translate(location.x, location.y);
    fill(fillColor);
    ellipse(0, 0, diametre, diametre);
    popMatrix();
 }
  
  void displayAround() {
    pushMatrix();
    translate(location.x, location.y);
    fill(255,255,255,20);
    ellipse(0, 0, diametre, diametre);
    popMatrix();
 }
  
  //Collision........................................
  // Collision simple
  // Si la somme des deux rayons est supérieure à la distance des centres, il y a alors une collision
  boolean isCollidingCircle(Mover bird) {
    boolean result = false;
    float distance = PVector.dist(this.location, bird.location);
    
    if ((this.getRadius() + bird.getRadius()) >= distance) result = true;
    
    return result;
  }
  
  
  //Methodes autres==================================
  //Creer les vector
  void instanciate() {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    
    setRadius(10);
  }
}
