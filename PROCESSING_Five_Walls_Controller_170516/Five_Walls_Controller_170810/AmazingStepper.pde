
final int MOTOR_MIN_POSITION = 3; 
final int MOTOR_MAX_POSITION = 250;
final int MOTOR_DEFAULT_POSITION = MOTOR_MIN_POSITION; 

final int MOTOR_MIN_SPEED = 3; 
final int MOTOR_MAX_SPEED = 250; 
final int MOTOR_DEFAULT_SPEED = 127;

final int MOTOR_HALT = 254;
final int MOTOR_GO = 255;

AmazingStepper[][] motors;

int[][] wallMotorIds = { { 17,18,19,20,21,22,23,24,25 },
                         { 33,34,35,36,37,38,39,40,41 },
                         { 49,50,51,52,53,54,55,56,57 },
                         { 65,66,67,68,69,70,71,72,73 },
                         { 81,82,83,84,85,86,87,88,89 }
                       };


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
  
    static void flatwallAll() {
    sendToPort("I0\n"+"D"+1+"\n","from 'highAll'");
    sendToPort("I0\n"+"D"+30+"\n","from 'highAll'");
    sendToPort("I0\n"+"D"+2+"\n","from 'highAll'");
    sendToPort("I0\n"+"D"+75+"\n","from 'highAll'");
  }
  
  static void sendAll(int position, int speed) {
    sendToPort("I0\n"+"D"+1+"\n","from 'sendAll'"); // speed
    sendToPort("I0\n"+"D"+speed+"\n","from 'sendAll'"); // speed value
    sendToPort("I0\n"+"D"+2+"\n","from 'sendAll'"); // position
    sendToPort("I0\n"+"D"+position+"\n","from 'sendAll'"); // position value
  }
}