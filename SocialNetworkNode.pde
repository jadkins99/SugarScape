class SocialNetworkNode{
  boolean hasBreadcrumb;
  Agent data;
  SocialNetworkNode parent; // first node that added this to the social network
  
  /** initializes a new SocialNetworkNode storing the passed agent. 
   *  The node initially does not contain a breadcrumb.
   */
  public SocialNetworkNode(Agent a){
    this.hasBreadcrumb = false;
    this.data = a;
    this.parent = null;
  }
  
  /** returns true if this node has a breadcrumb.
   */
  public boolean hasBreadcrumb(){
    return this.hasBreadcrumb; 
  }
  
  /** Places a breadcrumb on the node.
   */
  public void placeBreadcrumb(){
    this.hasBreadcrumb = true; 
  }
  
  /** Gets this node's parent, the first node that added this node to the search
   */
  public SocialNetworkNode getParent(){
    return this.parent; 
  }
  
  /** Helper for placeBreadcrumb().
   */
  private void placeBreadcrumb(SocialNetworkNode parent){
    this.parent = parent;
    placeBreadcrumb();
  }
  
  /** Removes any breadcrumb from the node.
   */
  public void removeBreadcrumb(){
    this.hasBreadcrumb = false; 
    this.parent=null;
  }
  
  /** Returns the agent stored at this node.
   */
  public Agent getAgent(){
    return this.data; 
  }
}
