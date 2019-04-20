
SugarGrid myGrid;
Graph numGraph;
Graph ageAvgGraph;
Graph wealthGraph;
Graph ageGraph;
Graph sugarAvgGraph;
Graph propCultGraph;
ReplacementRule rr;
FertilityRule f;
boolean culture = false;
boolean fertility = false;

void setup() { 
  /* Testing */
  (new SquareTester()).test();
  (new AgentTester()).test();
  (new SugarGridTester()).test();  
  (new GrowbackRuleTester()).test();
  (new StackTester()).test();
  (new QueueTester()).test();
  (new ReplacementRuleTester()).test();
  (new SeasonalGrowbackRuleTester()).test();
  (new FertilityRuleTester()).test();

System.out.println("Welcome to the SugarScape");
System.out.println("Press c to view Agents by culture");
System.out.println("Press f to view Agents by fertility");

  size(1200,800);
  background(128);
  
  int minMetabolism = 1;
  int maxMetabolism = 4;
  int minVision = 1;
  int maxVision = 5;
  int minInitialSugar = 50;
  int maxInitialSugar = 100;

  MovementRule mrs = new SugarSeekingMovementRule();
  AgentFactory af = new AgentFactory(minMetabolism, maxMetabolism, minVision, maxVision,minInitialSugar, maxInitialSugar, mrs);

GrowthRule g = new GrowbackRule(1);

 int minAgeDeath = 60;
  int maxAgeDeath = 100;
 
  rr = new ReplacementRule(minAgeDeath,maxAgeDeath,af);
  
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

  
  myGrid = new SugarGrid(40,40,20,g,f,rr);
  myGrid.addSugarBlob(15,15,2,8);
  myGrid.addSugarBlob(35,25,2,8);
  myGrid.addSugarBlob(0,40,2,8);
  for (int i = 0; i < 100; i++) {
    Agent a = af.makeAgent();
    myGrid.addAgentAtRandom(a);
  }
  
 
  //numGraph = new NumberOfAgentsTimeSeriesGraph(850, 650, 300, 150);
  ageAvgGraph = new AverageAgentAgeTimeSeriesGraph(850, 250, 300, 150, 1000);
  sugarAvgGraph = new AverageAgentSugarTimeSeriesGraph(850,50,300,150);
  propCultGraph = new ProportionOfTrueCultureTimeSeriesGraph(850,450,300,150);
 // wealthGraph = new SortedAgentWealthGraph(850, 450, 300, 150);
  //ageGraph = new AgeCDFGraph(850, 650, 300, 150);
  frameRate(10);
}

void draw() {  
 // numGraph.update(myGrid);
  ageAvgGraph.update(myGrid);
  sugarAvgGraph.update(myGrid);
  propCultGraph.update(myGrid);
 // wealthGraph.update(myGrid);
  
  
  myGrid.update();
  //background(255);
  myGrid.display(culture,fertility,f);
  
  
  
   
  }
  
  void keyPressed(){
   if(key == 'c'){
    fertility = false;
    culture = true;
   }
   
   else if(key == 'f'){
    culture = false; 
     fertility = true;
   }
        
  }
