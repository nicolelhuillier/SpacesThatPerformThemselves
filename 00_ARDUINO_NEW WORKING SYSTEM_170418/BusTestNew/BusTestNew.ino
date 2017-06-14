// Stress test for SoftwareWire library.
// Tested with an Arduino Uno connected to an Arduino Uno.
// This is the sketch for the Master Arduino using the software i2c.

// Use define to switch between the Arduino Wire and the SoftwareWire.
#define TEST_SOFTWAREWIRE


#ifdef TEST_SOFTWAREWIRE

#include "SoftwareWire.h"

// SoftwareWire constructor.
// Parameters:
//   (1) pin for the software sda
//   (2) pin for the software scl
//   (3) use internal pullup resistors. Default true. Set to false to disable them.
//   (4) allow the Slave to stretch the clock pulse. Default true. Set to false for faster code.

// This stress test uses A4 and A5, that makes it easy to switch between the (hardware) Wire
// and the (software) SoftwareWire libraries.
// myWire: sda = A4, scl = A5, turn on internal pullups, allow clock stretching by Slave
SoftwareWire myWire( A4, A5);

#else

// Make code work with normal Wire library.
#include <Arduino.h>
#include <Wire.h>
#define myWire Wire         // use the real Arduino Wire library instead of the SoftwareWire.

#endif

#define MAX_VALUE 255
char commandBuffer[64];
int commandIndex = 0;

int wallIdPins[] = {8,9,10,11,12}; //the pin numbers for identifying which wall this controller is for. These pins will be INPUT_PULLUP, and the appropriate one will be grounded. Tested on bootup 
#define UNIDENTIFIED 99

/**
 * 
 * This is a newer (April 2017) version of the bus controller for AmazingStepper.
 * 
 * this expects the following format for incoming data:
 * I66\nD40\n
 * 
 * Where 'I' means 'set the ID' and 'D' means set the Data.
 * 
 * Whenever data is set, a message is sent on the wire to the last-set-ID with the given Data.
 * 
 * Messages are interpreted upon '\n'
 */

void setup()
{
  pinMode(wallIdPins[0],INPUT_PULLUP);
  pinMode(wallIdPins[1],INPUT_PULLUP);
  pinMode(wallIdPins[2],INPUT_PULLUP);
  pinMode(wallIdPins[3],INPUT_PULLUP);
  pinMode(wallIdPins[4],INPUT_PULLUP);

  Serial.begin(9600);      // start serial port

  int wallID = UNIDENTIFIED;
  for (int i = 0; i<(sizeof(wallIdPins)/sizeof(int)); ++i) {
    if (LOW==digitalRead(wallIdPins[i])) {
      wallID = i;
    }
  }

  Serial.print("Master-");
  if (UNIDENTIFIED == wallID) {
    Serial.println("UNKNOWN");
  } else {
    Serial.println(wallID);    
  }
  

  myWire.begin();          // join i2c bus as master
  myWire.setClock(5000);
}

void sendOnWire(uint8_t addr, uint8_t data) {
  myWire.beginTransmission(addr);
  myWire.write( data );
  if( myWire.endTransmission() != 0)
  {
    Serial.println("WireError!");
  } else {
    Serial.print(addr);
    Serial.print(":");
    Serial.println(data);
  }

}

void clearBuffer() {
  for (int i = 0; i < sizeof(commandBuffer); ++i) {
    commandBuffer[i] = 0;
  }
  commandIndex = 0;
}

void loop()
{
  static int id = 0;
  static int val = 0;

  static bool ignoreNext = false;
  unsigned int value = 0;

  while (Serial.available() > 0) {
    char c = Serial.read();
 
    if (c == '\r') {
      continue; //ignore carriage returns, if present
    }
 
    if (c == '\n') {
      // check if there is a command in the buffer
      if (!ignoreNext) {
        switch (commandBuffer[0]) {
          case 'I':
            value = (atoi(commandBuffer + 1));
            if (value>=0 && value<=MAX_VALUE) {
              id = value; 
//              Serial.print("I: ");
//              Serial.println(value);
            } else {
//              Serial.print("Out Of Bounds: ");
//              Serial.println(value);
            }
            break;
          case 'D':
            value = (atoi(commandBuffer + 1));
            if (value>=0 && value<=MAX_VALUE) {
              val = value;
              sendOnWire(id,val);

//              Serial.print("B: ");
//              Serial.println(value);
            } else {
//              Serial.print("Out Of Bounds: ");
//              Serial.println(value);
            }
            break;
          default:
            Serial.println("Error!");
            break;
        }
      } else {
        Serial.println("Ignored Overflow Data");
        ignoreNext = false;
      }
 
      clearBuffer();
      Serial.println(".");
    } else {
      if (commandIndex >= sizeof(commandBuffer)) {
        Serial.println("BufferFull!");
        clearBuffer();
        ignoreNext = true;
      } else {
        if (!ignoreNext) {
          commandBuffer[commandIndex++] = c;
        }
      }
    }
  }
  
}
