import java.lang.Math;

class Square {
 /* Fields
  *   where the square is
  *    - x and y coordinates (on the grid, right? not on the screen)
  *   how much sugar is on the square right now 
  *   the maximum amount of sugar that the square can hold
  *     (should the max amount be forced to be the same for every square, or
  *      should we rely on the object that calls the constructor to enforce that?)
  *   whether the square is currently occupied, and who is occupying it
  *    - this should be an Agent reference, null for unoccupied
  */
  private int x;
  private int y;
  private int sugarLevel;
  private int maxSugarLevel;
  private Agent agent;
  private int pollution;
   
  /* Constructor
  *   initializes a new Square with the specified initial and maximum sugar levels, 
  *   and the specified x and y coordinates. The square should be unoccupied.
  *   Sets sugarLevel to at most maxSugarLevel
  */
  public Square(int sugarLevel, int maxSugarLevel, int x, int y) {
    this.sugarLevel = Math.min(sugarLevel, maxSugarLevel);
    this.maxSugarLevel = maxSugarLevel;
    this.x = x;
    this.y = y;
    pollution = 0;
  }
  
  /* Returns the current level of sugar
  */
  public int getSugar() {
    return sugarLevel; 
  }
  
  /* returns the maximum amount of sugar that can be stored here.
  *
  */
  public int getMaxSugar() {
    return maxSugarLevel; 
  }
  
  /* returns the x coordinate of the Square
  *  (on the grid, right?)
  *
  */
  public int getX() {
    return x; 
  }
  
  /* returns the y coordinate of the Square
  *  (on the grid, right?)
  *
  */
  public int getY() {
    return y;
  }
  
  /* Returns the current level of pollution
  */
  public int getPollution() {
    return pollution; 
  }

  /* Sets the sugar level to the specified value. 
  *  If the value is negative, sets the sugar level to 0 instead. 
  *  If the value is larger than the maximum amount of sugar that can be stored here, 
  *  sets the sugar level to the maximum value instead.
  *
  */
  public void setSugar(int howMuch) {
    setSugar(howMuch, false);
  }
  
  public void setSugar(int howMuch, boolean force) {
    if (force == true && howMuch > maxSugarLevel) {
      maxSugarLevel = howMuch;
      sugarLevel = howMuch;
    }
    else {
      sugarLevel = Math.max(0, Math.min(howMuch, maxSugarLevel));
    }
  }
  
  /* Sets the maximum sugar level to the specified value. 
  *  If the specified value is less than 0, sets the maximum sugar level to 0 instead. 
  *  Adjusts the current sugar level to ensure it is no larger than the updated maximum.
  *
  */
  public void setMaxSugar(int howMuch) {
    maxSugarLevel = Math.max(0, howMuch);
    sugarLevel = Math.min(sugarLevel, maxSugarLevel);
  }
  
  /* Returns the Agent object that currently occupies this Square, if any. 
  *  Returns null if no Agent is present. 
  *  You may make an empty Agent class to ensure your code compiles, and 
  *  to facilitate tests of your code. 
  *  The test system will provide its own Agent class.
  *
  */
  public Agent getAgent() {
    return agent;
  }
  
  /* Sets the Agent currently occupying this Square to the specified Agent a. 
  *  If this Square is not empty, then:
  *     unless the current agent is the same as the specified Agent or 
  *     the specified Agent is null, this should produce an error instead 
  *     (use assert(false)).
  *
  */
  public void setAgent(Agent a) {
    if (agent != null && a != null) {
      if (!agent.equals(a)) {
        assert(false);
      }      
    }
    agent = a;
    if (a != null) a.setSquare(this);
  }
  
  /* Sets the pollution level 
  */
  public void setPollution(int p) {
    pollution = p;
  }

  /* Draws a Square. 
  *  The Square should be drawn as a size*size square 
  *  at position (size*xOffset, size*yOffset). 
  *
  *  The square should have a while border 4 pixels wide. 
  *  The square should be colored as a function of its Sugar Levels. 
  *  An example color scheme is to use shades of yellow: 
  *    (255, 255, 255 - sugarLevel/6.0*255)
  *
  */
  public void display(int size) {
    int smallsize = Math.max(0, size-8);
    noStroke();
    fill(255);
    rect(x*size, y*size, size, size);
    fill(255, 255, 255 - sugarLevel/6.0*255);
    rect(x*size+4, y*size+4, smallsize, smallsize);
    
    if (agent != null) {
      agent.display(x*size + size/2, y*size + size/2, smallsize);
    }
  }
  
   public void display(int size,boolean culture,boolean fertility,FertilityRule f) {
    int smallsize = Math.max(0, size-8);
    noStroke();
    fill(255);
    rect(x*size, y*size, size, size);
    fill(255, 255, 255 - sugarLevel/6.0*255);
    rect(x*size+4, y*size+4, smallsize, smallsize);
    
    if (agent != null) {
      agent.display(x*size + size/2, y*size + size/2, smallsize,culture,fertility,f);
    }
  }
  
  /* Two squares are equal if they share the same location and properties
  */
  public boolean equals(Square other) {
    if (this.x == other.getX()
        && this.y == other.getY()
        && this.sugarLevel == other.getSugar()
        && this.maxSugarLevel == other.getMaxSugar()
        && this.agent.equals(other.getAgent())
       ) {
      return true;
    }
    else {
      return false;
    }
  }
}


class SquareTester {
  void test() {
    
    // test constructor, get/set Sugar and MaxSugar
    // square with sugarLevel 5, maxSugarLevel 9, position (x, y) = (15, 15)
    Square s = new Square(5, 9, 20, 20); 
    assert (s.getMaxSugar() == 9);
    s.setMaxSugar(4);
    assert(s.getSugar() == 4);
    s.setSugar(s.getSugar()-1);
    assert(s.getSugar() == 3);
    s.setSugar(-1);
    assert (s.getSugar() == 0);
    s.setSugar(5);
    assert (s.getSugar() == 4);
    s.setMaxSugar(-1);
    assert (s.getMaxSugar() == 0);
    assert (s.getSugar() == 0);
    
    // test get/set Agent
    assert (s.getAgent() == null);
    Agent a = new Agent(3, 2, 4, null);
    s.setAgent(a);
    assert (s.getAgent() == a);
    
    s.setMaxSugar(10);
    s.setSugar(8);
    
    Square s2 = new Square(8, 10, 20, 20);
    s2.setAgent(new Agent(3, 2, 4, null));
    assert(!s2.equals(s));
    s2.setAgent(null);
    s2.setAgent(a);
    assert(s2.equals(s));
    assert(s.equals(s2));
    
    s.setSugar(11, true);
    assert(s.getSugar() == 11);
    assert(s.getMaxSugar() == 11);

    s.display(20);
  }
}
