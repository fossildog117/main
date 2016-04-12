import processing.serial.*;
import controlP5.*;
import java.util.Random;
import java.lang.String;

Serial myPort;        // Serial port

Logger logger; //Logger

float temp, pH, stirring;

float targetTemp, targetpH, targetStirring;
long lastTimeMillis;

float maxTemp = temp + 1;
float minTemp = temp - 1;
float maxPH = pH + 1;
float minPH = pH - 1;
float maxStirring = stirring + 5;
float minStirring = stirring - 5;

ControlP5 cp5;

int myColorBackground = color(0,0,0);

Knob myKnobA; // Change Temperature 
Knob myKnobB; // Change pH 
Knob myKnobC; // Change Stirring 
Knob currentTemp; // Current Temperature
Knob currentpH; // Current pH
Knob currentStirring; // Current Stirring

Chart myChartA; // Temperature Line Graph
Chart myChartB; // pH Line Graph

void setup() {
    
  // myPort = new Serial(this, nameOfPort, 9600);
  // myPort.bufferUntil('\n');
  
  // Proto-type values
  temp = 25;
  pH = 7;
  stirring = 400;
  
  size(1000,550);
  smooth();
  noStroke();
  
  // Read from serial port - real time 
  //try {
  // String portName = Serial.list()[0];
  // serialPort = new Serial(this, portName, 9600);
  // // Wait until a newline character is read to generate a serialEvent()
  // serialPort.bufferUntil('\n');
  //} catch (ArrayIndexOutOfBoundsException ex) {
  //  System.out.println("No serial connection, make sure MSP is connected and try again!");
  //  ex.printStackTrace();
  //}
  
  // Initiate Logger
  logger = new Logger();
  
  lastTimeMillis = System.currentTimeMillis();
  
  cp5 = new ControlP5(this);
    
  myKnobA = cp5.addKnob("Set Temp")
               .setRange(15,40)
               .setValue(temp)
               .setPosition(100,70)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .snapToTickMarks(false)
               .setDragDirection(Knob.HORIZONTAL)
               ;
                     
  myKnobB = cp5.addKnob("Set pH")
               .setRange(0,14.0)
               .setValue(pH)
               .setPosition(100,210)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .setDragDirection(Knob.HORIZONTAL)
               ;
               
  myKnobC = cp5.addKnob("Set Stirring (RPM)")
               .setRange(0,500)
               .setValue(stirring)
               .setPosition(100,350)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .setDragDirection(Knob.HORIZONTAL)
               ;
               
  currentTemp = cp5.addKnob("Current Temp")
               .setRange(15,40)
               .setValue(temp)
               .setPosition(275,70)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .lock()
               ;
               
  currentpH = cp5.addKnob("Current pH")
              .setRange(0,14)
              .setValue(pH)
              .setPosition(275,210)
              .setRadius(50)
              .setNumberOfTickMarks(10)
              .setTickMarkLength(4)
              .snapToTickMarks(false)
              .lock()
              ;
               
  currentStirring = cp5.addKnob("Current Stirring")
               .setRange(0,500)
               .setValue(stirring)
               .setPosition(275,350)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .lock()
               ;
               
  myChartA = cp5.addChart("Temperature past 24 hours")
               .setPosition(450, 70)
               .setSize(400, 90)
               .setRange(13, 40)
               .setDecimalPrecision(2)
               .setView(Chart.LINE)
               ;

  myChartA.addDataSet("temp");
  myChartA.setColors("temp", color(255), color(100, 155, 220));
  myChartA.setColorBackground(0);
  myChartA.updateData("temp", 15, 15);
  
  myChartB = cp5.addChart("pH past 24 hours")
             .setPosition(450, 220)
             .setSize(400, 90)
             .setRange(0, 14)
             .setDecimalPrecision(2)
             .setView(Chart.LINE) 
             ;

  myChartB.addDataSet("pH");
  myChartB.setColors("pH", color(255), color(100, 155, 220));
  myChartB.setColorBackground(0);
  myChartB.updateData("pH", 0, 0, 0, 0);

  // Proto-type values
  pH = myKnobB.getValue();
  minPH = pH - 1;
  maxPH = pH + 1;
  
  temp = myKnobA.getValue();
  minTemp = temp - 1;
  maxTemp = temp + 1;
  
  stirring = myKnobC.getValue();
  minStirring = stirring - 5;
  maxStirring = stirring + 5;

}

void draw() {
  background(myColorBackground);
 
 // Check time delta to update the current temp mock value 
 if (checkTimeDelta(System.currentTimeMillis(), 500)) {
    currentTemp = getCurrentTemp();
  }
 
  //x-y axis for temperature graph
  stroke(255);
  line(449,70,449,160);
  stroke(255);
  line(449,160,849,160);
  
  for (int i = 65; i < 166; i = i + 15) {
        
    if (i == 65) {
    
    fill(255);
    textSize(9);
    text("Temp. C", 430, i);
    
    } else {
    
    fill(255);
    textSize(9);
    text(Integer.toString(Math.abs((i/3) - 66)), 430, i);
  
    }
  
  }
 
  //x-y axis for pH graph
  stroke(255);
  line(449,220,449,310);
  stroke(255);
  line(449,310,849,310);
  
  fill(255);
  textSize(9);
  text("pH", 430, 210);
  
  for (int i = 225; i < 316; i = i + 45) {
    
    fill(255);
    textSize(9);
    text(Integer.toString(7 - (i - 270)/45 * 7), 430, i);
      
  }
  
  // UI Control
  // Update pH
  pH = myKnobB.getValue();
  minPH = pH - 1;
  maxPH = pH + 1;
 
  myChartB.updateData("pH", getPastPH(24));
  currentpH.setValue(getCurrentPH());
  
  // Update Temperature
  temp = myKnobA.getValue();
  minTemp = temp - 1;
  maxTemp = temp + 1;
  
  myChartA.updateData("temp", getPastTemp(24));
  currentTemp.setValue(getCurrentTemp());
  
  // Update Stirring
  stirring = myKnobC.getValue();
  minStirring = stirring - 5;
  maxStirring = stirring + 5;
  
  currentStirring.setValue(getCurrentStirring());
  
  // UI Warning indicators
  
  if (pH > 11) {
    
    float x,y;
    x = (255 * (pH - 10))/4;
    y = (255 * (14 - pH))/4;
    myKnobB.setColorForeground(color(x, y, 0));
    myKnobB.setColorActive(color(x, y, 0));
    currentpH.setColorForeground(color(x, y, 0));
    
  } else if (pH < 4) {
    
    float x,y;
    x = -(63.75 * pH) + 255;
    y = 63.75 * pH;
    myKnobB.setColorForeground(color(x, y, 0));
    myKnobB.setColorActive(color(x, y, 0));
    currentpH.setColorForeground(color(x, y, 0));
    
  } else {
    
    myKnobB.setColorForeground(color(0, 255, 0));
    myKnobB.setColorActive(color(0, 255, 0));
    currentpH.setColorForeground(color(0, 255, 0));
    
  }
  
  if (temp > 35) {
    
    float x,y;
    x = (51 * (temp - 35));
    y = 51 * (40 - temp);
    myKnobA.setColorForeground(color(x, y, 0));
    myKnobA.setColorActive(color(x, y, 0));
    currentTemp.setColorForeground(color(x, y, 0));
    
  } else if (temp < 20) {
    
    float x,y;
    x = (-51.000000 * temp) + 1020.000000;
    y = (51.000000 * temp) + -765.000000;
    myKnobA.setColorForeground(color(x, y, 0));
    myKnobA.setColorActive(color(x, y, 0));
    currentTemp.setColorForeground(color(x, y, 0));
    
  } else {
    
    myKnobA.setColorForeground(color(0, 255, 0));
    myKnobA.setColorActive(color(0, 255, 0));
    currentTemp.setColorForeground(color(0, 255, 0));
    
  }
  
  if (stirring > 400) {
    
    float x,y;
    y = (-2.550000 * stirring) + 1275.000000;
    x = (2.550000 * stirring) + -1020.000000;
    myKnobC.setColorForeground(color(x, y, 0));
    myKnobC.setColorActive(color(x, y, 0));
    currentStirring.setColorForeground(color(x, y, 0));
    
  } else if (stirring < 100) {
    
    float x,y;
    x = (-5.100000 * stirring) + 510.000000;
    y = (5.100000 * stirring) + -255.000000;
    myKnobC.setColorForeground(color(x, y, 0));
    myKnobC.setColorActive(color(x, y, 0));
    currentStirring.setColorForeground(color(x, y, 0));
    
  } else {
    
    myKnobC.setColorForeground(color(0, 255, 0));
    myKnobC.setColorActive(color(0, 255, 0));
    currentStirring.setColorForeground(color(0, 255, 0));
    
  }
  
}

void knob(int theValue) {
  myColorBackground = color(theValue);
  println("a knob event. setting background to " + theValue);
}

float getCurrentPH() {
  // This is the mock temperature method
  
  float range = maxPH - minPH;
  Random rand = new Random();
  float finalPH = rand.nextFloat() * range + minPH;
  
  return finalPH;
  
  // Using data from the logger
  // return logger.lastTemp();
}

float[] getPastPH(int n) {
  
  float mockPH[] = new float[n];
  for (int i = 0; i < n; i++) {
    mockPH[i] = getCurrentPH(); 
  }
  return mockPH;
  
  //For no mock data
  //int i = 0;
  //ArrayList<Float> nTemps = logger.xTemp(n);
  //float[] pastTemps = new float[n];
  //for (Float f : nTemps) {
  //  if (f == null) {
  //    pastTemps[i++] = 0;
  //  } else {
  //    pastTemps[i++] = f;
  //  }
  //}
  //return pastTemps;
}

float getCurrentTemp() {
  // This is the mock temperature method
  
  float range = maxTemp - minTemp;
  Random rand = new Random();
  float finalTemp = rand.nextFloat() * range + minTemp;
  
  return finalTemp;
  
  // Using data from the logger
  // return logger.lastTemp();
}

float[] getPastTemp(int n) {
  
  float mockTemps[] = new float[n];
  for (int i = 0; i < n; i++) {
    mockTemps[i] = getCurrentTemp(); 
  }
  return mockTemps;
  
  //For no mock data
  //int i = 0;
  //ArrayList<Float> nTemps = logger.xTemp(n);
  //float[] pastTemps = new float[n];
  //for (Float f : nTemps) {
  //  if (f == null) {
  //    pastTemps[i++] = 0;
  //  } else {
  //    pastTemps[i++] = f;
  //  }
  //}
  //return pastTemps;
}

float getCurrentStirring() {
  // This is the mock temperature method
  
  float range = maxStirring - minStirring;
  Random rand = new Random();
  float finalStirring = rand.nextFloat() * range + minStirring;
  
  return finalStirring;
  
  // Using data from the logger
  // return logger.lastTemp();
}

boolean checkTimeDelta(long currentTimeMillis, long desiredDeltaMillis) {
  if (currentTimeMillis - lastTimeMillis > desiredDeltaMillis) {
    lastTimeMillis = currentTimeMillis;
    return true;
  } else {
    return false;
  }
}

void updateTempText() {
  currentTempText.setText(String.format("Current Temp: %.2f", currentTemp));
  minTempText.setText(String.format("Min Temp: %.2f", targetTempMin));
  maxTempText.setText(String.format("Max Temp: %.2f", targetTempMax));
}

public void SetTemp(int val) {
  // Updates the target min temp and max temp with the current slider values.
  if (minTemp.getValue() < maxTemp.getValue()) {
    targetTempMin = minTemp.getValue();
    targetTempMax = maxTemp.getValue();
    print(String.format("New minimum temp is: %.2f.\n", targetTempMin));
    print(String.format("New maximum temp is: %.2f.\n", targetTempMax));
    // Do something to send an update to the microcontroller through a write data class of some kind?
    // eg:
    serialPort.write("_T" + String.format("%.2f,%.2f\n", targetTempMin, targetTempMax));
    // So writing to the serialPort a string such as "_T25.72,32.44" 
  } else {
    // Give an error if min > max
    print("Sorry min was greater than max.\n");
  }