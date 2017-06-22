boolean sendToStart = false;
boolean sendToStop  = false;
boolean sendToLEDs  = false;
boolean sendToMotors = false;
boolean sendToArduino = false;

int inChannel  = 0;
int inPitch    = 0;
int inVelocity = 0;

//send data
String dataOutput = "";


void sendToLED() {

  if (sendToArduino) {

    if (sendToLEDs) {
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      portLED.write(sendStr);

      println("sent to LEDs: "+ sendStr);
      sendToLEDs = false;
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