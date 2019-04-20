import java.util.LinkedList;

class Queue<T> {
  private LinkedList<T> Queue;
  
  /* creates a new empty Queue.
  */
  public Queue() {
    Queue = new LinkedList<T>();
  }
  
  /* returns true if and only if this Queue is empty.
  */
  public boolean isEmpty() {
    return (Queue.size() == 0);
  }
  
  /* adds the provided element to the back of the Queue.
  */
  public void add(T e) {
    Queue.add(e);
  }
  
  /* returns the front element of the Queue, or null if the Queue is empty.
  */
  public T peek() {
    return Queue.peek();
  }
  
  /* returns the front element of the Queue and removes that element from the Queue. 
  * Returns null if the Queue is empty.
  */
  public T poll() {
    return Queue.poll();
  }
}

class QueueTester {
  public void test() {
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
    Agent a1 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    Agent a2 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    
    Queue<Agent> q = new Queue<Agent>();
    q.add(a1);
    q.add(a1);
    q.add(a2);
    Agent a = q.peek();
    assert(a.equals(a1));
    a = q.poll();
    assert(a.equals(a1));
    a = q.poll();
    assert(a.equals(a1));
    assert(!q.isEmpty());
    a = q.poll();
    assert(a.equals(a2));
    assert(q.isEmpty());
    a = q.poll();
    assert(a == null);        
  }
}
