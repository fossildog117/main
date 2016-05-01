#include <stdio.h>
#include <EngduinoLEDs.h>
#include <EngduinoButton.h>
#include <EngduinoAccelerometer.h> 
#include <Wire.h> 

char val; //Data received from the serial port
int highscore;

void setup() {
  // put your setup code here, to run once:
  EngduinoLEDs.begin();
  EngduinoButton.begin();
  EngduinoAccelerometer.begin(); 
  Serial.begin(9600);
  
}

void loop() {
  // put your main code here, to run repeatedly.
  
  if (Serial.available()) {
    val = Serial.read();
      if (val == '1') {
        EngduinoLEDs.setAll(GREEN, 5);
        delay(100);
        } else if (val == '2') {
          EngduinoLEDs.setAll(RED, 5);
          delay(100);
          } 
  }

  EngduinoLEDs.setAll(OFF);
  
  if(EngduinoButton.wasPressed()) {
    Serial.write('3' - '0');
    EngduinoLEDs.setAll(BLUE, 5);
    delay(50);
  }
  
  float accelerations[3];
  EngduinoAccelerometer.xyz(accelerations);
  float y = accelerations[1];
  Serial.println(y);

}

