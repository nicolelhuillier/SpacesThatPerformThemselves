/*Required Connections
  --------------------
    pin 2:  LED Strip #1    OctoWS2811 drives 8 LED Strips.
    pin 14: LED strip #2    All 8 are the same length.
    pin 7:  LED strip #3
    pin 8:  LED strip #4    A 100 ohm resistor should used
    pin 6:  LED strip #5    between each Teensy pin and the
    pin 20: LED strip #6    wire to the LED strip, to minimize
    pin 21: LED strip #7    high frequency ringining & noise.
    pin 5:  LED strip #8
    pin 15 & 16 - Connect together, but do not use
    pin 4 - Do not use
    pin 3 - Do not use as PWM.  Normal use is ok.

    Code inspired on: https://gist.github.com/nocduro/9b15ba001f52465897c56ba58b9d4d26
*/

int inByteCounter = 0;   //MIDI in

int inPitch = 0;         //MIDI in
int inVelocity = 0;      //MIDI in
int inInt = 0;           //MIDI in

////////

#include <OctoSK6812.h>

const int ledsPerStrip = 60; //número de LEDs

// why multiply by 6? 2 bytes per colour??
DMAMEM int displayMemory[ledsPerStrip * 8];
int drawingMemory[ledsPerStrip * 8];

OctoSK6812 leds(ledsPerStrip, displayMemory, drawingMemory, SK6812_GRBW);

const int wallIdPins[] = { 0, 1, 23, 22, 19 }; //the pin numbers for identifying which wall this controller is for. These pins will be INPUT_PULLUP, and the appropriate one will be grounded. Tested on bootup 
#define UNIDENTIFIED 99
int wallID = UNIDENTIFIED;

void printWallID() {
  Serial.print("LED-");
  if (UNIDENTIFIED == wallID) {
    Serial.println("UNKNOWN");
  } else {
    Serial.println(wallID);    
  }
  
}

void setup() {

  Serial.begin(9600); //mas rapido? 115200?
  Serial.setTimeout(50);

  /********** BEGIN - wall ID *********/
  //NOTICE: the message on boot might not be received on the PC side due to whatever reason... so we made it also reply when '1' is sent on serial.
  for (int i=0; i < (sizeof(wallIdPins)/sizeof(int)); ++i) {
      pinMode(wallIdPins[i],INPUT_PULLUP);
  }

  for (int i = 0; i<(sizeof(wallIdPins)/sizeof(int)); ++i) {
    if (LOW==digitalRead(wallIdPins[i])) {
       wallID = i;
    }
  }

  printWallID();
 /********** END - wall ID *********/
 
  leds.begin();
  leds.show();

  leds.setPixel(0, 0xFF000000);
  leds.setPixel(1, 0x00FF0000);
  leds.setPixel(2, 0x0000FF00);
  leds.setPixel(3, 0x000000FF);
  leds.setPixel(4, 0xFFFFFFFF);
  leds.show();
  //delay(5000);
}

#define RED    0xFF000000
#define GREEN  0x00FF0000
#define BLUE   0x0000FF00
#define YELLOW 0xFFFF0000
#define PINK   0xFF108800
#define ORANGE 0xE0580000
#define WHITE  0x000000FF
#define OFF    0x00000000

void loop() {
  int microsec = 1800000 / leds.numPixels();  // change them all in 2 seconds - es lo que se demora en hacer color wipe

  // uncomment for voltage controlled speed
  // millisec = analogRead(A9) / 40;


  //para traer nota midi:
  if (Serial.available() > 0) {
    // get incoming byte:
    inInt = Serial.parseInt();
  }

  if (1 == inInt) {
    printWallID();
  }

  if (inInt == 70) {
    colorStripe(BLUE, microsec, 8);
    
  }

  if (inInt == 71) {
    colorBlock(OFF, microsec);
    
  }

  if (inInt == 72) {
    colorWipe(WHITE, microsec);
  }

  if (inInt == 73) {
    colorBlock(BLUE, microsec);
  }

  if (inInt == 74) {
    colorBlock(PINK, microsec);
  }

  if (inInt == 75) {
    colorBlock(YELLOW, microsec);
  }

  if (inInt == 76) {
    colorBlock(WHITE, microsec);
  }

  if (inInt == 77) {
    colorBlock(RED, microsec);
  }
}


//FUNCTION 1: colorWipe
void colorWipe(int color, int wait)
{
  for (int i = 0; i < leds.numPixels(); i++) { //60 * 8= 480 * sec calcular cuanto se demora el delay
    leds.setPixel(i, color);  
    leds.show();
   delayMicroseconds(wait);
  }

}


//FUNCTION 2: colorBlock
void colorBlock(int color, int wait)
{
  for (int i = 0; i < leds.numPixels(); i++) {
    leds.setPixel(i, color);

  }
  leds.show();
}


//FUNCTION 3: colorStripe ------ tengo que probar y ver qué hace...
void colorStripe(int color, int wait, int strip)
{
  int startIndex =  strip *  ledsPerStrip;
  int endIndex  = startIndex + ledsPerStrip;

  for (int i = startIndex; i < endIndex; i++) {
    leds.setPixel(i, color);
    leds.show();
    delayMicroseconds(wait);
  }
}
