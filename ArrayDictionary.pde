import java.util.ArrayList;
import java.util.Collections;

public class ArrayDictionary<K extends Comparable<K>, V> implements Dictionary<K, V>
{
  private ArrayList<Pair<K,V>> storage;
  
  public void bulkAdd(ArrayList<Pair<K,V>> data){
    storage.addAll(data);
    Collections.sort(storage); 
  }
  public ArrayDictionary(){
    storage = new ArrayList<Pair<K,V>>();  
  }
  
  public void clear(){
    storage = new ArrayList<Pair<K,V>>();    
  }
  
  public int size(){
    return this.storage.size();    
  }

  public void put(K key, V value){
    Pair<K,V> target = new Pair<K,V>(key, value);
    for(int i=0; i < storage.size(); i++)
      if(storage.get(i).compareTo(target) <= 0){
        if(storage.get(i).compareTo(target) == 0)
          storage.set(i, target);
        else
          storage.add(i,target);
        return;
      }
    storage.add(target); //case for the back.
  }
  
  public V remove(K key){
    Pair<K,V> target = new Pair<K,V>(key, null);
    for(int i=0; i < storage.size(); i++)
      if(storage.get(i).compareTo(target) <= 0)
        if(storage.get(i).compareTo(target) == 0)
          return storage.remove(i).getValue();
        else
          return null; //not in the list.
    return null;
  }
  
  private int binSearch(Pair<K,V> key){
    int start = 0;
    int end = this.storage.size();
    int mid;
    
    while(start < end){
        mid = (end - start)/2 + start;
        int res = storage.get(mid).compareTo(key);
        if(res == 0)
            return mid;
        else if(res < 0)
          end = mid;
        else
          start = mid+1;
    }
    return -1;
  }
  
  public boolean contains(K key){
    return binSearch(new Pair<K,V>(key,null)) != -1;    
  }
  
  public V get(K key){
    //for(int i=0; i < storage.size(); i++)
    //  if(storage.get(i).compareTo(new Pair<K,V>(key,null))==0)
    //    return storage.get(i).getValue();
    //return null;
    int location = binSearch(new Pair<K,V>(key,null));
    if(location == -1)
      return null;
    else
      return storage.get(location).getValue();
  }
}
