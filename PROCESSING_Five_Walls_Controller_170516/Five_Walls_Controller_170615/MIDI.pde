
void noteOn(int channel, int pitch, int velocity) {

  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);    
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  if (pitch == 80) {
    AmazingStepper.highAll();
  }
  
  if (pitch == 81) {
    AmazingStepper.lowAll();
  }
  
  if (pitch == 82) {
    AmazingStepper.sendMovement(17,127,250); // port, speed, pos
    AmazingStepper.sendMovement(33,127,250); // port, speed, pos
    AmazingStepper.sendMovement(49,127,250); // port, speed, pos
    AmazingStepper.sendMovement(65,127,250); // port, speed, pos
    AmazingStepper.sendMovement(81,127,250); // port, speed, pos
  }
  
  
  // ===== LEDs =====
  //guardar valores
  inChannel  = channel;
  inPitch    = pitch;
  inVelocity = velocity;
  
  sendToArduino = true;

  //secuencias de inicio, stop, 
    
    
    
   // Motors channel - Channel 2 on Abelton
  if (inChannel == 0) {
    sendToMotors = true;
  }
  
  
  // LED channel wall 1 - Channel 1 on Abelton
  if ( inChannel == 1) {
    sendToLEDs_Wall1 = true;
  }

  // LED channel wall 2 - Channel 3 on Abelton
  if (inChannel == 2) {
    sendToLEDs_Wall2 = true;
  }
  
    // LED channel wall 3 - Channel 4 on Abelton
  if (inChannel == 3) {
    sendToLEDs_Wall3 = true;
  }
      // LED channel wall 4 - Channel 5 on Abelton
  if (inChannel == 4) {
    sendToLEDs_Wall4 = true;
  }
      // LED channel wall 5 - Channel 6 on Abelton
  if (inChannel == 5) {
    sendToLEDs_Wall5 = true;
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