boolean sendToStart = false;
boolean sendToStop  = false;

boolean sendToMotors = false;
boolean sendToArduino = false;
boolean sendToLEDs_Wall1  = false;
boolean sendToLEDs_Wall2  = false;
boolean sendToLEDs_Wall3  = false;
boolean sendToLEDs_Wall4  = false;
boolean sendToLEDs_Wall5  = false;

int inChannel  = 0;
int inPitch    = 0;
int inVelocity = 0;

//send data
String dataOutput = "";


void sendToLED() {

  if (sendToArduino) {

    if (sendToLEDs_Wall1) { // Wall 1
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      portLED_Wall1.write(sendStr);

      println("sent to LEDs: "+ sendStr);
      sendToLEDs_Wall1 = false;
    } 
    if (sendToLEDs_Wall2) { // Wall 2
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      portLED_Wall2.write(sendStr);

      println("sent to LEDs: "+ sendStr);
      sendToLEDs_Wall2 = false;
    }
     
     if (sendToLEDs_Wall3) { // Wall 3
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      portLED_Wall3.write(sendStr);

      println("sent to LEDs: "+ sendStr);
      sendToLEDs_Wall3 = false;
    } 
     if (sendToLEDs_Wall4) { // Wall 4
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      portLED_Wall4.write(sendStr);

      println("sent to LEDs: "+ sendStr);
      sendToLEDs_Wall4 = false;
    }  
    
    if (sendToLEDs_Wall5) { // Wall 5
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      portLED_Wall5.write(sendStr);

      println("sent to LEDs: "+ sendStr);
      sendToLEDs_Wall5 = false;
    }

    //if (sendToMotors) {
    //  String sendStr =  inPitch+"";
    //  myPort02.write(sendStr);

    //  println("sent to Motors: "+ sendStr);
    //  sendToMotors = false;
    //}

    sendToArduino = false;
  }


  /*
  myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
   delay(200);
   myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff
   
   int number = 0;
   int value = 90;
   
   myBus.sendControllerChange(channel, number, value); // Send a controllerChange
   delay(2000);
   */
}