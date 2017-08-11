// MOVEMENT 0
void movement0() {
  AmazingStepper.lowAll();
}


// MOVEMENT 1
void movement1A() {
  moveCenterRods(85,50);
}

void movement1B() {
  moveCenterRods(0,50); 
}

void movement1C() {
  moveCenterRods(65,50); 
}


// MOVEMENT 2
void movement2A() {
  moveRandomPoints1(90,250); 
}

void movement2B() {
  moveRandomPoints1(65,250); 
  moveRandomPoints2(90,250); 
}

void movement2C() {
  moveRandomPoints2(65,250); 
  moveCenterRods(90,250); 
}

void movement2D() {
  moveCenterRods(65,250); 
  moveRandomPoints3(90,250);
}

void movement2E() {
  moveRandomPoints3(65,250);
  moveRandomPoints4(90,250);
}

void movement2F() {
  moveRandomPoints4(65,250);
  moveRandomPoints5(90,250);
}

void movement2G() {
  moveRandomPoints5(65,250);
}


// MOVEMENT 3
void movement3A() {
  moveInRange(17,25,100,250);
}

void movement3B() {
  moveInRange(33,41,100,250);
}

void movement3C() {
  moveInRange(49,57,100,250);
}

void movement3D() {
  moveInRange(65,73,100,250);
}


// MOVEMENT 4
void movement4A() {
  AmazingStepper.sendAll(0,127);
}

void movement4B() {
  AmazingStepper.sendAll(90,127);
}


// MOVEMENT 5
void movement5A1_clockwise() {
  moveThreeInRange(19,0,127);
}

void movement5A2_clockwise() {
  moveThreeInRange(18,0,127);
}

void movement5A3_clockwise() {
  moveThreeInRange(17,0,127);
}

void movement5B1_clockwise() {
  moveThreeInRange(35,0,127);
}

void movement5B2_clockwise() {
  moveThreeInRange(34,0,127);
}

void movement5B3_clockwise() {
  moveThreeInRange(33,0,127);
}

void movement5C1_clockwise() {
  moveThreeInRange(51,0,127);
}

void movement5C2_clockwise() {
  moveThreeInRange(50,0,127);
}

void movement5C3_clockwise() {
  moveThreeInRange(49,0,127);
}

void movement5D1_clockwise() {
  moveThreeInRange(67,0,127);
}

void movement5D2_clockwise() {
  moveThreeInRange(66,0,127);
}

void movement5D3_clockwise() {
  moveThreeInRange(65,0,127);
}


void movement5A1_anticlockwise() {
  moveThreeInRange(17,100,127);
}

void movement5A2_anticlockwise() {
  moveThreeInRange(18,100,127);
}

void movement5A3_anticlockwise() {
  moveThreeInRange(19,100,127);
}

void movement5B1_anticlockwise() {
  moveThreeInRange(33,100,127);
}

void movement5B2_anticlockwise() {
  moveThreeInRange(34,100,127);
}

void movement5B3_anticlockwise() {
  moveThreeInRange(35,100,127);
}

void movement5C1_anticlockwise() {
  moveThreeInRange(49,100,127);
}

void movement5C2_anticlockwise() {
  moveThreeInRange(50,100,127);
}

void movement5C3_anticlockwise() {
  moveThreeInRange(51,100,127);
}

void movement5D1_anticlockwise() {
  moveThreeInRange(65,100,127);
}

void movement5D2_anticlockwise() {
  moveThreeInRange(66,100,127);
}

void movement5D3_anticlockwise() {
  moveThreeInRange(67,100,127);
}


// MOVEMENT 6
void movement6() {
  AmazingStepper.sendAll(65,127);
}


// MOVEMENT 7
// same as movement 2


// MOVEMENT 8
void movement8A() {
  moveInRange(81,89,100,100); 
}

void movement8B() {
  moveInRange(65,73,100,250); 
}

void movement8C() {
  moveInRange(49,57,100,250); 
}

void movement8D() {
  moveInRange(33,41,100,250); 
}

void movement8E() {
  moveInRange(17,25,100,250); 
}


// MOVEMENT 9 
void movement9() {
  AmazingStepper.sendAll(145,127);
}

// MOVEMENT 10
void movement10() {
  AmazingStepper.sendAll(0,50);
}

// ========================
// === HELPER FUNCTIONS ===
// ========================

// movement1
// 21,37,53,69,85 (center)
void moveCenterRods(int position, int speed) {
    AmazingStepper.sendMovement(21,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(37,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(53,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(69,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(85,position,speed); // port, speed, pos 
}

//movement 2.1
// 17,33,49,65,81
void moveRandomPoints1(int position, int speed) {
    AmazingStepper.sendMovement(17,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(33,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(49,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(65,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(81,position,speed); // port, speed, pos 
}

// movement 2.2
// 25,41,57,73,89
void moveRandomPoints2(int position, int speed) {
    AmazingStepper.sendMovement(25,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(41,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(57,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(73,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(89,position,speed); // port, speed, pos 
}

// movement 2.3
// 18,34,50,66,82
void moveRandomPoints3(int position, int speed) {
    AmazingStepper.sendMovement(18,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(34,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(50,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(66,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(82,position,speed); // port, speed, pos 
}

// movement 2.4
// 23,39,55,71,87
void moveRandomPoints4(int position, int speed) {
    AmazingStepper.sendMovement(23,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(39,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(55,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(71,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(87,position,speed); // port, speed, pos 
}

// movement 2.5
// 19,25,51,67,83
void moveRandomPoints5(int position, int speed) {
    AmazingStepper.sendMovement(19,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(25,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(51,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(67,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(83,position,speed); // port, speed, pos 
}

void moveInRange(int start, int end, int position, int speed) {
  for (int i = start; i <= end; i++) {
    AmazingStepper.sendMovement(i,position,speed);
  }
}

// === WAVE === 
void moveThreeInRange(int start, int position, int speed) {
    AmazingStepper.sendMovement(start,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(start+3,position,speed); // port, speed, pos
    AmazingStepper.sendMovement(start+6,position,speed); // port, speed, pos
}