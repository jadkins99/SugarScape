
/* TimeSeriesGraph -- time is on the x axis
 */
abstract class TimeSeriesGraph extends Graph {
  private int numUpdates;
  
  /* Calls Graph constructor Passes argument to the super-class constructor, and sets the number of update calls to 0.
  *
  * tested visually.
  */
  public TimeSeriesGraph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    super(x, y, howWide, howTall, xlab, ylab);
    numUpdates = 0;
  }
  
  /** In subclasses this will compute the y value of the next point in the graph.
   */
  public abstract int nextY(SugarGrid g);
  
  /*  Overrides the superclass update method. 
  *   If the "number of updates" -- the number of points updated so far -- is 0, calls the superclass update method. 
  *   Otherwise, calls nextY(g) to get the y-coordinate of the next point in the line. 
  *
  *   Draws a 1x1 square (i.e., a point; color is your choice) at the point that would be at 
  *   (number of updates, nextpoint(g)) in the graph that is being plotted. 
  *
  *   Increases the number of updates by 1. 
  *
  *   If the number of updates exceeds the width of the graph, set the number of updates back to 0 
  *   (erasing the graph on the next call, and starting over). 
  *
  * tested visually.
  */
  public void update(SugarGrid g) {
    if (numUpdates == 0) {
      super.update(g);
    }
    else {
      fill(0,0,255);
      rect(xOnScreen(numUpdates),yOnScreen(nextY(g)), 1, 1);
    }
    if (++numUpdates > howWide) {
      numUpdates = 0;
    }
  }
}

/** A line graph of the number of agents on the SugarScape
 */
class NumberOfAgentsTimeSeriesGraph extends TimeSeriesGraph {
  
  /* Constructor, calls parent constructor
  */
  public NumberOfAgentsTimeSeriesGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "steps", "agents");
  }

  /*
  */
  public int nextY(SugarGrid g) {
     return g.getAgents().size();
  }
}

/** A line graph of the number of agents on the SugarScape
 */
class AverageAgentSugarTimeSeriesGraph extends TimeSeriesGraph {
  
  /* Constructor, calls parent constructor
  */
  public AverageAgentSugarTimeSeriesGraph(int x, int y, int howWide, int howTall) {
    super(x, y, howWide, howTall, "Time", "Average Agent Sugar");
  }

  /*
  */
  public int nextY(SugarGrid g) {
    ArrayList<Agent> agts = g.getAgents();
    int totalSugar = 0;
    for (Agent agt: agts) {
      totalSugar += agt.getSugarLevel();
    }
    return totalSugar/agts.size();
  }
}

/** A line graph of the number of agents on the SugarScape
 */
class AverageAgentAgeTimeSeriesGraph extends TimeSeriesGraph {
  int maxAge;
  
  /* Constructor, calls parent constructor
  */
  public AverageAgentAgeTimeSeriesGraph(int x, int y, int howWide, int howTall, int maxAge) {
    super(x, y, howWide, howTall, "Time", "Average Agent Age");
    this.maxAge = maxAge;
  }

  /*
  */
  public int nextY(SugarGrid g) {
    ArrayList<Agent> agts = g.getAgents();
    int totalAge = 0;
    for (Agent agt: agts) {
      totalAge += agt.getAge();
    }
    int avgAge = totalAge/(agts.size() + 1);
    if (avgAge > maxAge) avgAge = maxAge;
    return howTall*avgAge/maxAge;
  }
}

class ProportionOfTrueCultureTimeSeriesGraph extends TimeSeriesGraph{
  public ProportionOfTrueCultureTimeSeriesGraph(int x, int y, int howWide, int howTall){
   super( x, y, howWide, howTall, "Time", "Prop. Agents in True Culture");
  }
  
  public int nextY(SugarGrid g){
    float propTrueCulture = 0;
    ArrayList<Agent> agentList = g.getAgents();
    for(Agent a: agentList){
      if(a.getTribe()) propTrueCulture++;
    }
    propTrueCulture /= agentList.size();
    propTrueCulture *= howTall;
    
    return (int)propTrueCulture;
  }
}
