int currentTime;
int previousTime;
int deltaTime;

int nbCollision = 0;
int portal1X = 150;
int portal1Y = 200;
int portal2X = 650;
int portal2Y = 600;


ArrayList<Circle> portals;
int portalMaxSize = 2;
boolean portalsON;


int flockMaxSize = 50;
ArrayList<Mover> flock;


//SETUP---------------------------------------------------------------------------------------------------------------------------------------
void setup () {
  //fullScreen(P2D);
  size (900, 800);
  currentTime = millis();
  previousTime = millis();
  
  flock = new ArrayList<Mover>();
  createFlock();
  
  portals = new ArrayList<Circle>();
  createPortal();
  portalsON = false;
  
  flock.get(0).debug = true;
}


//DRAW---------------------------------------------------------------------------------------------------------------------------------------
void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();  
}


//GAME-CYCLE---------------------------------------------------------------------------------------------------------------------------------

void update(int delta) {
  Circle first = portals.get(0);
  Circle second = portals.get(1);
  int mulX;
  int mulY;
  
  
  for (Mover m : flock) {
    m.flock(flock);
    
    if ( first.isCollidingCircle(m) && portalsON ){
      if (m.location.x > first.location.x) mulX = -3;
      else mulX= 3;
      if (m.location.y > first.location.y) mulY = -3;
      else mulY = 3;    
      
      m.setLocation( ( (int)second.location.x + ((int)m.getRadius()*mulX) ), ( (int)second.location.y + ((int)m.getRadius()* mulY) ) );
      nbCollision++;
          System.out.print("\nCollision : "+ nbCollision);
    }
    
    if ( second.isCollidingCircle(m) && portalsON ){
      if (m.location.x > second.location.x) mulX = -3;
      else mulX= 3;
      if (m.location.y > second.location.y) mulY = -3;
      else mulY = 3;    
      
      m.setLocation( ( (int)first.location.x + ((int)m.getRadius()*mulX) ), ( (int)first.location.y + ((int)m.getRadius()* mulY) ) );
      nbCollision++;
      System.out.print("\nCollision : "+ nbCollision);
    }
    
    
    
    m.update(delta);
  }
}

//****************************************
void display () {
  background(0);
  
  //Partie de flock
  for (Mover m : flock) {
    m.display();
  }
  
  //Partie des portals
  if (portalsON) {
    for (Circle p : portals) {
      p.display();
    }
  }
}

//CONTROLER-------------------------------------------------------------------------------------------------------------------------------------

void keyPressed() {
  switch (key) {
    
    case 'd':  //Affichage du rond temoin autour un flock
      flock.get(0).debug = !flock.get(0).debug;
      break;
    
    case ' ':  //Activation - desactivation portail
      if (!portalsON) {
        System.out.print("\nPortals activated");
        respawnPortals();
        portalsON = true; 
      }
      else {
        System.out.print("\nPortals deactivated");
        portalsON = false; 
      }
      break;
    
    case 'r':  //Reset de tout le jeux
      flock.clear();
      createFlock();
      portalsON = false;
      nbCollision = 0;
      System.out.print("Reset all\n");
      break;
  }
}

void mousePressed(){
  createFlock();
}



//UTILITAIRES-------------------------------------------------------------------------------------------------------------------------------------

//Creer des new floak et mettre dans la arraylist SI pas depasse size
void createFlock(){
    if (flock.size() < flockMaxSize)
    {
      Mover m = new Mover(new PVector(random(0, width), random(0, height)), new PVector(random (-2, 2), random(-2, 2)));
      m.fillColor = color(random(255), random(255), random(255));
      flock.add(m);
      System.out.print("\nFlock number = " + flock.size());
    }
    else System.out.print("Max de 50 oiseaux atteind\n");   //println();
}

//Creer des Circle Portal
void createPortal(){
    Circle portal1 = new Circle(portal1X, portal1Y, 30);
    portal1.fillColor = color (200, 50, 0);
    portals.add(portal1);
    
    Circle portal2 = new Circle(portal2X, portal2Y, 30);
    portal2.fillColor = color (200, 50, 0);
    portals.add(portal2);
  
}

//Faire reapparaitre aleatoirement les portals
void respawnPortals(){
    portal1X = (int)random(30, width-30);
    portal1Y = (int)random(30, height-30);
    portals.get(0).setLocation(portal1X, portal1Y);
    
    portal2X = (int)random(30, width-30);
    portal2Y = (int)random(30, height-30);
    portals.get(1).setLocation(portal2X, portal2Y);
}
