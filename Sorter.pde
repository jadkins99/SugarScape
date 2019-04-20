import java.util.Collections;

abstract class Sorter {
  /* sorts al so that the Agents are ordered from least Sugar (index 0) to most Sugar (last element of the list).
  */
  public abstract void sort(ArrayList<Agent> al);
  
  /*  Returns true if and only if Agent a has less sugar than Agent b.
  */
  protected boolean lessThan(Agent a, Agent b) {
    return a.getSugarLevel() < b.getSugarLevel();
  }
  
  /* Exchanges two elements of an arraylist
  */
  protected void exchange(ArrayList<Agent> al, int i, int j) {
    Agent tmp = al.get(i);
    al.set(i, al.get(j));
    al.set(j, tmp);
  }
}

class MergeSorter extends Sorter {
  ArrayList<Agent> aux;
    
  /* calls MergeSort on an ArrayList 
  */
  public void sort(ArrayList<Agent> al) {
    aux = new ArrayList<Agent>(al); 
    sort(al, 0, al.size());
  }
  
  /* MergeSort: sorts section of array from index start to index end-1
  *  sorts left and right halves recursively, then calls merge()
  */
  private void sort(ArrayList<Agent> al, int start, int end) {
    // the base case: a single element is already sorted
    if (end - start == 1) return; 
    
    int middle = (end+start)/2; // ensure this cuts the array in half when end - start = 2
    sort(al, start, middle);
    sort(al, middle, end);
    merge(al, start, end);
  }
  
  /* Merge: merges two sorted halves of a section of array
  */
  private void merge(ArrayList<Agent> al, int start, int end) {
    
    // copy section of array to aux
    for (int i = start; i < end; i++) {
      aux.set(i, al.get(i));
    }
    
    // merge, copying back to al, until i = middle or j = end
    int middle = (end+start)/2;
    int current = start, i = start, j = middle;
    while (i < middle && j < end) {
      if (lessThan(aux.get(j), aux.get(i))) {
        al.set(current++, aux.get(j++));
      }
      else {
        al.set(current++, aux.get(i++));
      }
    }
    
    // i = middle? copy rest of j's
    // j = end? copy rest of i's
    if (i == middle) {
      while (j < end) {
        al.set(current++, aux.get(j++));
      }
    }
    if (j == end) {
      while (i < middle) {
        al.set(current++, aux.get(i++));
      }
    }
  } // merge()
  
}

class QuickSorter extends Sorter {
    
  /* shuffles an array and calls QuickSort 
  */
  public void sort(ArrayList<Agent> al) {
    Collections.shuffle(al);
    sort(al, 0, al.size()-1);
  }
  
  /* QuickSort: sorts section of array from index lo to index hi
  *  finds the right place in the array for the 0th element; 
  *  calls itself recursively on the left and right sections
  */
  private void sort(ArrayList<Agent> al, int lo, int hi)
  {
    if (hi <= lo) return;
    int j = partition(al, lo, hi);
    sort(al, lo, j-1);
    sort(al, j+1, hi);
  }
  
  /* QuickSort Partition
  *
  *  @author Robert Sedgewick, Princeton U.
  *  @author Kevin Wayne, Princeton U.
  */
  private int partition(ArrayList<Agent> al, int lo, int hi) {
  int i = lo, j = hi+1;
  while (true) {
    while (lessThan(al.get(++i), al.get(lo))) {
      if (i == hi) break;
    }
    while (lessThan(al.get(lo), al.get(--j))) {
      if (j == lo) break;  
    }
    
    if (i >= j) break;
    exchange(al, i, j);
  }
  exchange(al, lo, j);
  return j;
  }
}
