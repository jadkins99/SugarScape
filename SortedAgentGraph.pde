/** SortedAgent Graph -- 
 *  The x axis is agent, sorted by wealth (or whatever quantity we want to graph)
 *  The y axis is wealth (ditto).
 */
abstract class SortedAgentGraph extends Graph {
  
  /* Calls Graph constructor Passes argument to the super-class constructor, and sets the number of update calls to 0.
  *
  * tested visually.
  */
  public SortedAgentGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
  }
  
  /* 
  */  
  public abstract void initialize(SugarGrid g);
  public abstract boolean hasNextPoint();
  public abstract int nextX();
  public abstract int nextY();
  
  /*  Overrides the superclass update method. 
  *   Operates as follows:
  *   - Call the update() method of the superclass.
  *   - Call the initialize() method of the subclass, which initializes any internal state. 
  *   - Declare an int variable pixelX and set it to 0.
  *   - While the subclass object has a next point, 
  *     - Draw a 1x1 rectangle at (nextX(), nextY()). (Use xOnScreen and yOnScreen to put the rectangle at the right place.)
  *     - Increase pixelX by 1.
  *
  * tested visually.
  */
  public void update(SugarGrid g) {
    super.update(g);
    initialize(g);
    
    while(hasNextPoint()) {
      fill(0,0,255);
      rect(xOnScreen(nextX()),yOnScreen(nextY()), 1, 1);
    }
  }
  
  /** Helper for subclass nextY() methods. 
   *  Given values of a SortedAgent at agents i and i+1, finds the value for x between i and i+1
   *  The third parameter is a = x - i.
   */
   protected abstract float interpolateSortedAgents(float loVal, float hiVal, float a);
}

/** Shows a cumulative distribution of sugarLevel over the set of live agents
 */
class SortedAgentWealthGraph extends SortedAgentGraph {
  private ArrayList<Agent> agents; //created in initialize()
  private int totalWealth; 
  private float agentsPerX;
  private int nextX;
  
  /* Constructor, calls parent constructor
  */
  public SortedAgentWealthGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "sugar level", "fraction of agents");
  }

  /** Gets an ArrayList of Agents and sorts the list by sugar levels. 
   *  Fills wealth so that wealth[i] contains the number of values = i in the sorted list. 
   *  Sets agentsPerX, the number of values divided by the number of points to plot.
   *  Sets nextX to 0.
   */  
  public void initialize(SugarGrid g) {
    agents = g.getAgents();agents = g.getAgents();
    Sorter s = new MergeSorter();
    if(agents.size() > 0){
    s.sort(agents); // by sugar level
    }
    totalWealth = 0;
    for (Agent agt: agents) totalWealth += agt.getSugarLevel();
    agentsPerX = (float)(agents.size())/howWide;
    nextX = 0;
  }
  
  /* returns true if nextX < howWide;
  */
  public boolean hasNextPoint() {
   return (nextX < howWide);
  }
  
  /* getter for X
  */
  public int nextX() {
   return nextX; 
  }
  
  /* find the next Y and increment X
  */
  public int nextY() {
    if(agents.size() > 0){
    float agtI = nextX*agentsPerX;
    float loVal = agents.get((int)(Math.floor(agtI))).getSugarLevel();
    float hiVal = agents.get(Math.min((int)(Math.ceil(agtI)), agents.size()-1) ).getSugarLevel();
    int retval = (int) (interpolateSortedAgents(loVal, hiVal, (float)(agtI - Math.floor(agtI))) * howTall / totalWealth);
    nextX += 1;
    return retval;
    }
    else return 0;
  }
  
  /** Does not interpolate: sets to lower value
   */
  protected float interpolateSortedAgents(float loVal, float hiVal, float a) {
    return loVal;
  }

}
