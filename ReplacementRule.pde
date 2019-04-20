import java.util.Collections;
import java.util.Random;
import java.util.List;
import java.util.HashMap; // added
class ReplacementRule {
  private int minAge;
  private int maxAge;
  HashMap<Agent,Integer> maxAgeMap; // added
  AgentFactory fac;
  
  /* initializes a replacement rule with the specified values for minimum and maximum lifespans. 
  * fac will be used to generate any new random agents.
  */
  public ReplacementRule(int minAge, int maxAge, AgentFactory fac) {
    this.minAge = minAge;
    this.maxAge = maxAge;
    this.fac = fac;
    maxAgeMap = new HashMap<Agent,Integer>(); // added
  }
  
  /* This method accepts an Agent a, and determines whether the agent should be replaced yet. 
  * a should be replaced if it is no longer alive. 
  *
  * Further, if this is the first time ReplacementRule has been asked about Agent a, 
  * then generate a random integer between minAge and maxAge to represent the lifespan of a.
  *
  *   The assignment has this to say:
  *     Store this integer in a List as well as storing a reference to Agent a 
  *     (you may want to make an additional class to facilitate this, or use two lists).
  *
  *   Instead, we get and store the lifespan of a in a.lifespan using a.getLifespan() and a.setLifespan().
  *
  * When replaceThisOne(a) is subsequently called, it checks whether the age of a exceeds the randomly generated lifespan. 
  * If it does, then return true regardless of whether a is alive or not and set the age of a to maxAge + 1. 
  * The last step ensures that function will return a consistent value after an agent has gotten too old. 
  *
  * If a is null, returns false (the assignment says, "you may return any value").
  */
  public boolean replaceThisOne(Agent a) {
    if (a.getLifespan() == Agent.NOLIFESPAN) {
      Random r = new Random();
      int lifeSpan = minAge + r.nextInt(maxAge+1 - minAge); // added
      maxAgeMap.put(a,lifeSpan); // added
      a.setLifespan(lifeSpan); // slightly changed
    }
    else if(a == null){
     maxAgeMap.remove(a);      
    }
    else {
      if (a.getAge() > a.getLifespan()) {
        a.setAge(maxAge+1);
        return true;
      }
    }
    return false;
  }
  
  /* Returns a new Agent that is a replacement for Agent a. 
  * For now, both a and others should be ignored, though in future we might design rules that will use them. 
  * By including the parameters now, we can ensure that tests we write today will still work in the future.}
  */
  public Agent replace(Agent a, List<Agent> others) {
    return fac.makeAgent();
  }
}

class ReplacementRuleTester {
  public void test() {
    int minMetabolism = 3;
    int maxMetabolism = 6;
    int minVision = 2;
    int maxVision = 4;
    int minInitialSugar = 5;
    int maxInitialSugar = 10;
    MovementRule mr = new PollutionMovementRule();
    
    AgentFactory af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision, 
                                       minInitialSugar, maxInitialSugar, mr);
                                      
    int minAge = 40;
    int maxAge = 80;
    ReplacementRule rr = new ReplacementRule(minAge, maxAge, af);
                                       
    Agent a = af.makeAgent();
    
    assert(rr.replaceThisOne(a) == false);
    int ls = a.getLifespan();
    assert(ls <= maxAge && ls >= minAge);
    assert(rr.maxAgeMap.get(a) <= maxAge || rr.maxAgeMap.get(a) >= minAge);
    a.step();
    a.setLifespan(a.getAge() - 1);
    assert(rr.replaceThisOne(a) == true);
    List<Agent> others = null;
    a = rr.replace(a, others);
    assert(rr.replaceThisOne(a) == false);   
    
  }
}
