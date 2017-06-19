import controlP5.*;
import processing.serial.*;
import java.util.*;
import themidibus.*; //Import the library

//DECLARE CLASS
ControlP5 cp5;

//clase MIDi
MidiBus myBus; // The MidiBus  

boolean portsReady = false; // don't send anything unless the ports are ready

static Serial serialPorts[]; 

final int MOTOR_MIN_POSITION = 3; 
final int MOTOR_MAX_POSITION = 250;
final int MOTOR_DEFAULT_POSITION = MOTOR_MIN_POSITION; 


final int MOTOR_MIN_SPEED = 3; 
final int MOTOR_MAX_SPEED = 250; 
final int MOTOR_DEFAULT_SPEED = 127;

final int MOTOR_HALT = 254;
final int MOTOR_GO = 255;

int Motor17Pos = MOTOR_DEFAULT_POSITION;
int Motor18Pos = MOTOR_DEFAULT_POSITION;
int Motor19Pos = MOTOR_DEFAULT_POSITION;
int Motor20Pos = MOTOR_DEFAULT_POSITION;
int Motor21Pos = MOTOR_DEFAULT_POSITION;
int Motor22Pos = MOTOR_DEFAULT_POSITION;
int Motor23Pos = MOTOR_DEFAULT_POSITION;
int Motor24Pos = MOTOR_DEFAULT_POSITION;
int Motor25Pos = MOTOR_DEFAULT_POSITION;

int Motor33Pos = MOTOR_DEFAULT_POSITION;
int Motor34Pos = MOTOR_DEFAULT_POSITION;
int Motor35Pos = MOTOR_DEFAULT_POSITION;
int Motor36Pos = MOTOR_DEFAULT_POSITION;
int Motor37Pos = MOTOR_DEFAULT_POSITION;
int Motor38Pos = MOTOR_DEFAULT_POSITION;
int Motor39Pos = MOTOR_DEFAULT_POSITION;
int Motor40Pos = MOTOR_DEFAULT_POSITION;
int Motor41Pos = MOTOR_DEFAULT_POSITION;

int Motor49Pos = MOTOR_DEFAULT_POSITION;
int Motor50Pos = MOTOR_DEFAULT_POSITION;
int Motor51Pos = MOTOR_DEFAULT_POSITION;
int Motor52Pos = MOTOR_DEFAULT_POSITION;
int Motor53Pos = MOTOR_DEFAULT_POSITION;
int Motor54Pos = MOTOR_DEFAULT_POSITION;
int Motor55Pos = MOTOR_DEFAULT_POSITION;
int Motor56Pos = MOTOR_DEFAULT_POSITION;
int Motor57Pos = MOTOR_DEFAULT_POSITION;

int Motor65Pos = MOTOR_DEFAULT_POSITION;
int Motor66Pos = MOTOR_DEFAULT_POSITION;
int Motor67Pos = MOTOR_DEFAULT_POSITION;
int Motor68Pos = MOTOR_DEFAULT_POSITION;
int Motor69Pos = MOTOR_DEFAULT_POSITION;
int Motor70Pos = MOTOR_DEFAULT_POSITION;
int Motor71Pos = MOTOR_DEFAULT_POSITION;
int Motor72Pos = MOTOR_DEFAULT_POSITION;
int Motor73Pos = MOTOR_DEFAULT_POSITION;

int Motor81Pos = MOTOR_DEFAULT_POSITION;
int Motor82Pos = MOTOR_DEFAULT_POSITION;
int Motor83Pos = MOTOR_DEFAULT_POSITION;
int Motor84Pos = MOTOR_DEFAULT_POSITION;
int Motor85Pos = MOTOR_DEFAULT_POSITION;
int Motor86Pos = MOTOR_DEFAULT_POSITION;
int Motor87Pos = MOTOR_DEFAULT_POSITION;
int Motor88Pos = MOTOR_DEFAULT_POSITION;
int Motor89Pos = MOTOR_DEFAULT_POSITION;

int Motor17Speed = MOTOR_DEFAULT_SPEED;
int Motor18Speed = MOTOR_DEFAULT_SPEED;
int Motor19Speed = MOTOR_DEFAULT_SPEED;
int Motor20Speed = MOTOR_DEFAULT_SPEED;
int Motor21Speed = MOTOR_DEFAULT_SPEED;
int Motor22Speed = MOTOR_DEFAULT_SPEED;
int Motor23Speed = MOTOR_DEFAULT_SPEED;
int Motor24Speed = MOTOR_DEFAULT_SPEED;
int Motor25Speed = MOTOR_DEFAULT_SPEED;

int Motor33Speed = MOTOR_DEFAULT_SPEED;
int Motor34Speed = MOTOR_DEFAULT_SPEED;
int Motor35Speed = MOTOR_DEFAULT_SPEED;
int Motor36Speed = MOTOR_DEFAULT_SPEED;
int Motor37Speed = MOTOR_DEFAULT_SPEED;
int Motor38Speed = MOTOR_DEFAULT_SPEED;
int Motor39Speed = MOTOR_DEFAULT_SPEED;
int Motor40Speed = MOTOR_DEFAULT_SPEED;
int Motor41Speed = MOTOR_DEFAULT_SPEED;

int Motor49Speed = MOTOR_DEFAULT_SPEED;
int Motor50Speed = MOTOR_DEFAULT_SPEED;
int Motor51Speed = MOTOR_DEFAULT_SPEED;
int Motor52Speed = MOTOR_DEFAULT_SPEED;
int Motor53Speed = MOTOR_DEFAULT_SPEED;
int Motor54Speed = MOTOR_DEFAULT_SPEED;
int Motor55Speed = MOTOR_DEFAULT_SPEED;
int Motor56Speed = MOTOR_DEFAULT_SPEED;
int Motor57Speed = MOTOR_DEFAULT_SPEED;

int Motor65Speed = MOTOR_DEFAULT_SPEED;
int Motor66Speed = MOTOR_DEFAULT_SPEED;
int Motor67Speed = MOTOR_DEFAULT_SPEED;
int Motor68Speed = MOTOR_DEFAULT_SPEED;
int Motor69Speed = MOTOR_DEFAULT_SPEED;
int Motor70Speed = MOTOR_DEFAULT_SPEED;
int Motor71Speed = MOTOR_DEFAULT_SPEED;
int Motor72Speed = MOTOR_DEFAULT_SPEED;
int Motor73Speed = MOTOR_DEFAULT_SPEED;

int Motor81Speed = MOTOR_DEFAULT_SPEED;
int Motor82Speed = MOTOR_DEFAULT_SPEED;
int Motor83Speed = MOTOR_DEFAULT_SPEED;
int Motor84Speed = MOTOR_DEFAULT_SPEED;
int Motor85Speed = MOTOR_DEFAULT_SPEED;
int Motor86Speed = MOTOR_DEFAULT_SPEED;
int Motor87Speed = MOTOR_DEFAULT_SPEED;
int Motor88Speed = MOTOR_DEFAULT_SPEED;
int Motor89Speed = MOTOR_DEFAULT_SPEED;

ScrollableList[] portTxt;

Textfield timelineTxt;
Textfield timeTxt;

static class AmazingStepper {
  
  final static int MODE_SPEED = 1;
  final static int MODE_POSITION = 2;
  
  final static int MODE_HALT = 254;
  final static int MODE_GO = 255;
  
  
  //not using enums due to processing being annoying
  final static int sUNKNOWN = 0;
  final static int sSPEED = 1;
  final static int sPOSITION = 2;
  
  //default speed and position are negative, so *any* value is a 'change', and will be sent.
  int position = -1;
  int speed = -1;
   
  int motorMessageMode = sUNKNOWN;
  int motorId = 0;
  int portNum = 0;
  
  AmazingStepper(int id,int portNum) {
    this.motorId = id;
    this.portNum = portNum;
  }
  
  void setSpeed(int newSpeed) {
    if (newSpeed != this.speed) {
      this.speed = newSpeed;
      String message = "I"+motorId+"\n";
      if (motorMessageMode != sSPEED) {
        message += "D"+MODE_SPEED+"\n"; 
        motorMessageMode = sSPEED;
      }
      message += "D"+newSpeed+"\n";
      sendToPort(this.portNum,message,"from setSpeed of "+motorId);
    }
  }
  
  void setPosition(int newPosition) {
    if (newPosition != this.position) {
      this.position = newPosition;        
      String message = "I"+motorId+"\n";
      if (motorMessageMode != sPOSITION) {
        message += "D"+MODE_POSITION+"\n"; 
        motorMessageMode = sPOSITION;
      }
      message += "D"+position+"\n";
      sendToPort(this.portNum,message,"from setPosition of "+motorId);
    }
  }
  
  void halt() {
    sendToPort(this.portNum,"I"+motorId+"\n"+"D"+MODE_HALT+"\n","from 'halt' of "+motorId);
  }
  
  void go() {
    sendToPort(this.portNum,"I"+motorId+"\n"+"D"+MODE_GO+"\n","from 'go' of "+motorId);
  }
  
  static void sendString(String s) {
      sendToPort(s,"from 'sendString'");
  }
  
  static void sendMovement(int port, int speed, int pos) {
    sendToPort("I"+port+"\n"+"D"+1+"\n","from 'sendMovement'");  
    sendToPort("I"+port+"\n"+"D"+speed+"\n","from 'sendMovement'");
    sendToPort("I"+port+"\n"+"D"+2+"\n","from 'sendMovement'");  
    sendToPort("I"+port+"\n"+"D"+pos+"\n","from 'sendMovement'");
  }
  
  
  static void haltAll() {
    sendToPort("I0\n"+"D"+MODE_HALT+"\n","from 'haltAll'");
  }
 
  static void goAll() {
    sendToPort("I0\n"+"D"+MODE_GO+"\n","from 'goAll'");
  }
  
  static void highAll() {
    sendToPort("I0\n"+"D"+1+"\n","from 'highAll'"); // 1 is speed
    sendToPort("I0\n"+"D"+127+"\n","from 'highAll'"); // 127 is the value of the speed
    sendToPort("I0\n"+"D"+2+"\n","from 'highAll'"); // 2 is position
    sendToPort("I0\n"+"D"+250+"\n","from 'highAll'"); // 250 is the value of position
  }
  
  static void lowAll() {
    sendToPort("I0\n"+"D"+1+"\n","from 'highAll'");
    sendToPort("I0\n"+"D"+250+"\n","from 'highAll'");
    sendToPort("I0\n"+"D"+2+"\n","from 'highAll'");
    sendToPort("I0\n"+"D"+0+"\n","from 'highAll'");
  }
  
}

//TODO: make code modular, by intializing an array of motors in Setup(), rather than 3 static motors like it is now... 
//int[] stepperIds = { 66, 67, 68 };
//AmazingStepper[] steppers; 
AmazingStepper[][] motors;

int[][] wallMotorIds = { { 17,18,19,20,21,22,23,24,25 },
                         { 33,34,35,36,37,38,39,40,41 },
                         { 49,50,51,52,53,54,55,56,57 },
                         { 65,66,67,68,69,70,71,72,73 },
                         { 81,82,83,84,85,86,87,88,89 }
                       };

/**
 * This function inits the serial ports, and returns true iff it found all five walls
 */
boolean initWallControllers() {
  String portNames[] = Serial.list();
  //  printArray(Serial.list());

  serialPorts = new Serial[5];
  
  final int NUM_WALLS = 5;
  int wallsFound = 0;
  final int TIMEOUT_MS = 4000;
  final int MAX_TRY = 10;

  String[] wallPortNames = new String[NUM_WALLS];
  
  final String[] wallPortNamesFromFile = loadStrings("portsNames.txt");
  
  if (null!=wallPortNamesFromFile) {
    Arrays.sort(portNames, new Comparator<String>() {
      public int compare(String s1, String s2) {
        if (Arrays.asList(wallPortNamesFromFile).contains(s1)) { return 1; } else { return -1; }
      }
    });
  }
  
  for (int i = 0; wallsFound<(NUM_WALLS) && i<portNames.length; ++i) {
  
    try {
      Serial testPort = new Serial(this, portNames[i], 9600);
      testPort.bufferUntil('\n');
      testPort.write('\r'); //BusTestNew sketch gracefully ignores carriage returns.
      int tryCount = 0;
      boolean found = false;
      
      while (!found && tryCount<MAX_TRY) {
        if (testPort.available() > 0) {
          String initStr = testPort.readStringUntil('\n');
          if (initStr != null) {
            println("Found init Str:" + initStr);
            final String INIT_PREFIX = "Master-";
            int position = initStr.indexOf(INIT_PREFIX);
            if (-1!=position && position<(initStr.length() - INIT_PREFIX.length())) {
              String wallNum = initStr.substring(position + INIT_PREFIX.length());
              try {
                int wallNumInt =  Integer.parseInt(wallNum.trim());
                serialPorts[wallNumInt] = testPort;
                println("Identified wall #"+wallNumInt+" on port: "+portNames[i]);
                wallPortNames[wallNumInt] = portNames[i];
                found = true;
                wallsFound++;
              } catch (RuntimeException e) {
                println("Unable to extract wall ID: '"+wallNum+"'");
              }
            }
          }
        }
        tryCount++;
        delay(TIMEOUT_MS/MAX_TRY);
      }
      
      if (MAX_TRY==tryCount) {
        println("TIMEOUT!");
      }
    }
    catch(RuntimeException e){
      println("Inaccessible Port: "+portNames[i]);
    }
       
  }
  
  if (NUM_WALLS == wallsFound) {
    saveStrings("portsNames.txt", wallPortNames);
  }

  //serialPorts[0] = new Serial(this, portName1, 9600);
  //serialPorts[1] = new Serial(this, portName2, 9600);
  //serialPorts[2] = new Serial(this, portName3, 9600);
  //serialPorts[3] = new Serial(this, portName4, 9600);
  //serialPorts[4] = new Serial(this, portName5, 9600);
  portsReady = true; //Elsewhere in the code (in the draw loop?) it relys on this 'portsReady' to be true only after the ports are open for proper functioning.

  return (NUM_WALLS == wallsFound);
}

void setup() {
  size(1550, 700);
  background(210);
  stroke(255);
  line(10, 215, 530, 215);
  line(650, 215, 1170, 215);
  line(10, 435, 530, 435);
  line(650, 435, 1170, 435);
  
  initWallControllers();
  
  
  ///
  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.    
  myBus = new MidiBus(this, 0, 1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

 
  //INITIALIZE
  cp5 = new ControlP5(this);

  //slider(Name, minimum, maximum, default, x_position, y_position, width, height) 
  cp5.addSlider("Motor17Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 10, 100, 15);
  cp5.addSlider("Motor18Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 10, 100, 15);
  cp5.addSlider("Motor19Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 10, 100, 15);
  cp5.addSlider("Motor20Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 80, 100, 15);
  cp5.addSlider("Motor21Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 80, 100, 15);
  cp5.addSlider("Motor22Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 80, 100, 15);
  cp5.addSlider("Motor23Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 150, 100, 15);
  cp5.addSlider("Motor24Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 150, 100, 15);
  cp5.addSlider("Motor25Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 150, 100, 15);
  
  cp5.addSlider("Motor33Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 240, 100, 15);
  cp5.addSlider("Motor34Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 240, 100, 15);
  cp5.addSlider("Motor35Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 240, 100, 15);
  cp5.addSlider("Motor36Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 310, 100, 15);
  cp5.addSlider("Motor37Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 310, 100, 15);
  cp5.addSlider("Motor38Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 310, 100, 15);
  cp5.addSlider("Motor39Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 380, 100, 15);
  cp5.addSlider("Motor40Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 380, 100, 15);
  cp5.addSlider("Motor41Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 380, 100, 15);
  
  cp5.addSlider("Motor49Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 470, 100, 15);
  cp5.addSlider("Motor50Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 470, 100, 15);
  cp5.addSlider("Motor51Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 470, 100, 15);
  cp5.addSlider("Motor52Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 540, 100, 15);
  cp5.addSlider("Motor53Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 540, 100, 15);
  cp5.addSlider("Motor54Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 540, 100, 15);
  cp5.addSlider("Motor55Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 10, 610, 100, 15);
  cp5.addSlider("Motor56Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 190, 610, 100, 15);
  cp5.addSlider("Motor57Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 370, 610, 100, 15);
  
  cp5.addSlider("Motor65Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 650, 10, 100, 15);
  cp5.addSlider("Motor66Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 830, 10, 100, 15);
  cp5.addSlider("Motor67Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 1010, 10, 100, 15);
  cp5.addSlider("Motor68Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 650, 80, 100, 15);
  cp5.addSlider("Motor69Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 830, 80, 100, 15);
  cp5.addSlider("Motor70Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 1010, 80, 100, 15);
  cp5.addSlider("Motor71Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 650, 150, 100, 15);
  cp5.addSlider("Motor72Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 830, 150, 100, 15);
  cp5.addSlider("Motor73Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 1010, 150, 100, 15);
  
  cp5.addSlider("Motor81Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 650, 240, 100, 15);
  cp5.addSlider("Motor82Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 830, 240, 100, 15);
  cp5.addSlider("Motor83Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 1010, 240, 100, 15);
  cp5.addSlider("Motor84Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 650, 310, 100, 15);
  cp5.addSlider("Motor85Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 830, 310, 100, 15);
  cp5.addSlider("Motor86Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 1010, 310, 100, 15);
  cp5.addSlider("Motor87Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 650, 380, 100, 15);
  cp5.addSlider("Motor88Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 830, 380, 100, 15);
  cp5.addSlider("Motor89Pos", MOTOR_MIN_POSITION, MOTOR_MAX_POSITION, MOTOR_DEFAULT_POSITION, 1010, 380, 100, 15);

  cp5.addSlider("Motor17Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 30, 100, 15);
  cp5.addSlider("Motor18Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 30, 100, 15);
  cp5.addSlider("Motor19Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 30, 100, 15);
  cp5.addSlider("Motor20Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 100, 100, 15);
  cp5.addSlider("Motor21Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 100, 100, 15);
  cp5.addSlider("Motor22Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 100, 100, 15);
  cp5.addSlider("Motor23Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 170, 100, 15);
  cp5.addSlider("Motor24Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 170, 100, 15);
  cp5.addSlider("Motor25Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 170, 100, 15);
  
  cp5.addSlider("Motor33Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 260, 100, 15);
  cp5.addSlider("Motor34Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 260, 100, 15);
  cp5.addSlider("Motor35Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 260, 100, 15);
  cp5.addSlider("Motor36Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 330, 100, 15);
  cp5.addSlider("Motor37Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 330, 100, 15);
  cp5.addSlider("Motor38Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 330, 100, 15);
  cp5.addSlider("Motor39Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 400, 100, 15);
  cp5.addSlider("Motor40Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 400, 100, 15);
  cp5.addSlider("Motor41Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 400, 100, 15);
  
  cp5.addSlider("Motor49Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 490, 100, 15);
  cp5.addSlider("Motor50Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 490, 100, 15);
  cp5.addSlider("Motor51Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 490, 100, 15);
  cp5.addSlider("Motor52Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 560, 100, 15);
  cp5.addSlider("Motor53Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 560, 100, 15);
  cp5.addSlider("Motor54Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 560, 100, 15);
  cp5.addSlider("Motor55Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 10, 630, 100, 15);
  cp5.addSlider("Motor56Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 190, 630, 100, 15);
  cp5.addSlider("Motor57Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 370, 630, 100, 15);
  
  cp5.addSlider("Motor65Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 650, 30, 100, 15);
  cp5.addSlider("Motor66Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 830, 30, 100, 15);
  cp5.addSlider("Motor67Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 1010, 30, 100, 15);
  cp5.addSlider("Motor68Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 650, 100, 100, 15);
  cp5.addSlider("Motor69Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 830, 100, 100, 15);
  cp5.addSlider("Motor70Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 1010, 100, 100, 15);
  cp5.addSlider("Motor71Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 650, 170, 100, 15);
  cp5.addSlider("Motor72Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 830, 170, 100, 15);
  cp5.addSlider("Motor73Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 1010, 170, 100, 15);
  
  cp5.addSlider("Motor81Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 650, 260, 100, 15);
  cp5.addSlider("Motor82Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 830, 260, 100, 15);
  cp5.addSlider("Motor83Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 1010, 260, 100, 15);
  cp5.addSlider("Motor84Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 650, 330, 100, 15);
  cp5.addSlider("Motor85Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 830, 330, 100, 15);
  cp5.addSlider("Motor86Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 1010, 330, 100, 15);
  cp5.addSlider("Motor87Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 650, 400, 100, 15);
  cp5.addSlider("Motor88Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 830, 400, 100, 15);
  cp5.addSlider("Motor89Speed", MOTOR_MIN_SPEED, MOTOR_MAX_SPEED, MOTOR_DEFAULT_SPEED, 1010, 400, 100, 15);
 /*
 //for manual calls of 'update'... currently simply called from 'draw' instead of using a button. 
  cp5.addButton("Update")
    //.setValue(500)
    .setPosition(10, 200)
    .setSize(50, 50);
 */
 portTxt = new ScrollableList[5];
 portTxt[0] = cp5.addScrollableList("port1Txt")
   .setPosition(1260,10)
   .setSize(200,120);

 portTxt[1] = cp5.addScrollableList("port2Txt")
   .setPosition(1260,130)
   .setSize(200,120);

 portTxt[2] = cp5.addScrollableList("port3Txt")
   .setPosition(1260,260)
   .setSize(200,120);

 portTxt[3] = cp5.addScrollableList("port4Txt")
   .setPosition(1260,390)
   .setSize(200,120);

 portTxt[4] = cp5.addScrollableList("port5Txt")
   .setPosition(1260,520)
   .setSize(200,120);

 timelineTxt = cp5.addTextfield("timeline")
   .setPosition(650,550)
   .setSize(500,120);
  
 timeTxt = cp5.addTextfield("time")
  .setPosition(650,530)
  .setSize(200,15);
  
  cp5.addButton("Send_Go")
    //.setValue(500)
    .setPosition(650, 470)
    .setSize(50, 50);
    
  cp5.addButton("Send_Halt")
    //.setValue(500)
    .setPosition(720, 470)
    .setSize(50, 50);
    
  cp5.addButton("Add")
    //.setValue(500)
    .setPosition(810, 470)
    .setSize(50, 50);
    
  cp5.addButton("Play")
    //.setValue(500)
    .setPosition(890, 470)
    .setSize(50, 50)
    .setColorBackground(color(127, 255, 91));
    
  cp5.addButton("Stop")
    //.setValue(500)
    .setPosition(960, 470)
    .setSize(50, 50)
    .setColorBackground(color(244, 83, 65));

  cp5.addButton("Clear")
    //.setValue(500)
    .setPosition(1030, 470)
    .setSize(50, 50);
    
  cp5.addButton("All_250")
    //.setValue(500)
    .setPosition(1110, 470)
    .setSize(50, 50); 
    
  cp5.addButton("All_0")
    //.setValue(500)
    .setPosition(1180, 470)
    .setSize(50, 50);

  cp5.addButton("Control_Motor")
    //.setValue(500)
    .setPosition(1180, 530)
    .setSize(50, 50);


  int portId = 0;
  motors = new AmazingStepper[5][];
  for (int wall = 0; wall < 5; wall++ ) {
    motors[wall] = new AmazingStepper[9];
    for (int i = 0; i<9; i++) {
      motors[wall][i] = new AmazingStepper(wallMotorIds[wall][i],portId);
    }
    portId++;
  }
}

int getVal(String control) {
 return round(cp5.getController(control).getValue());
}

boolean hasChanged(String control, int oldValue) {
  return (getVal(control) != oldValue);
}

void draw() {
  if (portsReady) { 
    if (!playEnabled) {
      Update();
    }
  }
  
  for (int i = 0; i<serialPorts.length; ++i) {
    if (serialPorts[i].available() > 0) {
      //todo: handle isPortReady logic
      
      print("Rcv"+i+": ");
      String line = "";
      while (serialPorts[i].available() > 0) {
        int inByte = serialPorts[i].read();
        print(""+char(inByte));
        line+=char(inByte);
      }
      if (!line.equals(".")) {
      //  portTxt[i].addItem(line,null); //<-- disabled because ControlP5 seems to have bugs with handling of scrollable lists...
      }
      println();
    }
  }
  
  
  //

}

void Add() {
  String item = timeTxt.getText()+","+Motor17Pos+","+Motor17Speed+","+Motor18Pos+","+Motor18Speed+","+Motor19Pos+","+Motor19Speed+","+Motor20Pos+","+Motor20Speed+","+Motor21Pos+","+Motor21Speed+","+Motor22Pos+","+Motor22Speed+","+Motor23Pos+","+Motor23Speed+","+Motor24Pos+","+Motor24Speed+","+Motor25Pos+","+Motor25Speed+
  ","+Motor33Pos+","+Motor33Speed+","+Motor34Pos+","+Motor34Speed+","+Motor35Pos+","+Motor35Speed+","+Motor36Pos+","+Motor36Speed+","+Motor37Pos+","+Motor37Speed+","+Motor38Pos+","+Motor38Speed+","+Motor39Pos+","+Motor39Speed+","+Motor40Pos+","+Motor40Speed+","+Motor41Pos+","+Motor41Speed+
  ","+Motor49Pos+","+Motor49Speed+","+Motor50Pos+","+Motor50Speed+","+Motor51Pos+","+Motor51Speed+","+Motor52Pos+","+Motor52Speed+","+Motor53Pos+","+Motor53Speed+","+Motor54Pos+","+Motor54Speed+","+Motor55Pos+","+Motor55Speed+","+Motor56Pos+","+Motor56Speed+","+Motor57Pos+","+Motor57Speed+
  ","+Motor65Pos+","+Motor65Speed+","+Motor66Pos+","+Motor66Speed+","+Motor67Pos+","+Motor67Speed+","+Motor68Pos+","+Motor68Speed+","+Motor69Pos+","+Motor69Speed+","+Motor70Pos+","+Motor70Speed+","+Motor71Pos+","+Motor71Speed+","+Motor72Pos+","+Motor72Speed+","+Motor73Pos+","+Motor73Speed+
  ","+Motor81Pos+","+Motor81Speed+","+Motor82Pos+","+Motor82Speed+","+Motor83Pos+","+Motor83Speed+","+Motor84Pos+","+Motor84Speed+","+Motor85Pos+","+Motor85Speed+","+Motor86Pos+","+Motor86Speed+","+Motor87Pos+","+Motor87Speed+","+Motor88Pos+","+Motor88Speed+","+Motor89Pos+","+Motor89Speed+
  "\n";
  timelineTxt.setText(timelineTxt.getText()+item);
}

boolean playEnabled = false;
int getItemTime(int idx) {
  String timelineStr = timelineTxt.getText();
  String[] items = timelineStr.split("\n");
  return Integer.parseInt(items[idx].split(",")[0]);
}

int getItemCount() {
  String timelineStr = timelineTxt.getText();
  String[] items = timelineStr.split("\n");
  return items.length;
}
 
String[] getItemData(int idx) {
  String timelineStr = timelineTxt.getText();
  String[] items = timelineStr.split("\n");
  return items[idx].split(",");
}

void queueNext() {
  int timeToWait = getItemTime(playIndex);
  println("queued item "+playIndex+" in "+ timeToWait);
  setTimeout("playNext",timeToWait);
}

int playIndex = 0;
void playNext() {
  println("PlayingNext...");
  if (playEnabled) {
    println("playing "+playIndex);
     String[] itemData = getItemData(playIndex);
     
     for (int i=1; i <= (5*9)*2; i+=2) {
       motors[i/9][i%9].setPosition(Integer.parseInt(itemData[i]));
       motors[i/9][i%9].setSpeed(Integer.parseInt(itemData[i+1]));
     }
  
     playIndex++;
  
     if (playIndex<getItemCount()) {
       queueNext();
     } else {
       //loop
       println("Reached end, looping");
       Play();
     }
  } else {
    println("Playing is no longer enabled, quitting!");
  }
}

void Play() {  
  println("Play called...");
  playEnabled = true;
  playIndex = 0;
  int timeToWait = getItemTime(0);
  setTimeout("playNext",timeToWait);
}



void Stop() {
  println("Stop called...");
  playEnabled = false;
}

void Clear() {
  Stop();
  timelineTxt.clear();
}

void Update() { 
  
  motors[0][0].setPosition(Motor17Pos);
  motors[0][0].setSpeed(Motor17Speed);
  motors[0][1].setPosition(Motor18Pos);
  motors[0][1].setSpeed(Motor18Speed);
  motors[0][2].setPosition(Motor19Pos);
  motors[0][2].setSpeed(Motor19Speed);
  motors[0][3].setPosition(Motor20Pos);
  motors[0][3].setSpeed(Motor20Speed);
  motors[0][4].setPosition(Motor21Pos);
  motors[0][4].setSpeed(Motor21Speed);
  motors[0][5].setPosition(Motor22Pos);
  motors[0][5].setSpeed(Motor22Speed);
  motors[0][6].setPosition(Motor23Pos);
  motors[0][6].setSpeed(Motor23Speed);
  motors[0][7].setPosition(Motor24Pos);
  motors[0][7].setSpeed(Motor24Speed);
  motors[0][8].setPosition(Motor25Pos);
  motors[0][8].setSpeed(Motor25Speed);
  
  motors[1][0].setPosition(Motor33Pos);
  motors[1][0].setSpeed(Motor33Speed);
  motors[1][1].setPosition(Motor34Pos);
  motors[1][1].setSpeed(Motor34Speed);
  motors[1][2].setPosition(Motor35Pos);
  motors[1][2].setSpeed(Motor35Speed);
  motors[1][3].setPosition(Motor36Pos);
  motors[1][3].setSpeed(Motor36Speed);
  motors[1][4].setPosition(Motor37Pos);
  motors[1][4].setSpeed(Motor37Speed);
  motors[1][5].setPosition(Motor38Pos);
  motors[1][5].setSpeed(Motor38Speed);
  motors[1][6].setPosition(Motor39Pos);
  motors[1][6].setSpeed(Motor39Speed);
  motors[1][7].setPosition(Motor40Pos);
  motors[1][7].setSpeed(Motor40Speed);
  motors[1][8].setPosition(Motor41Pos);
  motors[1][8].setSpeed(Motor41Speed);
  
  motors[2][0].setPosition(Motor49Pos);
  motors[2][0].setSpeed(Motor49Speed);
  motors[2][1].setPosition(Motor50Pos);
  motors[2][1].setSpeed(Motor50Speed);
  motors[2][2].setPosition(Motor51Pos);
  motors[2][2].setSpeed(Motor51Speed);
  motors[2][3].setPosition(Motor52Pos);
  motors[2][3].setSpeed(Motor52Speed);
  motors[2][4].setPosition(Motor53Pos);
  motors[2][4].setSpeed(Motor53Speed);
  motors[2][5].setPosition(Motor54Pos);
  motors[2][5].setSpeed(Motor54Speed);
  motors[2][6].setPosition(Motor55Pos);
  motors[2][6].setSpeed(Motor55Speed);
  motors[2][7].setPosition(Motor56Pos);
  motors[2][7].setSpeed(Motor56Speed);
  motors[2][8].setPosition(Motor57Pos);
  motors[2][8].setSpeed(Motor57Speed);
  
  motors[3][0].setPosition(Motor65Pos);
  motors[3][0].setSpeed(Motor65Speed);
  motors[3][1].setPosition(Motor66Pos);
  motors[3][1].setSpeed(Motor66Speed);
  motors[3][2].setPosition(Motor67Pos);
  motors[3][2].setSpeed(Motor67Speed);
  motors[3][3].setPosition(Motor68Pos);
  motors[3][3].setSpeed(Motor68Speed);
  motors[3][4].setPosition(Motor69Pos);
  motors[3][4].setSpeed(Motor69Speed);
  motors[3][5].setPosition(Motor70Pos);
  motors[3][5].setSpeed(Motor70Speed);
  motors[3][6].setPosition(Motor71Pos);
  motors[3][6].setSpeed(Motor71Speed);
  motors[3][7].setPosition(Motor72Pos);
  motors[3][7].setSpeed(Motor72Speed);
  motors[3][8].setPosition(Motor73Pos);
  motors[3][8].setSpeed(Motor73Speed);

  motors[4][0].setPosition(Motor81Pos);
  motors[4][0].setSpeed(Motor81Speed);
  motors[4][1].setPosition(Motor82Pos);
  motors[4][1].setSpeed(Motor82Speed);
  motors[4][2].setPosition(Motor83Pos);
  motors[4][2].setSpeed(Motor83Speed);
  motors[4][3].setPosition(Motor84Pos);
  motors[4][3].setSpeed(Motor84Speed);
  motors[4][4].setPosition(Motor85Pos);
  motors[4][4].setSpeed(Motor85Speed);
  motors[4][5].setPosition(Motor86Pos);
  motors[4][5].setSpeed(Motor86Speed);
  motors[4][6].setPosition(Motor87Pos);
  motors[4][6].setSpeed(Motor87Speed);
  motors[4][7].setPosition(Motor88Pos);
  motors[4][7].setSpeed(Motor88Speed);
  motors[4][8].setPosition(Motor89Pos);
  motors[4][8].setSpeed(Motor89Speed);
  
}

static void sendToPort(String msgStr, String debugStr) {

   for (int i = 0; i < serialPorts.length; ++i) {
     sendToPort(i,msgStr,debugStr);
   }

}

static void sendToPort(int portNum, String msgStr, String debugStr) {
   serialPorts[portNum].write(msgStr);
   println("Sent: '"+portNum+" "+msgStr.replaceAll("\n","_")+"' "+debugStr);
}


void Send_Halt() {
  AmazingStepper.haltAll();
}

void Send_Go() {
  AmazingStepper.goAll();
}

void All_250(){
  AmazingStepper.highAll();
}

void All_0(){
  AmazingStepper.lowAll();
}

void Control_Motor(){
  
  //for (int i = 0; i < wallMotorIds[2].length; i++){
  //  int motorId = wallMotorIds[2][i];
  //  AmazingStepper.sendMovement(motorId,127,250); // port, speed, pos
  //}
  
  //int[][] wallMotorIds = { { 17,18,19,20,21,22,23,24,25 },
                         //{ 33,34,35,36,37,38,39,40,41 },
                         //{ 49,50,51,52,53,54,55,56,57 },
                         //{ 65,66,67,68,69,70,71,72,73 },
                         //{ 81,82,83,84,85,86,87,88,89 }
                         
    AmazingStepper.sendMovement(17,127,250); // port, speed, pos
    AmazingStepper.sendMovement(33,127,250); // port, speed, pos
    AmazingStepper.sendMovement(49,127,250); // port, speed, pos
    AmazingStepper.sendMovement(65,127,250); // port, speed, pos
    AmazingStepper.sendMovement(81,127,250); // port, speed, pos


  
  
  //AmazingStepper.sendString("I49\nD1\n");
  //AmazingStepper.sendString("I49\nD127\n");
  //AmazingStepper.sendString("I49\nD2\n");
  //AmazingStepper.sendString("I49\nD250\n");
  
  //motors[2][0].setPosition(250);
  //motors[2][0].setSpeed(150);
  //motors[2][1].setPosition(pos);
  //motors[2][1].setSpeed(speed);
}


  