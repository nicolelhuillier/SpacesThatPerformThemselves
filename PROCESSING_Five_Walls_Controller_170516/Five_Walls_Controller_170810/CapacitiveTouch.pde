void capacitiveTouchEvent() {
  String val;
  if ( portCapacitive.available() > 0) {  
    val = portCapacitive.readStringUntil('\n');         // read it and store it in val
    println("value......" + val);

    //if (val != null && val.length() == 2){
      if(val != null) {
        int channel = 1;
        if (val.contains("Index=1")) {
          println("ONEEEE");
          sendNote(73, channel);
        }
        if (val.contains("Index=2")) {
          println("TWO");
          sendNote(73, channel);
        }
        if (val.contains("Index=3")) {
          println("THREE");
          sendNote(73, channel);
        }
        if (val.contains("Index=4")) {
          println("FOUR");
          sendNote(74,channel);
        }
        if (val.contains("Index=5")) {
          println("FIVE");
          sendNote(74, channel);
        }
        if (val.contains("Index=6")) {
          println("SIX");
          sendNote(75, channel);
        }
        if (val.contains("Inde=7")) {
          println("SEVEN");
          sendNote(75,channel);
        }
        if (val.contains("Index=8")) {
          println("EIGHTTTTT");
          sendNote(75, channel);
        }
        if (val.contains("Index=9")) {
          println("NINEEEE");
          sendNote(77, channel);
        }
        if (val.contains("Index=10")) {
          println("TEN");
          sendNote(77,channel);
        }
        if (val.contains("Index=11")) {
          println("ELEVENN");
          sendNote(77, channel);
        }
      }
      
  } 
}

void sendNote(int pitch, int channel) {
 
  int velocity = 127;

  myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  delay(200);
  myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff

  int number = 0;
  int value = 60;

  myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  //delay(2000);

}