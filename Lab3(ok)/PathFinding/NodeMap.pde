

//Énumération des directions possibles
enum Direction { EAST, SOUTH, WEST, NORTH }

/********************
  Représente une carte de cellule permettant
  de trouver le chemin le plus court entre deux cellules
********************/
class NodeMap extends Matrix {
  
  //VARIABLES=====================================================================================
  Node start;
  Node end;
  
  
  //Pathfinding Algo
  //Matrix.cell = list de tout les noeuds 
  ArrayList <Node> path;
  ArrayList <Node> openList    = new ArrayList<Node>();
  ArrayList <Node> closeList   = new ArrayList<Node>();
  ArrayList <Node> pathList   = new ArrayList<Node>();
  
  
  boolean debug = false;
  
  
  //CONSTRUCTEURS=================================================================================
  NodeMap (int nbRows, int nbColumns) {
    super (nbRows, nbColumns);
  
  }
  
  NodeMap (int nbRows, int nbColumns, int bpp, int width, int height) {
    super (nbRows, nbColumns, bpp, width, height);
  }
  
  //GETTER SETTER=================================================================================
  String toStringFGH() {
    String result = "";
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node current = (Node)cells.get(j).get(i);     
        result += "(" + current.getF() + ", " + current.getG() + ", " + current.getH() + ") ";
      }
      
      result += "\n";
    }
    
    return result;
  }
  
    
  
  //METHODES======================================================================================
  void init() {
    cells = new ArrayList<ArrayList<Cell>>();
    
    for (int j = 0; j < rows; j++){
      cells.add (new ArrayList<Cell>()); // Instanciation des rangees
      
      for (int i = 0; i < cols; i++) {
        Cell temp = new Node(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
        
        // Position matricielle
        temp.i = i;
        temp.j = j;
        
        cells.get(j).add (temp);
      }
    }
    
    println ("rows : " + rows + " -- cols : " + cols);
  }
  
  
  //**********************************************
  //Sert a trouver si la celleule stard ou end ser a sur un mur
  boolean checkCellsForStartEnd(int x, int y){
    Node current = (Node)cells.get(y).get(x); 
    if (current.isWalkable) return true;
    return false; 
  }
    
    
  //**********************************************
  //Configure la cellule de départ
  void setStartCell (int i, int j) {
    
    if (start != null) {
      start.isStart = false;
      start.setFillColor(baseColor);
    } 
    
    start = (Node)cells.get(j).get(i);
    start.isStart = true;
    
    start.setFillColor(color (127, 0, 127));
  }
  
  //**********************************************
  //Configure la cellule de fin
  void setEndCell (int i, int j) {
    if (end != null) {
      end.isEnd = false;
      end.setFillColor(baseColor);
    }
    
    end = (Node)cells.get(j).get(i);
    end.isEnd = true;
    end.setFillColor(color (127, 127, 0));
  }
  
  //**********************************************
  //Met a jour les H des cellules doit etre appele apres le changement du noeud de debut ou fin
  void updateHs() {
    for (int j = 0; j < rows; j++) {          //0 a 99 (rows = 100)
      for (int i = 0; i < cols; i++) {        //0 a 99 (clos = 100)
        Node current = (Node)cells.get(j).get(i); 
        current.setH( calculateH(current));   
        //allNodes.add(current);
      }
    }
  }
  
  
  //**********************************************
  // Permet de generer aleatoirement le cout de deplacement entre chaque cellule
  void randomizeMovementCost() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        int cost = parseInt(random (0, cols)) + 1;
        
        Node current = (Node)cells.get(j).get(i);
        current.setMovementCost(cost);
      }
    }
  }
  
  //**********************************************
  // Permet de generer les voisins de la cellule a la position indiquee
  void generateNeighbours(int i, int j) {
    Node c = (Node)getCell (i, j);
    if (debug) println ("Current cell : " + i + ", " + j);
    
    for (Direction d : Direction.values()) {
      Node neighbour = null;
      
      switch (d) {
        case EAST :
          if (i < cols - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i + 1, j);
          }
          break;
          
        case SOUTH :
          if (j < rows - 1) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j + 1);
          }
          break;
          
        case WEST :
          if (i > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i - 1, j);
          }
          break;
          
        case NORTH :
          if (j > 0) {
            if (debug) println ("\tGetting " + d + " neighbour for " + i + ", " + j);
            neighbour = (Node)getCell(i, j - 1);
          }
          break;
      }
      
      if (neighbour != null) {
        if (neighbour.isWalkable) {
          c.addNeighbour(neighbour);
        }
      }
    }
  }
  
  //**********************************************
  //Génère les voisins de chaque Noeud. 
  //Pas la méthode la plus efficace car ça prend beaucoup de mémoire.
  //Idéalement, on devrait le faire au besoin
  void generateNeighbourhood() {
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        generateNeighbours(i, j);
      }
    }
  }
  
  
  //**********************************************
  //Permet de trouver le chemin le plus court entre deux cellules
  void findAStarPath () {
    if (start == null || end == null) {
      println ("No start and no end defined!");
      return;
    }
    
    
    
    //Algo A*
    //Partie init
    openList.clear();
    closeList.clear();
    //remttre a 0 les F                   //(F est calculer et non stoker dans ce prog G+H a chaque fois)
    updateHs();                           //Mettre tout les h 
    openList.add(start);
    start.setG(0);
   
    //Partie bloucle pour trouver chemin
    Node currentNode = null;
    boolean ok = false;
    int count = 0;
    
    while (openList.size() > 0) {
      count++;
      Node lowerCostNode = getLowestCost(openList);        //Trouver le node avec +petit F de openList
      
      if (lowerCostNode.isEnd) {                           //Si c'est la fin on sort boucle 
        ok = true;
        break; 
      }
      
      openList.remove(lowerCostNode);                      //Retire le noeud de la openList
      closeList.add(lowerCostNode);                        //Mettre noeud dans closeList
      
      currentNode = lowerCostNode;
      for (Node neighbour : lowerCostNode.neighbours) {    //Calculer G de tous les voisin du noeud courant
        if ( closeList.contains(neighbour) || !neighbour.isWalkable) continue;       //Si pas deja dans closeList ou que pas marchable
        else {
          int Gprime = currentNode.getG() + neighbour.getMvCost();                      //Calculer G' du neighbour (currentNode G + mvCost)
          
          if (openList.contains(neighbour) || (Gprime >= neighbour.getG()) ) continue;  //Si openList a neighbour || G' >= G de neighbour passe prochain voisin
          else {
            neighbour.setParent(currentNode);                                              //Set le currentNode comme parent au neighbour  
            neighbour.setG(Gprime);                                                        //Neighbour G = G'
            
            if (!openList.contains(neighbour)) openList.add(neighbour);                    //Si neighbour est dans openList                                                           
          }
        }
      }                                         
    }
    
    if (!ok) 
      println ("No path been find, sorry an error occur");
    else { 
      println ("A path been find, good");
      println(count);
      generatePath();
    }
  }
  
  
  //**********************************************
  //Permet de générer le chemin une fois trouvée
  void generatePath () {
    Node current = end;
    int count = 0;
    while (!current.isStart) {
      pathList.add(current);
      Node next = current;
      current = null;
      current = next.getParent();
      count++;
    }
    println("nb node chemin " + count);
    
    color c = color(200, 200,0);
    for (int i = pathList.size()-1; i > 0; i--) {
      Cell cell = pathList.get(i);
      cell.setFillColor(c);   
    }
  }
  
  
  //**********************************************
  //Cherche et retourne le noeud le moins couteux de la liste ouverte
  //@return Node le moins couteux de la liste ouverte
  private Node getLowestCost(ArrayList<Node> openList) {
    Node node = openList.get(0);

    for (int i = 1; i < openList.size(); i++) {
      if (node.getF() > openList.get(i).getF()) {
        node = openList.get(i);
      }
    }
    
    return node;
  }
  

 //**********************************************
 //Calcule le coût de déplacement entre deux noeuds 
 //@param nodeA Premier noeud
 //@param nodeB Second noeud
 //@return
  private int calculateCost(Cell a, Cell b) {
    int cost = 0;
    int dX = b.i - a.i;
    if (dX < 0) dX *= -1;
    int dY = b.j - a.j;
    if (dY < 0) dY *= -1;
    
    cost = (dX + dY) * start.getMvCost();
    return cost;
  }
  
  
  //**********************************************
  //Calcule l'heuristique entre le noeud donnée et le noeud finale
  //@param node Noeud que l'on calcule le H
  //@return la valeur H
  private int calculateH(Cell node) {
    int H = 0;
    int dX = end.i - node.i;
    if (dX < 0) dX *= -1;
    int dY = end.j - node.j;
    if (dY < 0) dY *= -1;
    
    H = (dX + dY) * start.getMvCost();
    return H;
  }
  
  
  //**********************************************
  // Permet de créer un mur à la position _i, _j avec une longueur et orientation données.
  void makeWall (int _i, int _j, int _length, boolean _vertical) {
    int max;
    
    if (_vertical) {
      max = _j + _length > rows ? rows: _j + _length;  
      
      for (int j = _j; j < max; j++) {
        ((Node)cells.get(j).get(_i)).setWalkable (false, 0);
      }       
    } 
    else {
      max = _i + _length > cols ? cols: _i + _length;  
      
      for (int i = _i; i < max; i++) {
        ((Node)cells.get(_j).get(i)).setWalkable (false, 0);
      }     
    }
  }
}
