class Node extends Cell {

  //VARIABLES==============================================================================================
  // Variables pour le pathfinding
  private int G;
  private int H;
  private int movementCost;
  
  Node parent; // Cellule parent
  ArrayList<Node> neighbours; // Cellules voisins
  
  
  boolean isStart = false; // Definit si la cellule est une la case départ
  boolean isEnd = false; // Definit si la cellule est une la case fin
  boolean selected = false; // Definit si la cellule est sélectionnée pour le chemin
  
  boolean isWalkable = true; // Definit si la cellule est marchable  
  
  
  //CONSTRUCTEURS===========================================================================================
  Node (int _x, int _y) {
    super (_x, _y);
    
    G = Integer.MAX_VALUE;
    H = 0;
  }
  
  
  Node (int _x, int _y, int _w, int _h) {
    super (_x, _y, _w, _h);
    G = Integer.MAX_VALUE;
    H = 0;
    movementCost = 10;
  }
  
  
  //GETTER SETTER==========================================================================================
  int getF() {return G + H;}
  int getH() {return H;}
  int getG() {return G;}
  int getMvCost() {return movementCost;}
  
  void setH (int h) {this.H = h;}
  void setG (int g) {this.G = g;}
  
  Node getParent () {return this.parent;}    
  void setParent (Node parent) {
    this.parent = parent;
    this.G = this.movementCost + parent.getF();
  }
  
  void setMovementCost (int cost) {
    movementCost = cost;
    if (this.parent != null) {
      G = movementCost + parent.getF();
    }
  }
  
  void setWalkable (boolean value, int bgColor) {
    isWalkable =false;
    fillColor = bgColor;
  }
  
  
  String toString() {
    return "( " + getF() + ", " + getG() + ", " + getH() + ")"; 
  }
  
  
  
  //METHODES================================================================================================
  // Permet d'ajouter des voisins à la liste
  void addNeighbour (Node neighbour) {
    if (neighbours == null) {
      neighbours = new ArrayList<Node>();
    }
    
    neighbours.add(neighbour);
  }
  
 

}
