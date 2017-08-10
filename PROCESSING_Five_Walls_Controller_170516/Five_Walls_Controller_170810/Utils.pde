void setTimeout(String name,long time){
  new TimeoutThread(this,name,time,false);
}
void setInterval(String name,long time){
  intervals.put(name,new TimeoutThread(this,name,time,true));
}
void clearInterval(String name){
  TimeoutThread t = intervals.get(name);
  if(t != null){
    t.kill();
    t = null;
    intervals.put(name,null);
  }
}
HashMap<String,TimeoutThread> intervals = new HashMap<String,TimeoutThread>();
 
import java.lang.reflect.Method;
 
class TimeoutThread extends Thread{
  Method callback;
  long now,timeout;
  Object parent;
  boolean running;
  boolean loop;
 
  TimeoutThread(Object parent,String callbackName,long time,boolean repeat){
    this.parent = parent; 
    try{
      callback = parent.getClass().getMethod(callbackName);
    }catch(Exception e){
      e.printStackTrace();
    }
    if(callback != null){
      timeout = time;
      now = System.currentTimeMillis();
      running = true;  
      loop = repeat; 
      new Thread(this).start();
    }
  }
 
  public void run(){
    while(running){
      if(System.currentTimeMillis() - now >= timeout){
        try{
          callback.invoke(parent);
        }catch(Exception e){
          e.printStackTrace();
        }
        if(loop){
          now = System.currentTimeMillis();
        }else running = false;
      }
    }
  }
  void kill(){
    running = false;
  }
 
}