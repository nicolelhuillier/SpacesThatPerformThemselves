import controlP5.*;
import processing.serial.*;
import java.util.*;

//DECLARE CLASS
ControlP5 cp5;

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
  
  static void haltAll() {
    sendToPort("I0\n"+"D"+MODE_HALT+"\n","from 'haltAll'");
  }
 
  static void goAll() {
    sendToPort("I0\n"+"D"+MODE_GO+"\n","from 'goAll'");
  }
  
}

//TODO: make code modular, by intializing an array of motors in Setup(), rather than 3 static motors like it is now... 
//int[] stepperIds = { 66, 67, 68 };
//AmazingStepper[] steppers; 
AmazingStepper as17;
AmazingStepper as18;
AmazingStepper as19;
AmazingStepper as20;
AmazingStepper as21;
AmazingStepper as22;
AmazingStepper as23;
AmazingStepper as24;
AmazingStepper as25;

AmazingStepper as33;
AmazingStepper as34;
AmazingStepper as35;
AmazingStepper as36;
AmazingStepper as37;
AmazingStepper as38;
AmazingStepper as39;
AmazingStepper as40;
AmazingStepper as41;

AmazingStepper as49;
AmazingStepper as50;
AmazingStepper as51;
AmazingStepper as52;
AmazingStepper as53;
AmazingStepper as54;
AmazingStepper as55;
AmazingStepper as56;
AmazingStepper as57;

AmazingStepper as65;
AmazingStepper as66;
AmazingStepper as67;
AmazingStepper as68;
AmazingStepper as69;
AmazingStepper as70;
AmazingStepper as71;
AmazingStepper as72;
AmazingStepper as73;

AmazingStepper as81;
AmazingStepper as82;
AmazingStepper as83;
AmazingStepper as84;
AmazingStepper as85;
AmazingStepper as86;
AmazingStepper as87;
AmazingStepper as88;
AmazingStepper as89;

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
  background(15);
  stroke(255);
  line(10, 215, 530, 215);
  line(650, 215, 1170, 215);
  line(10, 435, 530, 435);
  line(650, 435, 1170, 435);
  
  initWallControllers();
  
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
    .setColorBackground(color(0, 128, 0));
    
  cp5.addButton("Stop")
    //.setValue(500)
    .setPosition(960, 470)
    .setSize(50, 50)
    .setColorBackground(color(128, 0, 0));

  cp5.addButton("Clear")
    //.setValue(500)
    .setPosition(1030, 470)
    .setSize(50, 50);

  as17 = new AmazingStepper(17,0); //assigning ports (0)
  as18 = new AmazingStepper(18,0);
  as19 = new AmazingStepper(19,0);
  as20 = new AmazingStepper(20,0);
  as21 = new AmazingStepper(21,0);
  as22 = new AmazingStepper(22,0);
  as23 = new AmazingStepper(23,0);
  as24 = new AmazingStepper(24,0);
  as25 = new AmazingStepper(25,0);
  
  as33 = new AmazingStepper(33,1);
  as34 = new AmazingStepper(34,1);
  as35 = new AmazingStepper(35,1);
  as36 = new AmazingStepper(36,1);
  as37 = new AmazingStepper(37,1);
  as38 = new AmazingStepper(38,1);
  as39 = new AmazingStepper(39,1);
  as40 = new AmazingStepper(40,1);
  as41 = new AmazingStepper(41,1);
  
  as49 = new AmazingStepper(49,2);
  as50 = new AmazingStepper(50,2);
  as51 = new AmazingStepper(51,2);
  as52 = new AmazingStepper(52,2);
  as53 = new AmazingStepper(53,2);
  as54 = new AmazingStepper(54,2);
  as55 = new AmazingStepper(55,2);
  as56 = new AmazingStepper(56,2);
  as57 = new AmazingStepper(57,2);
  
  as65 = new AmazingStepper(65,3);
  as66 = new AmazingStepper(66,3);
  as67 = new AmazingStepper(67,3);
  as68 = new AmazingStepper(68,3);
  as69 = new AmazingStepper(69,3);
  as70 = new AmazingStepper(70,3);
  as71 = new AmazingStepper(71,3);
  as72 = new AmazingStepper(72,3);
  as73 = new AmazingStepper(73,3);
  
  as81 = new AmazingStepper(81,4);
  as82 = new AmazingStepper(82,4);
  as83 = new AmazingStepper(83,4);
  as84 = new AmazingStepper(84,4);
  as85 = new AmazingStepper(85,4);
  as86 = new AmazingStepper(86,4);
  as87 = new AmazingStepper(87,4);
  as88 = new AmazingStepper(88,4);
  as89 = new AmazingStepper(89,4);
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
     
     as17.setPosition(Integer.parseInt(itemData[1]));
     as17.setSpeed(Integer.parseInt(itemData[2]));
     as18.setPosition(Integer.parseInt(itemData[3]));
     as18.setSpeed(Integer.parseInt(itemData[4]));
     as19.setPosition(Integer.parseInt(itemData[5]));
     as19.setSpeed(Integer.parseInt(itemData[6]));
     as20.setPosition(Integer.parseInt(itemData[7]));
     as20.setSpeed(Integer.parseInt(itemData[8]));
     as21.setPosition(Integer.parseInt(itemData[9]));
     as21.setSpeed(Integer.parseInt(itemData[10]));
     as22.setPosition(Integer.parseInt(itemData[11]));
     as22.setSpeed(Integer.parseInt(itemData[12]));
     as23.setPosition(Integer.parseInt(itemData[13]));
     as23.setSpeed(Integer.parseInt(itemData[14]));
     as24.setPosition(Integer.parseInt(itemData[15]));
     as24.setSpeed(Integer.parseInt(itemData[16]));
     as25.setPosition(Integer.parseInt(itemData[17]));
     as25.setSpeed(Integer.parseInt(itemData[18]));
     
     as33.setPosition(Integer.parseInt(itemData[19]));
     as33.setSpeed(Integer.parseInt(itemData[20]));
     as34.setPosition(Integer.parseInt(itemData[21]));
     as34.setSpeed(Integer.parseInt(itemData[22]));
     as35.setPosition(Integer.parseInt(itemData[23]));
     as35.setSpeed(Integer.parseInt(itemData[24]));
     as36.setPosition(Integer.parseInt(itemData[25]));
     as36.setSpeed(Integer.parseInt(itemData[26]));
     as37.setPosition(Integer.parseInt(itemData[27]));
     as37.setSpeed(Integer.parseInt(itemData[28]));
     as38.setPosition(Integer.parseInt(itemData[29]));
     as38.setSpeed(Integer.parseInt(itemData[30]));
     as39.setPosition(Integer.parseInt(itemData[31]));
     as39.setSpeed(Integer.parseInt(itemData[32]));
     as40.setPosition(Integer.parseInt(itemData[33]));
     as40.setSpeed(Integer.parseInt(itemData[34]));
     as41.setPosition(Integer.parseInt(itemData[35]));
     as41.setSpeed(Integer.parseInt(itemData[36]));
  
     as49.setPosition(Integer.parseInt(itemData[37]));
     as49.setSpeed(Integer.parseInt(itemData[38]));
     as50.setPosition(Integer.parseInt(itemData[39]));
     as50.setSpeed(Integer.parseInt(itemData[40]));
     as51.setPosition(Integer.parseInt(itemData[41]));
     as51.setSpeed(Integer.parseInt(itemData[42]));
     as52.setPosition(Integer.parseInt(itemData[43]));
     as52.setSpeed(Integer.parseInt(itemData[44]));
     as53.setPosition(Integer.parseInt(itemData[45]));
     as53.setSpeed(Integer.parseInt(itemData[46]));
     as54.setPosition(Integer.parseInt(itemData[47]));
     as54.setSpeed(Integer.parseInt(itemData[48]));
     as55.setPosition(Integer.parseInt(itemData[49]));
     as55.setSpeed(Integer.parseInt(itemData[50]));
     as56.setPosition(Integer.parseInt(itemData[51]));
     as56.setSpeed(Integer.parseInt(itemData[52]));
     as57.setPosition(Integer.parseInt(itemData[53]));
     as57.setSpeed(Integer.parseInt(itemData[54]));
  
     as65.setPosition(Integer.parseInt(itemData[55]));
     as65.setSpeed(Integer.parseInt(itemData[56]));
     as66.setPosition(Integer.parseInt(itemData[57]));
     as66.setSpeed(Integer.parseInt(itemData[58]));
     as67.setPosition(Integer.parseInt(itemData[9]));
     as67.setSpeed(Integer.parseInt(itemData[60]));
     as68.setPosition(Integer.parseInt(itemData[61]));
     as68.setSpeed(Integer.parseInt(itemData[62]));
     as69.setPosition(Integer.parseInt(itemData[63]));
     as69.setSpeed(Integer.parseInt(itemData[64]));
     as70.setPosition(Integer.parseInt(itemData[65]));
     as70.setSpeed(Integer.parseInt(itemData[66]));
     as71.setPosition(Integer.parseInt(itemData[67]));
     as71.setSpeed(Integer.parseInt(itemData[68]));
     as72.setPosition(Integer.parseInt(itemData[69]));
     as72.setSpeed(Integer.parseInt(itemData[70]));
     as73.setPosition(Integer.parseInt(itemData[71]));
     as73.setSpeed(Integer.parseInt(itemData[72]));
  
     as81.setPosition(Integer.parseInt(itemData[73]));
     as81.setSpeed(Integer.parseInt(itemData[74]));
     as82.setPosition(Integer.parseInt(itemData[75]));
     as82.setSpeed(Integer.parseInt(itemData[76]));
     as83.setPosition(Integer.parseInt(itemData[77]));
     as83.setSpeed(Integer.parseInt(itemData[78]));
     as84.setPosition(Integer.parseInt(itemData[79]));
     as84.setSpeed(Integer.parseInt(itemData[80]));
     as85.setPosition(Integer.parseInt(itemData[81]));
     as85.setSpeed(Integer.parseInt(itemData[82]));
     as86.setPosition(Integer.parseInt(itemData[83]));
     as86.setSpeed(Integer.parseInt(itemData[84]));
     as87.setPosition(Integer.parseInt(itemData[85]));
     as87.setSpeed(Integer.parseInt(itemData[86]));
     as88.setPosition(Integer.parseInt(itemData[87]));
     as88.setSpeed(Integer.parseInt(itemData[88]));
     as89.setPosition(Integer.parseInt(itemData[89]));
     as89.setSpeed(Integer.parseInt(itemData[90]));
  
  
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
  
  as17.setPosition(Motor17Pos);
  as17.setSpeed(Motor17Speed);
  as18.setPosition(Motor18Pos);
  as18.setSpeed(Motor18Speed);
  as19.setPosition(Motor19Pos);
  as19.setSpeed(Motor19Speed);
  as20.setPosition(Motor20Pos);
  as20.setSpeed(Motor20Speed);
  as21.setPosition(Motor21Pos);
  as21.setSpeed(Motor21Speed);
  as22.setPosition(Motor22Pos);
  as22.setSpeed(Motor22Speed);
  as23.setPosition(Motor23Pos);
  as23.setSpeed(Motor23Speed);
  as24.setPosition(Motor24Pos);
  as24.setSpeed(Motor24Speed);
  as25.setPosition(Motor25Pos);
  as25.setSpeed(Motor25Speed);
  
  as33.setPosition(Motor33Pos);
  as33.setSpeed(Motor33Speed);
  as34.setPosition(Motor34Pos);
  as34.setSpeed(Motor34Speed);
  as35.setPosition(Motor35Pos);
  as35.setSpeed(Motor35Speed);
  as36.setPosition(Motor36Pos);
  as36.setSpeed(Motor36Speed);
  as37.setPosition(Motor37Pos);
  as37.setSpeed(Motor37Speed);
  as38.setPosition(Motor38Pos);
  as38.setSpeed(Motor38Speed);
  as39.setPosition(Motor39Pos);
  as39.setSpeed(Motor39Speed);
  as40.setPosition(Motor40Pos);
  as40.setSpeed(Motor40Speed);
  as41.setPosition(Motor41Pos);
  as41.setSpeed(Motor41Speed);
  
  as49.setPosition(Motor49Pos);
  as49.setSpeed(Motor49Speed);
  as50.setPosition(Motor50Pos);
  as50.setSpeed(Motor50Speed);
  as51.setPosition(Motor51Pos);
  as51.setSpeed(Motor51Speed);
  as52.setPosition(Motor52Pos);
  as52.setSpeed(Motor52Speed);
  as53.setPosition(Motor53Pos);
  as53.setSpeed(Motor53Speed);
  as54.setPosition(Motor54Pos);
  as54.setSpeed(Motor54Speed);
  as55.setPosition(Motor55Pos);
  as55.setSpeed(Motor55Speed);
  as56.setPosition(Motor56Pos);
  as56.setSpeed(Motor56Speed);
  as57.setPosition(Motor57Pos);
  as57.setSpeed(Motor57Speed);
  
  as65.setPosition(Motor65Pos);
  as65.setSpeed(Motor65Speed);
  as66.setPosition(Motor66Pos);
  as66.setSpeed(Motor66Speed);
  as67.setPosition(Motor67Pos);
  as67.setSpeed(Motor67Speed);
  as68.setPosition(Motor68Pos);
  as68.setSpeed(Motor68Speed);
  as69.setPosition(Motor69Pos);
  as69.setSpeed(Motor69Speed);
  as70.setPosition(Motor70Pos);
  as70.setSpeed(Motor70Speed);
  as71.setPosition(Motor71Pos);
  as71.setSpeed(Motor71Speed);
  as72.setPosition(Motor72Pos);
  as72.setSpeed(Motor72Speed);
  as73.setPosition(Motor73Pos);
  as73.setSpeed(Motor73Speed);

  as81.setPosition(Motor81Pos);
  as81.setSpeed(Motor81Speed);
  as82.setPosition(Motor82Pos);
  as82.setSpeed(Motor82Speed);
  as83.setPosition(Motor83Pos);
  as83.setSpeed(Motor83Speed);
  as84.setPosition(Motor84Pos);
  as84.setSpeed(Motor84Speed);
  as85.setPosition(Motor85Pos);
  as85.setSpeed(Motor85Speed);
  as86.setPosition(Motor86Pos);
  as86.setSpeed(Motor86Speed);
  as87.setPosition(Motor87Pos);
  as87.setSpeed(Motor87Speed);
  as88.setPosition(Motor88Pos);
  as88.setSpeed(Motor88Speed);
  as89.setPosition(Motor89Pos);
  as89.setSpeed(Motor89Speed);
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