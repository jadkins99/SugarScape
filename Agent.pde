import java.lang.Math;
import java.util.Random;
class Agent {
  public static final int NOLIFESPAN = -999;
  private int metabolism;
  private int vision;
  private int sugarLevel;
  private MovementRule movementRule;
  private int age;
  private int lifespan;
  private Square square;
  private char sex;
  private boolean[] culture;
  Random r = new Random();
  /* initializes a new Agent with the specified values for its 
  *  metabolism, vision, stored sugar, and movement rule.
  *
  */
  public Agent(int metabolism, int vision, int initialSugar, MovementRule m) {
    
    if(r.nextBoolean()){
      this.sex = 'Y';
    }
    else{
     this.sex = 'X'; 
    }
    this.metabolism = metabolism;
    this.vision = vision;
    this.sugarLevel = initialSugar;
    this.movementRule = m;
    this.culture = new boolean[11];
    
    for(int i = 0; i < 11;i++){
      culture[i] = r.nextBoolean();
    }
 
    age = 0;
    lifespan = NOLIFESPAN;
    square = null;
  }
  
  public Agent(int metabolism, int vision, int initialSugar, MovementRule m,char sex) {
    assert(sex == 'X' || sex == 'Y');
    this.sex = sex;
    this.metabolism = metabolism;
    this.vision = vision;
    this.sugarLevel = initialSugar;
    this.movementRule = m;
    this.culture = new boolean[11];
    age = 0;
    lifespan = NOLIFESPAN;
    square = null;
  }
  
  /* returns the amount of food the agent needs to eat each turn to survive. 
  *
  */
  public int getMetabolism() {
    return metabolism; 
  } 
  
  public char getSex(){
    
   return sex; 
  }
  
  /* returns the agent's vision radius.
  *
  */
  public int getVision() {
    return vision; 
  } 
  
  /* returns the amount of stored sugar the agent has right now.
  *
  */
  public int getSugarLevel() {
    return sugarLevel; 
  } 
  
  /* returns the Agent's movement rule.
  *
  */
  public MovementRule getMovementRule() {
    return movementRule; 
  } 
  
  /* returns the Agent's age.
  *
  */
  public int getAge() {
    return age; 
  } 
  
  /* sets the Agent's age.
  *
  */
  public void setAge(int howOld) {
    assert(howOld >= 0);
    this.age = howOld; 
  } 
  
  /* returns the Agent's lifespan.
  *
  */
  public int getLifespan() {
    return lifespan; 
  } 
  
  /* sets the Agent's lifespan.
  *
  */
  public void setLifespan(int span) {
    assert(span >= 0);
    this.lifespan = span; 
  } 
  
  /* returns the Square occupied by the Agent.
  *
  */
  public Square getSquare() {
    return square; 
  } 
  
  /* sets the the Square occupied by the Agent.
  *
  */
  public void setSquare(Square s) {
    this.square = s; 
  } 
  
  /* Moves the agent from source to destination. 
  *  If the destination is already occupied, the program should crash with an assertion error
  *  instead, unless the destination is the same as the source.
  *
  */
  public void move(Square source, Square destination) {
    // make sure this agent occupies the source
    assert(this == source.getAgent());
    if (!destination.equals(source)) { 
      assert(destination.getAgent() == null);
      source.setAgent(null);
      destination.setAgent(this);
    }
  } 
  
  /* Reduces the agent's stored sugar level by its metabolic rate, to a minimum value of 0.
  *
  */
  public void step() {
    sugarLevel = Math.max(0, sugarLevel - metabolism); 
    age += 1;
  } 
  
  /* returns true if the agent's stored sugar level is greater than 0, false otherwise. 
  * 
  */
  public boolean isAlive() {
    return (sugarLevel > 0);
  } 
  
  /* The agent eats all the sugar at Square s. 
  *  The agent's sugar level is increased by that amount, and 
  *  the amount of sugar on the square is set to 0.
  *
  */
  public void eat(Square s) {
    sugarLevel += s.getSugar();
    s.setSugar(0);
  } 
  
  public void gift(Agent other,int amount){
    assert(this.getSugarLevel() >= amount);
    other.sugarLevel += amount;
    this.sugarLevel -= amount;
  }
  
  public void influence(Agent other){
  int rand = r.nextInt(11);
  if(this.culture[rand] != other.culture[rand]) other.culture[rand] = this.culture[rand];
  }
  
  public void nurture(Agent parent1,Agent parent2){
    for(int i = 0; i < 11; i++){
     if(r.nextBoolean()) this.culture[i] = parent1.culture[i];
     else this.culture[i] = parent2.culture[i];
    }
  }
  
  public boolean getTribe(){
    int trueVals = 0;
    int falseVals = 0;
    for(int i = 0; i < 11; i++){
      if(this.culture[i]) trueVals++;
      else falseVals++;
    }
    if(trueVals > falseVals) return true;
    else return false; 
  }
  
  /* Two agents are equal only if they're the same agent, 
  *  not just if they have the same properties.
  */
  public boolean equals(Agent other) {
    return this == other;
  }
  
  public void display(int x, int y, int scale) {
    fill(0);
    ellipse(x, y, 3.0*scale/4, 3.0*scale/4);
  }
  
  public void display(int x, int y, int scale,boolean culture,boolean fertility,FertilityRule f) {
    if(culture){
      if(getTribe()) fill(41,24,237);
      else fill(237,89,92);
    }
    
    else if(fertility){
     if(f.isFertile(this)) fill(252,5,212);
     else fill(5,252,81);
    }
    
    else fill(0);
    
    stroke(0);
    ellipse(x, y, 3.0*scale/4, 3.0*scale/4);
    fill(0);
  }
  
  
}

class AgentTester {
  
  public void test() {
    
    // test constructor, accessors
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
    MovementRule m = null;
    Agent a = new Agent(metabolism, vision, initialSugar, m); 
    Agent a1 = new Agent(metabolism,vision,initialSugar,m,'X');
    Agent a2 = new Agent(metabolism,vision,initialSugar,m,'Y');
    assert(a1.getSex() == 'X');
    assert(a2.getSex() == 'Y');
    assert(a.getSex() == 'X' || a.getSex() == 'Y');
    a1.gift(a2,1);
    assert(a1.getSugarLevel() == 3);
    assert(a2.getSugarLevel() == 5);
    assert(a.isAlive());
    assert(a.getMetabolism() == 3);
    assert(a.getVision() == 2);
    assert(a.getSugarLevel() == 4);
    assert(a.getMovementRule() == null);
    
    // movement
    Square s1 = new Square(5, 9, 10, 10);
    Square s2 = new Square(5, 9, 12, 12);
    s1.setAgent(a);
    a.move(s1, s2);
    assert(s2.getAgent().equals(a));
    
    // eat
    a.eat(s2);
    assert(a.getSugarLevel() == 9);
    
    // test get/set MovementRule
    
    // step
    a.step();
    assert(a.getSugarLevel() == 6);
    a.step();
    a.step();
    a.step();
    assert(a.getSugarLevel() == 0);
    assert(!a.isAlive());
  }
}
