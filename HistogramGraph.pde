
/** Histogram Graph -- 
 *  The x axis is whatever quantity counts, e.g., agent wealth.
 *  The y axis is the number of agents with that amount of wealth.
 */
abstract class HistogramGraph extends Graph {
  protected ArrayList<Integer> histogram; // created in subclass's initialize() method
  
  /* Calls Graph constructor Passes argument to the super-class constructor, and sets the number of update calls to 0.
  *
  * tested visually.
  */
  public HistogramGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
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
   *  Given values of a Histogram at agents i and i+1, finds the value for x between i and i+1
   *  The third parameter is a = x - i.
   */
   protected float interpolateHistogram(float loVal, float hiVal, float a) {
     return a*hiVal + (1-a)*loVal;
   }
}

/** Shows a cumulative distribution of sugarLevel over the set of live agents
 */
class WealthHistogramGraph extends HistogramGraph {
  private float valuesPerX;
  private int nextX;
  private int numAgents;
  
  /* Constructor, calls parent constructor
  */
  public WealthHistogramGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "sugar level", "fraction of agents");
  }

  /** Gets an ArrayList of Agents and sorts the list by sugar levels. 
   *  Fills histogram so that histogram[i] contains the number of values = i in the sorted list. 
   *  Sets valuesPerX, the number of values divided by the number of points to plot.
   *  Sets nextX to 0.
   */  
  public void initialize(SugarGrid g) {
    ArrayList<Agent> agts = g.getAgents();
    numAgents = agts.size();
    Sorter s = new MergeSorter();
    s.sort(agts); // by sugar level
    histogram = new ArrayList<Integer>(agts.get(numAgents-1).getSugarLevel());
    for (Agent agt: agts) {
      int sugar = agt.getSugarLevel();
      if (histogram.get(sugar) == null) histogram.set(sugar, new Integer(1));
      else histogram.set(sugar, histogram.get(sugar) + 1);
    }
    valuesPerX = (float)(agts.size())/howWide;
    nextX = 0;
  }
  
  /* returns true of nextX < howWide;
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
    int totalSugar = histogram.get(histogram.size()-1);
    float agtI = nextX*valuesPerX;
    float loVal = histogram.get((int)(Math.floor(agtI)));
    float hiVal = histogram.get(Math.min((int)(Math.ceil(agtI)), histogram.size()-1) );
    int retval = (int) (interpolateHistogram(loVal, hiVal, (float)(agtI - Math.floor(agtI))) * howTall / totalSugar);
    nextX += 1;
    return retval;
  }
}
