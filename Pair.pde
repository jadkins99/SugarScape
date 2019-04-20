class Pair<K extends Comparable<K>, V> implements Comparable<Pair<K,V>> {
  private K pkey; // can't use "key"; it reserved in Processing
  private V pval;
  
  public Pair(K k, V v) {
    pkey = k; 
    pval = v;
  }
  
  public K getKey() {
    return pkey;
  }
  
  public V getValue() {
    return pval;
  }
  
  public int compareTo(Pair<K, V> other) {
    return pkey.compareTo(other.getKey());
  }
}
