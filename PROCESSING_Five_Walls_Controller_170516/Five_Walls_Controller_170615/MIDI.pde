
void noteOn(int channel, int pitch, int velocity) {

  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);    
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  if (pitch == 72) {
    AmazingStepper.highAll();
  }
  
  if (pitch == 73) {
    AmazingStepper.lowAll();
  }
  
  if (pitch == 71) {
    AmazingStepper.sendMovement(17,127,250); // port, speed, pos
    AmazingStepper.sendMovement(33,127,250); // port, speed, pos
    AmazingStepper.sendMovement(49,127,250); // port, speed, pos
    AmazingStepper.sendMovement(65,127,250); // port, speed, pos
    AmazingStepper.sendMovement(81,127,250); // port, speed, pos
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