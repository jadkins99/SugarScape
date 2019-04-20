import java.util.LinkedList;

class Stack<T> {
  private LinkedList<T> stack;
  
  /* creates a new empty stack.
  */
  public Stack() {
    stack = new LinkedList<T>();
  }
  
  /* returns true if and only if this stack is empty.
  */
  public boolean isEmpty() {
    return (stack.size() == 0);
  }
  
  /* pushes the provided element on top of the stack.
  */
  public void push(T e) {
    stack.push(e);
  }
  
  /* returns the top element of the stack, or null if the stack is empty.
  */
  public T peek() {
    return stack.peek();
  }
  
  /* returns the top element of the stack and removes that element from the stack. 
  * Returns null if the stack is empty.
  */
  public T pop() {
    return stack.poll();
  }
}

class StackTester {
  public void test() {
    int metabolism = 3;
    int vision = 2;
    int initialSugar = 4;
    Agent a1 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    Agent a2 = new Agent(metabolism, vision, initialSugar, new PollutionMovementRule());
    
    Stack<Agent> s = new Stack<Agent>();
    s.push(a1);
    s.push(a1);
    s.push(a2);
    Agent a = s.peek();
    assert(a.equals(a2));
    a = s.pop();
    assert(a.equals(a2));
    a = s.pop();
    assert(a.equals(a1));
    assert(!s.isEmpty());
    a = s.pop();
    assert(s.isEmpty());
    a = s.pop();
    assert(a == null);
    
    
  }
}
