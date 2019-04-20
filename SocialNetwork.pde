import java.util.List;
import java.util.Stack;

class SocialNetwork {
  boolean[][] adjMatrix;
  ArrayList<SocialNetworkNode> nodes;

  /** Initializes a new social network such that 
   *  for every pair of Agents (x,y) on grid g, 
   *   if x can see y (i.e. y is on a square that is in the vision of x), 
   *   then there is a directed edge from the SocialNetworkNode for x to 
   *   the SocialNetworkNode for y in this new social network. 
   *
   *  Note that x might be able to see y even if y cannot see x.
   */
  public SocialNetwork(SugarGrid g) {
    nodes = new ArrayList<SocialNetworkNode>();
    for(Agent a : g.getAgents())
      nodes.add(new SocialNetworkNode(a));
    adjMatrix = new boolean[nodes.size()][nodes.size()];
    for(int i = 0; i < nodes.size(); i++){
      Agent current = nodes.get(i).getAgent();
      for(int j = 0; j < nodes.size(); j++){
        if(i == j)
          continue;
        adjMatrix[i][j] = canSee(current, nodes.get(j).getAgent(),g);
      }
    }
  }
  
  /** Returns true if a can see b.
   */
  private boolean canSee(Agent a, Agent b, SugarGrid g) {
    for (int i = 0; i < g.getWidth(); i++)
      for (int j = 0; j < g.getHeight(); j++)
        if (g.getAgentAt(i, j) == a) {
           return visible(b, g.generateVision(i, j, a.getVision()));
        }
    assert(1==0);
    return false; //shouldn't happen, if a is actually in g.
  }

  /** Returns true if one of visibleSquares contains the agent.
   */
  private boolean visible(Agent b, LinkedList<Square> visibleSquares) {
    for (Square s : visibleSquares) {
      if (s.getAgent() == b)
        return true;
    }
    return false;
  }

  /** Returns true if node n is adjacent to node m in this SocialNetwork. 
   *  (This means n's agent can see m's agent.)
   *  Returns false if either n or m is not present in the social network.
   */
  public boolean adjacent(SocialNetworkNode n, SocialNetworkNode m){
    if(!nodes.contains(n) || !nodes.contains(m))
      return false;
    return adjMatrix[nodes.indexOf(n)][nodes.indexOf(m)];
  }
  
  /** Returns a list (either ArrayList or LinkedList) containing 
   *  all the nodes that n is adjacent to. (Those nodes whose agents are seen by n's agent.) 
   *  Returns null if n is not in the social network.
   */
  public List<SocialNetworkNode> seenBy(SocialNetworkNode n){
    if(!nodes.contains(n))
      return null;
    ArrayList<SocialNetworkNode> al = new ArrayList<SocialNetworkNode>();
    int j = nodes.indexOf(n);
    for(int i=0; i < nodes.size(); i++)
      if(adjMatrix[i][j])
        al.add(nodes.get(i));
    return al;
  }

  /** Returns a list (either ArrayList or LinkedList) containing 
   *  all the nodes that are adjacent to m. (Those nodes whose agents see m's agent.) 
   *  Returns null if n is not in the social network.
   */
  public List<SocialNetworkNode> sees(SocialNetworkNode m){
    if(!nodes.contains(m))
      return null;
    ArrayList<SocialNetworkNode> al = new ArrayList<SocialNetworkNode>();
    int i = nodes.indexOf(m);
    for(int j = 0; j < nodes.size(); j++){
      if(adjMatrix[i][j])
        al.add(nodes.get(j));
    }
    return al;
  }  
  
  /** Remove breadcrumbs from all nodes in the network.
   */
  public void removeBreadcrumbs(){
    for(SocialNetworkNode n : nodes)
      n.removeBreadcrumb();
  }
  
  /** Returns the node containing the passed agent. 
   *  Returns null if that agent is not represented in this graph.
   */
  private SocialNetworkNode getNode(Agent a){
    for(SocialNetworkNode n : nodes)
      if(n.getAgent() == a)
        return n;
    return null;
  } 

  /** Returns true if there exists any path through the social network 
   *  that connects x to y. 
   *  A path should start at the node for agent x, 
   *  proceed through any node x can see, 
   *  and then any node that agent can see, and so on, 
   *  until it reaches node y.
   */
  public boolean pathExists(Agent a, Agent b){
     SocialNetworkNode origin = getNode(a);
     SocialNetworkNode dest = getNode(b);
     if(origin == null || dest == null)
       return false;
     if(a == b)
       return true;
     removeBreadcrumbs();
     Stack<SocialNetworkNode> dfsStack = new Stack<SocialNetworkNode>();   
     dfsStack.push(origin);
     origin.placeBreadcrumb();
     while(!dfsStack.isEmpty()){
       SocialNetworkNode s = dfsStack.pop();
       if(s == dest)
         return true;
       int i = nodes.indexOf(s);
       for(int j = 0; j < adjMatrix.length; j++)
         if(adjMatrix[i][j] && !nodes.get(j).hasBreadcrumb()){
           dfsStack.push(nodes.get(j));
           nodes.get(j).placeBreadcrumb();
         }
     }  
     return false;
  }
  
  /** Returns the shortest path through the social network from node x to node y.
   *  If more than one path is the shortest, returns any of the shortest ones. 
   *  If there is no path from x to y, returns null. 
   *  Makes use of each node's parent: the first node 
   *  that added the node to the search.
   */
  public List<Agent> bacon(Agent a, Agent b){
     SocialNetworkNode origin = getNode(a);
     SocialNetworkNode dest = getNode(b);
     if(origin == null || dest == null)
       return null;
     removeBreadcrumbs();
     Queue<SocialNetworkNode> bfsQueue = new Queue<SocialNetworkNode>();   
     bfsQueue.add(origin);
     origin.placeBreadcrumb();
     while(!bfsQueue.isEmpty()){
       SocialNetworkNode s = bfsQueue.poll();
       if(s == dest)
         return rollBack(s);
       int i = nodes.indexOf(s);
       for(int j = 0; j < adjMatrix.length; j++)
         if(adjMatrix[i][j] && !nodes.get(j).hasBreadcrumb()){
           bfsQueue.add(nodes.get(j));
           nodes.get(j).placeBreadcrumb(s);
         }
     }  
     return null;
  }
  
  /** Returns a path that goes to each node from its parent,
   *  starting at the root ancestor and ending at the given node. 
   *
   *  If the given node is the root, returns the path root -> root.
   */
  private List<Agent> rollBack(SocialNetworkNode end){
    ArrayList<Agent> path = new ArrayList<Agent>();
    path.add(0, end.getAgent());
    while(end.getParent() != null){
      end = end.getParent();
      path.add(0, end.getAgent());
    }
    if(path.size() == 1)
      path.add(end.getAgent()); //special case for path to self.
    return path;
  }
}
