interface GrowthRule {
  public void growBack(Square s);
}

class GrowbackRule implements GrowthRule {
  int rate;
  
  /* Initializes a new GrowbackRule with the specified growth rate.
  *
  */
  public GrowbackRule(int rate) {
    this.rate = rate;
  }
  
  /* Increases the sugar in Square s by the growth rate, 
  *  up to the maximum value that can be stored in s. 
  *  Note: you should use only public methods of the Square class. 
  *  The Autograder will provide its own Square class, 
  *  which may not have the private methods or variable names you expect.
  */
  public void growBack(Square s) {
    s.setSugar(s.getSugar() + rate);
  }
}

class SeasonalGrowbackRule implements GrowthRule {
  private int alpha;
  private int beta;
  private int gamma;
  private int equator;
  private int numSquares; 
  private boolean northSummer;
  private int ageOfSeason;

  /* initializes a new seasonal growback rule with the specified parameter values. 
  * The season is initially set to northSummer.
  */
  public SeasonalGrowbackRule(int alpha, int beta, int gamma, int equator, int numSquares) {
    this.alpha = alpha;
    this.beta = beta;
    this.gamma = gamma;
    this.equator = equator;
    this.numSquares = numSquares;
    northSummer = true;
    ageOfSeason = 0;
  }
  
  /* operates in the following way:
  * If s is positioned at or above the equator (specified by the parameter equator), and it's northSummer, 
  * or if s is positioned below the equator and it's southSummer, 
  * then increase the sugar level by alpha, to a maximum of the maximum sugar level allowed on this square.
  *
  * If s is positioned at or above the equator (specified by the parameter equator), and it's southSummer, 
  * or if s is positioned below the equator and it's northSummer, 
  * then increase the sugar level by beta, to a maximum of the maximum sugar level allowed on this square.
  *
  * If this rule has been called gamma*numSquares times in total since the last change of seasons, then 
  * if it is currently northSummer, it must now be southSummer, and vice-versa.
  */
  public void growBack(Square s) {
    if ( (s.getY() <= equator && northSummer) || (s.getY() > equator && !northSummer)) {
      s.setSugar(s.getSugar() + alpha);
    }
    else {
      s.setSugar(s.getSugar() + beta);      
    }
    
    ageOfSeason += 1;
    if (ageOfSeason >= gamma*numSquares) {
      northSummer = !northSummer;
      ageOfSeason = 0;
    }
  }
  
  /* returns true if and only if it is currently northSummer.
  */
  public boolean isNorthSummer() {
    return northSummer;
  }
}


class GrowbackRuleTester {
  public void test() {
    int r = 4;
    GrowbackRule gr = new GrowbackRule(r);
    Square s = new Square(5, 10, 40, 40);
    gr.growBack(s);
    assert(s.getSugar() == 9);
    gr.growBack(s);
    assert(s.getSugar() == 10);
  }
}


class SeasonalGrowbackRuleTester {
  void test() {
    int alpha = 2;
    int beta = 1;
    int gamma = 1;
    int equator = 1;
    int numSquares = 4; 
    SeasonalGrowbackRule gr = new SeasonalGrowbackRule(alpha, beta, gamma, equator, numSquares);
    Square s = new Square(5, 10, 0, 0);
    gr.growBack(s);
    assert(gr.isNorthSummer());
    assert(s.getSugar() == 7);
    gr.growBack(s);
    assert(gr.isNorthSummer());
    assert(s.getSugar() == 9);
    gr.growBack(s);
    assert(gr.isNorthSummer());
    assert(s.getSugar() == 10);
    s.setMaxSugar(15);
    gr.growBack(s);
    assert(!gr.isNorthSummer());
    assert(s.getSugar() == 12);
    gr.growBack(s);
    assert(!gr.isNorthSummer());
    assert(s.getSugar() == 13);
  }
}
