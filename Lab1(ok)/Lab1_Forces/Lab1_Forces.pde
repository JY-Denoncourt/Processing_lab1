//======================================================================================================
//Variables globales
int nbMovers = 50;
Boolean poolON;
float xOff = 0.0;
float n;

Fluid pool;
Mover[] balls;
Mover balloon;

PFont densityText;


//======================================================================================================
void setup () {
  size (800, 600);
  background(150, 50,50);
  densityText = createFont("Arial",20,true);
  
  //Section for FLUID
  pool = new Fluid();
  poolON = false;
  
  
  //Section for mover : BALLS & Balloon
  createBalls();
  createBalloon();
}




//======================================================================================================
void draw () {
  update();
  display();
  
  
  textAlign(CENTER);
  textSize(20);
  if (poolON) text( pool.getDensity()+"\nJean-Yves Denoncourt" ,width/2 , (height - (pool.getRectangle().getHeight())/2) );
}


//======================================================================================================
//Fonctions
void update() {
  //Section for mover : BALLS
  for (int i = 0; i < balls.length; i++) {
    float m = balls[i].mass;
    PVector gravity = new PVector (0, 0.1 * m);
    PVector friction = balls[i].velocity.get();
    
    friction.normalize();
    friction.mult(-1);
    friction.mult(0.02);
    
    if (mousePressed) {
      if (mouseButton == LEFT) {
        PVector wind = new PVector (.1, 0);
        balls[i].applyForce(wind);
      }
      else if (mouseButton == RIGHT) {
        PVector wind = new PVector (-0.1, 0);
        balls[i].applyForce(wind);
      }
    }
    
    if (poolON) {
      if (pool.getRectangle().intersect(balls[i].getRectangle())) {   
        PVector fForce = pool.draggingForce(balls[i].velocity, balls[i].mass);
        balls[i].applyForce(fForce);
      }
    }
    
    balls[i].applyForce(gravity);
    balls[i].applyForce(friction);
    balls[i].update();
    balls[i].checkEdges();
  }  
  
  //Section pour mover : BALLOON
  float m = balloon.mass;
  PVector gravity = new PVector (0, 0.1*m);
  PVector friction = balloon.velocity.get();
  PVector helium = new PVector (0, -0.13*m);
    
  friction.normalize();
  friction.mult(-1);
  friction.mult(0.02);
  
  if (mousePressed) {
    if (mouseButton == LEFT) {
      PVector wind = new PVector (.1, 0);
      balloon.applyForce(wind);
    }
    else if (mouseButton == RIGHT) {
      PVector wind = new PVector (-0.1, 0);
      balloon.applyForce(wind);
    }
  }
  
  balloon.applyForce(helium);
  balloon.applyForce(gravity);
  balloon.applyForce(friction);
  balloon.update();
  balloon.checkEdges();
}

//+++++++++++++++++++++++++++++++++++++++++
void display () {
  background(150, 50,50);
  
  if (poolON) pool.display();
  
  for (int i = 0; i < balls.length; i++) {
    balls[i].display();
  }
  
  balloon.display();
}

//+++++++++++++++++++++++++++++++++++++++++
void createBalls() {
  balls = new Mover[nbMovers];
    for (int i = 0; i < balls.length; i++) {
      float numGauss = randomGaussian();       // randomNB entre -1 et 1
      System.out.print("\n" + numGauss);
      float sd = 1;                            // Standard deviation | Écart-type
      float mean = 2.5;                        // Moyenne
      float mass = sd * numGauss + mean;      // nb voulu
      
      balls[i] = new Mover();
      balls[i].mass = mass;
      balls[i].location.x = 30 + i * (width / nbMovers);
      balls[i].location.y = balls[i].size.y;
    }
}

void createBalloon() {
  balloon = new Mover(5, width/2, height/2);
}

//++++++++++++++++++++++++++++++++++++++++
void keyReleased (){
  //Pool there or not there
  if (key == ' ') {
    if (!poolON) {
      pool.randomSize();
      pool.randomDensity();
      System.out.print("   Fluide on");
      poolON = true; //Affiche liquide
    }
    else {
      System.out.print("   Fluide off");
      poolON = false; //Desaffiche liquide
    }
  }
}

//++++++++++++++++++++++++++++++++++++++++
//Pour reseter les Balls et la balloon *****A refaire ******
void keyPressed() {
  if (key == 'r') {
    for (int i = 0; i < balls.length; i++) {
      createBalls();
      //balls[i].location.y = balls[i].size.y;
    }
      createBalloon();
  }
}
