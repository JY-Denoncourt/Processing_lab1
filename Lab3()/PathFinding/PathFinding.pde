//VARIABLES==============================================================================
NodeMap worldMap;

int deltaTime = 0;
int previousTime = 0;

int mapRows = 100;
int mapCols = 100;

color baseColor = color (0, 127, 0);


//SETUP==================================================================================
void setup () {
  size (800, 800);
  //fullScreen();
  
  initMap();
}


//BOUCLE DE JEUX========================================================================
void draw () {
  deltaTime = millis () - previousTime;
  previousTime = millis();
  
  update(deltaTime);
  display();
}


//METHODES==============================================================================
void update (float delta) {
  worldMap.update(delta);
}

//++++++++++++++++++++++++++++++++++++++++++++++++++
void display () {
  
  if (worldMap.path != null) {
    for (Cell c : worldMap.path) {
      c.setFillColor(color (127, 0, 0));
    }
  }
  
  worldMap.display();
}



//++++++++++++++++++++++++++++++++++++++++++++++++++
void initMap () {
  worldMap = new NodeMap (mapRows, mapCols); 
  
  worldMap.setBaseColor(baseColor);
  
  //makeWall(int _i, int _j, int _length, boolean _vertical) 
  worldMap.makeWall (mapCols / 2, 0, 15, true);
  worldMap.makeWall (mapCols / 2 - 9, 10, 10, false);
  worldMap.makeWall (5, mapRows/2, mapRows- (mapRows*10/100), false);
  worldMap.makeWall (mapCols/3, 5, mapCols- (mapCols*20/100), true);
  
  //Setup cellule Start si pas un mur
  boolean isWall = true;
  int startCellX;
  int startCellY;
  do {
    startCellX = (int)random(0,mapCols-1);
    startCellY = (int)random(0,mapRows-1);
    if ( worldMap.checkCellsForStartEnd(startCellX, startCellY) ) isWall = false;
  } while (isWall);  
  worldMap.setStartCell(startCellX , startCellY);    //(mapCols / 2 - 5, 3);
  
  //Setup cellule End si pas un mur ni startCell
  isWall = true;
  boolean isStartCell = false;
  int endCellX;
  int endCellY;
  do {
    endCellX = (int)random(0,mapCols-1);
    endCellY = (int)random(0,mapRows-1);
    if ( worldMap.checkCellsForStartEnd(endCellX, endCellY) ) isWall = false;
    if ( (startCellX == endCellX) && (startCellY == endCellY) ) isStartCell = true;
  } while( isWall || isStartCell );
  worldMap.setEndCell(endCellX, endCellY);    //(mapCols - 1, mapRows - 1);
  
  
  
  // Mise à jour de tous les H des cellules
  //worldMap.updateHs();
  
  worldMap.generateNeighbourhood();
      
  worldMap.findAStarPath();
}


//CONTROLER===============================================================================

void keyPressed() {
  switch (key) {
    
    case ' ':  //Reset all
      initMap();
      break;
  }
}
