import controlP5.*;
import processing.serial.*;
import java.util.*;
import themidibus.*; //Import the library

//DECLARE CLASS
ControlP5 cp5;

//clase MIDi
MidiBus myBus; // The MidiBus  

// LED port
Serial portLED_Wall1;
Serial portLED_Wall2;
Serial portLED_Wall3; 
Serial portLED_Wall4; 
Serial portLED_Wall5; 

// CapacitiveTouch port
Serial portCapacitive;


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
  //myBus = new MidiBus(this, 0, 1); // Nicole's computer - Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
  myBus = new MidiBus(this, 1, 2); // Kevin's computer - Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.

  // LED PORT
  //String portLEDName = Serial.list()[6]; // Nicole's computer 
 
  portLED_Wall1 = new Serial(this, Serial.list()[11], 9600);  // Kevin's computer
  portLED_Wall2 = new Serial(this, Serial.list()[12], 9600);  // Kevin's computer
  portLED_Wall3 = new Serial(this, Serial.list()[13], 9600);  // Kevin's computer
  portLED_Wall4 = new Serial(this, Serial.list()[14], 9600);  // Kevin's computer
  portLED_Wall5 = new Serial(this, Serial.list()[15], 9600);  // Kevin's computer

  // CapacitiveTouch port
  portCapacitive = new Serial(this, Serial.list()[10], 9600);
  
  
  setupGUI();

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
      sendToLED();
      capacitiveTouchEvent();
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


  