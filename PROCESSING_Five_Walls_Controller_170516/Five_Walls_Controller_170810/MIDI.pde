
void noteOn(int channel, int pitch, int velocity) {

  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);    
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);

  switch (pitch) {
    // MOVEMENT 0 
    case 2: movement0(); break;
    
    // MOVEMENT 1
    case 3: movement1A(); break;
    case 4: movement1B(); break;
    case 5: movement1C(); break;
    
    // MOVEMENT 2
    case 6: movement2A(); break;
    case 7: movement2B(); break;
    case 8: movement2C(); break;
    case 9: movement2D(); break;
    case 10: movement2E(); break;
    case 11: movement2F(); break;
    case 12: movement2G(); break;
    
    // MOVEMENT 3
    case 13: movement3A(); break;
    case 14: movement3B(); break;
    case 15: movement3C(); break;
    case 16: movement3D(); break;
    
    // MOVEMENT 4
    case 17: movement4A(); break;
    case 18: movement4B(); break;
    
    // MOVEMENT 5
    case 19: movement5A1_clockwise(); break;
    case 20: movement5A2_clockwise();break;
    case 21: movement5A3_clockwise(); break;
    case 22: movement5B1_clockwise(); break;
    case 23: movement5B2_clockwise(); break;
    case 24: movement5B3_clockwise(); break;
    case 25: movement5C1_clockwise(); break;
    case 26: movement5C2_clockwise(); break;
    case 27: movement5C3_clockwise(); break;
    case 28: movement5D1_clockwise(); break;
    case 29: movement5D2_clockwise(); break;
    case 30: movement5D3_clockwise(); break;
    
    case 31: movement5A1_anticlockwise(); break;
    case 32: movement5A2_anticlockwise();break;
    case 33: movement5A3_anticlockwise(); break;
    case 34: movement5B1_anticlockwise(); break;
    case 35: movement5B2_anticlockwise(); break;
    case 36: movement5B3_anticlockwise(); break;
    case 37: movement5C1_anticlockwise(); break;
    case 38: movement5C2_anticlockwise(); break;
    case 39: movement5C3_anticlockwise(); break;
    case 40: movement5D1_anticlockwise(); break;
    case 41: movement5D2_anticlockwise(); break;
    case 42: movement5D3_anticlockwise(); break;
    
    
    // MOVEMENT 6
    case 43: movement6(); break;
    
    // MOVEMENT 8 
    case 44: movement8A(); break;
    case 45: movement8B(); break;
    case 46: movement8C(); break;
    case 47: movement8D(); break;
    case 48: movement8E(); break;
    
    
    // MOVEMENT 9 
    case 49: movement9(); break;
    
    // MOVEMENT 10 
    case 50: movement10(); break;
    
    
    // OTHERS
   case 80:  AmazingStepper.highAll(); break; //all to 250
   case 81: AmazingStepper.lowAll(); break; //all to 0
   case 82: 
      AmazingStepper.sendMovement(17,127,250); // port, speed, pos
      AmazingStepper.sendMovement(33,127,250); // port, speed, pos
      AmazingStepper.sendMovement(49,127,250); // port, speed, pos
      AmazingStepper.sendMovement(65,127,250); // port, speed, pos
      AmazingStepper.sendMovement(81,127,250); // port, speed, pos
      break;
   case 83: AmazingStepper.flatwallAll(); //all to center (speed 30, pos 75)
   case 84: 
      AmazingStepper.sendMovement(21,14,75); // port, speed, pos
      AmazingStepper.sendMovement(37,14,75); // port, speed, pos
      AmazingStepper.sendMovement(53,14,75); // port, speed, pos
      AmazingStepper.sendMovement(69,14,75); // port, speed, pos
      AmazingStepper.sendMovement(85,14,75); // port, speed, pos
      break;
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