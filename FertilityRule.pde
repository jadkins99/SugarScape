import java.util.Map;
import java.util.Random;
import java.util.HashMap;
public class FertilityRule{
Integer[] xChildbearingOnset;
Integer[] xClimactericOnset;
Integer[] yChildbearingOnset;
Integer[] yClimactericOnset;
HashMap<Agent,Integer[]> agentFertilityWindow;
HashMap<Agent,Integer> agentBeginningSugar;

// constructor for FertilityRule 
public FertilityRule(Map<Character, Integer[]> childbearingOnset, Map<Character,Integer[]> climactericOnset){
  
  // make sure the maps contain X and Y
  assert(childbearingOnset.containsKey('X') && childbearingOnset.containsKey('Y'));
  assert(climactericOnset.containsKey('X') && climactericOnset.containsKey('Y'));
  
  // assign variables for each interval of ages
  this.xChildbearingOnset = childbearingOnset.get('X');
  this.xClimactericOnset = climactericOnset.get('X');
  
  this.yChildbearingOnset = childbearingOnset.get('Y');
  this.yClimactericOnset = climactericOnset.get('Y');
  
  // create maps for agents fertility and the initial sugar they had when they were given by their fertility range
  this.agentFertilityWindow = new HashMap<Agent, Integer[]>();
  this.agentBeginningSugar = new HashMap<Agent,Integer>();
    
}
// method for checking if an agent is fertile
public boolean isFertile(Agent a){
  // if a is dead remove a from maps and return false
  if(a == null){
    agentFertilityWindow.remove(a);
    agentBeginningSugar.remove(a);
    return false;
  }
  
  // if a is not dead but does not have a fertility range
  else if(!agentFertilityWindow.containsKey(a)){
    Random r = new Random();
    // if a is female
    if(a.getSex() == 'X'){
      // create random fertileStart and fertileEnd within the childbearing Onset and climactericOnset intervals
      int fertileStart = r.nextInt((xChildbearingOnset[1] - xChildbearingOnset[0]) + 1) + xChildbearingOnset[0];
      int fertileEnd = r.nextInt((xClimactericOnset[1] - xClimactericOnset[0]) + 1) + xClimactericOnset[0];
      agentFertilityWindow.put(a,new Integer[]{fertileStart,fertileEnd});
      agentBeginningSugar.put(a,a.getSugarLevel());
    }
    
    // if a is male
    else if(a.getSex() == 'Y'){
      // create random fertileStart and fertileEnd within the childbearing Onset and climactericOnset intervals
      int fertileStart = r.nextInt((yChildbearingOnset[1] - yChildbearingOnset[0]) + 1) + yChildbearingOnset[0];
      int fertileEnd = r.nextInt((yClimactericOnset[1] - yClimactericOnset[0]) + 1) + yClimactericOnset[0];
      agentFertilityWindow.put(a,new Integer[]{fertileStart,fertileEnd});
      agentBeginningSugar.put(a,a.getSugarLevel());
    }
  }
  // if a's age is within a's fertility interval
  if(a.getAge() >= agentFertilityWindow.get(a)[0] && a.getAge() <= agentFertilityWindow.get(a)[1]){
    //  and if a's current sugarlevel is greater than or equal to what is was initially
    if(a.getSugarLevel() >= agentBeginningSugar.get(a)){
      // then return true
      return true;
    }    
  }
    
  return false;
}

public boolean canBreed(Agent a, Agent b,LinkedList<Square> local){
  boolean bInLocal = false;
  boolean emptySquareInLocal = false;
  
  // if both a and and b are fertile
  if(isFertile(a) && isFertile(b)){
    
    // if a and b are of different sex
    if(a.getSex() != b.getSex()){
      
      // check if b is in local
      for(Square s : local){
       if(s.getAgent() != null){
         if(s.getAgent().equals(b)){
           bInLocal = true;
           break;
         }
        }
      }
      
      // check if there is an empty square in local
      for(Square s: local){
       if(s.getAgent() == null){
         emptySquareInLocal = true;
         break;
       }
      }
      
      // if b is in local and there is an empty square in local return true
      if(bInLocal && emptySquareInLocal) return true;
    }
  }
  
  // if the previous conditions are not met, return false
  return false;
}

// method for breeding two agents
public Agent breed(Agent a, Agent b, LinkedList<Square> aLocal, LinkedList<Square> bLocal){
  
  // if a and b cannot both breed return null
  if(!(canBreed(a,b,aLocal) && canBreed(b,a,bLocal))) return null;
  
  // create instance variables for the new baby
  int babyMetabolism;
  int babyVision;
  MovementRule babyMovementRule;
  char babySex;
  int babyInitialSugar= 0;
  Random r = new Random();
  
  // randomly assign the baby's metabolism from the two parents 
  if(r.nextBoolean()) babyMetabolism = a.getMetabolism();
  else babyMetabolism = b.getMetabolism();
  
  // randomly assign the baby's vision from the two parents 
  if(r.nextBoolean()) babyVision = a.getVision();
  else babyVision = b.getVision();
  
  // randomly assign the baby's movementRule from the two parents
  if(r.nextBoolean()) babyMovementRule = a.getMovementRule();
  else babyMovementRule = b.getMovementRule();
  
  // randomly assign the baby's sex
  if(r.nextBoolean()) babySex = 'X';
  else babySex = 'Y';
  
 
  //babyInitialSugar = agentBeginningSugar.get(a)/2 + agentBeginningSugar.get(b)/2;
  
  // create new baby
  Agent baby = new Agent(babyMetabolism,babyVision,babyInitialSugar,babyMovementRule,babySex);
   // assign the baby's initial sugar level to half of half of a's initial sugar level and half of b's initial sugar level
  a.gift(baby,agentBeginningSugar.get(a)/2);
  b.gift(baby,agentBeginningSugar.get(b)/2);
  
  // parents nurture the baby
  baby.nurture(a,b);
  
  // randomly pick between a's local and b's local and then set the baby to a empty square in that local
  if(r.nextBoolean()){
    for(Square s: aLocal){
      if(s.getAgent() == null){      
        s.setAgent(baby);
        break;
      }
    }
  }
  else{
    for(Square s: bLocal){
     if(s.getAgent() == null){
       s.setAgent(baby); 
       break;
     }
    }       
  }  
  return baby;
}
}

public class FertilityRuleTester{
  public void test(){
    Integer[] ageRange = {12,15};
    Integer[] ageRange2 = {30,40};
    Map h1 = new HashMap();
    Map h2 = new HashMap();
    h1.put('X',ageRange);
    h1.put('Y',ageRange);
    h2.put('X',ageRange2);
    h2.put('Y',ageRange2);
    
    
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
    
   SugarGrid sg = new SugarGrid(50,50,10,new GrowbackRule(1),f,rr);
   
    Agent a1 = new Agent(2,3,5,new SugarSeekingMovementRule(),'Y');
    Agent a2 = new Agent(2,3,5,new SugarSeekingMovementRule(),'X');
    Agent a3 = new Agent(2,3,5,new SugarSeekingMovementRule(),'Y');
    Agent a4 = new Agent(2,3,5,new SugarSeekingMovementRule(),'X');
    
   assert(!f.isFertile(a1));
   assert(!f.isFertile(a2));
   assert(!f.isFertile(a3));
   assert(!f.isFertile(a4));
   a1.setAge(15);
   a2.setAge(15);
   assert(f.isFertile(a1));
   assert(f.isFertile(a2));
   sg.placeAgent(a1,2,2);
   sg.placeAgent(a2,1,2);
   sg.placeAgent(a3,1,3);
   sg.placeAgent(a4,4,3);
   assert(f.canBreed(a1,a2,sg.generateVision(2,2,1)));
   assert(f.canBreed(a2,a1,sg.generateVision(1,2,1)));
   assert(!f.canBreed(a1,a4,sg.generateVision(2,2,1)));
   assert(!f.canBreed(a4,a1,sg.generateVision(2,3,1)));
   
  }  
}
