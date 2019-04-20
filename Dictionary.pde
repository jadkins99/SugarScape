interface Dictionary<K extends Comparable<K>,V> {
  
  /** Inserts key into the dictionary with the specified value associated. 
   *  If key is already present (determined using compareTo() == 0), it overwrites the old value with the new value.
   */
  public void put(K key, V value);
  
  /** Returns true if key is in the dictionary.
   */
  public boolean contains(K key);
   
  /** Returns whatever V object is stored in the dictionary under key. 
   *  Returns null if key is not stored in the dictionary.
   */
  public V get(K key);
    
  /** Returns whatever V object is stored in the dictionary under key and deletes that object from the dictionary. 
   *  If key is not in the dictionary, this method throws an AssertionError or NullPointerException.
   */
  public V remove(K key);
  
  /** Removes all key-value pairs
   *
   */
  public void clear();
  
  /** Returns the number of key-value pairs
   */
  public int size();
}
