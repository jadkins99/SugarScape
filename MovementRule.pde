import java.util.LinkedList;
import java.util.Collections;

interface MovementRule {
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle);
}

class SugarSeekingMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public SugarSeekingMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    for (Square s : neighborhood) {
      if (s.getSugar() > retval.getSugar() ||
          (s.getSugar() == retval.getSugar() && 
           g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle)
          )
         ) {
        retval = s;
      } 
    }
    return retval;
  }
}

class PollutionMovementRule implements MovementRule {
  /* The default constructor. For now, does nothing.
  *
  */
  public PollutionMovementRule() {
  }
  
  /* For now, returns the Square containing the most sugar. 
  *  In case of a tie, use the Square that is closest to the middle according 
  *  to g.euclidianDistance(). 
  *  Squares should be considered in a random order (use Collections.shuffle()). 
  */
  public Square move(LinkedList<Square> neighborhood, SugarGrid g, Square middle) {
    Square retval = neighborhood.peek();
    Collections.shuffle(neighborhood);
    boolean bestSquareHasNoPollution = (retval.getPollution() == 0);
    for (Square s : neighborhood) {
      boolean newSquareCloser = (g.euclideanDistance(s, middle) < g.euclideanDistance(retval, middle));
      if (s.getPollution() == 0) {
        if (!bestSquareHasNoPollution || s.getSugar() > retval.getSugar() ||
            (s.getSugar() == retval.getSugar() && newSquareCloser)
           ) {
          retval = s;
        }
      }
      else if (!bestSquareHasNoPollution) { 
        float newRatio = s.getSugar()*1.0/s.getPollution();
        float curRatio = retval.getSugar()*1.0/retval.getPollution();
        if (newRatio > curRatio || (newRatio == curRatio && newSquareCloser)) {
          retval = s;
        }
      }
    }
    return retval;
  }
}

class CombatMovementRule extends SugarSeekingMovementRule{
  int alpha;
  public CombatMovementRule(int alpha){
    this.alpha = alpha; 
  }
  
  public Square move(LinkedList<Square> neighbourhood,SugarGrid g, Square middle){
    Square target = null;
    Agent casualty;
    LinkedList<Square> squareList = neighbourhood;
    LinkedList<Square> updatedSquareList = new LinkedList<Square>();
    for(Square s:squareList){
      // rule 1. if of the same tribe remove
     if(middle.getAgent().getTribe() == s.getAgent().getTribe()){
       squareList.remove(s);
       continue;
     }
     // rule 2. if s's agent has more sugar, remove
     if(middle.getAgent().getSugarLevel() <= s.getAgent().getSugarLevel()){
      squareList.remove(s);
      continue;
     }
    }
    
    for(Square s:squareList){
      // rule 3
      if(s.getAgent() != null){
        // find the middle agent's vision of they moved to that square
        LinkedList<Square> potentialVision = g.generateVision(s.getX(),s.getY(),middle.getAgent().getVision());
        // for each square in potential vision, check if the the square's agent has more sugar than middle's agent and if its from a different tribe
        for(Square ss: potentialVision){
          // if the potential agent has more sugar than you and is from a different tribe remove that square
          if(ss.getAgent().getSugarLevel() > middle.getAgent().getSugarLevel() && ss.getAgent().getTribe() != middle.getAgent().getTribe()) squareList.remove(s);
        }
      }
    }  
    // rule 4 update sugar levels and max sugar levels to account for the agents sugar
    for(Square s: squareList){
      if(s.getAgent() != null){
        int newSugar = s.getSugar() + alpha;
        int newMaxSugar = s.getMaxSugar() + s.getAgent().getSugarLevel();
        
        updatedSquareList.add(new Square(s.getX(),s.getY(),newSugar,newMaxSugar));
      }
    }
   // rule 5
   Square targetSquare = super.move(updatedSquareList,g,middle);

   // find square corresponding to targetSquare
   for(Square s: squareList){
    if(targetSquare == null){
      // if targetSquare null don't do anything
    }
    else if(s.getX() == targetSquare.getX() && s.getY() == targetSquare.getY()){
     target = s; 
    }
   }
   // rule 6
   if(target.getAgent() == null){
    return target; 
   }   
   // rule 7
   else{
    casualty = target.getAgent(); 
    // rule 8
    target.setAgent(null);
    
    // rule 9
    middle.getAgent().sugarLevel += Math.min(alpha,casualty.getSugarLevel());
    
    // rule 10
    g.killAgent(casualty);
    
    // rule 11
    return target;
   }
    
  }  
}


class SugarSeekingMovementRuleTester {
  public void test() {
    SugarSeekingMovementRule mr = new SugarSeekingMovementRule();
    //stubbed
  }
}

class PollutionMovementRuleTester {
  public void test() {
    PollutionMovementRule mr = new PollutionMovementRule();
    //stubbed
  }
}
