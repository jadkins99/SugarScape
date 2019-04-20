class PollutionRule {
  private int gatheringPollution;
  private int eatingPollution;
  
  /* initializes a new PollutionRule class with a specified pollution rate for gathering or eating sugar on a given square.
  */
  public PollutionRule(int gatheringPollution, int eatingPollution) {
    this.gatheringPollution = gatheringPollution;
    this.eatingPollution = eatingPollution;
  }
  
  /*  If s is not occupied, then does nothing. 
  *   If an agent a is occupying s, then the pollution level of s is increased 
  *   by eatingPollution points for every point of metabolism agent a has, 
  *   and by gatheringPollution points for every point of sugar currently on s. 
  */
  public void pollute(Square s) {
    if (s.getAgent() != null) {
      s.setPollution(s.getPollution() + eatingPollution*s.getAgent().getMetabolism() + gatheringPollution*s.getSugar());
    }
  }
}

class PollutionRuleTester {
  public void test() {
    int gatheringPollution = 0;
    int eatingPollution = 0;
  
    PollutionRule pr = new PollutionRule(gatheringPollution, eatingPollution);
    //stubbed
  }
}
