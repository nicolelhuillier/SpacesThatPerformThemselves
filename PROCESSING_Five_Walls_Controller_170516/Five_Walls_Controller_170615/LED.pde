import themidibus.*; //Import the library
import processing.serial.*;


Serial myPort01; 
//Serial myPort02; 
//Serial myPort03;

MidiBus myBus; // The MidiBus  

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

void setup() {
  size(400, 400);
  background(0);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  // Either you can
  //                   Parent In Out
  //                     |    |  |
  //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  // or you can ...
  //                   Parent         In                   Out
  //                     |            |                     |
  //myBus = new MidiBus(this, "IncomingDeviceName", "OutgoingDeviceName"); // Create a new MidiBus using the device names to select the Midi input and output devices respectively.

  // or for testing you could ...
  //                 Parent  In        
  //                   |     |          
  myBus = new MidiBus(this, 0, 1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  println(Serial.list());

  String portName01 = Serial.list()[6];
  println(portName01);
  myPort01 = new Serial(this, portName01, 9600);

  //String portName02 = Serial.list()[2];
  //println(portName02);
  //myPort02 = new Serial(this, portName02, 9600);

  //String portName03 = Serial.list()[3];
  //println(portName03);
}



void draw() {


  if (sendToArduino) {

    if (sendToLEDs) {
      // myPort.write(inVelocity);
      String sendStr = inPitch+"";
      myPort01.write(sendStr);

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

void noteOn(int channel, int pitch, int velocity) {
  /*
  // Receive a noteOn
   println();
   println("Note On:");
   println("--------");
   println("Channel:"+channel);    
   println("Pitch:"+pitch);
   println("Velocity:"+velocity);
   */

  //guardar valores
  inChannel  = channel;
  inPitch    = pitch;
  inVelocity = velocity;
  
  sendToArduino = true;

  //secuencias de inicio, stop, 
  if ( inChannel == 0) {
    sendToLEDs = true;
  }

  //LEDs
  if (inChannel == 1) {
    sendToMotors = true;
  }
  
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  /*
  println();
   println("Note Off:");
   println("--------");
   println("Channel:"+channel);
   println("Pitch:"+pitch);
   println("Velocity:"+velocity);
   */
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}