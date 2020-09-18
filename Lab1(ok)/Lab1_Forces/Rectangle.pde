class Rectangle {
  float x, y, w, h;
  
  
  //Constructeurs=======================================================================
  Rectangle(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  //====================================================================================
  
  
  
  float left () {return x;}
  float top () {return y;}
  float right () {return x + w;}
  float bottom () {return y + h;}
  float getHeight() {return h;}
  
  //+++++++++++++++++++++++++++++++++++++
  Boolean contains(Rectangle _r) {
    Boolean result = false;
    
    if (x <= _r.x && ((x + w) >= (_r.x + _r.w)) && y <= _r.y && ((y + h) >= (_r.y + _r.h))) {
      result = true;
    }
    
    return result;
  }
  
  //+++++++++++++++++++++++++++++++++++++
  Boolean intersect(Rectangle _r) {
    Boolean result = false;
    
    if (!(this.left() > _r.right() ||
        this.right() < _r.left() ||
        this.top() > _r.bottom() ||
        this.bottom() < _r.top())) {
      result = true;
    }
        
    return result;
  }
   
   
  //++++++++++++++++++++++++++++++++++++ 
  void display() {
    rect (x, y, w, h);
  }
  
  //++++++++++++++++++++++++++++++++++++ 
  void setSize(float y, float h) {
    this.y = y;
    this.h = h; 
  }
}
