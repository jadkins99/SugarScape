import java.lang.Math;
import java.util.HashSet;
import java.util.Collections;
import java.util.Random;

class SugarGrid {

  private Square[][] grid;
  private int howWide;
  private int howHigh;
  private int squareSideLength;
  private GrowthRule growthRule;
  private FertilityRule fertilityRule;
  private ReplacementRule replacementRule;
  private Random rand;
  
  /* Initializes a new SugarGrid object with a w*h grid of Squares, 
  *  a sideLength for the squares (used for drawing purposes only) 
  *  of the specified value, and 
  *  a sugar growback rule g. 
  *  Initialize the Squares in the grid to have 0 initial and 0 maximum sugar.
  *
  */
  
   public SugarGrid(int w, int h, int sideLength, GrowthRule g,FertilityRule f,ReplacementRule rr) {
    this.howWide = w;
    this.howHigh = h;
    this.squareSideLength = sideLength;
    this.replacementRule = rr;
    this.fertilityRule = f;
    growthRule = g;
    rand = new Random();
    
    // make the grid, initially with 0-max-sugar Squares
    grid = new Square[howWide][howHigh];
    for (int i = 0; i < howWide; i++) {
      for (int j = 0; j < howHigh; j++) {
        grid[i][j] = new Square(0, 0, i, j);
      }
    }
  }
  

  

  /* Accessor methods for the named variables.
  *
  */
  
  /* Accessors
  */
  public int getWidth() {
    return howWide;
  }
  
  public int getHeight() {
    return howHigh;
  }
  
  public int getSquareSize() {
    return squareSideLength;
  }
  
  /* returns respectively the initial or maximum sugar at the Square 
  *  in row i, column j of the grid.
  *
  */
  public int getSugarAt(int i, int j) {
    assert(i >= 0 && j >= 0 && i < howWide && j < howHigh);
    return grid[i][j].getSugar(); 
  }
 
  public int getMaxSugarAt(int i, int j) {
    assert(i >= 0 && j >= 0 && i < howWide && j < howHigh);
    return grid[i][j].getMaxSugar(); 
  }

  /* returns the Agent occupying the square at position (i,j) in the grid, 
  *  or null if no agent is present there.
  *
  */
  public Agent getAgentAt(int i, int j) {
    assert(i >= 0 && j >= 0 && i < howWide && j < howHigh);
    return grid[i][j].getAgent(); 
  }

  /* places Agent a at Square(i,j), provided that the square is empty. 
  *  If the square is not empty (and doesn't contain a), the program should crash with an assertion failure.
  *
  */
  public void placeAgent(Agent a, int i, int j) {
    assert(i >= 0 && j >= 0 && i < howWide && j < howHigh);
    Square s = grid[i][j];
    if (s.getAgent() == null) {
      s.setAgent(a);
      a.setSquare(s);
    }
    assert(s.getAgent().equals(a));
  }

  /* A method that computes the Euclidian distance between two squares on the grid 
  *  at (x1,y1) and (x2,y2). 
  *  Points are indexed from (0,0) up to (width-1, height-1) for the grid. 
  *  The formula for Euclidean distance is normally sqrt( (x2-x1)2 + (y2-y1)2 ) However...
  *  
  *  As in the book, the grid is a torus. 
  *  This means that an Agent that moves off the top of the grid ends up at the bottom 
  *  (and vice versa), and 
  *  an Agent that moves off the left hand side of the grid ends up on the right hand 
  *  side (and vice versa). 
  *
  *  You should return the minimum euclidian distance between the two points. 
  *  For example, euclidianDistance((1,1), (19,19)) on a 20x20 grid would be 
  *  sqrt(2*2 + 2*2) = sqrt(8) ~ 3, and not sqrt(18*18 + 18*18) = sqrt(648) ~ 25. 
  *
  *  The built-in Java method Math.sqrt() may be useful.
  *
  */
  public double euclideanDistance(Square s1, Square s2) {
    int xDiff = s1.getX() - s2.getX();
    int yDiff = s1.getY() - s2.getY();
    if (xDiff > this.howWide/2) xDiff = howWide - xDiff;
    if (yDiff > howHigh/2) yDiff = howHigh - yDiff;
    return Math.sqrt(Math.pow(xDiff, 2) + Math.pow(yDiff, 2));
  }
  
  /* Creates a circular blob of sugar on the gird. 
  *  The center of the blob is at position (x,y), and 
  *  that Square is updated to store a maximum of max sugar or 
  *  its current maximum value, whichever is greater. 
  *
  *  Then, every square within euclidian distance of radius is updated 
  *  to store a maximum of (max-1) sugar, or its current maximum value, 
  *  whichever is greater. 
  *
  *  Then, every square within euclidian distance of 2*radius is updated 
  *  to store a maximum of (max-2) sugar, or its current maximum value, 
  *  whichever is greater. 
  *
  *  This process continues until every square has been updated. 
  *  Any Square that has a new maximum value 
  *  should also have its Sugar level set to this maximum.
  *
  */
  public void addSugarBlob(int x, int y, int radius, int max) {
    Square xy = new Square(0, 0, x, y);
    for (int i = 0; i < howWide; i++) {
      for (int j = 0; j < howHigh; j++) {
        Square s = grid[i][j];
        int radii = (int) Math.ceil(euclideanDistance(s, xy)/radius);
        s.setSugar(s.getSugar() + Math.max(0, max - radii), true);
      }
    }
  }
  
  /* Returns a linked list containing radius squares in each cardinal direction, 
  *  centered on (x,y). 
  *
  *  For example, generateVision(5,5,2) should return the squares 
  *   (5,5), (4,5), (3,5), (6,5), (7,5), (5,4), (5,3), (5,6), and (5,7). 
  *
  *  returns all of these points that are on the grid; if radius < 0 returns an empty list  
  *
  *  When radius is 0, returns a list containing only (x,y). 
  *
  */
  public LinkedList<Square> generateVision(int x, int y, int radius) {
    LinkedList<Square> retval = new LinkedList<Square>();
    if (radius < 0) {
      return retval;
    }
    for (int i = -radius; i <= radius; i++) {
      if (y+i >= 0 && y+i < howHigh && x >= 0 && x < howWide) {
        retval.add(grid[x][y+i]);
      }
      if (x+i >= 0 && x+i < howWide && i != 0 && y >= 0 && y < howHigh) {
        retval.add(grid[x+i][y]);
      }
    }
    return retval;
  }
  
  /* Adds agent at a Square
  */
  public void addAgentAt(Agent ag, int i, int j) {
    grid[i][j].setAgent(ag);
  }
  
  // kills agent
  public void killAgent(Agent a){
    a.sugarLevel = 0;
    a = null;
    fertilityRule.isFertile(a);
    replacementRule.replaceThisOne(a);
  }

  /* Updates the grid by one step. Each square on the grid is processed in turn, according the following steps:
   * 1. The GrowbackRule of this grid is applied to the Square, possibly increasing its sugar level.
   * 2. If the square is not occupied, then we're done, and can go to the next square.
   * 3. If the square has an agent in it, then:
   *   a. The agent burns its stored sugar based on its metabolic rate.
   *   b. If the agent is now dead, mark its current square as unoccupied.
   *   c. If the agent is still alive, generate vision for the agent (based on the agent's vision radius)
   *   d. Apply the agent's movement rule to determine where the agent wants to move.
   *   e. Move the agent to its preferred square, provided the target square is not occupied.
   *   f. Make the agent eat all the sugar on the current square.
   *
   * New for A6: uses a HashSet instead of an grid of booleans to track newly occupied Squares (so as not to let an agent move twice in one udpate)
   */
  public void update() {
    HashSet<Square> seenSquares = new HashSet<Square>();
    for (int i = 0; i < howWide; i++) {
      for (int j = 0; j < howHigh; j++) {
        Square s = grid[i][j];
        growthRule.growBack(s);
        if (seenSquares.contains(s)) {
          continue;
        }
        Agent a = s.getAgent();
        if (a == null) {         
          continue;
        }
        
         
        a.step(); // d and e before a, b, and c -- or could put step() inside Agent.move()
        if (!a.isAlive()) {
          s.setAgent(null);
          continue;
        }
        LinkedList<Square> vision = generateVision(i, j, a.getVision());
        Square dest = a.getMovementRule().move(vision, this, s);
        
        if (dest.getAgent() == null) {
          a.move(s, dest);
          seenSquares.add(dest);
        }
        
          // neighbors adjacent to a
        LinkedList<Square> neighbors = generateVision(i,j,1);
        
        Collections.shuffle(neighbors);
        
         for(Square adj: neighbors){
         if(adj.getAgent() != null){
          Agent b = adj.getAgent();
          // if a is not b influence b
          if(!a.equals(b))
          a.influence(b);  
         }
         }  
         
         if(rr.replaceThisOne(a)){
         a.getSquare().setAgent(null); 
         continue;
        } 
        
        else{
        a.eat(dest);   
        }
        
         LinkedList<Square> aLocal = generateVision(a.getSquare().getX(),a.getSquare().getY(),1);      
         
         for(Square s1: aLocal){
          if(s1.getAgent() != null){
           Agent b = s1.getAgent(); 
           LinkedList<Square> bLocal = generateVision(b.getSquare().getX(),b.getSquare().getY(),1);
           f.breed(a,b,aLocal,bLocal);
          }
         }
          
         
                 
                  
      }
        }       
      }
           

  /* Display each square
  */
  public void display() {
    for (int i = 0; i < howWide; i++) {
      for (int j = 0; j < howHigh; j++) {
        grid[i][j].display(squareSideLength);
      }
    }    
  }
  
    public void display(boolean culture,boolean fertility,FertilityRule f) {
    for (int i = 0; i < howWide; i++) {
      for (int j = 0; j < howHigh; j++) {
        grid[i][j].display(squareSideLength,culture,fertility,f);
      }
    }    
  }
  
  /* inserts agent a at a randomly selected position on the grid. 
  * Puts the agent at the first unoccupied "random" position. Following these instructions: 
  *     You may use any method you like to determine where the agent is placed, 
  *     but it must place the agent at a different location each time, and 
  *     it must be possible for the agent to be placed at any unoccupied location.
  * The SugarGrid stores a randomly shuffled list of all square positions and cycles through the list
  *
  * Does nothing if an unoccupied Square can't be found
  */
  public void addAgentAtRandom(Agent a) {
    Square s = getRandomUnoccupiedSquare();
    s.setAgent(a);
  }
    
  /* Gets a random unoccupied square 
  *  Returns null after nlogn tries, n = #squares
  */
  private Square getRandomUnoccupiedSquare() {
    int limit = (int) (howWide*howHigh*Math.log(howWide*howHigh));
    for (int n = 0; n < limit; n++) {
      int i = rand.nextInt(howWide);
      int j = rand.nextInt(howHigh);
      Square s = grid[i][j];
      if (s.getAgent() == null) {
        return s;
      }
    }
    return null;
  }
  
  /* returns a list of all agents on the SugarGrid at present.
  *
  */
  public ArrayList<Agent> getAgents() {
    ArrayList<Agent> retval = new ArrayList<Agent>();
    for (int i = 0; i < howWide; i++) {
      for (int j = 0; j < howHigh; j++) {
        Agent a = grid[i][j].getAgent();
        if (a != null) {
          retval.add(a);
        }
      }
    }
    return retval;
  }
  
}


class SugarGridTester {
  void test() {
    GrowbackRule gr = null;
    int w = 2;
    int h = 2;
    int sideLength = 15;
    
  int minAgeDeath = 60;
  int maxAgeDeath = 100;
  


  rr = new ReplacementRule(minAgeDeath,maxAgeDeath,new AgentFactory(1,2,3,4,5,6,new SugarSeekingMovementRule()));
  
    Integer[] childbearingOnset = {12,15};
    Integer[] xClimactericOnset = {40,50};
    Integer[] yClimactericOnset = {50,60};
    Map childbearingOnsetMap = new HashMap();
    Map climactericOnsetMap = new HashMap();
    childbearingOnsetMap.put('X',childbearingOnset);
    childbearingOnsetMap.put('Y',childbearingOnset);
    climactericOnsetMap.put('X',xClimactericOnset);
    climactericOnsetMap.put('Y',yClimactericOnset);
    
   f = new FertilityRule(childbearingOnsetMap,climactericOnsetMap);
    
    // constructor, accessors
    SugarGrid sg = new SugarGrid(w, h, sideLength, gr,f,rr);
    
    
    assert(sg.getWidth() == 2);
    assert(sg.getHeight() == 2);
    assert(sg.getSquareSize() == 15);
    
    assert(sg.getSugarAt(0, 1) == 0);
    assert(sg.getMaxSugarAt(0, 1) == 0);
    assert(sg.getAgentAt(0, 1) == null);
    
    // add sugar blob
    int x = 0;
    int y = 1;
    int radius = 1;
    int max = 2;
    sg.addSugarBlob(x, y, radius, max);
    assert(sg.getSugarAt(0, 1) == 2);
    assert(sg.getSugarAt(0, 0) == 1);
    assert(sg.getSugarAt(1, 0) == 0);
    
    // distance
    Square s1 = new Square(5, 9, 10, 10);
    Square s2 = new Square(5, 9, 13, 14);
    assert(sg.euclideanDistance(s1,s2) == 5.0d);
    
    // vision
    LinkedList<Square> ll = sg.generateVision(1, 3, 4);
    assert(ll.size() == 2);
    
    // place agents
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
       
    /* display
    Agent a01 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    Agent a10 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    sg.placeAgent(a01, 0, 1);
    sg.placeAgent(a10, 1, 0);
    sg.display();
    */
    
    // add agents at random
    Agent a1 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    Agent a2 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    sg.addAgentAtRandom(a1);
    sg.addAgentAtRandom(a2);
    assert(!a1.getSquare().equals(a2.getSquare()));
    assert(a1.getSquare().getAgent() == a1);
    assert(a2.getSquare().getAgent() == a2);
    
    // get array of agents
    ArrayList<Agent> agtarr = sg.getAgents();
    assert(agtarr.size() == 2);
    assert(agtarr.get(0) == a1 || agtarr.get(0) == a2);
  }
}
