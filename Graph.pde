class Graph {
  protected int x;
  protected int y;
  protected int howWide;
  protected int howTall;
  private String xlab;
  private String ylab;
  private int updates = 0;
  
  /*  initializes a new graph to be drawn with its upper left corner 
  *   at coordinates (x,y), with the specified width and height, and the specified axis labels.
  *
  * tested visually.
  */
  public Graph(int x, int y, int howWide, int howTall, String xlab, String ylab) {
    this.x = x;
    this.y = y;
    this.howWide = howWide;
    this.howTall = howTall;
    this.xlab = xlab;
    this.ylab = ylab;
  }
  
  /** These helper functions should be useful for any graph where 1pixel = 1x or 1y
   *  The first converts graph x value to screen x value.
   *  The second converts graph y value to screen y value
   */
  protected int xOnScreen(int xOnGraph) {
    return xOnGraph + x;
  }

  protected int yOnScreen(int yOnGraph) {
    return -yOnGraph + y + howTall;
  }

  /* Initializes a graph by drawing the axes.
  *  Subclasses will override this in one of two ways:
  *  - a subclass with time on the x-axis (e.g. TimeSeriesGraph) will update one point in the graph and re-initialize the graph 
  *    when all the points have been drawn.
  *  - other subclasses (e.g., WealthHistogramGraph) will redraw an entire graph at each time step.
  *
  *  Draws a white rectangle at coordinates (x,y), with the specified height and width. 
  *  Then draws a black line along the bottom of the rectangle for the x-axis, 
  *  and a black line along the left side for the y-axis. 
  *  Uses the text() method to write xlab underneath the graph, and ylab to the left of the graph.
  *
  * tested visually.
  */
  public void update(SugarGrid g) {
    noStroke();
    fill(255);
    rect(x, y, howWide, howTall);
    stroke(0);
    strokeWeight(1); // might make a member
    line(x, y+howTall, x+howWide, y+howTall);
    line(x, y+howTall, x, y);
    fill(0);
    writeRotatedText(xlab, x+howWide, y+howTall+15, 0);
    writeRotatedText(ylab, x-5, y, -PI/2.0);
    updates += 1;
  }
  
  /* writes rotated text at position (x,y)
  */
  private void writeRotatedText(String s, int i, int j, float angle) {
    pushMatrix();
    translate(i, j);
    rotate(angle);
    text(s, -s.length()*8, 0 );
    popMatrix();
  }
}
